extends Panel

signal signal_done(tag_datas)

onready var tag_button_path = preload('res://Scenes/Tags/Tag_Button.tscn')
onready var list_grid = $Main_MarginContainer/Main_VBoxContainer/TagsList_ScrollContainer/TagsList_GridContainer
onready var added_hbox = $Main_MarginContainer/Main_VBoxContainer/Added_HBoxContainer/Added_ScrollContainer/Added_HBoxContainer

var added_tags = []

func _ready():
# warning-ignore:return_value_discarded
	$Done_Button.connect("pressed",self,"_done")
# warning-ignore:return_value_discarded
	$Cancel_Button.connect("pressed",self,"_cancel")
	
	for tag in added_tags:
		added_hbox.add_child(_instantiate_tag_button(tag ,"_remove_tag"))
		
	for tag in ProjectData.tags:
		if not added_tags.has(tag):
			list_grid.add_child(_instantiate_tag_button(tag,"_add_tag"))

func setup(already_added_tags):
	for tag in already_added_tags:
		added_tags.append(tag)

func _instantiate_tag_button(tag_data,on_pressed):
	var tag_button = tag_button_path.instance()
	tag_button.setup(tag_data)
	tag_button.connect("signal_pressed", self, on_pressed)
	return tag_button

'''Insert tag back to list_grid'''
func _remove_tag(tag_data):
	var tag_button = _instantiate_tag_button(tag_data,"_add_tag")
	list_grid.add_child(tag_button)
	list_grid.move_child(tag_button,0)
	added_tags.remove(added_tags.find(tag_data))
	
func _add_tag(tag_data):
	added_hbox.add_child(_instantiate_tag_button(tag_data,"_remove_tag"))
	added_tags.append(tag_data)

func _done():
	emit_signal("signal_done",added_tags)
	self.queue_free()

func _cancel():
	self.queue_free()

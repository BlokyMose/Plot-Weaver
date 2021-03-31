extends Panel

onready var tag_button_path = preload('res://Scenes/Tags/Tag_Button.tscn')

onready var list_grid = $Main_MarginContainer/Main_VBoxContainer/TagsList_ScrollContainer/TagsList_GridContainer
onready var added_hbox = $Main_MarginContainer/Main_VBoxContainer/Added_HBoxContainer/Added_ScrollContainer/Added_HBoxContainer

func _ready():
	#TODO: Insert tags to grid based on ProjectData
	#TODO: 
	
	var tag_class = load("res://Scripts/Classes/Tag.gd")
	var quest_tag = tag_class.new("Quest", Color.red)
	ProjectData.tags.append(quest_tag)
	
	var side_quest_tag = tag_class.new("Side Quest", Color.orange, Color.blue)
	ProjectData.tags.append(side_quest_tag)
	
	for tag in ProjectData.tags:
		_instantiate_tag_button(tag)

func _instantiate_tag_button(tag_data):
	var tag_button = tag_button_path.instance()
	tag_button.setup(tag_data)
	tag_button.connect("signal_pressed", self, "_add_tag")
	list_grid.add_child(tag_button)
	
func _add_tag(tag_data):
	print("Added: "+tag_data.name)
	#TODO: instantiate tag button to added_hbox, with different _on_click
	#TODO: prevent same tags to be added again

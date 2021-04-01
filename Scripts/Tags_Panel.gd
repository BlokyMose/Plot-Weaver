extends Panel

var hover_opacity = 0.9
onready var bg_panel = get("custom_styles/panel")
onready var tag_insertion_path = load("res://Scenes/Tags/TagsInsertion_Panel.tscn")
var is_inserting = false
var tags = []

func _ready():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,0)
	
		# PLACEHOLDER
	var tag_class = load("res://Scripts/Classes/Tag.gd")
	var quest_tag = tag_class.new("Quest", Color.red)
	ProjectData.tags.append(quest_tag)
	
	var side_quest_tag = tag_class.new("Side Quest", Color.orange, Color.blue)
	ProjectData.tags.append(side_quest_tag)
	# PLACEHOLDER


func _update_tag_labels(tag_datas):
	is_inserting = false
	for tag in $ScrollContainer/HBoxContainer.get_children():
		$ScrollContainer/HBoxContainer.remove_child(tag)
	
	tags.clear()
		
	for tag in tag_datas:
		$ScrollContainer/HBoxContainer.add_child(_instantiate_tag_label(tag))
		tags.append(tag)
		

func _instantiate_tag_label(tag_data):
	var tag_label = Label.new()
	tag_label.text = " "+tag_data.name+" "
	tag_label.set("custom_styles/normal",StyleBoxFlat.new())
	tag_label.get("custom_styles/normal").bg_color = tag_data.color
	tag_label.set("custom_colors/font_color", tag_data.font_color)
	return tag_label
# -- Signals --

func _on_Tags_Panel_mouse_entered():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,hover_opacity)

func _on_Tags_Panel_mouse_exited():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,0)

func _on_Tags_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not is_inserting:
			is_inserting = true
			var tag_insertion = tag_insertion_path.instance()
			tag_insertion.setup(tags)
			tag_insertion.connect("signal_done", self, "_update_tag_labels")
			$CanvasLayer.add_child(tag_insertion)

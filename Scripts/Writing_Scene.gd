extends Panel

var _WBox_path = "res://Scenes/Writing/WBox_Panel.tscn"
onready var _WBoxes_Group = $ScrollContainer/Main_VBox/WBoxes_VBox

var WBoxes = []
var holding_key = false

func _input(event):
	if event is InputEventKey:
		
		# Scroll down
		if event.scancode == KEY_PAGEDOWN and not event.echo:
				holding_key = !holding_key
				if holding_key:
					$ScrollContainer.scroll_vertical += OS.window_size.y/4
		
		# Scroll up
		if event.scancode == KEY_PAGEUP and not event.echo:
				holding_key = !holding_key
				if holding_key:
					$ScrollContainer.scroll_vertical -= OS.window_size.y/4

func _instantiate_WBox():
	# Instantiate WBox
	var WBox_file = load(_WBox_path).duplicate()
	var WBox = WBox_file.instance()
	var WBox_panel = WBox.get_node("HBoxContainer/WBox_Panel")
	_WBoxes_Group.add_child(WBox)
	WBox_panel.connect("signal_insert_WBox",self,"insert_WBox")
	WBox_panel.connect("signal_place_cursor_WBox",self,"place_cursor_WBox")
	
	return [WBox, WBox_panel]

func update_numbers():
	for WBox in WBoxes:
		WBox.get_node("HBoxContainer/WBox_Panel").update_number()
		
func insert_WBox(index):
	var WBox_instantiation = _instantiate_WBox()
	var WBox = WBox_instantiation[0]
	var WBox_panel = WBox_instantiation[1]
	
	move_child(WBox,index)
	WBox_panel.setup_editing_mode(true)
	WBox_panel.editing_mode()
	
	# Record WBox
	if index >= WBoxes.size():
		WBoxes.append(WBox)
	elif index<=0 :
		WBoxes.insert(0,WBox)
	else:
		WBoxes.insert(index,WBox)
	
	# Set WBox number
	update_numbers()

func place_cursor_WBox(index):
	var _target_index = index
	if index >= WBoxes.size():
		_target_index = WBoxes.size()-1
	elif index<=0 :
		_target_index = 0

	var WBox_panel = WBoxes[_target_index].get_node("HBoxContainer/WBox_Panel")
	WBox_panel.setup_editing_mode(true)
	WBox_panel.editing_mode()



# -- Signals --

func _on_AddRegion_Button_pressed():
	var WBox_instantiation = _instantiate_WBox()
	var WBox = WBox_instantiation[0]
	
	# Record WBox
	WBoxes.append(WBox)
	
	# Set WBox number
	WBox.get_node("HBoxContainer/Number_Panel/Number_Label").set_text(String(WBoxes.size()) +" |")
	

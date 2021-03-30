extends Panel

var _WBox_path = "res://Scenes/Writing/WBox_Panel.tscn"
onready var _WBoxes_Group = $ScrollContainer/Main_VBox/WBoxes_VBox

var WBoxes = []
var holding_key = false

var title = "Title"
var desc = "Desc"
var areas = []

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
	var WBox_settings = WBox.get_node("HBoxContainer/Settings_Panel")
	var WBox_number = WBox.get_node("HBoxContainer/Number_Panel")
	
	
	_WBoxes_Group.add_child(WBox)
	WBox.connect("signal_insert_WBox",self,"feature_insert_WBox")
	WBox.connect("signal_place_cursor_WBox",self,"feature_place_cursor_WBox")
	WBox_settings.connect("signal_move_to",self,"feature_WBox_move_to")
	WBox_settings.connect("signal_delete",self,"feature_WBox_delete")
	WBox_number.connect("signal_move_to",self,"feature_WBox_move_to")
	
	return WBox

func _update_WBoxes_numbers():
	for WBox in WBoxes:
		WBox.update_number()

func get_data():
	title = $ScrollContainer/Main_VBox/Title_Panel/Title.text
	desc = $ScrollContainer/Main_VBox/Desc_Panel/Desc.text
	
	for WBox in WBoxes:
		areas.append( WBox._text_edit.text)
	
	var data = {
		"Title":title,
		"Desc":desc,
		"Areas":areas
	}
	
	return data

# -- Features --

func feature_insert_WBox(index):
	var WBox = _instantiate_WBox()
	
	_WBoxes_Group.move_child(WBox,index)
	WBox.setup_editing_mode(true)
	WBox.editing_mode()
	
	# Record WBox
	if index >= WBoxes.size():
		WBoxes.append(WBox)
	elif index<=0 :
		WBoxes.insert(0,WBox)
	else:
		WBoxes.insert(index,WBox)
	
	# Set WBox number
	_update_WBoxes_numbers()

func feature_place_cursor_WBox(index):
	var _target_index = index
	if index >= WBoxes.size():
		_target_index = WBoxes.size()-1
	elif index<=0 :
		_target_index = 0

	var WBox = WBoxes[_target_index]
	WBox.setup_editing_mode(true)
	WBox.editing_mode()

func feature_WBox_move_to(WBox, index):
	WBoxes.remove(WBoxes.find(WBox,0))
	WBoxes.insert(index,WBox)
	_WBoxes_Group.move_child(WBox,index)
	_update_WBoxes_numbers()
	
func feature_WBox_delete(WBox, index):
	WBoxes.remove(index)
	_WBoxes_Group.remove_child(WBox)
	WBox.queue_free()
	_update_WBoxes_numbers()

# -- Signals --

func _on_AddRegion_Button_pressed():
	var WBox = _instantiate_WBox()
	
	# Record WBox
	WBoxes.append(WBox)
	
	# Set WBox number
	WBox.get_node("HBoxContainer/Number_Panel/Number_Label").set_text(String(WBoxes.size()) +" |")
	


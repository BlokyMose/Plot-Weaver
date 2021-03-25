extends VBoxContainer

var WBoxes = []

func _on_AddRegion_Button_pressed():
	# Instantiate WBox
	var WBox_file = load("res://Scenes/Writing/WBox_Panel.tscn").duplicate()
	var WBox = WBox_file.instance()
	add_child(WBox)
	
	# Record WBox
	WBoxes.append(WBox)
	
	# Set WBox number
	WBox.get_node("HBoxContainer/Number_Panel/Number_Label").set_text(String(WBoxes.size()) +" |")

func update_numbers():
	for WBox in WBoxes:
		WBox.get_node("HBoxContainer/WBox_Panel").update_number()	

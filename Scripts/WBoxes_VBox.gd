extends VBoxContainer

var wBoxes = []

func _on_AddRegion_Button_pressed():
	# Instantiate wBox
	var wBox_file = load("res://Scenes/Writing/WBox_Panel.tscn").duplicate()
	var wBox = wBox_file.instance()
	add_child(wBox)
	
	# Record WBox
	wBoxes.append(wBox)
	
	# Set wBox number
	wBox.get_node("HBoxContainer/Number_Panel/Number_Label").set_text(String(wBoxes.size()) +" |")

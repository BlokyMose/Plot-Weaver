extends VBoxContainer

func _on_AddRegion_Button_pressed():
	var dBoxScene = load("res://Scenes/Writing/DBox_Panel.tscn").duplicate()
	add_child(dBoxScene.instance())

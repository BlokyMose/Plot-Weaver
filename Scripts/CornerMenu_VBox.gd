extends VBoxContainer

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_show_menu(false)
		
func _show_menu(show):
	for child in $MenuList_VBox.get_children():
		child.visible = show

func _on_CornerMenu_VBox_mouse_exited():
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		_show_menu(false)

func _on_Logo_TextureRect_mouse_entered():
	mouse_filter = Control.MOUSE_FILTER_STOP
	_show_menu(true)

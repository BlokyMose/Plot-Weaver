extends Panel

func _ready():
	OS.low_processor_usage_mode = true
	$FileDialog.popup_centered()
	
func release_focus():
	var current_focus_control = get_focus_owner()
	if current_focus_control:
		current_focus_control.release_focus()

func _on_Main_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			release_focus()

extends Panel

signal signal_move_to(WBox, index)

export var idleOpacity = 64
export var highlightOpacity = 200

var isReordering = false
var mouse_origin_position = Vector2(0,0)

# Hardcoded to match WBox and WBoxes_VBox
func cor_reorder():
	while isReordering:
		yield(get_tree().create_timer(0.1),"timeout")
		if !isReordering: break
		if get_global_mouse_position().y > mouse_origin_position.y + rect_size.y:
			mouse_origin_position = get_global_mouse_position()
			emit_signal("signal_move_to", owner, owner.get_index()+1)
			
		elif get_global_mouse_position().y < mouse_origin_position.y - rect_size.y:
			mouse_origin_position = get_global_mouse_position()
			if owner.get_index()>0:
				emit_signal("signal_move_to", owner, owner.get_index()-1)
			
			
func _on_Number_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			isReordering = !isReordering
			mouse_origin_position = get_global_mouse_position()
			cor_reorder()

func _on_Number_Panel_mouse_entered():
	$Number_Label.modulate = Color8(255,255,255, highlightOpacity)

func _on_Number_Panel_mouse_exited():
	$Number_Label.modulate = Color8(255,255,255, idleOpacity)

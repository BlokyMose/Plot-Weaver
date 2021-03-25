extends Panel

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
			print("[Plus]  Global: ",get_global_mouse_position().y,"  Ori: ", mouse_origin_position.y)
			mouse_origin_position = get_global_mouse_position()
			owner.get_parent().move_child(owner,owner.get_index()+1)
			owner.get_parent().update_numbers() # supposedly call WBoxes_VBox
			
		elif get_global_mouse_position().y < mouse_origin_position.y - rect_size.y:
			print("[Minus]  Global: ",get_global_mouse_position().y,"  Ori: ", mouse_origin_position.y)
			mouse_origin_position = get_global_mouse_position()
			if owner.get_index()>0:
				owner.get_parent().move_child(owner,owner.get_index()-1)
				owner.get_parent().update_numbers() # supposedly call WBoxes_VBox
			
			
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

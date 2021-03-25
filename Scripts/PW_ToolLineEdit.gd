extends PanelContainer

signal click_event

var line_edit_bg_color_normal

func _ready():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,125)
	line_edit_bg_color_normal = $HBoxContainer/LineEdit.get("custom_styles/normal").bg_color

func setup(name, icon_texture, place_holder):
	$HBoxContainer/Name_Label.text = name
	$HBoxContainer/Icon_Panel/Icon_TextureRect.texture = icon_texture
	$HBoxContainer/LineEdit.placeholder_text = place_holder

# --- Signals ---

func _on_PW_ToolButton_mouse_entered():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,230)
	
func _on_PW_ToolButton_mouse_exited():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,125)

func _on_PW_ToolButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			commit_text()

func _on_LineEdit_text_changed(_new_text):
	var _to_stop_warning = proof_text()
	
func proof_text() -> bool:
	var _text = $HBoxContainer/LineEdit.get_text()
	if _text.length() == 0 or int(_text)<1:
		$HBoxContainer/LineEdit.get("custom_styles/normal").bg_color = Color.red
		return false
	else:
		$HBoxContainer/LineEdit.get("custom_styles/normal").bg_color = line_edit_bg_color_normal
		return true

func commit_text():
	if proof_text():
		emit_signal("click_event", int($HBoxContainer/LineEdit.get_text())-1)


func _on_LineEdit_text_entered(_new_text):
	commit_text()

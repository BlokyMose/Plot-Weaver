extends PanelContainer

signal click_event

func _ready():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,125)

func setup(name, icon_texture):
	$HBoxContainer/Name_Label.text = name
	$HBoxContainer/Icon_Panel/Icon_TextureRect.texture = icon_texture

# --- Signals ---

func _on_PW_ToolButton_mouse_entered():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,230)
	
func _on_PW_ToolButton_mouse_exited():
	modulate = Color8(modulate.r8,modulate.g8, modulate.b8,125)

func _on_PW_ToolButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("click_event")


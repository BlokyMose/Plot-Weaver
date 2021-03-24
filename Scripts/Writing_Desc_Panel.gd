extends Panel

export var highligtAdd = 5
export var hoverHighlightOpacity = 127
var idleOpacity = 0
var isFocusing = false

func _on_Desc_focus_exited():
	isFocusing = false
	_on_Desc_mouse_exited()

func _on_Desc_mouse_entered():
	if (isFocusing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,hoverHighlightOpacity)


func _on_Desc_mouse_exited():
	if (isFocusing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,idleOpacity)


func _on_Desc_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			if (isFocusing == true): return
			isFocusing = true
			var _bgColor = get("custom_styles/panel").bg_color 
			get("custom_styles/panel").bg_color = Color8(_bgColor.r8+highligtAdd,_bgColor.g8+highligtAdd,_bgColor.b8+highligtAdd,255)


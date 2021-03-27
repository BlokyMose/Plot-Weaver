extends PanelContainer

signal signal_insert_tag(tag_string)
signal signal_clear_formatting


func _ready():
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Style_OptionButton.connect("pressed",self,"_emit_style")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Bold_Panel/Button.connect("pressed",self,"_emit_bold")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Italic_Panel/Button.connect("pressed",self,"_emit_italic")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Underline_Panel/Button.connect("pressed",self,"_emit_underline")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Strikethrough_Panel/Button.connect("pressed",self,"_emit_strikethrough")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Code_Panel/Button.connect("pressed",self,"_emit_code")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Center_Panel/Button.connect("pressed",self,"_emit_center")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Right_Panel/Button.connect("pressed",self,"_emit_right")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Color_Panel/Button.connect("pressed",self,"_emit_color")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Clear_Panel/Button.connect("pressed",self,"_clear_formatting")
# warning-ignore:return_value_discarded
	$MarginContainer/HBoxContainer/Exit_Panel/Button.connect("pressed",self,"_exit")
	
	
func _emit_style():
	emit_signal("signal_insert_tag","placeHolder")

func _emit_bold():
	emit_signal("signal_insert_tag","b")

func _emit_italic():
	emit_signal("signal_insert_tag","i")

func _emit_underline():
	emit_signal("signal_insert_tag","u")

func _emit_strikethrough():
	emit_signal("signal_insert_tag","s")

func _emit_code():
	emit_signal("signal_insert_tag","code")

func _emit_center():
	emit_signal("signal_insert_tag","center")

func _emit_right():
	emit_signal("signal_insert_tag","right")

func _emit_color():
	emit_signal("signal_insert_tag","placeholdwr")

func _clear_formatting():
	emit_signal("signal_clear_formatting")
	
func _exit():
	$MarginContainer/HBoxContainer/Exit_Panel/Button._on_Button_mouse_exited()
	visible = false

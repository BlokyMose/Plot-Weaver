extends Button

signal signal_pressed(tag_data)

var tag_data

func setup(_tag_data):
	tag_data = _tag_data
	text = " "+tag_data.name+" "
	get("custom_styles/normal").bg_color = tag_data.color
	set("custom_colors/font_color", _tag_data.font_color)
	

func _on_Tag_Button_pressed():
	emit_signal("signal_pressed",tag_data)

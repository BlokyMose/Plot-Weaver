extends Button

signal signal_pressed(tag_data)

var tag_data

func setup(_tag_data):
	tag_data = _tag_data
	text = " "+tag_data.name+" "
	get("custom_styles/normal").bg_color = Color(tag_data.color.r,tag_data.color.g,tag_data.color.b,0.75)
	get("custom_styles/hover").bg_color = Color(tag_data.color.r,tag_data.color.g,tag_data.color.b,0.9)
	
	set("custom_colors/font_color", _tag_data.font_color)
	set("custom_colors/font_color_hover", _tag_data.font_color)
	
	

func _on_Tag_Button_pressed():
	emit_signal("signal_pressed",tag_data)
	self.queue_free()

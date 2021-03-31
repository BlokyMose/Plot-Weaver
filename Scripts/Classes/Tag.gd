extends Object

class_name Tag, "res://Assets/Images/Icons/PlotWeaver_Tag.svg"

var name
var color
var font_color
var location = []

func _init(_name:String, _color:Color, _font_color:Color = Color.white):
	name = _name
	color = _color
	font_color = _font_color

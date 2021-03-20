#extends TextEdit
#onready var dialogue_label = get_node("Dialogue_Label")
#export var lineHeight = 30
#
#func _on_DialogueBox_text_changed():
#	dialogue_label.visible = false
#	var _newHeight = lineHeight * get_line_count()
#	get_parent().get_parent().rect_min_size = Vector2(get_parent().get_parent().rect_min_size.x, _newHeight)
#	get_parent().rect_min_size = Vector2(get_parent().rect_min_size.x, _newHeight)
#	dialogue_label.rect_min_size = Vector2(dialogue_label.rect_min_size.x, _newHeight)
#	dialogue_label.set_bbcode(get_text())
#	rect_min_size = Vector2(rect_min_size.x, _newHeight) 
#	print("Height ", rect_min_size.y)
#

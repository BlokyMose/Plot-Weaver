extends PanelContainer

export var lineHeight = 30
export var highligtAdd = 5
export var hoverHighlightOpacity = 127
var idleOpacity = 0
var is_editing = false

onready var _hBox = $WBox_HBox
onready var _textEdit = $WBox_HBox/WBox_TextEdit
onready var _label = $W_Label
onready var _number_label = get_parent().get_node("Number_Panel/Number_Label")

signal signal_editing(is_editing)
signal signal_hovering(is_hovering)

func _ready():
	idleOpacity = get("custom_styles/panel").bg_color.a8
	
func editing_mode():
	is_editing = true
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8+highligtAdd,_bgColor.g8+highligtAdd,_bgColor.b8+highligtAdd,255)
	_textEdit.grab_focus()
	_textEdit.cursor_set_line(_textEdit.get_line_count()-1)
	_textEdit.cursor_set_column(_textEdit.get_line(_textEdit.cursor_get_line()).length())
	
func setup_editing_mode(_is_editing):
	self.is_editing = _is_editing
	emit_signal("signal_editing",_is_editing)
	_textEdit.visible = _is_editing
	if _is_editing:
		_label.modulate = Color.transparent
	else:
		_label.modulate = Color.white
		_on_WBox_Outer_Panel_mouse_exited()
		
func update_size():
	
	# fine visible line
#	var _newHeight = lineHeight * _textEdit.get_line_count()
	var _newHeight = lineHeight * (_label.get_visible_line_count() + _label.get_line_count())
	print(_label.get_visible_line_count())
	
	# Update parent Panel
	rect_min_size = Vector2(rect_min_size.x, _newHeight)
	
	# Update HBox
	_hBox.rect_min_size = Vector2(_hBox.rect_min_size.x, _newHeight)
	
	# Update TextEdit
	_textEdit.rect_min_size = Vector2(_textEdit.rect_min_size.x, _newHeight) 
	
	# Update RichTextLabel
	_label.rect_min_size = Vector2(_label.rect_min_size.x, _newHeight)
#	_label.visible = false
	_label.set_bbcode(_textEdit.get_text())

func update_number():
	 _number_label.set_text(String(owner.get_index()+1)+" |")

# -- Signals -- 

func _on_WBox_TextEdit_focus_exited():
	if (is_editing == false): return
	setup_editing_mode(false)

func _on_WBox_TextEdit_text_changed():
	setup_editing_mode(true)
	update_size()

func _on_WBox_Outer_Panel_mouse_entered():
	emit_signal("signal_hovering", true)
	
	if (is_editing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,hoverHighlightOpacity)

func _on_WBox_Outer_Panel_mouse_exited():
	emit_signal("signal_hovering", false)
	
	if (is_editing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,idleOpacity)

func _on_WBox_Outer_Panel_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			setup_editing_mode(true)
			editing_mode()

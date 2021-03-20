extends PanelContainer

export var lineHeight = 30
export var highligtAdd = 5
export var hoverHighlightOpacity = 127
var idleOpacity = 0
var isFocusing = false

onready var _hBox = $DBox_HBox
onready var _textEdit = $DBox_HBox/DialogueBox_TextEdit
onready var _label = $Dialogue_Label

func _ready():
	idleOpacity = get("custom_styles/panel").bg_color.a8
	
func editing_mode():
	if (isFocusing == true): return
	isFocusing = true
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8+highligtAdd,_bgColor.g8+highligtAdd,_bgColor.b8+highligtAdd,255)
	_textEdit.grab_focus()
	_textEdit.cursor_set_line(_textEdit.get_line_count()-1)
	
	_textEdit.cursor_set_column(_textEdit.get_line(_textEdit.cursor_get_line()).length())
	
func show_label(show):
	_label.visible = show
	_textEdit.visible = !show
	
func update_size():
	var _newHeight = lineHeight * _textEdit.get_line_count()
	
	# Update parent Panel
	rect_min_size = Vector2(rect_min_size.x, _newHeight)
	
	# Update HBox
	_hBox.rect_min_size = Vector2(_hBox.rect_min_size.x, _newHeight)
	
	# Update TextEdit
	_textEdit.rect_min_size = Vector2(_textEdit.rect_min_size.x, _newHeight) 
	
	# Update RichTextLabel
	_label.rect_min_size = Vector2(_label.rect_min_size.x, _newHeight)
	_label.visible = false
	_label.set_bbcode(_textEdit.get_text())

# -- Signals -- 

func _on_Dialogue_focus_exited():
	if (isFocusing == false): return
	isFocusing = false
	_on_Dialogue_Label_mouse_exited()
	show_label(true)

func _on_DialogueBox_text_changed():
	editing_mode()
	show_label(false)
	update_size()

func _on_Dialogue_Label_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			print("mouse clicked")
			editing_mode()
			show_label(false)

func _on_Dialogue_Label_mouse_entered():
	if (isFocusing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,hoverHighlightOpacity)

func _on_Dialogue_Label_mouse_exited():
	if (isFocusing == true): return
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,idleOpacity)

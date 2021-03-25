extends PanelContainer

export var lineHeight = 30
export var highligtAdd = 5
export var hoverHighlightOpacity = 127
var idleOpacity = 0
var is_editing = false
var holding_control = false
var holding_key = false;

onready var _hBox = $WBox_HBox
onready var _text_edit = $WBox_HBox/WBox_TextEdit
onready var _label = $W_Label
onready var _number_label = get_parent().get_node("Number_Panel/Number_Label")

signal signal_editing(is_editing)
signal signal_hovering(is_hovering)

func _ready():
	idleOpacity = get("custom_styles/panel").bg_color.a8

func _input(event):
	# prevent unfocused WBox to execute this method
	if get_focus_owner() != null:
		if get_focus_owner().get_instance_id() != _text_edit.get_instance_id(): 
			return
	else: 
		return
	
	if event is InputEventKey:
		if event.scancode == KEY_CONTROL:
			holding_control = event.pressed
			if not event.pressed:
				holding_key = false
		
		# Bold
		if event.scancode == KEY_B and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("b")

		# Italic
		if event.scancode == KEY_I and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("i")

		# Underline
		if event.scancode == KEY_U and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("u")

		# Strikethrough
		if event.scancode == KEY_MINUS and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("s")

		# Code
		if event.scancode == KEY_SLASH and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("code")

		# Center
		if event.scancode == KEY_E and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("center")

		# Right
		if event.scancode == KEY_R and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_insert_tags("right")
		# Wat
		if event.scancode == KEY_Q and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_test()

func _insert_tags(tag_string):
	
	
	# Insert markup tags at the start and end of selection
	if _text_edit.is_selection_active():
		
		var _selection_start = Vector2(0,0)
		var _selection_end = Vector2(0,0)
		
		# Selection lines start from up to down
		if _text_edit.get_selection_from_line() < _text_edit.get_selection_to_line():
			_selection_start = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
			_selection_end = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
		
		# Selection lines start from down to up
		elif _text_edit.get_selection_from_line() > _text_edit.get_selection_to_line():
				_selection_start = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
				_selection_end = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
		
		# Selection happens on the same line
		else:
			if _text_edit.get_selection_from_column() < _text_edit.get_selection_to_column():
				_selection_start = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
				_selection_end = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
			else:
				_selection_start = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
				_selection_end = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
		
		_text_edit.deselect()
		
		# Insert tags, and reposition cursor
		_text_edit.cursor_set_line(_selection_end.y)
		_text_edit.cursor_set_column(_selection_end.x)
		_text_edit.insert_text_at_cursor("[/"+tag_string+"]")
		var _cursor_end_position = Vector2(_text_edit.cursor_get_column(),_text_edit.cursor_get_line())
		
		_text_edit.cursor_set_line(_selection_start.y)
		_text_edit.cursor_set_column(_selection_start.x)
		_text_edit.insert_text_at_cursor("["+tag_string+"]")
		
		_text_edit.cursor_set_line(_cursor_end_position.y)
		_text_edit.cursor_set_column(_cursor_end_position.x-1)
	
	# Insert markup tags in cursor position
	else:
		_text_edit.insert_text_at_cursor("["+tag_string+"][/"+tag_string+"]")
		_text_edit.cursor_set_column(_text_edit.cursor_get_column()-4)
	
func _test():
	var _tag_string_first = "[b]"
	var _tag_string_first_count = _tag_string_first.length()
	var _tag_string_last = "[/b]"
	var _tag_string_last_count = _tag_string_last.length()
	
	# Forward check
	var _break = false
	for line_index in range(_text_edit.cursor_get_line(),_text_edit.get_line_count()):
		if _break==false:
			
			var start_index = 0
			if _text_edit.cursor_get_line() == line_index:
				start_index = _text_edit.cursor_get_column()
			
			for char_index in range(start_index,_text_edit.get_line(line_index).length()-_tag_string_last_count+1):
				
				# Check first string tag, then break the loop
				_text_edit.select(line_index , char_index , line_index , char_index+_tag_string_first_count)
				if _text_edit.get_selection_text() == _tag_string_first:
					_text_edit.deselect()
					_break = true
					print("BREAK! for")
					break
					
				# Check last string tag, then toggle it off
				_text_edit.select(line_index , char_index , line_index , char_index+_tag_string_last_count)
				if _text_edit.get_selection_text() == _tag_string_last:
					_text_edit.cut()
					_break = true
					break
					
				_text_edit.deselect()
				
		else:
			break
			
	_break = false
	for line_index in range(_text_edit.cursor_get_line(),-1,-1):
		if _break==false:
			for char_index in range(_text_edit.get_line(line_index).length()-_tag_string_last_count+1,-1,-1):
				
				# Check first string tag, then break the loop
				_text_edit.select(line_index , char_index-_tag_string_first_count , line_index , char_index)
				if _text_edit.get_selection_text() == _tag_string_first:
					_text_edit.cut()
					_break = true
					break
					
				# Check last string tag, then toggle it off
				_text_edit.select(line_index , char_index-_tag_string_last_count , line_index , char_index)
				if _text_edit.get_selection_text() == _tag_string_last:
					_text_edit.deselect()
					_break = true
					break
				
				_text_edit.deselect()
				
		else:
			break
	
	
func editing_mode():
	is_editing = true
	var _bgColor = get("custom_styles/panel").bg_color 
	get("custom_styles/panel").bg_color = Color8(_bgColor.r8+highligtAdd,_bgColor.g8+highligtAdd,_bgColor.b8+highligtAdd,255)
	_text_edit.grab_focus()
	_text_edit.cursor_set_line(_text_edit.get_line_count()-1)
	_text_edit.cursor_set_column(_text_edit.get_line(_text_edit.cursor_get_line()).length())
	
func setup_editing_mode(_is_editing):
	self.is_editing = _is_editing
	emit_signal("signal_editing",_is_editing)
	_text_edit.visible = _is_editing
	if _is_editing:
		_label.modulate = Color.transparent
	else:
		_label.modulate = Color.white
		_on_WBox_Outer_Panel_mouse_exited()
		
func update_size():
	
	# find visible line
	var _newHeight = lineHeight * (_label.get_visible_line_count() + _label.get_line_count())
	print(_label.get_visible_line_count())
	
	# Update parent Panel
	rect_min_size = Vector2(rect_min_size.x, _newHeight)
	
	# Update HBox
	_hBox.rect_min_size = Vector2(_hBox.rect_min_size.x, _newHeight)
	
	# Update TextEdit
	_text_edit.rect_min_size = Vector2(_text_edit.rect_min_size.x, _newHeight) 
	
	# Update RichTextLabel
	_label.rect_min_size = Vector2(_label.rect_min_size.x, _newHeight)
	_label.set_bbcode(_text_edit.get_text())

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

extends PanelContainer

export var line_height = 30
export var char_width = 7

export var highligtAdd = 5
export var hoverHighlightOpacity = 127
var idleOpacity = 0

var is_editing = false
var is_locked = false
var holding_control = false
var holding_shift = false
var holding_alt = false

var holding_key = false
var holding_mouse_left = false
var previously_selected_text = ""

onready var _WBox_Panel = $HBoxContainer/WBox_Panel
onready var _hBox = $HBoxContainer/WBox_Panel/WBox_HBox
onready var _text_edit = $HBoxContainer/WBox_Panel/WBox_HBox/WBox_TextEdit
onready var _label = $HBoxContainer/WBox_Panel/W_Label
onready var _number_label = $HBoxContainer/Number_Panel/Number_Label
onready var _text_tools = $Floating_CanvasLayer/TextTools_PanelContainer
onready var _settings = $HBoxContainer/Settings_Panel

signal signal_editing(is_editing)
signal signal_hovering(is_hovering)
signal signal_insert_WBox(index)
signal signal_place_cursor_WBox(index)

func _ready():
	idleOpacity = _WBox_Panel.get("custom_styles/panel").bg_color.a8
	_text_tools.connect("signal_insert_tag",self,"_insert_tags_by_text_tools")
	_text_tools.connect("signal_clear_formatting",self,"_clear_formatting_by_text_tools")
	_settings.connect("signal_copy_text",self,"_copy_text")
	_settings.connect("signal_lock",self,"_lock")
	
	connect("signal_hovering",$HBoxContainer/Settings_Panel,"show_button")
	
# -- Features --

func _input(event):
	# prevent unfocused WBox to execute this method
	if get_focus_owner() != null:
		if get_focus_owner().get_instance_id() != _text_edit.get_instance_id(): 
			return
	else: 
		return
	
	# Shortcut keys
	if event is InputEventKey:
		
		# Formatted view
		if event.scancode == KEY_F1:
			if event.pressed:
				_text_edit.modulate = Color.transparent
				_label.modulate = Color.white
			# Markup view
			else:
				_text_edit.modulate = Color.white
				_label.modulate = Color.transparent
		
		# Control 
		if event.scancode == KEY_CONTROL:
			holding_control = event.pressed
				

		# Shift
		if event.scancode == KEY_SHIFT:
			holding_shift = event.pressed
		
		# Alt
		if event.scancode == KEY_ALT:
			holding_alt = event.pressed

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

		# Clear
		if event.scancode == KEY_EQUAL and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					_clear_formatting()

		# Insert WBox up
		if event.scancode == KEY_UP and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					holding_control = false
					emit_signal("signal_insert_WBox",get_index())

		# Insert WBox down
		if event.scancode == KEY_DOWN and not event.echo:
			if holding_control:
				holding_key = !holding_key
				if holding_key:
					holding_control = false
					emit_signal("signal_insert_WBox",get_index()+1)

		# Place cursor to WBox up
		if event.scancode == KEY_UP and not event.echo:
			if holding_alt:
				holding_key = !holding_key
				if holding_key:
					holding_alt = false
					emit_signal("signal_place_cursor_WBox",get_index()-1)

		# Place cursor to WBox down
		if event.scancode == KEY_DOWN and not event.echo:
			if holding_alt:
				holding_key = !holding_key
				if holding_key:
					holding_alt = false
					emit_signal("signal_place_cursor_WBox",get_index()+1)
					
		# Exit TextTools
		if event.scancode == KEY_ESCAPE and not event.echo:
			if _text_edit.visible :
				_text_edit.deselect()
				_text_tools.visible= false
			else:
				_on_WBox_TextEdit_focus_exited()
	
	# Selection and TextTools
	if event is InputEventMouseButton:
		# Only display TextTools on mouse release (click won't trigger this because there won't be a selection)
		if event.button_index == 1 and not event.is_echo():
			# Only display TextTools when in selection
			if _text_edit.get_selection_text() != "":
				# Prevent TextTools to follow mouse when already visible; Only re-follow mouse if there's a new selection
				if not _text_tools.visible or _text_edit.get_selection_text() != previously_selected_text:
					previously_selected_text = _text_edit.get_selection_text()
					
					# Setup TextTools
					_text_tools.visible = true
					_text_tools.rect_global_position = Vector2(\
					get_global_mouse_position().x - _text_tools.rect_size.x/2,\
					get_global_mouse_position().y - line_height*2 - 6\
					)
					
					# Prevent TextTools to be displayed beyond the screen
					if _text_tools.rect_global_position.x<10:
						_text_tools.rect_global_position = Vector2(10, _text_tools.rect_global_position.y)
					elif _text_tools.rect_global_position.x>OS.window_size.x - _text_tools.rect_size.x - 10:
						_text_tools.rect_global_position = Vector2(OS.window_size.x - _text_tools.rect_size.x - 10, _text_tools.rect_global_position.y)
			else:
				_text_tools.visible = false

func _insert_tags(tag_string):
	var _tag_string_first = "[" +tag_string+ "]"
	var _tag_string_first_count = _tag_string_first.length()
	var _tag_string_last = "[/" +tag_string+ "]"
	var _tag_string_last_count = _tag_string_last.length()
	var _cache_clipboard =  OS.get_clipboard()
	
	# Insert markup tags at the start and end of selection
	if _text_edit.is_selection_active():
		
		# Cache original selection positions
		var _selection_start = Vector2(_text_edit.get_selection_from_column(),_text_edit.get_selection_from_line())
		var _selection_end = Vector2(_text_edit.get_selection_to_column(),_text_edit.get_selection_to_line())
		
		# Remove tags that directly clamp the selection
		_text_edit.deselect()
		_text_edit.select(_selection_end.y,_selection_end.x,_selection_end.y,_selection_end.x+_tag_string_last_count)
		if _text_edit.get_selection_text() == _tag_string_last:
			_text_edit.select(_selection_start.y,_selection_start.x-_tag_string_first_count,_selection_start.y,_selection_start.x)
			if _text_edit.get_selection_text() == _tag_string_first:
				# Toggle off tags at the start & end of selection
				_text_edit.select(_selection_end.y,_selection_end.x,_selection_end.y,_selection_end.x+_tag_string_last_count)
				_text_edit.cut()
				_text_edit.select(_selection_start.y,_selection_start.x-_tag_string_first_count,_selection_start.y,_selection_start.x)
				_text_edit.cut()
				
				# Reset selection and cursor position
				if _selection_start.y == _selection_end.y:
					_text_edit.select(_selection_start.y,_selection_start.x-_tag_string_first_count,\
					_selection_end.y,_selection_end.x-_tag_string_first_count)
					_text_edit.cursor_set_line(_selection_end.y)
					_text_edit.cursor_set_column(_selection_end.x-_tag_string_first_count)	
				else:
					_text_edit.select(_selection_start.y,_selection_start.x-_tag_string_first_count,\
					_selection_end.y,_selection_end.x)
					_text_edit.cursor_set_line(_selection_end.y)
					_text_edit.cursor_set_column(_selection_end.x)	

				return
		
		# Remove tags that indirectly clamp the selection; 
		#	Purpose: to de-bolden the clamping tags and en-bold the new selection
		_text_edit.deselect()
		if _check_tag_exist_around(tag_string):
			if _selection_start.y==_selection_end.y:
				_selection_start = Vector2(_selection_start.x-_tag_string_first_count, _selection_start.y)
				_selection_end = Vector2(_selection_end.x-_tag_string_first_count, _selection_end.y)
			
		
		# Remove tags inside selection
		_text_edit.select(_selection_start.y,_selection_start.x,_selection_end.y,_selection_end.x)
		var _processed_text = _text_edit.get_selection_text()
		_processed_text = _processed_text.replace(_tag_string_first,"")
		_processed_text = _processed_text.replace(_tag_string_last,"")
		_text_edit.cut()
		_text_edit.insert_text_at_cursor(_processed_text)
		
		# Insert tags at the start & end of selection, then reposition cursor
		_text_edit.cursor_set_line(_selection_start.y)
		_text_edit.cursor_set_column(_selection_start.x)
		_text_edit.insert_text_at_cursor(_tag_string_first)
		var _cursor_start_position = Vector2(_text_edit.cursor_get_column(),_text_edit.cursor_get_line())
		
		_text_edit.cursor_set_line(_selection_end.y)
		_text_edit.cursor_set_column(_selection_end.x+_tag_string_first_count)
		_text_edit.insert_text_at_cursor(_tag_string_last)
		
		# Reset original selection
		if _selection_start.y == _selection_end.y:
			_text_edit.select(_selection_start.y,_selection_start.x+_tag_string_first_count,_selection_end.y,_selection_end.x+_tag_string_first_count)
		else:
			_text_edit.select(_selection_start.y,_selection_start.x+_tag_string_first_count,_selection_end.y,_selection_end.x)
		
		# If selection included also tags, then select only the text content
		if _text_edit.get_selection_text().substr(_text_edit.get_selection_text().length()-_tag_string_last_count,_tag_string_last_count) == _tag_string_last:
			_text_edit.select(_selection_start.y,_selection_start.x+_tag_string_first_count,_selection_end.y,_selection_end.x-_tag_string_last_count)

		_text_edit.cursor_set_line(_text_edit.cursor_get_line())
		_text_edit.cursor_set_column(_text_edit.cursor_get_column()-_tag_string_last_count)
	
	# Insert markup tags by cursor position (without selection)
	else:
		
		# Remove tags that clamp the selection if exist
		if _check_tag_exist_around(tag_string):
			return
		
		var _do_insert_on_empty = false
		var _cursor_original_position = Vector2(_text_edit.cursor_get_column(),_text_edit.cursor_get_line())
		
		# Check if cursor on the start of the line
		if _text_edit.cursor_get_column() == _text_edit.get_line(_text_edit.cursor_get_line()).length():
			_do_insert_on_empty = true
			
		# Check if cursor on the start of the line
		elif _text_edit.cursor_get_column() == 0:
			_do_insert_on_empty = true
			
		# Check if cursor in the middle of a word or not
		else:
			_text_edit.select(_text_edit.cursor_get_line(),_text_edit.cursor_get_column(),_text_edit.cursor_get_line(),_text_edit.cursor_get_column()+1)
			if _text_edit.get_selection_text()!=" ":
				_text_edit.select(_text_edit.cursor_get_line(),_text_edit.cursor_get_column(),_text_edit.cursor_get_line(),_text_edit.cursor_get_column()-1)
				if _text_edit.get_selection_text()!=" ":
					
					# Insert markup tags at the start & end of the word 
					# Reset
					_text_edit.deselect()
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x)
					
					# Forward loop to add last tag
					for _i in range(0,_text_edit.get_line(_text_edit.cursor_get_line()).length()-_text_edit.cursor_get_column()+1) :
						# If end of line, add tag
						if _text_edit.cursor_get_column() == _text_edit.get_line(_text_edit.cursor_get_line()).length():
							_text_edit.insert_text_at_cursor(_tag_string_last)
							break
						
						_text_edit.select(_text_edit.cursor_get_line(),_text_edit.cursor_get_column(),_text_edit.cursor_get_line(),_text_edit.cursor_get_column()+1)
						if _text_edit.get_selection_text()==" ":
							_text_edit.insert_text_at_cursor(_tag_string_last+" ")
							break

						else:
							_text_edit.cursor_set_column(_text_edit.cursor_get_column()+1)
							_text_edit.deselect()
							
					# Reset
					_text_edit.deselect()
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x)

					# Backward loop to add first tag
					for _i in range(_text_edit.cursor_get_column(),-1,-1) :
						
						# if the very start of line, add tag
						if _text_edit.cursor_get_column() == 0:
							_text_edit.insert_text_at_cursor(_tag_string_first)
							break
						
						_text_edit.select(_text_edit.cursor_get_line(),_text_edit.cursor_get_column(),_text_edit.cursor_get_line(),_text_edit.cursor_get_column()-1)
						if _text_edit.get_selection_text()==" ":
							_text_edit.insert_text_at_cursor(" "+_tag_string_first)
							break
						else:
							_text_edit.cursor_set_column(_text_edit.cursor_get_column()-1)
							_text_edit.deselect()
					
					# Reposition
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x+tag_string.length()+2)
					
				else:
					_do_insert_on_empty = true
			else:
				_do_insert_on_empty = true

		#Insert markup tags on an empty char 
		if _do_insert_on_empty:
			_text_edit.cursor_set_column(_cursor_original_position.x)
			_text_edit.cursor_set_line(_cursor_original_position.y)
			
			_text_edit.insert_text_at_cursor(_tag_string_first+_tag_string_last)
			_text_edit.cursor_set_column(_text_edit.cursor_get_column()-_tag_string_last_count)

	OS.set_clipboard(_cache_clipboard)

func _insert_tags_by_text_tools(tag_string):
	_insert_tags(tag_string)
	editing_mode()

func _check_tag_exist_around(tag_string) -> bool:
	var _tag_string_first = "[" +tag_string+ "]"
	var _tag_string_first_count = _tag_string_first.length()
	var _tag_string_last = "[/" +tag_string+ "]"
	var _tag_string_last_count = _tag_string_last.length()
	var _cursor_original_position = Vector2(_text_edit.cursor_get_column(),_text_edit.cursor_get_line())
	var _found_tag = false
	
	# Forward check: toggle off tag_string_last if exists
	var _break = false
	for line_index in range(_text_edit.cursor_get_line(),_text_edit.get_line_count()):
		if _break==false:
			
			var start_index = 0
			if _text_edit.cursor_get_line() == line_index:
				start_index = _text_edit.cursor_get_column()
			
			for char_index in range(start_index,_text_edit.get_line(line_index).length()-_tag_string_last_count+1):
				
				# Check tag_string_first, don't toggle off and stop the loop
				_text_edit.select(line_index , char_index , line_index , char_index+_tag_string_first_count)
				if _text_edit.get_selection_text() == _tag_string_first:
					_text_edit.deselect()
					_break = true
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x)
					break
					
				# Check last string tag, then toggle it off
				_text_edit.select(line_index , char_index , line_index , char_index+_tag_string_last_count)
				if _text_edit.get_selection_text() == _tag_string_last:
					_text_edit.cut()
					_break = true
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x)
					_found_tag = true
					break
					
				_text_edit.deselect()
				
		else:
			break
	
	_text_edit.cursor_set_line(_cursor_original_position.y)
	_text_edit.cursor_set_column(_cursor_original_position.x)
	
	# Backward check: toggle off tag_string_first if exists
	_break = false
	for line_index in range(_text_edit.cursor_get_line(),-1,-1):
		if _break==false:
			
			var start_index = _text_edit.get_line(line_index).length()
			if _text_edit.cursor_get_line() == line_index:
				start_index = _text_edit.cursor_get_column()
			
			for char_index in range(start_index,-1,-1):
				
				# Check last string tag, don't toggle off, stop the loop
				_text_edit.select(line_index , char_index-_tag_string_last_count , line_index , char_index)
				if _text_edit.get_selection_text() == _tag_string_last:
					_text_edit.deselect()
					_break = true
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x)
					break
					
				# Check first string tag, toggle it off
				_text_edit.select(line_index , char_index-_tag_string_first_count , line_index , char_index)
				if _text_edit.get_selection_text() == _tag_string_first:
					_text_edit.cut()
					_break = true
					_text_edit.cursor_set_line(_cursor_original_position.y)
					_text_edit.cursor_set_column(_cursor_original_position.x-_tag_string_first_count)
					_found_tag = true
					break
					
				_text_edit.deselect()
				
		else:
			break
	
	return _found_tag

func _clear_formatting():
	# TODO: Update later	
	var _tags = ['b','i','u','s','code','center','right'] # add more

	# When selecting
	if _text_edit.is_selection_active():
		# Cache original selection positions
		var _selection_start = Vector2(_text_edit.get_selection_from_column(),_text_edit.get_selection_from_line())
		var _selection_end = Vector2(_text_edit.get_selection_to_column(),_text_edit.get_selection_to_line())
	
		# Remove every tag
		for _tag_string in _tags:
			_text_edit.select(_selection_start.y,_selection_start.x,_selection_end.y,_selection_end.x)
			var _processed_text = _text_edit.get_selection_text()
			_processed_text = _processed_text.replace('['+_tag_string+']',"")
			_processed_text = _processed_text.replace('[/'+_tag_string+']',"")
			_text_edit.cut()
			_text_edit.insert_text_at_cursor(_processed_text)
		
			# Reset selection and cursor position
			if _selection_start.y == _selection_end.y:
				_text_edit.select(_selection_start.y,_text_edit.cursor_get_column()-_processed_text.length(),\
				_selection_end.y,_text_edit.cursor_get_column())

			else:
				_text_edit.select(_selection_start.y,_selection_start.x,\
				_selection_end.y,_selection_end.x)

	# Not selecting
	else:
		for _tag_string in _tags:
			# warning-ignore:return_value_discarded
			_check_tag_exist_around(_tag_string)
		pass

func _clear_formatting_by_text_tools():
	_clear_formatting()
	editing_mode()

func _copy_text(include_bbcode):
	if include_bbcode:
		OS.set_clipboard(_text_edit.text)
	else:
		OS.set_clipboard(_label.text)

func _lock(lock):
	is_locked = lock
	if is_locked:
		_on_WBox_TextEdit_focus_exited()
		_label.selection_enabled = true
		_label.mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		_label.selection_enabled = false
		_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		setup_editing_mode(true)
		editing_mode()

# -- Editing Mode -- 

func editing_mode():
	is_editing = true
	var _bgColor = _WBox_Panel.get("custom_styles/panel").bg_color 
	_WBox_Panel.get("custom_styles/panel").bg_color = Color8(_bgColor.r8+highligtAdd,_bgColor.g8+highligtAdd,_bgColor.b8+highligtAdd,255)
	_text_edit.grab_focus()
	if _text_edit.is_selection_active():
		_text_edit.cursor_set_line(_text_edit.get_selection_to_line())
		_text_edit.cursor_set_column(_text_edit.get_selection_to_column())
	else:
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
	var _newHeight = line_height * (_label.get_visible_line_count() + _label.get_line_count())
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
	 _number_label.set_text(String(get_index()+1)+" |")

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
	var _bgColor = _WBox_Panel.get("custom_styles/panel").bg_color 
	_WBox_Panel.get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,hoverHighlightOpacity)

func _on_WBox_Outer_Panel_mouse_exited():
	emit_signal("signal_hovering", false)
	
	if (is_editing == true): return
	
	var _bgColor = _WBox_Panel.get("custom_styles/panel").bg_color 
	_WBox_Panel.get("custom_styles/panel").bg_color = Color8(_bgColor.r8,_bgColor.g8,_bgColor.b8,idleOpacity)

func _on_WBox_Outer_Panel_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			if not is_locked:
				setup_editing_mode(true)
				editing_mode()


# Archived: position TextTools based on cursor position
#		print(_label.get_visible_line_count())
#		var _position_y = rect_global_position.y + (_label.get_visible_line_count() + _text_edit.cursor_get_line()-2) * line_height - 6 
#		var _position_x = rect_global_position.x - _text_tools.rect_size.x/3 + (_text_edit.cursor_get_column()) * char_width
#		while _position_x+_text_tools.rect_size.x > rect_global_position.x + rect_size.x:
#			_position_x -= rect_size.x
#
#		_text_tools.rect_global_position = Vector2(_position_x,_position_y)


# Archived: determining selection start/end manually (Selection_from / end automatically adjust)
#		var _selection_start = Vector2(0,0)
#		var _selection_end = Vector2(0,0)
#
#		# Selection lines start from up to down
#		if _text_edit.get_selection_from_line() < _text_edit.get_selection_to_line():
#			print("UP down")
#
#			_selection_start = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
#			_selection_end = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
#
#		# Selection lines start from down to up
#		elif _text_edit.get_selection_from_line() > _text_edit.get_selection_to_line():
#			print("down up")
#			_selection_start = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
#			_selection_end = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
#
#		# Selection happens on the same line
#		else:
#			if _text_edit.get_selection_from_column() < _text_edit.get_selection_to_column():
#				_selection_start = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
#				_selection_end = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
#			else:
#				_selection_start = Vector2(_text_edit.get_selection_to_column(), _text_edit.get_selection_to_line())
#				_selection_end = Vector2(_text_edit.get_selection_from_column(), _text_edit.get_selection_from_line())
#

# Archived
#func _check_tag_exist_inside(tag_string, _selection_start, _selection_end) :
#	var _tag_string_first = "[" +tag_string+ "]"
#	var _tag_string_first_count = _tag_string_first.length()
#	var _tag_string_last = "[/" +tag_string+ "]"
#	var _tag_string_last_count = _tag_string_last.length()
#	var _cursor_original_position = Vector2(_text_edit.cursor_get_column(),_text_edit.cursor_get_line())
#
#	# Cut old selected text that may contain tags, then insert a new processed text
#	_text_edit.select(_selection_start.y,_selection_start.x,_selection_end.y,_selection_end.x)
#	var _processed_text = _text_edit.get_selection_text()
#	_processed_text = _processed_text.replace(_tag_string_first,"")
#	_processed_text = _processed_text.replace(_tag_string_last,"")
#	_text_edit.cut()
#	_text_edit.insert_text_at_cursor(_processed_text)

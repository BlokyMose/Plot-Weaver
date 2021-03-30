extends MarginContainer

var _logo_idle_color = Color8(149,149,149,255)
var _logo_hover_color = Color8(80,80,80,255)
var _logo_pressed_color = Color8(5,5,5,255)
var _logo_bg_idle_color = Color8(245,245,245,0)
var _logo_bg_hover_color = Color8(245,245,245,125)
var _logo_bg_pressed_color = Color8(245,245,245,255)

onready var _logo_button = $CornerMenu_VBox/Logo_Panel/Logo_Button
onready var _logo_bg = $CornerMenu_VBox/Logo_Panel/BG_Panel
onready var _file_dialog = get_parent().get_node("FileDialog")
onready var _writing_panel = get_parent().get_parent().get_node("Writing_Panel")


var _logo_pressing = false

func _ready():
	_set_menu_visibility(false)
	_logo_button.modulate = _logo_idle_color
	_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_idle_color

func _set_menu_visibility(show):
	for child in $CornerMenu_VBox/MenuList_VBox .get_children():
		child.visible = show

func _hide_menu():
	_set_menu_visibility(false)
	
func _show_menu():
	_set_menu_visibility(true)

# -- Signals --

func _on_Logo_Button_toggled(button_pressed):
	_set_menu_visibility(button_pressed)
	_logo_pressing = button_pressed
	if button_pressed:
		_logo_button.modulate = _logo_pressed_color
		_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_pressed_color
	else:
		_logo_button.modulate = _logo_idle_color
		_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_idle_color

func _on_Logo_Button_mouse_entered():
	_logo_button.modulate = _logo_hover_color
	_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_hover_color

func _on_Logo_Button_mouse_exited():
	
	if not _logo_pressing:
		_logo_button.modulate = _logo_idle_color
		_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_idle_color
	else:
		_logo_button.modulate = _logo_pressed_color
		_logo_bg.get("custom_styles/panel").bg_color = _logo_bg_pressed_color

func _on_Save_Button_button_down():
	_file_dialog.mode = FileDialog.MODE_SAVE_FILE
	_file_dialog.window_title = "Save As"
	_file_dialog.popup()

func _on_FileDialog_dir_selected(dir):
	var file = File.new()
	
func _on_FileDialog_file_selected(path):
	var data = _writing_panel.get_data()
	
	var json_data = JSON.print(data,"\t")
	
	var file = File.new()
	file.open(path,File.WRITE)
	file.store_string(json_data)

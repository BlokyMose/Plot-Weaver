extends Panel

export var highlight_color = Color8(0,0,0,150)
export var idle_color = Color8(0,0,0,64)

onready var button = $Settings_Button
var WBox_Settings_path = "res://Scenes/Writing/WBox_Settings.tscn"
var PW_ToolButton_path = "res://Scenes/General/PW_ToolButton.tscn"
var PW_ToolLineEdit_path = "res://Scenes/General/PW_ToolLineEdit.tscn"


onready var icon_MoveUp = preload("res://Assets/Images/Icons/PlotWeaver_Up.svg")
onready var icon_MoveDown = preload("res://Assets/Images/Icons/PlotWeaver_Down.svg")
onready var icon_MoveTo = preload("res://Assets/Images/Icons/PlotWeaver_UpDown.svg")

var keep_active = false
var is_showing_settings = false
var WBox_Settings

func _ready():
	button.visible = false
	
func show_button(show):
	if not show and not keep_active:
		button.visible = false
	else:
		button.visible = true

func reset_button():
	is_showing_settings = false
	keep_active = false
	higlight_button(false)
	show_button(false)
	if WBox_Settings != null:
		WBox_Settings.queue_free()
		
func on_click_outside():
	if WBox_Settings!=null:
		print("Not null : ", get_global_mouse_position())
		if not (get_global_mouse_position().x > WBox_Settings.rect_global_position.x and get_global_mouse_position().x < WBox_Settings.rect_global_position.x + WBox_Settings.rect_size.x):
			reset_button()
		elif not (get_global_mouse_position().y > WBox_Settings.rect_global_position.y and get_global_mouse_position().y < WBox_Settings.rect_global_position.y + WBox_Settings.rect_size.y):
			reset_button()

func higlight_button(highlight):
	if highlight:
		button.modulate = highlight_color
	else:
		button.modulate = idle_color

func create_settings():
	# Instantiation and positioning
	var WBox_Settings_file = load(WBox_Settings_path)
	WBox_Settings = WBox_Settings_file.instance()
	get_tree().get_root().add_child(WBox_Settings)
	WBox_Settings.rect_position = Vector2(rect_global_position.x-WBox_Settings.rect_size.x+rect_size.x,rect_global_position.y+rect_size.y)

	# Insert features
	var PW_Toolbutton_MoveUp = load(PW_ToolButton_path).instance()
	PW_Toolbutton_MoveUp.connect("click_event",self,"feature_move_up")
	PW_Toolbutton_MoveUp.setup("Move Up", icon_MoveUp)
	WBox_Settings.get_node("VBoxContainer").add_child(PW_Toolbutton_MoveUp)
	
	var PW_Toolbutton_MoveDown = load(PW_ToolButton_path).instance()
	PW_Toolbutton_MoveDown.connect("click_event",self,"feature_move_down")
	PW_Toolbutton_MoveDown.setup("Move Down", icon_MoveDown)
	WBox_Settings.get_node("VBoxContainer").add_child(PW_Toolbutton_MoveDown)
	
	var PW_Toolbutton_MoveTo = load(PW_ToolLineEdit_path).instance()
	PW_Toolbutton_MoveTo.connect("click_event",self,"feature_move_to")
	PW_Toolbutton_MoveTo.setup("Move To", icon_MoveTo, "index")
	WBox_Settings.get_node("VBoxContainer").add_child(PW_Toolbutton_MoveTo)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			on_click_outside()

# --- Features ---

func feature_move_up():
	if(owner.get_index()>0):
		owner.get_parent().move_child(owner,owner.get_index()-1)
		owner.get_parent().update_numbers() # supposedly call WBoxes_VBox
		reset_button()
	
func feature_move_down():
	if(owner.get_index()<owner.get_parent().get_child_count()-1):
		owner.get_parent().move_child(owner,owner.get_index()+1)
		owner.get_parent().update_numbers() # supposedly call WBoxes_VBox
		reset_button()
	
func feature_move_to(index):
	print("Moveto ",index)
	if index >= 0 and index <= owner.get_parent().get_child_count()-1:
		owner.get_parent().move_child(owner,index)
		owner.get_parent().update_numbers() # supposedly call WBoxes_VBox
		reset_button()

# --- Signals ---

func _on_Settings_Button_mouse_entered():
	keep_active = true
	higlight_button(true)

func _on_Settings_Button_mouse_exited():
	keep_active = false
	higlight_button(false)

func _on_Settings_Button_button_down():
	is_showing_settings = !is_showing_settings
	
	if is_showing_settings:
		create_settings()
	else:
		reset_button()

func _on_WBox_Panel_signal_hovering(is_hovering):
	show_button(is_hovering)

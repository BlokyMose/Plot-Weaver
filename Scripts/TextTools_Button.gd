extends Button

onready var _parent_panel = get_parent().get("custom_styles/panel")

func _ready():
	# warning-ignore:return_value_discarded
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	# warning-ignore:return_value_discarded
	connect("mouse_exited",self,"_on_Button_mouse_exited")
	

func _on_Button_mouse_entered():
	_parent_panel.bg_color = Color(_parent_panel.bg_color.r,_parent_panel.bg_color.g,_parent_panel.bg_color.b,0.5)

func _on_Button_mouse_exited():
	_parent_panel.bg_color = Color(_parent_panel.bg_color.r,_parent_panel.bg_color.g,_parent_panel.bg_color.b,0)

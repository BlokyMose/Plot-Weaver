extends Panel

var hover_opacity = 0.9
onready var bg_panel = get("custom_styles/panel")


func _ready():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,0)

# -- Signals --

func _on_Tags_Panel_mouse_entered():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,hover_opacity)

func _on_Tags_Panel_mouse_exited():
	bg_panel.bg_color = Color(bg_panel.bg_color.r,bg_panel.bg_color.g,bg_panel.bg_color.b,0)

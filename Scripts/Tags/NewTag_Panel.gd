extends Panel

const WHITE = "WHITE"
const RED = "Red"
const BLUE = "Blue"
const GREEN = "Green"
const YELLOW = "Yellow"
const CYAN = "Cyan"
const PURPLE = "Purple"
const ORANGE = "Orange"

onready var option_button = $Color_HBoxContainer/Color_OptionButton
onready var name_lineEdit = $Name_HBoxContainer/Name_LineEdit


func _ready():
	option_button.connect("item_selected",self,"on_item_selected")
	
	option_button.add_item(WHITE)
	option_button.add_item(RED)
	option_button.add_item(BLUE)
	option_button.add_item(GREEN)
	option_button.add_item(YELLOW)
	option_button.add_item(CYAN)
	option_button.add_item(PURPLE)
	option_button.add_item(ORANGE)

func on_item_selected(index):
	match option_button.text:
		WHITE:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		RED:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		BLUE:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		GREEN:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		YELLOW:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		CYAN:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		PURPLE:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)
		ORANGE:
			name_lineEdit.get("custom_styles/normal").bg_color = Color.rebeccapurple
			name_lineEdit.set("custom_colors/font_color", Color.rebeccapurple)

extends Control

export(ButtonGroup) var group

onready var line_edit_node = get_node("/root/World/LineEdit")

var blue_style_pressed = load("res://Assets/ButtonStyles/blue_style_pressed.tres")
var blue_style_unpressed = load("res://Assets/ButtonStyles/blue_style_unpressed.tres")
var blank_style = load("res://Assets/ButtonStyles/blank_style.tres")

signal text_updated
signal word_submitted

func _ready():
	for i in group.get_buttons():
		i.connect('pressed', self, 'button_pressed')
		# https://godotengine.org/qa/64697/tabcontainer-custom_styles-panel-stylebox-resource-script
		# THIS WORKS!!!
		i.set("custom_styles/hover", blue_style_unpressed)
		i.set("custom_styles/pressed", blue_style_pressed)
		i.set("custom_styles/focus", blank_style)
		i.set("custom_styles/normal", blue_style_unpressed)

func button_pressed():
	if group.get_pressed_button().text != 'ENTER' and group.get_pressed_button().text != 'BACK':
		line_edit_node.append_at_cursor(group.get_pressed_button().text)
		text_updated()
	if group.get_pressed_button().text == 'BACK':
		line_edit_node.delete_char_at_cursor()
		text_updated()
	if group.get_pressed_button().text == 'ENTER' and line_edit_node.text.length() >= 5:
		word_submitted()

# since lineedit doesnt support signal on manual text change... need to do this instead
func text_updated():
	emit_signal("text_updated")
	# fire a manual signal here??? connected to world main script

func word_submitted():
	emit_signal("word_submitted")

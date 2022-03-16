extends Control

export(ButtonGroup) var group

onready var line_edit_node = get_node("/root/World/LineEdit")

var blank_style = load("res://Assets/ButtonStyles/blank_style.tres")

var blue_style_pressed = load("res://Assets/ButtonStyles/blue_style_pressed.tres")
var blue_style_unpressed = load("res://Assets/ButtonStyles/blue_style_unpressed.tres")

var green_style_pressed = load("res://Assets/ButtonStyles/green_style_pressed.tres")
var green_style_unpressed = load("res://Assets/ButtonStyles/green_style_unpressed.tres")

var yellow_style_pressed = load("res://Assets/ButtonStyles/yellow_style_pressed.tres")
var yellow_style_unpressed = load("res://Assets/ButtonStyles/yellow_style_unpressed.tres")

var red_style_pressed = load("res://Assets/ButtonStyles/red_style_pressed.tres")
var red_style_unpressed = load("res://Assets/ButtonStyles/red_style_unpressed.tres")

signal text_updated
signal word_submitted
signal butts

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

func word_submitted():
	emit_signal("word_submitted")

# update the keyboard images with new colors
func _on_World_update_keyboard(updated_letters_dict):
	for i in group.get_buttons():
		# excludes 'enter' and 'back' keys
		if i.text.to_lower() in updated_letters_dict.keys():
			if updated_letters_dict[i.text.to_lower()] == 'green':
				i.set("custom_styles/hover", green_style_unpressed)
				i.set("custom_styles/pressed", green_style_pressed)
				i.set("custom_styles/focus", blank_style)
				i.set("custom_styles/normal", green_style_unpressed)
			elif updated_letters_dict[i.text.to_lower()] == 'yellow':
				i.set("custom_styles/hover", yellow_style_unpressed)
				i.set("custom_styles/pressed", yellow_style_pressed)
				i.set("custom_styles/focus", blank_style)
				i.set("custom_styles/normal", yellow_style_unpressed)
			elif updated_letters_dict[i.text.to_lower()] == 'gray':
				i.set("custom_styles/hover", red_style_unpressed)
				i.set("custom_styles/pressed", red_style_pressed)
				i.set("custom_styles/focus", blank_style)
				i.set("custom_styles/normal", red_style_unpressed)

extends Node

var current_row = 0

onready var word_groups = []

onready var word_groups_node = get_node("/root/World/WordDisplay/VBoxContainer")

onready var line_edit_node = get_node("/root/World/LineEdit")

var columns_max

var word_guesses_max

# Called when the node enters the scene tree for the first time.
func _ready():
	# word guesses total
	word_guesses_max = word_groups_node.get_child_count()
	# letters per word
	columns_max = word_groups_node.get_child(0).get_child_count()
	
	print(word_guesses_max)
	print(columns_max)
	
	for child_num in word_guesses_max:
		word_groups.append(word_groups_node.get_child(child_num))

func _on_VirtualKeyboard_text_updated():
	# iterates through each box and updates value in accordance with current
	#	state of LineEdit node.
	var column = 0
	for letter in line_edit_node.text:
		word_groups[current_row].get_child(column).get_child(0).text = letter
		column += 1
	# makes backspace work as intended visually
	if column < columns_max and column >= 0:
		word_groups[current_row].get_child(column).get_child(0).text = ''

func _on_VirtualKeyboard_word_submitted():
	# TODO:
	# Check if valid word before sumbitting
	# Check which letters match if any
	
	# If guesses remaining, then continue on
	if current_row < word_guesses_max - 1:
		current_row += 1
		line_edit_node.clear()
	# Otherwise, end the game
	else:
		print('***** GAME OVER *****')

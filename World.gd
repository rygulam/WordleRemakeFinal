extends Node

var current_row = 0

onready var word_groups = []

onready var word_groups_node = get_node("/root/World/WordDisplay/VBoxContainer")

onready var line_edit_node = get_node("/root/World/LineEdit")

var columns_max

var word_guesses_max

# path to file containing list of all valid 5-letter words i.e. chosen dictionary
onready var word_list_file = 'res://Assets/sgb-words.txt'

# contains list of all valid 5-letter words
var word_list_array = []

# goal word needed to be guessed to win the game
var goal_word

# dictionary containing all letters of the alphabet
# used for keeping track of which letters have been used and info about them
# WHITE - not guessed
# GRAY - guessed, but not present in word
# YELLOW - guessed, and present in word but not in correct place
# GREEN - guessed, and in correct place in word
var letters_dict = {'a':'white', 'b':'white', 'c':'white', 'd':'white', 'e':'white',
					'f':'white', 'g':'white', 'h':'white', 'i':'white', 'j':'white',
					'k':'white', 'l':'white', 'm':'white', 'n':'white', 'o':'white',
					'p':'white', 'q':'white', 'r':'white', 's':'white', 't':'white',
					'u':'white', 'v':'white', 'w':'white', 'x':'white', 'y':'white',
					'z':'white'}

# used to update keyboard
signal update_keyboard

var green_texture = load("res://Assets/Textures/green_pressed.png")
var gray_texture = load("res://Assets/Textures/grey_pressed.png")
var yellow_texture = load("res://Assets/Textures/yellow_pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# open sgb-words.txt
	load_file(word_list_file)
	word_list_array.sort()
	# pick a word randomly and set it to a variable
	# seeds the RNG based on current time
	randomize()
	goal_word = word_list_array[randi() % word_list_array.size()]
	print('goal word is: ' + goal_word)
	
	# word guesses total
	word_guesses_max = word_groups_node.get_child_count()
	# letters per word
	columns_max = word_groups_node.get_child(0).get_child_count()
	
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
	# strip casing
	var text_to_be_compared = line_edit_node.text
	text_to_be_compared = text_to_be_compared.to_lower()
	
	# lookup in dictionary
	if text_to_be_compared in word_list_array:
		
		compare_guess_to_goal_word(text_to_be_compared, current_row)
		
		# If guesses remaining, then continue on
		if current_row < word_guesses_max - 1:
			current_row += 1
			line_edit_node.clear()
		else:
			print('***** GAME OVER *****')
			$AcceptDialog/Label2.text = ('YOU LOSE')
			$AcceptDialog.popup()
			# TODO play end state of game here
	else:
		print('word not valid!!!')
		# basically just do not continue

func compare_guess_to_goal_word(guess, current_row):
	print('your guess is ' + guess)
	
	# check if goal word matches guess exactly
	if guess == goal_word:
		for index in goal_word.length():
			letters_dict[guess[index]] = 'green'
			word_groups[current_row].get_child(0).texture = green_texture
			word_groups[current_row].get_child(1).texture = green_texture
			word_groups[current_row].get_child(2).texture = green_texture
			word_groups[current_row].get_child(3).texture = green_texture
			word_groups[current_row].get_child(4).texture = green_texture
		emit_signal("update_keyboard", letters_dict)
		print('***** YOU WIN *****')
		$AcceptDialog/Label2.text = ('YOU WIN')
		$AcceptDialog.popup()
		# TODO play end state of game here
	else:
		print('time to check every letter')
		# iterate over every letter in guess
		# GREEN - if letter matches and in right place
		# YELLOW - if letter is found in word but NOT in right place
		# GRAY - if letter is NOT found in word
		for index in goal_word.length():
			if guess[index] == goal_word[index]:
				print('letter: ' + guess[index] + ' matches')
				# update master letter list as green character
				letters_dict[guess[index]] = 'green'
				# update texture in word display on top
				word_groups[current_row].get_child(index).texture = green_texture
			elif guess[index] in goal_word:
				print('letter: ' + guess[index] + ' is in word but not right place')
				# update texture
				word_groups[current_row].get_child(index).texture = yellow_texture
				# do not override green with yellow
				if letters_dict[guess[index]] != 'green':
					letters_dict[guess[index]] = 'yellow'
			else:
				print('letter: ' + guess[index] + ' is NOT in word')
				# update texture
				word_groups[current_row].get_child(index).texture = gray_texture
				letters_dict[guess[index]] = 'gray'
		
		# at the end, emit signal to update keyboard
		# pass along the newly updated letters_dict
		emit_signal("update_keyboard", letters_dict)

# loads in word file line-by-line and creates an array of strings
func load_file(file):
	
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	# iterate through all lines until the end of file is reached
	while not f.eof_reached():
		var line = f.get_line()
		# add word to array
		word_list_array.append(line)
		index += 1
	f.close()
	return

func _on_AcceptDialog_confirmed():
	get_tree().reload_current_scene()

func _on_AcceptDialog2_confirmed():
	get_tree().reload_current_scene()

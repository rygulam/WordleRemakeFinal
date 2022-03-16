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
		
		compare_guess_to_goal_word(text_to_be_compared)
		
		# If guesses remaining, then continue on
		if current_row < word_guesses_max - 1:
			current_row += 1
			line_edit_node.clear()
		else:
			print('***** GAME OVER *****')
			# TODO play end state of game here
	else:
		print('word not valid!!!')
		# basically just do not continue

func compare_guess_to_goal_word(guess):
	print('your guess is ' + guess)
	
	# check if goal word matches guess exactly
	if guess == goal_word:
		print('***** YOU WIN *****')
		# TODO play end state of game here
	else:
		print('time to check every letter')
		

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

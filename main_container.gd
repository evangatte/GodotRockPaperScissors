extends Control

# On Ready Variables
@onready var player_score_label: Label = $MarginContainer/VBoxContainer/ScoreDisplay/PlayerScoreLabel
@onready var winner_label: Label = $MarginContainer/VBoxContainer/ScoreDisplay/WinnerLabel
@onready var computer_score_label: Label = $MarginContainer/VBoxContainer/ScoreDisplay/ComputerScoreLabel
@onready var player_selection_label: Label = $MarginContainer/VBoxContainer/SelectionDisplay/PlayerSelectionLabel
@onready var computer_selection_label: Label = $MarginContainer/VBoxContainer/SelectionDisplay/ComputerSelectionLabel
@onready var rock_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/RockButton
@onready var paper_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/PaperButton
@onready var scissors_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ScissorsButton

@onready var winners_modal: CanvasLayer = $WinnersModal
@onready var winners_modal_button: Button = $WinnersModal/WinnersModalButton

# used to track player/computer score
var player_score: int = 0;
var computer_score: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock_button.pressed.connect(func(): _on_rps_button_pressed("rock"))
	paper_button.pressed.connect(func(): _on_rps_button_pressed("paper"))
	scissors_button.pressed.connect(func(): _on_rps_button_pressed("scissors"))
	
	winners_modal_button.pressed.connect(_on_winners_modal_button_pressed)
	
	set_up_new_game()

# sets up intial starting UI and player/computer score
func set_up_new_game():
	player_score = 0
	computer_score = 0
	
	winner_label.text = "First player to win 3 rounds wins game"
	player_score_label.text = str(player_score)
	computer_score_label.text = str(computer_score)
	

# main game logic
func handle_round(player_selection: String, computer_selection: String):
	# update player selection UI
	player_selection_label.text = "Player selected " + player_selection
	computer_selection_label.text = "Computer selected " + computer_selection

	if player_selection == computer_selection:
		winner_label.text = "Tie!"
	elif (player_selection == "rock" && computer_selection == "scissors") || (player_selection == "scissors" && computer_selection == "paper") || (player_selection == "paper" && computer_selection == "rock"):
		winner_label.text = "Player Wins Round!"
		player_score += 1
	
		# update player score UI
		player_score_label.text = str(player_score)
	else:
		winner_label.text = "Computer Wins Round!"
		computer_score += 1
		
		# update computer score UI
		computer_score_label.text = str(computer_score)
		
	# check for game winner
	if player_score >= 3:
		winners_modal.visible = true
		winners_modal_button.text = "Player wins game! Click anywhere to start new game"
	elif computer_score >= 3:
		winners_modal.visible = true
		winners_modal_button.text = "Computer wins game! Click anywhere to start new game"



# returns random rock, paper, or scissors
func get_random_computer_selection() -> String:
	var random_choice_array = ["rock", "paper", "scissors"]
	
	return random_choice_array.pick_random()
	
# handle player button press and run round
func _on_rps_button_pressed(player_selection: String) -> void:
	handle_round(player_selection, get_random_computer_selection())

func _on_winners_modal_button_pressed() -> void:
	set_up_new_game()
	winners_modal.visible = false

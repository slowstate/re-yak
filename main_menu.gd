extends Control

var arena = preload("res://arena.tscn")
@onready var start_button_1: Button = $StartMenu/StartButton1
@onready var start_button_2: Button = $Story/StartButton2
@onready var story: Node2D = $Story
@onready var start_menu: Node2D = $StartMenu


@onready var arena_background: Sprite2D = $Story/ArenaBackground
@onready var main_char: Sprite2D = $Story/MainChar
@onready var enemy: Sprite2D = $Story/Enemy
@onready var main_char_portrait: Sprite2D = $Story/MainCharPortrait
@onready var enemy_portrait: Sprite2D = $Story/EnemyPortrait
@onready var next_button: Button = $Story/NextButton
@onready var text_box: Sprite2D = $Story/TextBox
@onready var label: Label = $Story/Label
@onready var score_label: Label = $StartMenu/ScoreLabel

@onready var just_a_chill_guy: AudioStreamPlayer = $JustAChillGuy

@onready var game_time: Timer = $GameTime

var storyboard
var arena_instance
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	just_a_chill_guy.play()
	start_menu.visible = true
	story.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_1_pressed() -> void:
	start_menu.visible = false
	enemy_portrait.visible = false
	enemy.visible = false
	main_char_portrait.visible = true
	storyboard = 0
	label.text = "Ughhh.. Where the hell am I?? I was playing tag with Truck-kun just a second ago.. @_@"
	next_button.visible = true
	story.visible = true


func _on_next_button_pressed() -> void:
	if storyboard == 0:
		enemy_portrait.visible = true
		enemy.visible = true
		main_char_portrait.visible = false
		label.text = "Hey!! Who the hell are you?! D:<"
		storyboard += 1
	elif storyboard == 1:
		enemy_portrait.visible = false
		main_char_portrait.visible = true
		label.text = "I'm lost, can you please tell me where I am? ?_?"
		storyboard += 1
	elif storyboard == 2:
		enemy_portrait.visible = true
		main_char_portrait.visible = false
		label.text = "This is the base of the Black Bean Gang, you baka >:3"
		storyboard += 1
	elif storyboard == 3:
		enemy_portrait.visible = false
		main_char_portrait.visible = true
		label.text = "Oh, then can you please tell me how I can get home? ~_~"
		storyboard += 1
	else:
		enemy_portrait.visible = true
		main_char_portrait.visible = false
		label.text = "Kono yarou.. You're not getting out of here alive!! Guys, kill him!!! >:("
		next_button.visible = false
		start_button_2.visible = true

		
func _on_start_button_2_pressed() -> void:
	story.visible = false
	just_a_chill_guy.playing = false
	arena_instance = arena.instantiate()
	arena_instance.score.connect(on_score_update)
	arena_instance.set_name("Arena")
	add_child(arena_instance)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	start_button_2.visible = false
	game_time.start()


func _on_game_time_timeout() -> void:
	_ready()

func on_score_update(score: int):
	score_label.text = "Last Score: " + str(score)

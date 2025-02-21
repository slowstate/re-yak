extends Node2D

var enemy_scene = preload("res://Enemy/enemy.tscn")

@onready var player = $Player
@onready var enemy_spawn_timer = $"EnemySpawnTimer"

var enemy_limit = 1
var enemy_count = 0

@onready var total_score_label = $"TotalScoreLabel"
@onready var style_score_label = $"StyleScoreLabel"
@onready var style_label = $StyleLabel

var total_score = 0
var style_score = 0
var style = Style.C

enum Style {C, B, A}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_style()
	if get_tree().get_nodes_in_group("enemies").size() < enemy_limit:
		enemy_count+=1
		spawn_enemy()

	
func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	new_enemy.enemy_killed.connect(on_enemy_killed)
	new_enemy.player_hit.connect(on_player_hit)
	new_enemy.position = Vector2(randi_range(0, 1152),0)
	new_enemy.add_to_group("enemies")
	get_tree().root.get_child(0).add_child(new_enemy)

func on_enemy_killed():
	var base_score
	if style == Style.C: base_score = 1
	elif style == Style.B: base_score = 2
	elif style == Style.A: base_score = 3
	
	var score_from_kill = base_score
	
	style_score += score_from_kill
	total_score += score_from_kill

func on_player_hit():
	style_score = 0


func update_style():
	var style_string = "C"
	if style_score < 5:
		style = Style.C
		style_string = "C"
	elif style_score >= 5 && style_score < 15:
		style = Style.B
		style_string = "B"
	elif style_score >= 15:
		style = Style.A
		style_string = "A"
	
	style_score_label.text = "Style Score: " + str(style_score)
	total_score_label.text = "Total Score: " + str(total_score)
	style_label.text = "Style: " + style_string

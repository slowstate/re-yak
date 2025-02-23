extends Node2D

var enemy_scene = preload("res://Enemy/enemy.tscn")

@onready var pressure_style_c: AudioStreamPlayer = $Audio/Music/PressureStyleC
@onready var pressure_style_b: AudioStreamPlayer = $Audio/Music/PressureStyleB
@onready var pressure_style_a: AudioStreamPlayer = $Audio/Music/PressureStyleA


@onready var player = $Player
@onready var enemy_spawn_timer = $"EnemySpawnTimer"
@onready var kills_in_quick_succession_timer = $KillsInQuickSuccessionTimer

var enemy_limit = 2
var enemy_count = 0

@onready var total_score_label = $"TotalScoreLabel"
@onready var style_score_label = $"StyleScoreLabel"
@onready var style_label = $StyleLabel
@onready var style_upgrade_1: AudioStreamPlayer = $"Audio/SoundEffects/StyleUpgrade1"
@onready var style_upgrade_2: AudioStreamPlayer = $"Audio/SoundEffects/StyleUpgrade2"
@onready var style_lost: AudioStreamPlayer = $"Audio/SoundEffects/StyleLost"
@onready var enemy_hit: AudioStreamPlayer = $Audio/SoundEffects/EnemyHit
@onready var enemy_headshot_style_c: AudioStreamPlayer = $Audio/SoundEffects/EnemyHeadshotStyleC
@onready var enemy_headshot_style_b: AudioStreamPlayer = $Audio/SoundEffects/EnemyHeadshotStyleB
@onready var enemy_headshot_style_a: AudioStreamPlayer = $Audio/SoundEffects/EnemyHeadshotStyleA
@onready var combo_label = $ComboLabel
@onready var combo_label_timer = $ComboLabelTimer

var total_score = 0
var style_score = 0
var style_string = "C"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.style = Global.Style.C
	

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

func on_enemy_killed(headshot: bool):
	var score_from_kill
	combo_label.text = ""
	# Base score set on current style
	if Global.style == Global.Style.C: score_from_kill = 1
	elif Global.style == Global.Style.B: score_from_kill = 2
	elif Global.style == Global.Style.A: score_from_kill = 3
	combo_label.text = "Base           +" + str(score_from_kill) + "\n"
	
	# Multiply for each feat
	if headshot:
		score_from_kill *= 2
		combo_label.text += "Headshot  x2\n"
		if Global.style == Global.Style.B:
			enemy_headshot_style_b.volume_db = randf_range(-20,-15)
			enemy_headshot_style_b.pitch_scale = randf_range(0.8,1.2)
			enemy_headshot_style_b.play()
		elif Global.style == Global.Style.A:
			enemy_headshot_style_a.volume_db = randf_range(-20,-15)
			enemy_headshot_style_a.pitch_scale = randf_range(0.8,1.2)
			enemy_headshot_style_a.play()
		else: enemy_headshot_style_c.volume_db = randf_range(-20,-15)
		enemy_headshot_style_c.pitch_scale = randf_range(0.8,1.2)
		enemy_headshot_style_c.play()
	else: enemy_hit.volume_db = randf_range(-20,-15)
	enemy_hit.pitch_scale = randf_range(0.8,1.2)
	enemy_hit.play()
	if !kills_in_quick_succession_timer.is_stopped():
		score_from_kill *= 2
		combo_label.text += "Quick         x2\n"
	if !player.is_on_floor():
		score_from_kill *= 3
		combo_label.text += "Airborne    x3\n"
	
	style_score += score_from_kill
	total_score += score_from_kill
	
	kills_in_quick_succession_timer.wait_time = 0.5
	kills_in_quick_succession_timer.start()
	
	combo_label_timer.wait_time = 2
	combo_label_timer.start()


func on_player_hit():
	style_score = 0
	style_lost.play()


func update_style():
	if style_score < 20 && Global.style != Global.Style.C:
		Global.style = Global.Style.C
		style_string = "C"
		enemy_limit = 2
		pressure_style_c.volume_db = -10
		pressure_style_b.volume_db = -80
		pressure_style_a.volume_db = -80
	elif style_score >= 20 && style_score < 50 && Global.style != Global.Style.B:
		Global.style = Global.Style.B
		style_string = "B"
		enemy_limit = 3
		pressure_style_c.volume_db = -80
		pressure_style_b.volume_db = -9
		pressure_style_a.volume_db = -80
		style_upgrade_1.play()
	elif style_score >= 50 && Global.style != Global.Style.A:
		Global.style = Global.Style.A
		style_string = "A"
		enemy_limit = 5
		pressure_style_c.volume_db = -80
		pressure_style_b.volume_db = -80
		pressure_style_a.volume_db = -8
		style_upgrade_2.play()
	
	style_score_label.text = "Style Score: " + str(style_score)
	total_score_label.text = "Total Score: " + str(total_score)
	style_label.text = "Style: " + style_string


func _on_combo_label_timer_timeout():
	combo_label.text = ""

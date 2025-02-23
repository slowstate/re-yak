extends RigidBody2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player: AnimationPlayer = $EnemyAnimation/AnimationPlayer

@onready var enemy_state_machine = $EnemyStateMachine
@onready var player_detector_1 = $PlayerDetector1
@onready var player_detector_2 = $PlayerDetector2
@onready var player_detector_3 = $PlayerDetector3
@onready var back_detector_1 = $BackDetector1
@onready var back_detector_2 = $BackDetector2
@onready var attack_detector_1 = $AttackDetector1
@onready var attack_detector_2 = $AttackDetector2

@onready var enemy_headshot_style_c: AudioStreamPlayer = $EnemyHeadshotStyleC
@onready var enemy_hit: AudioStreamPlayer = $EnemyHit


signal enemy_killed(headshot: bool)
signal player_hit

var SPEED = 150
var DIRECTION = Vector2(1,0)
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if moving: linear_velocity.x = DIRECTION.x * SPEED #position += DIRECTIOzN.normalized() * SPEED * delta

func _on_body_entered(body):
	if body.collision_layer == 4:
		queue_free()

func _on_head_hitbox_area_entered(area):
	enemy_headshot_style_c.play()
	enemy_killed.emit(true)
	queue_free()
	
func _on_hitbox_area_entered(area):
	enemy_killed.emit(false)
	enemy_hit.play()
	queue_free()
	
func _on_enemy_roaming_look_right(look_right):
	looking_right(look_right)
func _on_chasing_player_look_right(look_right):
	looking_right(look_right)

func looking_right(is_looking_right: bool):
	if is_looking_right:
		DIRECTION = Vector2(1,0)
		animation_player.play("Run_Right")
	else:
		DIRECTION = Vector2(-1,0)
		animation_player.play("Run_Left")
	player_detector_1.target_position = Vector2( -650.0 if DIRECTION == Vector2(-1,0) else 650.0, 0.0 )
	player_detector_2.target_position = Vector2( -630.0 if DIRECTION == Vector2(-1,0) else 630.0, -50.0 )
	player_detector_3.target_position = Vector2( -610.0 if DIRECTION == Vector2(-1,0) else 610.0, -100.0 )
	back_detector_1.target_position = Vector2( 100.0 if DIRECTION == Vector2(-1,0) else -100.0, 0.0 )
	back_detector_2.target_position = Vector2( 80.0 if DIRECTION == Vector2(-1,0) else -90.0, -80.0 )
	attack_detector_1.target_position = Vector2( -50.0 if DIRECTION == Vector2(-1,0) else 50.0, 0.0 )
	attack_detector_2.target_position = Vector2( -40.0 if DIRECTION == Vector2(-1,0) else 40.0, -60.0 )

func _on_enemy_idle_moving(is_moving):
	moving = false
func _on_enemy_roaming_moving(is_moving):
	moving = true
func _on_chasing_player_moving(is_moving):
	moving = true

func _on_chasing_player_attack():
	player_hit.emit()
	if DIRECTION == Vector2(1,0):
		animation_player.play("Attack_Right")
	else:
		animation_player.play("Attack_Left")
	#if right:
		#animation_player.play("Attack_Right")
	#else:
		#animation_player.play("Attack_Left")

extends CharacterBody2D

@onready var player_state_machine = $PlayerStateMachine
@onready var gun_cooldown_timer = $GunCooldownTimer
@onready var gunshot_style_c: AudioStreamPlayer = $GunshotStyleC
@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var bullet_scene = preload("res://Player/Bullet/bullet.tscn")

var can_shoot = true

func _ready():
	Global.player = self
	animation_player.play("Run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("player_left_click"):
		if can_shoot:
			shoot_bullet()
			gunshot_style_c.play()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_move_left", "player_move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot_bullet():
	var shot_bullet = bullet_scene.instantiate()
	
	shot_bullet.position = global_position
	shot_bullet.set_direction(get_global_mouse_position() - shot_bullet.position)
	get_tree().root.get_child(0).add_child(shot_bullet)
	
	can_shoot = false
	gun_cooldown_timer.wait_time = 0.5
	gun_cooldown_timer.start()


func _on_gun_cooldown_timer_timeout():
	can_shoot = true

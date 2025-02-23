extends CharacterBody2D

@onready var player_state_machine = $PlayerStateMachine
@onready var gun_cooldown_timer = $GunCooldownTimer
@onready var gunshot_style_c: AudioStreamPlayer = $GunshotStyleC
@onready var gunshot_style_b: AudioStreamPlayer = $GunshotStyleB
@onready var gunshot_style_a: AudioStreamPlayer = $GunshotStyleA
@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var right_pistol: Sprite2D = $Animation/CharacterContainer/Body/RightHand/RightPistol
@onready var left_pistol: Sprite2D = $Animation/CharacterContainer/Body/LeftHand/LeftPistol
@onready var smg: Sprite2D = $Animation/CharacterContainer/Body/RightHand/SMG
@onready var right_pistol_animation_player: AnimationPlayer = $Animation/CharacterContainer/Body/RightHand/RightPistol/RightPistolAnimationPlayer
@onready var left_pistol_animation_player: AnimationPlayer = $Animation/CharacterContainer/Body/LeftHand/LeftPistol/LeftPistolAnimationPlayer
@onready var smg_animation_player: AnimationPlayer = $Animation/CharacterContainer/Body/RightHand/SMG/SMGAnimationPlayer
@onready var assault_rifle: Sprite2D = $Animation/CharacterContainer/Body/RightHand/assault_rifle
@onready var assault_rifle_animation_player: AnimationPlayer = $Animation/CharacterContainer/Body/RightHand/assault_rifle/AssaultRifleAnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var bullet_scene = preload("res://Player/Bullet/bullet.tscn")

var can_shoot = true
var bullet_origin = Vector2(12,-32)

var on_vertical_path = false

func _ready():
	Global.player = self
	floor_max_angle = deg_to_rad(80)
	
	
func _physics_process(delta):
	if Global.style == Global.Style.C:
		right_pistol.visible = true
		left_pistol.visible = true
		smg.visible = false
		assault_rifle.visible = false
	elif Global.style == Global.Style.B:
		right_pistol.visible = false
		left_pistol.visible = false
		smg.visible = true
		assault_rifle.visible = false
	elif Global.style == Global.Style.A:
		right_pistol.visible = false
		left_pistol.visible = false
		smg.visible = false
		assault_rifle.visible = true
	if velocity.x > 0:
		animation_player.play("Run_Right")
		bullet_origin = Vector2(12,-30)
		flip_guns(false)
		smg.position = Vector2(-149, -30)
		assault_rifle.position = Vector2(-190, -30)
	elif velocity.x < 0:
		animation_player.play("Run_Left")
		bullet_origin = Vector2(-12,-30)
		smg.position = Vector2(-149, 32)
		assault_rifle.position = Vector2(-190, 55)
		flip_guns(true)
	else:
		animation_player.pause()
	
	if on_vertical_path:
		velocity.y = 0
		if Input.is_action_pressed("player_move_up"):
			position.y -= SPEED * delta
		if Input.is_action_pressed("player_move_down"):
			position.y += SPEED * delta
	# Add the gravity.
	elif not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("player_left_click"):
		if can_shoot:
			shoot_bullet()
	
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
	
	shot_bullet.global_position = position + bullet_origin
	shot_bullet.set_direction(get_global_mouse_position() - shot_bullet.position)
	get_tree().root.get_child(0).add_child(shot_bullet)
	
	can_shoot = false
	if Global.style == Global.Style.B:
		gunshot_style_b.volume_db = randf_range(-25,-20)
		gunshot_style_b.pitch_scale = randf_range(0.8,1.2)
		gunshot_style_b.play()
		gun_cooldown_timer.wait_time = 0.4
		smg_animation_player.play("SMG Shooting")
	elif Global.style == Global.Style.A:
		gunshot_style_a.volume_db = randf_range(-30,-25)
		gunshot_style_a.pitch_scale = randf_range(0.8,1.2)
		gunshot_style_a.play()
		gun_cooldown_timer.wait_time = 0.2
		assault_rifle_animation_player.play("Shooting AK")
	else:
		gunshot_style_c.volume_db = randf_range(-30,-25)
		gunshot_style_c.pitch_scale = randf_range(0.8,1.2)
		gunshot_style_c.play()
		gun_cooldown_timer.wait_time = 0.5
		right_pistol_animation_player.play("Pistol Shooting")
		left_pistol_animation_player.play("Pistol Shooting")
	gun_cooldown_timer.start()


func _on_gun_cooldown_timer_timeout():
	can_shoot = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	on_vertical_path = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	on_vertical_path = false

func flip_guns(flip: bool):
	right_pistol.flip_v = flip
	left_pistol.flip_v = flip
	smg.flip_v = flip
	assault_rifle.flip_v = flip

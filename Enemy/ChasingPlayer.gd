class_name ChasingPlayer extends State

@onready var player_detector_1 = $"../../PlayerDetector1"
@onready var player_detector_2 = $"../../PlayerDetector2"
@onready var player_detector_3 = $"../../PlayerDetector3"

@onready var back_detector_1 = $"../../BackDetector1"
@onready var back_detector_2 = $"../../BackDetector2"
@onready var chasing_player_timer = $"../../ChasingPlayerTimer"

@onready var attack_detector_1 = $"../../AttackDetector1"
@onready var attack_detector_2 = $"../../AttackDetector2"
@onready var attack_timer = $"../../AttackTimer"

signal look_right(look_right: bool)
signal moving(is_moving: bool)
signal attack

func enter() -> void:
	moving.emit(true)
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if attack_range_detected() && attack_timer.is_stopped():
		attack.emit()
		attack_timer.wait_time = 3
		attack_timer.start()
	if !player_detected():
		if back_detected():
			look_right.emit(back_detector_1.target_position.x > 0)
		else: chasing_player_timer.start()
	else: look_right.emit(back_detector_1.target_position.x < 0)
	
func physics_update(delta: float) -> void:
	pass

func player_detected() -> bool:
	return player_detector_1.is_colliding() || player_detector_2.is_colliding() || player_detector_3.is_colliding()

func back_detected() -> bool:
	return back_detector_1.is_colliding() || back_detector_2.is_colliding()

func attack_range_detected() -> bool:
	return attack_detector_1.is_colliding() || attack_detector_2.is_colliding()

func _on_chasing_player_timer_timeout():
	transition.emit("EnemyIdle")

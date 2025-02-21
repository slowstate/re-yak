class_name EnemyIdle extends State

@onready var idle_timer = $"../../IdleTimer"
@onready var player_detector_1 = $"../../PlayerDetector1"
@onready var player_detector_2 = $"../../PlayerDetector2"
@onready var player_detector_3 = $"../../PlayerDetector3"

signal moving(is_moving: bool)

func enter() -> void:
	moving.emit(false)
	idle_timer.wait_time = randi_range(1, 3)
	idle_timer.start()
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if player_detected():
		idle_timer.stop()
		transition.emit("ChasingPlayer")
	
func physics_update(delta: float) -> void:
	pass

func _on_idle_timer_timeout():
	transition.emit("EnemyRoaming")

func player_detected() -> bool:
	return player_detector_1.is_colliding() || player_detector_2.is_colliding() || player_detector_3.is_colliding()

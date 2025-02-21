class_name EnemyRoaming extends State

@onready var roam_timer = $"../../RoamTimer"
@onready var player_detector_1 = $"../../PlayerDetector1"
@onready var player_detector_2 = $"../../PlayerDetector2"
@onready var player_detector_3 = $"../../PlayerDetector3"

signal look_right(look_right: bool)
signal moving(is_moving: bool)

func enter() -> void:
	if randf() > 0.5:
		look_right.emit(true)
	else:
		look_right.emit(false)
	moving.emit(true)
	roam_timer.wait_time = randi_range(1, 3)
	roam_timer.start()
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if player_detected():
		roam_timer.stop()
		transition.emit("ChasingPlayer")
	
func physics_update(delta: float) -> void:
	pass

func _on_roam_timer_timeout():
	transition.emit("EnemyIdle")

func player_detected() -> bool:
	return player_detector_1.is_colliding() || player_detector_2.is_colliding() || player_detector_3.is_colliding()

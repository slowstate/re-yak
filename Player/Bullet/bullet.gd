extends RigidBody2D

var SPEED = 2000
var DIRECTION = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	linear_velocity = DIRECTION.normalized() * SPEED

func set_direction(direction : Vector2):
	DIRECTION = direction


func _on_hitbox_area_entered(area):
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()

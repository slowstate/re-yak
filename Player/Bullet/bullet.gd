extends Area2D

var SPEED = 600
var DIRECTION = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	position+= DIRECTION.normalized() * SPEED * delta #// position.x+=SPEED * delta

func set_direction(direction : Vector2):
	DIRECTION = direction


func _on_area_entered(area):
	queue_free()

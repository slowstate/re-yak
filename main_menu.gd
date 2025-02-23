extends Control

var arena = preload("res://arena.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	var arena_instance = arena.instantiate()
	arena_instance.set_name("Arena")
	add_child(arena_instance)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

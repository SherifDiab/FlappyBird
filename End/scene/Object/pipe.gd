extends CharacterBody2D

signal update_score

@onready var top_pipe: Sprite2D = get_node("top_pipe/Sprite2D")
@onready var bottom_pipe: Sprite2D = get_node("bottom_pipe/Sprite2D")

const SPEED: = -100.0

func _ready():
	velocity = Vector2(SPEED, 0)

func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_screen_exited():
	Disable_Shape(top_pipe)
	Disable_Shape(bottom_pipe)
	queue_free()

func Disable_Shape(shape: Node) -> void:
	shape.set_deferred("disabled", true)

func set_pipe_texture(pipe: Node, skin: String) -> void:
	pipe.texture = load(skin)

func _on_area_2d_area_exited(area):
	update_score.emit()

func top_bottom_pipe_texture(value: String) -> void:
	set_pipe_texture(top_pipe, value)
	set_pipe_texture(bottom_pipe, value)

func stop_moving() -> void:
	set_physics_process(false)

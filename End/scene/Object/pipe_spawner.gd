extends Node2D

signal score_updated

const pipe_texture = ["res://assets/Sprite/FlappyAsset/pipe-green.png", "res://assets/Sprite/FlappyAsset/pipe-red.png"]

var Pipes: = preload("res://scene/Object/pipes.tscn")
var texture

func _ready():
	texture = pipe_texture[(randi() % pipe_texture.size())]

func _on_timer_timeout():
	var pipe = Pipes.instantiate()
	pipe.position.y = randi_range(-80, 112)
	pipe.update_score.connect(add_score)
	add_child(pipe)
	pipe.top_bottom_pipe_texture(texture)

func add_score() -> void:
	$PointScored.play()
	score_updated.emit()

extends ParallaxBackground

const scroll_speed = 100

func _process(delta):
	scroll_offset.x -=  scroll_speed * delta

func stop_moving() -> void:
	set_process(false)

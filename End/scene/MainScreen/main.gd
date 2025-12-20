extends Control

@onready var bg: = get_node("BG")
@onready var player: = get_node("Player")
@onready var spawn_pipe_timer: Timer = get_node("CanvasLayer/pipe_spawner/Timer")
@onready var hub: = get_node("HUD/ScoreContainer")
@onready var sky: = get_node("CanvasLayer/Sprite2D")

var countdown = 3

func _ready():
	randomize()
	sky.texture = load("res://assets/Sprite/FlappyAsset/background-" + str(randi_range(1, 2)) + ".png")
	# Initialize and show banner ad at the bottom of the screen
	_setup_banner_ad()


func _setup_banner_ad() -> void:
	# Show banner ad at the bottom of the screen
	AdMobManager.load_banner(AdPosition.Values.BOTTOM)

func _on_gameover():
	spawn_pipe_timer.stop()
	player.player_move(false)
	get_tree().call_group("pipes", "stop_moving")
	bg.stop_moving()
	$HUD.gameover_display()

func _on_start_game():
	player.player_visible(true)
	while countdown >= 0:
		hub.update_score(countdown)
		await get_tree().create_timer(1.0).timeout
		countdown -= 1
	player.player_move(true)
	player.ready_anim_play(false)
	spawn_pipe_timer.start()

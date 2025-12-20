extends TextureButton

signal startGame

@onready var banner: = get_node("Banner")
@onready var score_container: = get_node("ScoreContainer")
@onready var game_over_message: = get_node("GameOver")
@onready var point_score_container: = get_node("ScorePanel/PointScoreContainer")
@onready var best_score_container: = get_node("ScorePanel/BestScoreContainer")

var score = 0
var best_score = 0
var _waiting_for_ad: bool = false

func _on_pressed():
	disabled = true
	banner.hide()
	startGame.emit()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_score_updated():
	score += 1
	score_container.update_score(score)

func gameover_display() -> void:
	game_over_message.show()
	await get_tree().create_timer(2.0).timeout
	game_over_message.hide()
	score_container.hide()
	$ScorePanel.show()
	$DeathSound.play()
	point_score_container.update_score(score)
	if best_score < score or !score:
		best_score_container.update_score(score)

	# Show interstitial ad after each round ends
	_show_interstitial_ad()


func _show_interstitial_ad() -> void:
	# Connect to interstitial closed signal to handle ad completion
	if not AdMobManager.interstitial_closed.is_connected(_on_interstitial_closed):
		AdMobManager.interstitial_closed.connect(_on_interstitial_closed)

	# Show the interstitial ad
	AdMobManager.show_interstitial()


func _on_interstitial_closed() -> void:
	# Disconnect the signal to avoid multiple connections
	if AdMobManager.interstitial_closed.is_connected(_on_interstitial_closed):
		AdMobManager.interstitial_closed.disconnect(_on_interstitial_closed)

	# Ad has closed, game can continue normally
	print("[HUD] Interstitial ad closed, ready to restart")

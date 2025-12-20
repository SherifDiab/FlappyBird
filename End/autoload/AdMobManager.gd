extends Node

# AdMob Manager Singleton
# Uses the poing-studios Godot AdMob Plugin
# https://github.com/poing-studios/godot-admob-plugin

# Signals
signal banner_loaded
signal banner_failed_to_load(error_message: String)
signal interstitial_loaded
signal interstitial_failed_to_load(error_message: String)
signal interstitial_closed

# Ad Unit IDs (Replace with your actual AdMob IDs for production)
# These are test IDs provided by Google for development
const BANNER_AD_UNIT_ID_ANDROID: String = "ca-app-pub-3940256099942544/6300978111"
const BANNER_AD_UNIT_ID_IOS: String = "ca-app-pub-3940256099942544/2934735716"
const INTERSTITIAL_AD_UNIT_ID_ANDROID: String = "ca-app-pub-3940256099942544/1033173712"
const INTERSTITIAL_AD_UNIT_ID_IOS: String = "ca-app-pub-3940256099942544/4411468910"

# Ad references
var _ad_view: AdView = null
var _interstitial_ad: InterstitialAd = null

# Callbacks
var _ad_listener: AdListener
var _interstitial_ad_load_callback: InterstitialAdLoadCallback
var _full_screen_content_callback: FullScreenContentCallback


func _ready() -> void:
	_setup_callbacks()
	# Pre-load interstitial ad
	load_interstitial()


func _setup_callbacks() -> void:
	# Banner ad listener
	_ad_listener = AdListener.new()
	_ad_listener.on_ad_loaded = _on_banner_loaded
	_ad_listener.on_ad_failed_to_load = _on_banner_failed_to_load
	_ad_listener.on_ad_clicked = func(): print("[AdMob] Banner clicked")
	_ad_listener.on_ad_opened = func(): print("[AdMob] Banner opened")
	_ad_listener.on_ad_closed = func(): print("[AdMob] Banner closed")
	_ad_listener.on_ad_impression = func(): print("[AdMob] Banner impression")

	# Interstitial load callback
	_interstitial_ad_load_callback = InterstitialAdLoadCallback.new()
	_interstitial_ad_load_callback.on_ad_loaded = _on_interstitial_loaded
	_interstitial_ad_load_callback.on_ad_failed_to_load = _on_interstitial_failed_to_load

	# Interstitial full screen content callback
	_full_screen_content_callback = FullScreenContentCallback.new()
	_full_screen_content_callback.on_ad_clicked = func():
		print("[AdMob] Interstitial clicked")
	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func():
		print("[AdMob] Interstitial dismissed")
		_destroy_interstitial()
		emit_signal("interstitial_closed")
		# Pre-load next interstitial
		load_interstitial()
	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error: AdError):
		print("[AdMob] Interstitial failed to show: ", ad_error.message)
		emit_signal("interstitial_closed")
	_full_screen_content_callback.on_ad_impression = func():
		print("[AdMob] Interstitial impression")
	_full_screen_content_callback.on_ad_showed_full_screen_content = func():
		print("[AdMob] Interstitial showed")


func get_banner_ad_unit_id() -> String:
	if OS.get_name() == "Android":
		return BANNER_AD_UNIT_ID_ANDROID
	elif OS.get_name() == "iOS":
		return BANNER_AD_UNIT_ID_IOS
	return BANNER_AD_UNIT_ID_ANDROID


func get_interstitial_ad_unit_id() -> String:
	if OS.get_name() == "Android":
		return INTERSTITIAL_AD_UNIT_ID_ANDROID
	elif OS.get_name() == "iOS":
		return INTERSTITIAL_AD_UNIT_ID_IOS
	return INTERSTITIAL_AD_UNIT_ID_ANDROID


# Banner Ad Functions
func load_banner(position: int = AdPosition.Values.BOTTOM) -> void:
	# Destroy existing banner if any
	if _ad_view:
		_ad_view.destroy()
		_ad_view = null

	var ad_size = AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	_ad_view = AdView.new(get_banner_ad_unit_id(), ad_size, position)
	_ad_view.ad_listener = _ad_listener

	var ad_request = AdRequest.new()
	_ad_view.load_ad(ad_request)
	print("[AdMob] Loading banner ad...")


func show_banner() -> void:
	if _ad_view:
		_ad_view.show()
		print("[AdMob] Showing banner")


func hide_banner() -> void:
	if _ad_view:
		_ad_view.hide()
		print("[AdMob] Hiding banner")


func destroy_banner() -> void:
	if _ad_view:
		_ad_view.destroy()
		_ad_view = null
		print("[AdMob] Banner destroyed")


# Interstitial Ad Functions
func load_interstitial() -> void:
	var loader = InterstitialAdLoader.new()
	loader.load(get_interstitial_ad_unit_id(), AdRequest.new(), _interstitial_ad_load_callback)
	print("[AdMob] Loading interstitial ad...")


func show_interstitial() -> void:
	if _interstitial_ad:
		_interstitial_ad.show()
		print("[AdMob] Showing interstitial")
	else:
		print("[AdMob] Interstitial not loaded yet")
		emit_signal("interstitial_closed")
		# Try to load for next time
		load_interstitial()


func is_interstitial_loaded() -> bool:
	return _interstitial_ad != null


func _destroy_interstitial() -> void:
	if _interstitial_ad:
		_interstitial_ad.destroy()
		_interstitial_ad = null


# Banner Callbacks
func _on_banner_loaded() -> void:
	print("[AdMob] Banner loaded successfully")
	emit_signal("banner_loaded")
	show_banner()


func _on_banner_failed_to_load(load_ad_error: LoadAdError) -> void:
	print("[AdMob] Banner failed to load: ", load_ad_error.message)
	emit_signal("banner_failed_to_load", load_ad_error.message)


# Interstitial Callbacks
func _on_interstitial_loaded(interstitial_ad: InterstitialAd) -> void:
	print("[AdMob] Interstitial loaded successfully")
	interstitial_ad.full_screen_content_callback = _full_screen_content_callback
	_interstitial_ad = interstitial_ad
	emit_signal("interstitial_loaded")


func _on_interstitial_failed_to_load(load_ad_error: LoadAdError) -> void:
	print("[AdMob] Interstitial failed to load: ", load_ad_error.message)
	emit_signal("interstitial_failed_to_load", load_ad_error.message)

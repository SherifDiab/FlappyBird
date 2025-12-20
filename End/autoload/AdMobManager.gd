extends Node

# AdMob Manager Singleton
# Handles banner and interstitial ads for the game
# Requires the Godot AdMob Plugin to be installed for Android/iOS exports

# Signals
signal banner_loaded
signal banner_failed_to_load(error_code: int)
signal interstitial_loaded
signal interstitial_failed_to_load(error_code: int)
signal interstitial_closed

# Ad Unit IDs (Replace with your actual AdMob IDs for production)
# These are test IDs provided by Google for development
const BANNER_AD_UNIT_ID_ANDROID: String = "ca-app-pub-3940256099942544/6300978111"
const BANNER_AD_UNIT_ID_IOS: String = "ca-app-pub-3940256099942544/2934735716"
const INTERSTITIAL_AD_UNIT_ID_ANDROID: String = "ca-app-pub-3940256099942544/1033173712"
const INTERSTITIAL_AD_UNIT_ID_IOS: String = "ca-app-pub-3940256099942544/4411468910"

# AdMob plugin reference
var _admob = null
var _is_admob_available: bool = false
var _is_banner_loaded: bool = false
var _is_interstitial_loaded: bool = false
var _banner_visible: bool = false

# Banner position constants
enum BannerPosition { TOP, BOTTOM }
var current_banner_position: int = BannerPosition.BOTTOM


func _ready() -> void:
	_initialize_admob()


func _initialize_admob() -> void:
	# Check if AdMob plugin is available (only on Android/iOS)
	if Engine.has_singleton("AdMob"):
		_admob = Engine.get_singleton("AdMob")
		_is_admob_available = true

		# Connect signals
		_admob.connect("banner_loaded", _on_banner_loaded)
		_admob.connect("banner_failed_to_load", _on_banner_failed_to_load)
		_admob.connect("interstitial_loaded", _on_interstitial_loaded)
		_admob.connect("interstitial_failed_to_load", _on_interstitial_failed_to_load)
		_admob.connect("interstitial_closed", _on_interstitial_closed)

		# Initialize AdMob with test mode enabled for development
		# Set to false for production builds
		var is_test_mode: bool = true
		_admob.initialize(is_test_mode)

		print("[AdMob] Initialized successfully")

		# Pre-load interstitial ad
		load_interstitial()
	else:
		_is_admob_available = false
		print("[AdMob] Plugin not available - running in editor or unsupported platform")


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
func load_banner(position: int = BannerPosition.BOTTOM) -> void:
	if not _is_admob_available:
		print("[AdMob] Cannot load banner - AdMob not available")
		return

	current_banner_position = position
	var ad_unit_id = get_banner_ad_unit_id()

	# Position: TOP = 1, BOTTOM = 0 for the plugin
	var pos = 1 if position == BannerPosition.TOP else 0
	_admob.load_banner(ad_unit_id, pos)
	print("[AdMob] Loading banner ad...")


func show_banner() -> void:
	if not _is_admob_available:
		return

	if _is_banner_loaded:
		_admob.show_banner()
		_banner_visible = true
		print("[AdMob] Showing banner")
	else:
		# Load and show when ready
		load_banner(current_banner_position)


func hide_banner() -> void:
	if not _is_admob_available:
		return

	if _banner_visible:
		_admob.hide_banner()
		_banner_visible = false
		print("[AdMob] Hiding banner")


func destroy_banner() -> void:
	if not _is_admob_available:
		return

	_admob.destroy_banner()
	_is_banner_loaded = false
	_banner_visible = false
	print("[AdMob] Banner destroyed")


# Interstitial Ad Functions
func load_interstitial() -> void:
	if not _is_admob_available:
		print("[AdMob] Cannot load interstitial - AdMob not available")
		return

	var ad_unit_id = get_interstitial_ad_unit_id()
	_admob.load_interstitial(ad_unit_id)
	print("[AdMob] Loading interstitial ad...")


func show_interstitial() -> void:
	if not _is_admob_available:
		print("[AdMob] Cannot show interstitial - AdMob not available")
		emit_signal("interstitial_closed")
		return

	if _is_interstitial_loaded:
		_admob.show_interstitial()
		print("[AdMob] Showing interstitial")
	else:
		print("[AdMob] Interstitial not loaded yet")
		emit_signal("interstitial_closed")
		# Try to load for next time
		load_interstitial()


func is_interstitial_loaded() -> bool:
	return _is_interstitial_loaded


func is_banner_loaded() -> bool:
	return _is_banner_loaded


func is_admob_available() -> bool:
	return _is_admob_available


# Signal Callbacks
func _on_banner_loaded() -> void:
	_is_banner_loaded = true
	print("[AdMob] Banner loaded successfully")
	emit_signal("banner_loaded")
	# Auto-show banner when loaded
	show_banner()


func _on_banner_failed_to_load(error_code: int) -> void:
	_is_banner_loaded = false
	print("[AdMob] Banner failed to load. Error code: ", error_code)
	emit_signal("banner_failed_to_load", error_code)


func _on_interstitial_loaded() -> void:
	_is_interstitial_loaded = true
	print("[AdMob] Interstitial loaded successfully")
	emit_signal("interstitial_loaded")


func _on_interstitial_failed_to_load(error_code: int) -> void:
	_is_interstitial_loaded = false
	print("[AdMob] Interstitial failed to load. Error code: ", error_code)
	emit_signal("interstitial_failed_to_load", error_code)


func _on_interstitial_closed() -> void:
	_is_interstitial_loaded = false
	print("[AdMob] Interstitial closed")
	emit_signal("interstitial_closed")
	# Pre-load next interstitial
	load_interstitial()

# SlideDisplayWindow.gd
extends Window

# Script for individual display windows
# This allows you to create separate windows for each monitor

@export var is_dark_theme: bool = false
@export var monitor_index: int = 0

var slide_controller: Node
var display_rect: TextureRect

func _ready():
	# Set up the window
	title = "Slide Display - " + ("Dark" if is_dark_theme else "Light")
	
	# Create the main display
	display_rect = TextureRect.new()
	display_rect.name = "SlideDisplay"
	display_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	display_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	display_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Add to window
	add_child(display_rect)
	
	# Set window to specified monitor
	if monitor_index < DisplayServer.get_screen_count():
		var screen_rect = DisplayServer.screen_get_usable_rect(monitor_index)
		position = screen_rect.position
		size = screen_rect.size
		
		# Optional: Make it borderless fullscreen
		# borderless = true
		# mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	# Connect to the main controller
	slide_controller = get_node("/root/DualSlideController")
	if slide_controller:
		slide_controller.slide_changed.connect(_on_slide_changed)

func _on_slide_changed(slide_index: int):
	"""Called when the slide changes"""
	# This will be handled by the main controller
	pass

func set_slide_texture(texture: Texture2D):
	"""Set the current slide texture"""
	if display_rect:
		display_rect.texture = texture

func _input(event):
	"""Forward input to main controller"""
	if slide_controller:
		slide_controller._input(event)
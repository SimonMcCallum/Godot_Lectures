# DualSlideController.gd
extends Node

# Main controller script - attach to a Node in your main scene

signal slide_changed(slide_index)

@export var light_slides_path: String = "res://slides/light/"
@export var dark_slides_path: String = "res://slides/dark/"
@export var slide_extension: String = ".png"

var current_slide_index: int = 0
var total_slides: int = 0
var light_slides: Array[Texture2D] = []
var dark_slides: Array[Texture2D] = []

# References to display nodes
@onready var light_display: TextureRect
@onready var dark_display: TextureRect

func _ready():
	# Connect to display nodes (assuming they're children or findable by name)
	light_display = get_node("LightDisplay") as TextureRect
	dark_display = get_node("DarkDisplay") as TextureRect
	
	# Load all slide images
	load_slides()
	
	# Display first slide
	if total_slides > 0:
		update_displays()

func load_slides():
	"""Load all slide images from the specified directories"""
	var dir = DirAccess.open(light_slides_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var slide_count = 0
		
		while file_name != "":
			if file_name.ends_with(slide_extension):
				slide_count += 1
			file_name = dir.get_next()
		
		total_slides = slide_count
		
		# Load light theme slides
		for i in range(total_slides):
			var slide_path = light_slides_path + "slide_" + str(i + 1) + slide_extension
			var texture = load(slide_path) as Texture2D
			if texture:
				light_slides.append(texture)
			else:
				print("Failed to load light slide: ", slide_path)
		
		# Load dark theme slides
		for i in range(total_slides):
			var slide_path = dark_slides_path + "slide_" + str(i + 1) + slide_extension
			var texture = load(slide_path) as Texture2D
			if texture:
				dark_slides.append(texture)
			else:
				print("Failed to load dark slide: ", slide_path)
	
	print("Loaded ", total_slides, " slides")

func _input(event):
	"""Handle input for slide navigation"""
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_RIGHT, KEY_SPACE, KEY_DOWN:
				next_slide()
			KEY_LEFT, KEY_UP:
				previous_slide()
			KEY_HOME:
				go_to_slide(0)
			KEY_END:
				go_to_slide(total_slides - 1)
			KEY_ESCAPE:
				get_tree().quit()
	
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			next_slide()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			previous_slide()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			previous_slide()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			next_slide()

func next_slide():
	"""Navigate to the next slide"""
	if current_slide_index < total_slides - 1:
		current_slide_index += 1
		update_displays()

func previous_slide():
	"""Navigate to the previous slide"""
	if current_slide_index > 0:
		current_slide_index -= 1
		update_displays()

func go_to_slide(index: int):
	"""Navigate to a specific slide"""
	if index >= 0 and index < total_slides:
		current_slide_index = index
		update_displays()

func update_displays():
	"""Update both displays with the current slide"""
	if current_slide_index < light_slides.size():
		light_display.texture = light_slides[current_slide_index]
	
	if current_slide_index < dark_slides.size():
		dark_display.texture = dark_slides[current_slide_index]
	
	# Emit signal for any listeners
	slide_changed.emit(current_slide_index)
	
	# Update slide counter (if you have a UI element for it)
	update_slide_counter()

func update_slide_counter():
	"""Update slide counter display"""
	var counter_text = str(current_slide_index + 1) + " / " + str(total_slides)
	# You can connect this to a Label node if you want to show slide numbers
	print("Slide: ", counter_text)

# Additional utility functions
func get_current_slide_index() -> int:
	return current_slide_index

func get_total_slides() -> int:
	return total_slides

func is_first_slide() -> bool:
	return current_slide_index == 0

func is_last_slide() -> bool:
	return current_slide_index == total_slides - 1
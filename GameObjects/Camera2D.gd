extends Camera2D

@export var zoomModifier = 1.5
@export var isZoomed = false
var light
var ui

# Called when the node enters the scene tree for the first time.
func _ready():
	light = $PointLight2D
	ui = $GameTimer
	do_zoom()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func do_zoom():
	print("DOZOOM")
	if (isZoomed):
		un_zoom()
	else:
		zoom_out()
	
func un_zoom():
	print("unzoom")
	zoom.x = zoom.x * zoomModifier
	zoom.y = zoom.y * zoomModifier
	light.scale.x = light.scale.x / zoomModifier
	light.scale.y = light.scale.y / zoomModifier
	ui.position.x = ui.position.x / zoomModifier
	ui.position.y = ui.position.y / zoomModifier
	isZoomed = false

func zoom_out():
	print("zoomout")
	zoom.x = zoom.x / zoomModifier
	zoom.y = zoom.y / zoomModifier
	light.scale.x = light.scale.x * zoomModifier
	light.scale.y = light.scale.y * zoomModifier
	ui.position.x = ui.position.x * zoomModifier
	ui.position.y = ui.position.y * zoomModifier
	isZoomed = true

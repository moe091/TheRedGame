extends Label

@export var duration = 60000.0
@export var labelText = "TIME: "
var running = false
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	timer.wait_time = duration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		text = labelText + str(duration - timer.time_left).pad_decimals(2)
	else:
		text = labelText
	


func start():
	running = true
	timer.start()
	
func stop():
	running = false
	timer.stop()

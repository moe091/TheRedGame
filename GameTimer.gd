extends Timer

@export var duration = 60000
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $"."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
	

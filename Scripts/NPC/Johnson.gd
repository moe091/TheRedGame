extends NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func jump():
	applyForce(3900, -24000)
	await get_tree().create_timer(2.1).timeout
	body.linear_velocity.x = 0
	
func leaveHouse():
	#applyForce(8000, 0)
	move(400)
	
func turnAround():
	applyForce(0, -3000)
	await get_tree().create_timer(0.1).timeout
	setFlipH(true)
	

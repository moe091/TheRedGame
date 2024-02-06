extends Level

@onready var box1 = $Objects/Box1
@onready var box2 = $Objects/Box2
@onready var player = $PlayerNode
@onready var jumpCheckpoint = $Areas/JumpCheckpoint
#var eventGroup1 = load("res://Scripts/src/events/EventGroup.gd").new()
#interaction = preload("src/events/event.gd").instantiate()
#interaction.parent = get("johnson")
#interaction.type = "dialog"
#interaction.pauseTime = 2
#interaction.data = "Young one!"
#interaction.next = set next somehow
var johnson = preload("res://GameObjects/NPCs/Johnson.tscn").instantiate()
#var johnsonInteractions = ["Young one!", 
#	"I've come all the way down from the ninth, just to see you!", 
#	"Have you heard? The madman is back, he's rambling his ramblings in the square at this very moment!",
#	"As soon as I heard, I thought to myself: 'What a teachable moment!' and I came straight down to the first to find you.",
#	"They laugh at me up on the ninth, for deigning to come all the way down here... they all lack my humility... Not to mention my wisdom!",
#	"No need to thank me, young pupil. I've come not for praise, but to spill a few drops of my wisdom, lest I overflow.",
#	"Now lets get going. This way, follow me!",
#	jumpJohnson]
#var johnsonInteractions2 = ["Perhaps we should use the front door instead",
#[leaveJohnson, 4],
#stopJohnson]




# Called when the node enters the scene tree for the first time.
func _ready():
	#var events = EventLoader.loadEvents("res://Scripts/src/events/EventStore/testevent.json", self, johnson)
	#johnson.setEvents(events, true)
	EventController.loadChain("Level1/testevent", self, johnson)
	EventController.loadMap("Level1/playerEvents1", self, player)
	EventController.startGroup("johnson1")
	
	#eventGroups.append(eventGroup1)
	#eventGroup1.loadEvents("Level1/testevent", self, johnson)
	#eventGroup1.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)


func spawnJohnson():
	johnson.position.x = -2792
	johnson.position.y = -385
	add_child(johnson)
	#johnson.setInteractions(johnsonInteractions, true)
	
func jumpJohnson():
	johnson.jump()
	#johnson.turnAround()
	await get_tree().create_timer(3.5).timeout
	#johnson.setInteractions(johnsonInteractions2, true)
	#speak("Young one! Didn't you hear me calling? I've come all the way down from the ninth, just to see you!", 3, true)

func leaveJohnson():
	johnson.leaveHouse()
	
func stopJohnson():
	johnson.stop()


func _on_box_body_entered(body):
	if "collision_layer" in body and body.get_groups().has("johnson"):
		box1.explode()

func _on_box_2_body_entered(body):
	if "collision_layer" in body and body.get_groups().has("johnson"):
		box2.explode()


func playerPastX(condition): #if condition has postDelay, could add await here before returning
	if player.x > condition.event.args:
		return true
	else:
		return false

func playerAboveY(condition):
	print("\n\nCHECKING PLAYER ABOVE Y ", condition.event.args)
	print("CURRENT Y = ", player.y)
	if player.y < condition.event.args:
		return true
	else:
		return false




func _on_jump_checkpoint_body_entered(body):
	print("BODY ENTERED JUMP CHECKPOINT", body)
	print("IS IN PLAYER GROUP:", body.is_in_group("PLAYER"))
	pass # Replace with function body.

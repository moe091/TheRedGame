extends Node2D
class_name Level

var eventTimer1 : Timer
var interactTarget = null
var event = load("res://Scripts/src/events/Event.gd")
var eventLoader = load("res://Scripts/src/events/EventLoader.gd").new()
var EventController = load("res://Scripts/src/events/EventController.gd").new()
var eventGroups : Array = []
var conditions : Array = []
var eraseConds : Array = []
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if interactTarget and Input.is_action_just_pressed("interact"):
		#interactTarget.interact()
		interact(interactTarget)
		
	for c in conditions:
		if (c.check.call(c)):
			print("CONDITION MET!")
			c.callback.call()
			eraseConds.append(c)
			
	#need separate loop to erase from conditions. If done while looping conditions, will skipe elements and go out of bounds		
	for c in eraseConds:
		conditions.erase(c)
		
			
	

func interact(target):
	EventController.interact(target)
	
func awaitCondition(event, callback):
	print("[Level::awaitCondition] AWATING CONDITION: ", event.condition)
	if event.condition.contains("."):
		var parts = event.condition.split(".")
		
		if parts[0] == "checkpoint":
			print("[Level::awaitCondition] Creating callback for function isTriggered in " + parts[1])
			var checkpointArea = self[parts[1]]
			var callable = Callable(self[parts[1]], "isTriggered")
			#parts[1] must match a checkpoint name which is defined as a variable in the current level.
			#e.g. "checkpoint.onRoof" will look for an object named onRoof in the current level(ref) and call the isTriggered function on it
			conditions.append({"event": event, "check": callable, "callback": callback})
		else:
			print("[Level::awaitCondition] UNKNOWN CONDIITION TYPE: ", parts[0])
	else:
		print("[Level::awaitCondition] Normal condition. Creating callback")
		conditions.append({"event": event, "check": Callable(self, event.condition), "callback": callback})
	
	
	
	
	
	
func setInteractable(target, canInteract):
	if canInteract:
		interactTarget = target
	elif interactTarget == target:
		interactTarget = null
		
	if interactTarget and "printName" in interactTarget:
		interactTarget.printName()
		


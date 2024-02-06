extends Area2D

#what group has to touch this checkpoint to trigger it. Default is player
@export var triggeredByGroup : String = "PLAYER"
@export var active : bool = true #is checkpoint active by default. If not, it won't be triggerable until some other event makes it active
var triggered : bool = false


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func isTriggered(_condition): #condition is passed into all conditional triggers. don't need to use it here though
	return triggered
	
func _on_body_entered(body):
	if active:
		print("[DEBUG] Body entered checkpoint", body)
		if body.is_in_group(triggeredByGroup):
			print("[DEBUG] Checkpoint triggered by ", triggeredByGroup)
			triggered = true
	else:
		print("[DEBUG] Body entered checkpoint, but checkpoint is not active yet!", body)

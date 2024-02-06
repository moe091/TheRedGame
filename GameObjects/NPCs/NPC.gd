extends Node2D
class_name NPC
@onready var body = $Body
@onready var speech = $Anchor/SpeechBox
@onready var sprite = $Anchor/AnchoredSprite
@onready var me = $"."
@onready var interactShape = $Anchor/InteractableArea/CollisionShape2D
@onready var interactIcon = $Anchor/InteractIcon

var interactable : bool = false: set = _setInteractable
var interactions : Array = []
var currentInteraction = 0

var events : Array = []
var curEvent : int = 0

var targetSpeed : int = 0
var linearAccel : Vector2 = Vector2(0, 0)
var angAccel : Vector2 = Vector2(0, 0)
var accelSpeed : int = 6000
var angSpeed : int = 3000
var stopping : bool = false

func _setInteractable(val):
	if interactShape:
		interactShape.disabled = !val
	
	if interactIcon:
		interactIcon.visible = val
			
			
	interactable = val
		

# Called when the node enters the scene tree for the first tme.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if targetSpeed > 0 and body.linear_velocity.x < targetSpeed:
		moveRight(delta)
	elif targetSpeed < 0 and body.linear_velocity.x > targetSpeed:
		moveLeft(delta)
	elif stopping:
		slowToStop(delta)
	
	
func slowToStop(delta):
	if abs(body.linear_velocity.x) < 100:
		body.linear_velocity.x = 0
		body.linear_velocity.y = 0
		body.angular_velocity = 0
		stopping = false
	elif body.linear_velocity.x > 0: #this could say >50, same thing
		moveLeft(delta)
	else:
		moveRight(delta)
	
	
func moveRight(delta):
	linearAccel.x = accelSpeed * delta
	angAccel.x = angSpeed * delta
	body.apply_central_force(linearAccel)
	body.apply_torque_impulse(angSpeed * delta)
	
func moveLeft(delta):
	linearAccel.x = -accelSpeed * delta
	angAccel.x = -angSpeed * delta
	body.apply_central_force(linearAccel)
	body.apply_torque_impulse(-angSpeed * delta)
	

func setFlipH(flip):
	sprite.flip_h = flip
	
func applyForce(x, y):
	body.apply_central_force(Vector2(x, y))
	
		
func setEvents(e, autoStart):
	events = e
	curEvent = 0
	if autoStart:
		events[curEvent].do()
		
func interact(): #may want logic here to decide whether to actually do next interaction.
	#nextInteraction()
	pass
#	if curEvent < events.size() and events[curEvent].interactable:
#		await events[curEvent].do()
#		#print("FINISHED EVENT", events[curEvent].data)

		

func speak(text, duration, hideWhenDone):
	speech.visible = true
	speech.setText(text)
	if hideWhenDone:
		await get_tree().create_timer(duration).timeout
		speech.visible = false
		speech.setText("")
		
func speakMultiple(texts, durations, hideWhenDone):
	var doHide = false
	for i in texts.size():
		if i == texts.size() - 1 and hideWhenDone:
			doHide = true
		speak(texts[i], durations[i], doHide)
		await get_tree().create_timer(durations[i]).timeout
		
		
func hideSpeech(resetInteractions=false):
	speech.visible = false
	if resetInteractions:
		currentInteraction = 0
		
func stop():
	stopping = true
	targetSpeed = 0
#	body.linear_velocity.x = 0
#	body.linear_velocity.y = 0
#	body.angular_velocity = 0
#	targetSpeed = 0

func move(speed):
	targetSpeed = speed
	
func _on_interactable_area_entered(area):
	if interactable:
		get_tree().get_current_scene().setInteractable(me, true)


func _on_interactable_area_exited(area):
	get_tree().get_current_scene().setInteractable(me, false)
	

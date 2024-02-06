extends Node

signal body_entered_player
const KILL_LAYER = 4
const LEFT = -1
const RIGHT = 1
var baseSprite = load("res://Images/ball.png")
var dashSprite = load("res://Images/ball_dash.png")

var player
var feet
var head
var leftHand
var rightHand
var sprite
var camera
var timer
var outerSprite
var dashParticles
@onready var speech = $center/SpeechBubble

var x: get = _getPlayerX
var y: get = _getPlayerY



@export_category("Jumping")
@export var jumpVector: Vector2 = Vector2(0, -650) #vector for impulse created by ground jump
@export var doubleJumpPower: int = -1000 #vector for impulse created by ground jump
@export var doubleJumpMin: int = -500 #vector for impulse created by ground jump
@export var doubleJumpMax: int = -5000 #vector for impulse created by ground jump
@export var jumpingPlus: int = -550 #if jump button is held, 200*delta up-impulse added each frame
@export var jumpingTimeout: float = 0.7
@export var wallJumpXPower: int  = 1000
@export var wallJumpYPower: int = -650


var onLeftWall = false
var onRightWall = false
var gravScale
var onGround: bool = false
var onRoof: bool = false
var onSurface: bool = false
var jumpBuffer: float = 0

@export_category("Dashing")
@export var dashTime = 0.5
@export var dashCooldown = 5
@export var dashPower = 750

@export_category("Movement")
@export var gravity = 1.5
@export var angularAccel = 16000 #amount of angular momentum applied when left/right is held
@export var linearAccel = 270 #amount of horizontal force applied when left/right is held



##############################################################################################
########################################### -SETUP- ##########################################
##############################################################################################
func _ready():
	camera = $center/Camera2D
	player = $Player
	feet = $center/Feet
	head = $center/Head
	leftHand = $center/LeftHand
	rightHand = $center/RightHand
	sprite = $Player/BallSprite
	outerSprite = $center/OuterSprite
	timer = $center/Camera2D/GameTimer
	dashParticles = $center/DashParticles
	gravScale = player.gravity_scale
	sprite.texture = baseSprite
	
	
func setSprite(s):
	sprite.texture = s
	

func _input(event):
	if event is InputEventKey:
		if (!timer.running):
			timer.start()
	
	
	
func speak(text, duration, hideWhenDone):
	speech.visible = true
	speech.setText(text)
	if hideWhenDone:
		await get_tree().create_timer(duration).timeout
		speech.visible = false
		speech.setText("")
###############################################################################################
########################################### -CHECKERS- ########################################
###############################################################################################
func checkWalls():
	if leftHand.is_on_wall():
		if !onLeftWall:
			player.touchLeftWall()
		onLeftWall = true
	else:
		onLeftWall = false	
		
	if rightHand.is_on_wall():
		if !onRightWall:
			player.touchRightWall()
		onRightWall = true
	else:
		onRightWall = false
		
		
func checkGround():
	if onGround and !feet.is_on_ground(): #JUST left the ground	
		if !player.jumping:
			player.setCanDouble(true)
	onGround = feet.is_on_ground()
	onSurface = onGround
	
	if onGround:
		if player.canDouble:
			player.setCanDouble(false)
		player.canDash = true;
		

			
func checkRoof():
	if onRoof and !head.is_on_ground(): #JUST left the ground	
		if !player.jumping:
			player.setCanDouble(true)
	onRoof = head.is_on_ground()
	onSurface = onRoof
	
	if onRoof:
		if player.canDouble:
			player.setCanDouble(false)
		player.canDash = true;
	
	
func checkInputs(delta):
	if !onSurface && player.canDash && Input.is_action_just_pressed("right_dash"):
		dashParticles.emitting = false
		dashParticles.emitting = true
		player.dash(RIGHT)
	
	if !onSurface && player.canDash && Input.is_action_just_pressed("left_dash"):
		dashParticles.emitting = false
		dashParticles.emitting = true
		player.dash(LEFT)
		
			
	if Input.is_action_just_pressed("tab"):
		camera.do_zoom()	
	
	if Input.is_action_just_pressed("left"):
		outerSprite.flip_h = true
	if Input.is_action_just_pressed("right"):
		outerSprite.flip_h = false
		
	if Input.is_action_pressed("left"):
		player.moveLeft(onSurface, delta)
		
	if Input.is_action_pressed("right"):
		player.moveRight(onSurface, delta)
			
	if !Input.is_action_pressed("up"):
		player.jumping = false;
		
	if Input.is_action_just_pressed("up") || jumpBuffer > 0:
		jumpBuffer-= delta
		if onSurface: #regular jump
			if (!Input.is_action_just_pressed("up")): #kill y velocity before queue'd jump, otherwise it will bounce a bit and jump way higher
				player.linear_velocity.y = 0
			player.jump()
		elif  leftHand.is_on_wall() and Input.is_action_just_pressed("up"):
			player.wallJump(RIGHT)
		elif  rightHand.is_on_wall() and Input.is_action_just_pressed("up"):
			player.wallJump(LEFT)
		elif player.canDouble: 
			player.doubleJump()
		elif Input.is_action_just_pressed("up"):
			jumpBuffer = 0.2
			
	if Input.is_action_just_released("reset"):
		get_tree().reload_current_scene()
			
			
			
			
###############################################################################################
########################################### -PROCESS- #########################################
###############################################################################################
func _process(delta):
	checkWalls()
	
	if player.reverseGrav < 0:
		checkRoof()
	else:
		checkGround()
		
	checkInputs(delta)
	
	
	
	
###############################################################################################
########################################### -SIGNALS- #########################################
###############################################################################################

func _on_player_body_entered(body):
	if ("collision_layer" in body and body.collision_layer == KILL_LAYER):
		get_tree().reload_current_scene()
	emit_signal("body_entered_player", body)


func _on_gravity_up_player_entered_grav_up():
	gravity = gravScale * -1
	player.reverseGrav = -1
	

func _on_gravity_down_player_entered_grav_down():
	gravity = gravScale
	player.reverseGrav = 1


func _on_interaction_area_entered(area):
	pass
	
	
func _getPlayerX():
	return player.position.x
	
func _getPlayerY():
	return player.position.y

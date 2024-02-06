extends RigidBody2D


var par

var jumping: bool = false
var jumpCountdown: float = 0
var jumpQueued: bool = false
var dashing: bool = false
var canDash: bool = false
var canDouble: bool = false
var reverseGrav: int = 1
var timeSinceJump = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	par = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dashing:
		gravity_scale = 0
	else:
		gravity_scale = par.gravity
		
	if jumpCountdown > 0:
		jumpCountdown -= delta
	elif jumpQueued:
		doubleJump()
		
	if jumping:
		timeSinceJump+= delta
		if timeSinceJump > 0.7:
			jumping = false
		else:
			apply_central_impulse(Vector2(0, delta * par.jumpingPlus * reverseGrav))

		
		
		
func moveRight(onGround, delta):
	if onGround:
		apply_torque_impulse(delta * par.angularAccel * reverseGrav)
		apply_central_impulse(Vector2(delta * par.linearAccel, 0))
	else:
		apply_torque_impulse(delta * par.angularAccel * reverseGrav)
		apply_central_impulse(Vector2(delta * par.linearAccel / 2, 0))
		
func moveLeft(onGround, delta):
	if onGround:
		apply_torque_impulse(-delta * par.angularAccel * reverseGrav)
		apply_central_impulse(Vector2(-delta * par.linearAccel, 0))
	else:
		apply_torque_impulse(-delta * par.angularAccel * reverseGrav)
		apply_central_impulse(Vector2(-delta * par.linearAccel / 2, 0))
	
func jump(): #only called when jumping is possible		
	timeSinceJump = 0
	apply_central_impulse(par.jumpVector * reverseGrav)
	jumping = true
	setCanDouble(false)
	
	await get_tree().create_timer(par.jumpingTimeout).timeout 
	setCanDouble(true)
	
func doubleJump():
	if jumpCountdown > 0:
		jumpQueued = true
		return
	else:
		jumpQueued = false
		
	dashing = false
	setCanDouble(false)
	if Input.is_action_pressed("left"):
		apply_central_impulse(Vector2(-200, par.doubleJumpPower * 0.8 * reverseGrav))
	elif Input.is_action_pressed("right"):
		apply_central_impulse(Vector2(200, par.doubleJumpPower * 0.8 * reverseGrav))
	else:
		apply_central_impulse(Vector2(0, par.doubleJumpPower * reverseGrav))
		
		
func wallJump(dir): #can doublejump BEFORE walljump, but not after
	#setCanDouble(false)
	#dashing = false #don't do this - leave dash-wallumps in as a mechanic for higher walljumps
	apply_central_impulse(Vector2(dir * par.wallJumpXPower, par.wallJumpYPower * reverseGrav))
	apply_torque_impulse(par.angularAccel * dir * reverseGrav)
	jumpCountdown = 0.2
	
	
func dash(dir):
	canDash = false
	dashing = true
	linear_velocity.y = 0
	if dir * linear_velocity.x < 250:
		apply_central_impulse(Vector2(dir * par.dashPower * 1.5, 0))
	else:
		apply_central_impulse(Vector2(dir * par.dashPower, 0))
	
	await get_tree().create_timer(par.dashTime).timeout
	dashing = false
	
	
func setCanDouble(val):
	canDouble = val
	if canDouble:
		par.setSprite(par.dashSprite)
	else:
		par.setSprite(par.baseSprite)
		
func touchLeftWall():
	linear_velocity.x = 0
	
func touchRightWall():
	linear_velocity.x = 0

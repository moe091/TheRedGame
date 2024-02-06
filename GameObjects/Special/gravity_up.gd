extends Area2D

signal player_entered_grav_up



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print('body', body)
	if ("collision_layer" in body and body.collision_layer == 1):
		print('LAYER 1')
		emit_signal('player_entered_grav_up')

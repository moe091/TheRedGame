extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("LEVEL 3 LOADED")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("PLAYER_BODY_SHAPE_ENTERED!")

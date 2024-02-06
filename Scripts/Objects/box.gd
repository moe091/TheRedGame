extends RigidBody2D
var explosionParticles = preload("res://GameObjects/effects/box_explode_particles.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func explode():
	explosionParticles.position = position
	get_tree().get_current_scene().add_child(explosionParticles)
	explosionParticles.emitting = true
	queue_free()


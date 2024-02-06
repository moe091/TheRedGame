extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print('overlaypping bodies:', get_overlapping_areas().any(is_jumpable))
	
func is_jumpable(a) -> bool:
	return a.is_in_group('jumpable')
	
func is_on_ground() -> bool:
	return get_overlapping_bodies().size() > 0
	#return get_overlapping_areas().any(is_jumpable)
	
	
	

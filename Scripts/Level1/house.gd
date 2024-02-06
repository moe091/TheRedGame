extends Node2D
var houseTexture2 : Texture = load("res://Images/BOBROSS/House2.png")
var houseTexture3 : Texture = load("res://Images/BOBROSS/House3.png")
var houseTexture4 : Texture = load("res://Images/BOBROSS/House4.png")
@onready var houseSprite = $HouseSprite
@onready var doorCollider = $HouseBody1/Door
@onready var collisionParticles1 = $JohnsonsenCollider1/CollisionParticles1
@onready var collisionParticles2 = $JohnsensonCollider2/CollisionParticles2
@onready var collisionParticles3 = $JohnsensonCollider3/CollisionParticles3

var col1Complete : bool = false
var col2Complete : bool = false
var col3Complete : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_johnsonsen_collider_1_body_entered(body):
	if !col1Complete:
		houseSprite.texture = houseTexture2
		collisionParticles1.emitting = true
		col1Complete = true
	#wood breaking animation


func _on_johnsenson_collider_2_body_entered(body):
	if !col2Complete:
		houseSprite.texture = houseTexture3
		collisionParticles2.emitting = true
		col2Complete = true
	


func _on_johnsenson_collider_3_body_entered(body):
	if !col3Complete:
		houseSprite.texture = houseTexture4
		collisionParticles3.emitting = true
		doorCollider.queue_free()
		col3Complete = true

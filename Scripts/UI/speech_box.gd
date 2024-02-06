extends BoxContainer

@onready var textArea : RichTextLabel = $Text
@onready var sprite : Sprite2D = $Bubble
@onready var interactLabel = $Continue
var interactable = false
var baseHeight : float = 128.0 #float to force decimal conversion when dividing
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#sprite.scale.y = (textArea.get_content_height() + 20) / baseHeight
	#sprite.offset.y = 128 * (1 - sprite.scale.y)
	#textArea.offset.y = 128 * sprite.scale.y
	
func setText(text):
	textArea.text = text
	
func setInteractable(val):
	interactable = val
	interactLabel.visible = interactable
	

extends Sprite2D


@onready var pmdText:Label = $Text;
@onready var pmdTypeText:TextEdit = $PmdTypeText;

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func newTextAdded():
	pmdText.text = pmdTypeText.text

extends Node2D

@onready var icon:TextureRect = $Portrait/Icon;

# Original size 256x192
# Editor size 341x192

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().get_window().size = Vector2(256, 192);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_file_dialog_file_selected(path):
	print(path);
	var image = Image.new()
	image.load(path)
	# var t = ImageTexture.new()
	# t.create_from_image(image)
	icon.texture = ImageTexture.create_from_image(image);
	icon.set_size(Vector2(40, 40));

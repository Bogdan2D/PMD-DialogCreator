extends Node2D

@onready var icon:TextureRect = $Portrait/Icon;
@onready var txtColorPicker:ColorPicker = $DebugPanel/TxtColorPicker/ColorPicker
@onready var prefixColorPicker:ColorPickerButton = $DebugPanel/TextEditPanel/PrefixColorPicker;
@onready var textboxText:TextEdit = $DebugPanel/TextEditPanel/PmdTypeText
@onready var textbox = $Textbox;

var colorSwatches = [
	Color(255, 255, 0, 1),
	Color(0, 255, 255, 1),
	Color(0, 255, 0, 1)
]

func _ready():
	prefixColorPicker.get_picker().can_add_swatches = false;
	prefixColorPicker.get_picker().edit_alpha = false;
	textbox.prefixColor = str(prefixColorPicker.get_picker().color.to_html(false));
	
	for i in range(colorSwatches.size()):
		txtColorPicker.add_preset(colorSwatches[i]);
		prefixColorPicker.get_picker().add_preset(colorSwatches[i]);


var colorPickerVisible = false;
var colorPickerLerpX:float = -200;
var iconAlphaLerp:float = 255;

func _process(delta):
	$DebugPanel/TxtColorPicker.position.x = lerp($DebugPanel/TxtColorPicker.position.x, colorPickerLerpX, 10 * delta);
	$Portrait.modulate.a = lerp($Portrait.modulate.a, iconAlphaLerp, 25 * delta);
	
	if(Input.is_action_just_pressed("ToggleColorPicker")):
		colorPickerVisible = !colorPickerVisible;
		if(colorPickerVisible):
			colorPickerLerpX = -65;
			iconAlphaLerp = 0;
		else:
			colorPickerLerpX = -200;
			iconAlphaLerp = 255;
		

func _on_file_dialog_file_selected(path):
	print(path);
	var image = Image.new()
	image.load(path)
	# var t = ImageTexture.new()
	# t.create_from_image(image)
	icon.texture = ImageTexture.create_from_image(image);
	icon.set_size(Vector2(40, 40));


func onColorInsert():
	textboxText.text += '[color=' + str(txtColorPicker.color.to_html(false)) + '] [/color]';

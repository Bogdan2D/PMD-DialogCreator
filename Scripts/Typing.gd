extends Sprite2D

@onready var pmdText:RichTextLabel = $Text;
@export var pmdTypeText:TextEdit;
#####################
# PMD YELLOW FFFF00 #
# PMD BLUE 009EFF   #
# PMD CYAN  00FFFF  #
# PMD GREEN 00FF00  #
#####################
var prefix:String = "[color=FFFF00]???[/color]: ";
var prefixColor = "FFFF00";

func newTextAdded():
	pmdText.text = prefix + pmdTypeText.text
	
func prefixTextChanged(new_text):
	if not prefixVisible:
		return;
	prefix = '[color=' + str(prefixColor) + ']' + new_text + '[/color]: ';
	newTextAdded();


func onPrefixColorChanged(color):
	prefixColor = color.to_html(false);
	
	if(prefixVisible):
		prefixTextChanged($"../DebugPanel/TextEditPanel/PrefixEdit".text);
	else:
		prefix = "";
		newTextAdded();


var prefixVisible:bool = true;
func onPrefixToggled(toggled_on):
	prefixVisible = toggled_on;
	
	if(prefixVisible):
		prefixTextChanged($"../DebugPanel/TextEditPanel/PrefixEdit".text);
	else:
		prefix = "";
		newTextAdded();

extends Sprite2D

@onready var pmdText:RichTextLabel = $Text;
@onready var pmdTypeText:TextEdit = $PmdTypeText;
#####################
# PMD YELLOW FFFF00 #
# PMD BLUE 009EFF   #
# PMD CYAN  00FFFF  #
# PMD GREEN 00FF00  #
#####################
var prefix:String = "[color=FFFF00]Riolu[/color]: ";

func newTextAdded():
	pmdText.text = prefix + pmdTypeText.text

	
	

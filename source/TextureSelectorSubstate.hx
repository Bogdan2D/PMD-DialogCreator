package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import haxe.io.Path;
import openfl.Assets;
import sys.FileSystem;
import sys.thread.Thread;

using StringTools;

enum TexBrowseFilters
{
	themes;
	boxes;
	portraits;
	icons;
}

// NOTICE: FIX THIS UP WHILE ON HOLIDAY.
class TextureSelectorSubstate extends FlxSubState
{
	var allowedImgExtensions:Array<String> = ['png', 'jpg', 'jpeg', 'bmp'];

	var header:FlxText;
	var optionGrp:FlxTypedSpriteGroup<TexSelectorObject>;
	var optionHighlighter:FlxSprite;
	var highligherLerpPos:FlxPoint;
	var filter:TexBrowseFilters;

	public function new(filter:TexBrowseFilters)
	{
		super();

		this.filter = filter;

		optionGrp = new FlxTypedSpriteGroup<TexSelectorObject>();
		header = new FlxText(0, 10, FlxG.width);
		header.setFormat('assets/data/Fonts/PKMN-Mystery-Dungeon.ttf', 40, 0xFFFFFF00, CENTER, SHADOW, 0xFF000000);

		header.text = switch (filter)
		{
			case themes: 'SELECT THEME';
			case boxes: 'SELECT BOX';
			case portraits: 'SELECT PORTRAIT';
			case icons: 'SELECT ICON';
			default: 'SELECT OBJECT';
		}

		optionHighlighter = new FlxSprite('assets/images/boxHighlighter.png');
		optionHighlighter.visible = false;
		optionHighlighter.setGraphicSize(96, 116);
		optionHighlighter.updateHitbox();

		FlxTween.color(optionHighlighter, 1, 0xFFFFFFFF, 0xFFDEDEDE, {ease: FlxEase.cubeInOut, type: PINGPONG});

		highligherLerpPos = new FlxPoint();
		////////////////////////////////////////////////////////////////////////////////////////////////
		// this is terrible and mind boggling but the fact that i managed to do this is incredible to me im satisfied
		var i:Int = 0;
		var row:Int = 0;
		var rowFull:Bool = false;

		var dirPath = switch (filter)
		{
			case themes: 'assets/images/portraits';
			case boxes: 'assets/images/boxes';
			case portraits: 'assets/images/portraits';
			case icons: 'assets/images/icons';
		}

		// var dir = (FileSystem.readDirectory(dirPath));
		for (graphic in FileSystem.readDirectory(dirPath))
		{
			var _isGraphicAllowed:Bool = false;
			var _canSwap:Bool = false;

			if (FileSystem.isDirectory(dirPath + '/$graphic'))
			{
				// if (!FileSystem.exists(dirPath + '/$graphic/' + 'M.png'))
				// continue;

				// if (!FileSystem.exists(dirPath + '/$graphic/' + 'F.png'))
				// continue;
				continue;
				_canSwap = true;
			}
			else
			{
				for (extension in allowedImgExtensions)
				{
					if (Path.extension(graphic) == extension)
					{
						_isGraphicAllowed = true;
						break;
					}
				}

				if (!_isGraphicAllowed)
				{
					trace('FILE $graphic IS NOT SUPPORTED. (Isnt an image. Should only use the following extensions: $allowedImgExtensions');
					continue;
				}
			}

			var pos = new FlxPoint();
			pos.x = 13;
			pos.y = 60 + row * 120;

			if (i != 0)
			{
				pos.x = !rowFull ? optionGrp.members[i - 1].x + 100 : 13;
				rowFull = false;

				if ((i + 1) % 5 == 0)
				{
					row++;
					rowFull = true;
				}
			}

			switch (filter)
			{
				case themes:
					// if (!FileSystem.exists('assets/images/portraits/$graphic') || !FileSystem.exists('assets/images/boxes/$graphic'))
					// continue;

					optionGrp.add(new TexSelectorObject(pos.x, pos.y, 'assets/images/boxes/$graphic', 'assets/images/portraits/$graphic'));
				case boxes:
					var _portraitPreview:String = null;

					if (FileSystem.exists('assets/images/portraits/$graphic'))
						_portraitPreview = 'assets/images/portraits/$graphic';

					optionGrp.add(new TexSelectorObject(pos.x, pos.y, 'assets/images/boxes/$graphic', _portraitPreview, _canSwap));
				case portraits:
					optionGrp.add(new TexSelectorObject(pos.x, pos.y, 'assets/images/portraits/$graphic', _canSwap));
				case icons:
					optionGrp.add(new TexSelectorObject(pos.x, pos.y, 'assets/images/icons/$graphic'));
				default:
					trace('idk bro');
			}
			i++;
		}

		//-----[Layering]-----\\
		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x64000000));
		add(optionGrp);
		add(optionHighlighter);
		add(new FlxSprite().makeGraphic(FlxG.width, 50, 0xBE000000));
		add(header);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		optionHighlighter.x = FlxMath.lerp(optionHighlighter.x, highligherLerpPos.x, 15 * elapsed);
		optionHighlighter.y = FlxMath.lerp(optionHighlighter.y, highligherLerpPos.y, 15 * elapsed);
		for (option in optionGrp)
		{
			if (FlxG.mouse.overlaps(option))
			{
				optionHighlighter.visible = true;
				highligherLerpPos.x = option.x - 2;
				highligherLerpPos.y = option.y - 3;

				if (FlxG.mouse.justReleased)
				{
					switch (filter)
					{
						case themes:
							PlayState.instance.changeTheme(option.graphicName, option.imagePreview.graphic.assetsKey);
						case boxes:
							PlayState.instance.changeBox(option.graphicName);
						case portraits:
							PlayState.instance.changePortrait(option.graphicName);
						case icons:
							PlayState.instance.changeIcon(option.graphicName);
						default:
							trace('this did nothing lmao');
					}
					close();
				}
			}
		}
		//////////////////////////////

		if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE, X]))
			close();

		if (FlxG.keys.pressed.UP)
		{
			if (!FlxG.keys.pressed.SHIFT)
				optionGrp.y += 225 * elapsed;
			else
				optionGrp.y += 700 * elapsed;
		}

		if (FlxG.keys.pressed.DOWN)
		{
			if (!FlxG.keys.pressed.SHIFT)
				optionGrp.y -= 225 * elapsed;
			else
				optionGrp.y -= 700 * elapsed;
		}

		// mouse
		if (FlxG.mouse.wheel > 1)
		{
			optionGrp.y += 500 * elapsed;
		}

		if (FlxG.mouse.wheel < 0)
		{
			optionGrp.y -= 500 * elapsed;
		}
	}
}

class TexSelectorObject extends FlxSpriteGroup
{
	public var imagePreview:FlxSprite;
	public var imageName:FlxText;

	public var graphicName:String;

	public var nbIcon:FlxSprite;

	// ADD A GENDER VERSION ICON TO SHOW THERE IS ONE THAT EXISTS
	public function new(X, Y, path:String, ?previewImg:FlxGraphicAsset = null, _canSwap:Bool = false):Void
	{
		super(X, Y);

		if (_canSwap)
			path += '/M.png';

		graphicName = path;

		imagePreview = new FlxSprite();
		imagePreview.loadGraphic(previewImg != null ? previewImg : path);

		imagePreview.setGraphicSize(90, 90);
		imagePreview.updateHitbox();

		imageName = new FlxText(imagePreview.x - 5, imagePreview.y + imagePreview.height + 2, 100, path.split('/')[path.split('/').length - 1]);
		imageName.setFormat('assets/data/Fonts/PKMN-Mystery-Dungeon.ttf', 20, 0xFFFFFFFF, CENTER);

		nbIcon = new FlxSprite(7, 7, 'assets/images/icon_NB.png');
		nbIcon.setGraphicSize(15, 15);
		nbIcon.updateHitbox();

		add(imagePreview);
		if (!_canSwap)
			add(nbIcon);
		add(imageName);
	}
}

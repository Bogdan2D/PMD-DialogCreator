package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import lime.app.Application;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	var _debugTab:DebugTab;

	var text:FlxText;
	var testText:FlxBitmapText;
	var textBox:FlxSprite;
	var portrait:FlxSprite;
	var icon:FlxSprite;

	var sessionSavedFile:Int = 0;

	var _sceneData = {
		name: "???",
		namePrefixEnabled: true,
		text: "Blah blah blah",
		iconTexture: 'assets/images/icons/icon_386.png',
		portraitTexture: 'assets/images/portraits/rt.png',
		boxTexture: 'assets/images/boxes/rt.png',
		iconFlipped: false
	}

	override public function create()
	{
		instance = this;

		camera.bgColor = 0xFFFFFFFF;

		_debugTab = new DebugTab(FlxG.width - 210, 10);
		// _debugTab.setPosition(FlxG.width - _debugTab.width - 10, 10);

		textBox = new FlxSprite().loadGraphic(_sceneData.boxTexture);
		textBox.setGraphicSize(480, 104);
		textBox.updateHitbox();
		textBox.screenCenter();
		textBox.y += 120;

		portrait = new FlxSprite(28, 136).loadGraphic(_sceneData.portraitTexture);
		portrait.setGraphicSize(96, 96);
		portrait.updateHitbox();

		icon = new FlxSprite(36, 144, _sceneData.iconTexture);
		icon.setGraphicSize(80, 80);
		icon.updateHitbox();
		icon.flipX = _sceneData.iconFlipped;

		text = new FlxText(textBox.x + 20, textBox.y + 15, 440, (_sceneData.namePrefixEnabled) ? _sceneData.name + ': ' + _sceneData.text : _sceneData.text);
		text.setFormat('assets/data/Fonts/PKMN-Mystery-Dungeon.ttf', 32, 0xFFFFFFFF, LEFT);
		text.setBorderStyle(SHADOW, 0xFF000000, 2, 1); // fix this
		//-----[Layering]-----\\
		add(textBox);
		add(text);
		add(portrait);
		add(icon);

		add(_debugTab);
		////////////////////////////////
		super.create();
		///////////////////////////////

		/*
			var i:Int = 0;
			for (image in FileSystem.readDirectory('assets/images/icons'))
			{
				FileSystem.rename('assets/images/icons/$image', 'assets/images/icons/icon_$i.png');

				i++;
			}
		 */

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(k:KeyboardEvent)
		{
			// f11 fullscreen cause why not :3
			if (k.keyCode == Keyboard.F11)
				FlxG.fullscreen = !FlxG.fullscreen;
			else if (k.keyCode != Keyboard.SHIFT || k.keyCode != Keyboard.ALTERNATE)
			{
				if (k.keyCode == Keyboard.BACKSPACE)
					_sceneData.text = _sceneData.text.substring(0, _sceneData.text.length - 1);
				else
					_sceneData.text += String.fromCharCode(k.charCode);

				text.text = (_sceneData.namePrefixEnabled) ? _sceneData.name + ': ' + _sceneData.text : _sceneData.text;
				// trace(text.text);
			}
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// SCREENSHOTTING
		if (FlxG.keys.justPressed.F12)
		{
			var image_pixels = openfl.Lib.application.window.readPixels(new lime.math.Rectangle(0, 0, Application.current.window.width,
				Application.current.window.height));
			var image_bytes = image_pixels.encode();

			if (!FileSystem.exists('output/${Std.string(Date.now()).split(' ')[0]}'))
				FileSystem.createDirectory('output/${Std.string(Date.now()).split(' ')[0]}');

			var file = sys.io.File.write('output/${Std.string(Date.now()).split(' ')[0]}/screenshot_$sessionSavedFile.png', true);
			file.writeBytes(image_bytes, 0, image_bytes.length);
			file.close();

			sessionSavedFile++;
		}
	}

	public function changeTheme(boxTex, portraitTex):Void
	{
		changeBox(boxTex);
		changePortrait(portraitTex);
	}

	public function changeBox(newTex):Void
	{
		_sceneData.boxTexture = newTex;

		textBox.loadGraphic(newTex);
		textBox.setGraphicSize(480, 104);
		textBox.updateHitbox();
		// textBox.screenCenter();
		// textBox.y += 120;
	}

	public function changePortrait(newTex):Void
	{
		_sceneData.portraitTexture = newTex;

		portrait.loadGraphic(newTex);
		portrait.setGraphicSize(96, 96);
		portrait.updateHitbox();
	}

	public function changeIcon(newTex):Void
	{
		_sceneData.iconTexture = newTex;

		icon.loadGraphic(newTex);
		icon.setGraphicSize(80, 80);
		icon.updateHitbox();
	}

	public function flipIcon(flipped:Bool):Void
		icon.flipX = _sceneData.iconFlipped = flipped;
}

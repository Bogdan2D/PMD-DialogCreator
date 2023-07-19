package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
#if debug
import openfl.display.FPS;
#end

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
		#if debug
		addChild(new FPS(10, 10, 0xFFFF0000));
		#end

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.sound.muteKeys = FlxG.sound.volumeDownKeys = FlxG.sound.volumeUpKeys = null;
	}
}

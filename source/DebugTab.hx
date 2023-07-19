package;

import flixel.FlxG;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITabMenu;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class DebugTab extends FlxUITabMenu
{
	var optionTabs = [{name: 'General', label: 'General'}, {name: 'Presets', label: 'Presets'}];
	var generalTab:FlxUI;

	var initPos:FlxPoint;

	public var selectThemeBtn:FlxUIButton;
	public var selectBoxBtn:FlxUIButton;
	public var selectPortraitBtn:FlxUIButton;
	public var selectIconBtn:FlxUIButton;

	public function new(X, Y):Void
	{
		super(null, optionTabs, true);
		setSize(300, 200);
		setPosition(X, Y);
		initPos = new FlxPoint(X, Y);
		color = 0xFF292929;

		generalTab = new FlxUI(null, this);
		generalTab.name = "General";

		addGroup(generalTab);
		//-----[GENERAL]-----\\
		selectThemeBtn = new FlxUIButton(15, 20, 'BOX + PORTRAIT', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(themes)));
		selectThemeBtn.color = 0xFF000000;
		selectThemeBtn.label.color = 0xFFFFFFFF;
		selectThemeBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		selectThemeBtn.label.size += 10;
		selectThemeBtn.resize(170, 20);

		selectBoxBtn = new FlxUIButton(15, 45, 'BOX', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(boxes)));
		selectBoxBtn.color = 0xFF000000;
		selectBoxBtn.label.color = 0xFFFFFFFF;
		selectBoxBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		selectBoxBtn.label.size += 10;

		selectPortraitBtn = new FlxUIButton(selectBoxBtn.x + 10 + selectBoxBtn.width, 45, 'PORTRAIT',
			() -> PlayState.instance.openSubState(new TextureSelectorSubstate(portraits)));
		selectPortraitBtn.color = 0xFF000000;
		selectPortraitBtn.label.color = 0xFFFFFFFF;
		selectPortraitBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		selectPortraitBtn.label.size += 10;

		selectIconBtn = new FlxUIButton(15, 70, 'ICON', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(icons)));
		selectIconBtn.color = 0xFF000000;
		selectIconBtn.label.color = 0xFFFFFFFF;
		selectIconBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		selectIconBtn.label.size += 10;
		selectIconBtn.resize(170, 20);

		generalTab.add(selectThemeBtn);
		generalTab.add(selectBoxBtn);
		generalTab.add(selectPortraitBtn);
		generalTab.add(selectIconBtn);
	}

	var shouldBeOnScreen:Bool = true;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ALT)
		{
			if (shouldBeOnScreen)
			{
				FlxTween.cancelTweensOf(this);
				FlxTween.tween(this, {x: initPos.x + 400}, 0.5, {ease: FlxEase.cubeOut});
				shouldBeOnScreen = false;
			}
			else
			{
				FlxTween.cancelTweensOf(this);
				FlxTween.tween(this, {x: initPos.x}, 0.5, {ease: FlxEase.cubeOut});
				shouldBeOnScreen = true;
			}
		}
	}
}

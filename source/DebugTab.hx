package;

import flixel.FlxG;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUITabMenu;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class DebugTab extends FlxUITabMenu
{
	var optionTabs = [
		{name: 'General', label: 'General'},
		{name: 'Customize', label: 'Customize'},
		{name: 'Presets', label: 'Presets'}
	];
	var customizeTab:FlxUI;

	var initPos:FlxPoint;

	public var selectThemeBtn:FlxUIButton;
	public var selectBoxBtn:FlxUIButton;
	public var selectPortraitBtn:FlxUIButton;
	public var selectIconBtn:FlxUIButton;
	public var genderToggleCheckbox:FlxUICheckBox;
	public var flipIcon:FlxUICheckBox;

	public function new(X, Y):Void
	{
		super(null, optionTabs, true);
		setSize(300, 200);
		setPosition(X, Y);
		initPos = new FlxPoint(X, Y);
		color = 0xFF292929;

		customizeTab = new FlxUI(null, this);
		customizeTab.name = "Customize";

		addGroup(customizeTab);
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

		genderToggleCheckbox = new FlxUICheckBox(15, 95, 'assets/images/icon_M.png', 'assets/images/icon_F.png', 'Toggle Type');
		genderToggleCheckbox.button.setSize(16, 16);
		genderToggleCheckbox.box.setGraphicSize(16, 16);
		genderToggleCheckbox.box.updateHitbox();
		genderToggleCheckbox.mark.setGraphicSize(16, 16);
		genderToggleCheckbox.mark.updateHitbox();
		genderToggleCheckbox.textX = 0;
		genderToggleCheckbox.button.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		genderToggleCheckbox.button.label.size += 10;
		genderToggleCheckbox.textIsClickable = true;

		flipIcon = new FlxUICheckBox(110, 95, null, null, 'Flip Icon');
		flipIcon.button.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		flipIcon.button.label.size += 10;
		flipIcon.callback = () -> PlayState.instance.flipIcon(flipIcon.checked);

		customizeTab.add(selectThemeBtn);
		customizeTab.add(selectBoxBtn);
		customizeTab.add(selectPortraitBtn);
		customizeTab.add(selectIconBtn);
		customizeTab.add(genderToggleCheckbox);
		customizeTab.add(flipIcon);
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

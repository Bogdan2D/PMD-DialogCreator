package;

import flixel.FlxG;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class DebugTab extends FlxUITabMenu
{
	var optionTabs = [
		{name: 'General', label: 'General'},
		{name: 'Customize', label: 'Customize'},
		{name: 'Presets', label: 'Presets'}
	];
	var generalTab:FlxUI;
	var customizeTab:FlxUI;

	var initPos:FlxPoint;

	public var general_editTextHeader:FlxText;
	public var general_editText:FlxUIInputText;
	public var general_editPrefixHeader:FlxText;
	public var general_editPrefix:FlxUIInputText;
	public var general_usePrefix:FlxUICheckBox;

	public var customize_selectThemeBtn:FlxUIButton;
	public var customize_selectBoxBtn:FlxUIButton;
	public var customize_selectPortraitBtn:FlxUIButton;
	public var customize_selectIconBtn:FlxUIButton;
	public var customize_genderToggleCheckbox:FlxUICheckBox;
	public var customize_flipIcon:FlxUICheckBox;

	public function new(X, Y):Void
	{
		super(null, optionTabs, true);
		setSize(300, 200);
		setPosition(X, Y);
		initPos = new FlxPoint(X, Y);
		color = 0xFF292929;

		customizeTab = new FlxUI(null, this);
		customizeTab.name = "Customize";

		generalTab = new FlxUI(null, this);
		generalTab.name = "General";

		addGroup(generalTab);
		addGroup(customizeTab);
		//-----[GENERAL]-----\\
		final ps = PlayState.instance;

		general_editTextHeader = new FlxText(10, 5, 150, 'Change Text');
		general_editTextHeader.setFormat('assets/data/Fonts/PKMN-Mystery-Dungeon.ttf', 16, 0xFFFFFFFF, LEFT);

		general_editText = new FlxUIInputText(10, 21, 150, PlayState.instance._sceneData.text, 16, 0xFF000000, 0xFFFFFFFF);
		general_editText.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		general_editText.lines = 1;
		general_editText.callback = (s1, s2) ->
		{
			ps._sceneData.text = s1;
			ps.text.resetText(ps._sceneData.text);
			ps.text.start(0.01);
			ps.text.skip();
		}

		general_editPrefixHeader = new FlxText(10, 40, 150, 'Change Prefix (Name)');
		general_editPrefixHeader.setFormat('assets/data/Fonts/PKMN-Mystery-Dungeon.ttf', 16, 0xFFFFFFFF, LEFT);

		general_editPrefix = new FlxUIInputText(10, 58, 150, PlayState.instance._sceneData.name, 16, 0xFF000000, 0xFFFFFFFF);
		general_editPrefix.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		general_editPrefix.lines = 1;
		general_editPrefix.callback = (s1, s2) ->
		{
			ps._sceneData.name = s1;
			ps.text.prefix = (ps._sceneData.namePrefixEnabled) ? s1 + ': ' : "";
		}

		general_usePrefix = new FlxUICheckBox(10, 85, null, null, 'Use Prefix');
		general_usePrefix.checked = ps._sceneData.namePrefixEnabled;
		general_usePrefix.button.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		general_usePrefix.button.label.size += 10;
		general_usePrefix.callback = () ->
		{
			PlayState.instance._sceneData.namePrefixEnabled = general_usePrefix.checked;
			if (general_usePrefix.checked)
				PlayState.instance.text.prefix = general_editPrefix.text + ': ';
			else
				PlayState.instance.text.prefix = "";
		};

		generalTab.add(general_editTextHeader);
		generalTab.add(general_editText);
		generalTab.add(general_editPrefixHeader);
		generalTab.add(general_editPrefix);
		generalTab.add(general_usePrefix);
		//-----[CUSTOMIZE]-----\\
		customize_selectThemeBtn = new FlxUIButton(15, 20, 'BOX + PORTRAIT', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(themes)));
		customize_selectThemeBtn.color = 0xFF000000;
		customize_selectThemeBtn.label.color = 0xFFFFFFFF;
		customize_selectThemeBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_selectThemeBtn.label.size += 10;
		customize_selectThemeBtn.resize(170, 20);

		customize_selectBoxBtn = new FlxUIButton(15, 45, 'BOX', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(boxes)));
		customize_selectBoxBtn.color = 0xFF000000;
		customize_selectBoxBtn.label.color = 0xFFFFFFFF;
		customize_selectBoxBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_selectBoxBtn.label.size += 10;

		customize_selectPortraitBtn = new FlxUIButton(customize_selectBoxBtn.x + 10 + customize_selectBoxBtn.width, 45, 'PORTRAIT',
			() -> PlayState.instance.openSubState(new TextureSelectorSubstate(portraits)));
		customize_selectPortraitBtn.color = 0xFF000000;
		customize_selectPortraitBtn.label.color = 0xFFFFFFFF;
		customize_selectPortraitBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_selectPortraitBtn.label.size += 10;

		customize_selectIconBtn = new FlxUIButton(15, 70, 'ICON', () -> PlayState.instance.openSubState(new TextureSelectorSubstate(icons)));
		customize_selectIconBtn.color = 0xFF000000;
		customize_selectIconBtn.label.color = 0xFFFFFFFF;
		customize_selectIconBtn.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_selectIconBtn.label.size += 10;
		customize_selectIconBtn.resize(170, 20);

		customize_genderToggleCheckbox = new FlxUICheckBox(15, 95, 'assets/images/icon_M.png', 'assets/images/icon_F.png', 'Toggle Type');
		customize_genderToggleCheckbox.button.setSize(16, 16);
		customize_genderToggleCheckbox.box.setGraphicSize(16, 16);
		customize_genderToggleCheckbox.box.updateHitbox();
		customize_genderToggleCheckbox.mark.setGraphicSize(16, 16);
		customize_genderToggleCheckbox.mark.updateHitbox();
		customize_genderToggleCheckbox.textX = 0;
		customize_genderToggleCheckbox.button.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_genderToggleCheckbox.button.label.size += 10;
		customize_genderToggleCheckbox.textIsClickable = true;

		customize_flipIcon = new FlxUICheckBox(110, 95, null, null, 'Flip Icon');
		customize_flipIcon.button.label.font = 'assets/data/Fonts/PKMN-Mystery-Dungeon.ttf';
		customize_flipIcon.button.label.size += 10;
		customize_flipIcon.callback = () -> PlayState.instance.flipIcon(customize_flipIcon.checked);

		customizeTab.add(customize_selectThemeBtn);
		customizeTab.add(customize_selectBoxBtn);
		customizeTab.add(customize_selectPortraitBtn);
		customizeTab.add(customize_selectIconBtn);
		customizeTab.add(customize_genderToggleCheckbox);
		customizeTab.add(customize_flipIcon);
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

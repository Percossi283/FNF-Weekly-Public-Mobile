package meta.data.options;

#if desktop
import meta.data.Discord.DiscordClient;
#end
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import meta.data.Controls;
import meta.data.*;
import meta.states.*;
import meta.states.substate.*;
import gameObjects.*;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Notes', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', "Loading"];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Notes':
				openSubState(new meta.data.options.NoteSettingsSubState());
			case 'Controls':
				openSubState(new meta.data.options.ControlsSubState());
			case 'Graphics':
				openSubState(new meta.data.options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new meta.data.options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new meta.data.options.GameplaySettingsSubState());
			case 'Loading':
				openSubState(new meta.data.options.MiscSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new meta.data.options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('OptionsBG'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		#if mobile
		addVirtualPad(UP_DOWN, A_B);
		#end

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P #if mobile || _virtualpad.buttonUp.justPressed #end) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P #if mobile || _virtualpad.buttonDown.justPressed #end) {
			changeSelection(1);
		}

		if (controls.BACK #if mobile || _virtualpad.buttonB.justPressed #end) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new WeeklyMainMenuState());
		}

		if (controls.ACCEPT #if mobile || _virtualpad.buttonA.justPressed #end) {
			openSelectedSubstate(options[curSelected]);
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

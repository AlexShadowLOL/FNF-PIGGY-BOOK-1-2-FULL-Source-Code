package;

// for game shutdown lololololololol
import flash.system.System;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

// used on v1 & v1.5!
class SeizureWarnScreen extends MusicBeatState
{
	public static var alreadyWarned:Bool = false;
	public static var leftState:Bool = false;

	// just keeping these two shitty variables cuz titlestate needs them to make this appear
	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";

	private var colorRotation:Int = 1;

	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Seizure Warning Screen", null);
		#end

		FlxG.sound.playMusic(Paths.music('seizureTrack', 'piggy'), 0.65);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1', 'piggy'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var bgBlackOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0.6;
		add(bgBlackOverlay);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"WARNING: "
			+ "\nThis Mod contains Flashing Lights\nAnd Many Other Stuff"
			+ "\nThat may Cause Seizures!"
			+ "\n\nPress ENTER to keep playing\nor ESCAPE to Close The Game if you can't handle Seizure stuff",
			32);
		
		txt.setFormat("JackInput", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			alreadyWarned = true;
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (controls.BACK)
		{
			System.exit(0);
		}
		
		super.update(elapsed);
	}
}

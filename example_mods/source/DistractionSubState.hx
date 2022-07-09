package;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import lime.app.Application;

import flash.system.System;

#if windows
import Discord.DiscordClient;
#end

class DistractionSubState extends MusicBeatState
{
	var blackScreen:FlxSprite;
	var dtxt:FlxSprite;

	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("4GTCFYIUTEQ3Y9RVBVB7O 8QET68O", null);
		#end

		FlxG.sound.playMusic(Paths.music('distraction', 'piggy'), 0.85);

		blackScreen = new FlxSprite().loadGraphic(Paths.image('secret/blackScreen', 'piggy'));
		blackScreen.scale.set(2, 2);
		blackScreen.updateHitbox();
		blackScreen.screenCenter();
		blackScreen.antialiasing = true;
		add(blackScreen);

		dtxt = new FlxSprite().loadGraphic(Paths.image('secret/DTxt', 'piggy'));
		dtxt.antialiasing = true;
		dtxt.screenCenter();
		dtxt.updateHitbox();
		add(dtxt);
	}

	override function update(elapsed:Float)
	{
		// :skull:
		if (FlxG.keys.justPressed.ANY)
		{
			System.exit(0);
		}

		super.update(elapsed);
	}
}

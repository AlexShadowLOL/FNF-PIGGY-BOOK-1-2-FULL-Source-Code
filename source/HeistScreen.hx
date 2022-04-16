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

class HeistScreen extends MusicBeatState
{
	var blackScreen:FlxSprite;
	var htxt:FlxSprite;

	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("4GTCFYIUTEQ3Y9RVBVB7O 8QET68O", null);
		#end

		FlxG.sound.playMusic(Paths.music('heist', 'piggy'), 0.85);

		blackScreen = new FlxSprite().loadGraphic(Paths.image('secret/blackScreen', 'piggy'));
		blackScreen.scale.set(2, 2);
		blackScreen.updateHitbox();
		blackScreen.screenCenter();
		blackScreen.antialiasing = true;
		add(blackScreen);

		htxt = new FlxSprite().loadGraphic(Paths.image('secret/HTxt', 'piggy'));
		htxt.antialiasing = true;
		htxt.screenCenter();
		htxt.updateHitbox();
		add(htxt);
	}

	override function update(elapsed:Float)
	{
		// :heist:
		if (FlxG.keys.justPressed.ANY)
		{
			System.exit(0);
		}

		super.update(elapsed);
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Cache extends MusicBeatState
{
	public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;

	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var images = [];
	var music = [];

	var loadingText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();

		loadingText = new FlxText(0, FlxG.height - 65, FlxG.width, "", 36);
		loadingText.setFormat(Paths.font("JAi_____.ttf"), 36, FlxColor.WHITE, CENTER);
		loadingText.screenCenter(X);

		#if cpp
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		toBeDone = Lambda.count(music) + Lambda.count(images);

		add(loadingText);

		FlxG.mouse.visible = false;

		trace('started caching...');

		sys.thread.Thread.create(() -> {
			cache();
		});

		super.create();
	}

	override function update(elapsed) 
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			doFunniZoom();
		}

		loadingText.text = "Loading" + " (" + done + "/" + toBeDone + ")";

		super.update(elapsed);
	}

	function cache()
	{
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace("cached " + replaced);
			done++;
		}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}

		trace("finished caching...");

		loaded = true;

		FlxG.switchState(new MainMenuState());
	}

	function doFunniZoom()
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.3, {ease: FlxEase.expoOut});
		
		new FlxTimer().start(0.25, function(tmr:FlxTimer)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3, {ease: FlxEase.expoOut});
		});
	}
}
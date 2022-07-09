package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;
	
	var show:String = "";
	var target:FlxState;
	var stopMusic = false;
	var callbacks:MultiCallback;

	var backgrounds:FlxSprite;
	var loadingText:FlxText;

	var isLoading:Bool = true;
	
	public function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}

	override function create()
	{		
		// stolen from ddto cuz i was struggling with flxg.random.bool :pain: kys
		var random = FlxG.random.float(0, 100);

		trace(random);

		if (random >= 0 && random <= 25)
		{
			show = 'meat-potatoes';
		}
		if (random >= 25 && random <= 50)
		{
			show = 'alleys';
		}
		if (random >= 50 && random <= 100)
		{
			show = 'penny-willow-tio';
		}

		switch (show)
		{
			case 'meat-potatoes':
				backgrounds = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_2', 'piggy'));
				backgrounds.setGraphicSize(FlxG.width, FlxG.height);
				backgrounds.updateHitbox();
				backgrounds.screenCenter();
				backgrounds.antialiasing = true;
				add(backgrounds);
			case 'alleys':
				backgrounds = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_3', 'piggy'));
				backgrounds.setGraphicSize(FlxG.width, FlxG.height);
				backgrounds.updateHitbox();
				backgrounds.screenCenter();
				backgrounds.antialiasing = true;
				add(backgrounds);	
			case 'penny-willow-tio':
				backgrounds = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1', 'piggy'));
				backgrounds.setGraphicSize(FlxG.width, FlxG.height);
				backgrounds.updateHitbox();
				backgrounds.screenCenter();
				backgrounds.antialiasing = true;
				add(backgrounds);
		}

		loadingText = new FlxText(0, FlxG.height - 65, 0, "Loading", 36);
		loadingText.setFormat(Paths.font("JAi_____.ttf"), 36, FlxColor.WHITE);
		loadingText.borderStyle = FlxTextBorderStyle.OUTLINE;
		loadingText.borderSize = 2;
		loadingText.borderColor = FlxColor.BLACK;
		loadingText.screenCenter(X);
		add(loadingText);

		updateText();
		
		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallback(onLoad);
				var introComplete = callbacks.add("introComplete");
				checkLoadSong(getSongPath());
				if (PlayState.SONG.needsVoices)
					checkLoadSong(getVocalPath());
				checkLibrary("shared");
				checkLibrary("piggy");	
				
				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			}
		);
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String)
	{
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;
			
			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if debug
		if (FlxG.keys.justPressed.SPACE)
			trace('fired: ' + callbacks.getFired() + " unfired:" + callbacks.getUnfired());
		#end
	}
	
	function onLoad()
	{
		isLoading = false;

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.switchState(getNextState(target, stopMusic));
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
//		if (PlayState.storyWeek == 1)
//			Paths.setCurrentLevel("piggy");
//		else if (PlayState.storyWeek == 2)
//			Paths.setCurrentLevel("piggy");
//		else if (PlayState.storyWeek == 3)
//			Paths.setCurrentLevel("piggy");
//		else
//			Paths.setCurrentLevel("week" + PlayState.storyWeek);
//		#if NO_PRELOAD_ALL
//		var loaded = isSoundLoaded(getSongPath())
//			&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
//			&& isLibraryLoaded("shared");

        // use the one above incase if this breaks
		Paths.setCurrentLevel("new");
		#if NO_PRELOAD_ALL
		var loaded = isSoundLoaded(getSongPath())
		        && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
				&& isLibraryLoaded("shared");

		if (!loaded)
			return new LoadingState(target, stopMusic);
		#end
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	#if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	#end
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}

	function updateText()
	{
		if (isLoading)
		{
			switch(loadingText.text)
			{
				case 'Loading':
					loadingText.text = 'Loading.';
				case 'Loading.':
					loadingText.text = 'Loading..';
				case 'Loading..':
					loadingText.text = 'Loading...';
				case 'Loading...':
					loadingText.text = 'Loading';
			}
		}
		else
		{
			loadingText.text = 'Finished.';
			loadingText.screenCenter(X);
		}

		new FlxTimer().start(0.1, function(tmr:FlxTimer){ updateText(); });
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}
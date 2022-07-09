package book1;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

import flash.system.System;

#if windows
import Discord.DiscordClient;
#end

#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayStateB1 extends MusicBeatState
{
	public static var instance:book1.PlayStateB1 = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;

	public static var isStoryMode:Bool = false;
	public static var isFreeplay:Bool = false;
	public static var isFreeplayTwo:Bool = false;
	public static var isFreeplay3:Bool = false;
	public static var isExtrasMenu:Bool = false;
	public static var isFelixCutscene:Bool = false;
	public static var isExtraFreeplay:Bool = false;
	public static var isAlmost:Bool = false;
	public static var isPiracy:Bool = false;

	public static var deathReason:String = "standard";
	
	// useful practice mode
	public static var practiceMode:Bool = false;
	public static var cantDie:Bool = false;

	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 0;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	var appTitleSongs:Array<String> = [
		"FNF: PIGGY BOOK 1 - AlexShadow - Locked In",
		"FNF: PIGGY BOOK 1 - Vodicus & AlexShadow - Piracy"
	];

	var warningTwn:FlxTween;
	var warningShit:HealthWarning;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	
	// watermarks
	var kadeEngineWatermark:FlxText;
	var newWatermark:FlxText;
	var newWatermark2:FlxText;
	
	// thank you so much M1 Aether :hug:
	var mustHit:Bool = false;

	private static var songTimeLeft:String = "";
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	var lvlText:FlxText;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	private var camZooming:Bool = false;
	public static var curSong:String = "";

	public var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	var bulletDodges:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	var currentDifficulty:String = "";

	private var healthBarBG:FlxSprite;
	public static var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;

	private var shakeCam:Bool = false;

	private var startingSong:Bool = false;

	public static var curXP:Float = 0.00;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var alreadyPlayedCuts:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var dontSpamFunc:Bool = false;
	var curLibrary:String = "";
	
	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	// some bg variables here cuz yes
	var fgLight:FlxSprite;
	var deadFans:FlxSprite;

    // bg boppers shit variables
	
	// inGame shit variables
	var blackScreen2:FlxSprite; // naming it blackScreen2 cuz blackScreen is already used for winter horrorland's intro and im too lazy to remove winter horrorland intro code /e cry
                                // edit: well i did, but... its just to organize myself
	var vignette:FlxSprite;
	var vignetteRed:FlxSprite;	
	var snowOverlay:FlxBackdrop; // idk why i love this sm
	var redOverlay:FlxSprite; // so scary :((((
	var promenadeOverlay:FlxBackdrop; 
	var zeeJumpscare:FlxSprite;

	// countdown
	var blackCountdown:FlxSprite;
	var countdownBox:FlxSprite;

	var bgBlackOverlay:FlxSprite;

	var bulletPopup:BulletPopup;

	public var songList:Array<String> = [
		'locked-in'
	];

	var fc:Bool = true;

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;

	var scoreTxt:FlxText;
	var judgementCounter:FlxText;

	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botplayTxt:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff

	var curSelSong:Int = 0;
	var curSelDiff:String = "";
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	override public function create()
	{	
		instance = this;

		FlxG.sound.cache(Paths.inst(book1.PlayStateB1.SONG.song));
		FlxG.sound.cache(Paths.voices(book1.PlayStateB1.SONG.song));
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		switch (SONG.song.toLowerCase())
		{
			case 'locked-in': curSelSong = 0;
			case 'piracy': curSelSong = 1;
		}

		switch (storyDifficulty)
		{
			case 0:
				curSelDiff = "Hard";
			case 1:
				curSelDiff = "Rematch";
			case 2:
				curSelDiff = "Nightmare";
		}

		Lib.application.window.title = appTitleSongs[curSelSong] + " - [" + curSelDiff + "]";

		if (FlxG.save.data.parallax)
			camMovement = FlxTween.tween(this, {}, 0);

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;
		bulletDodges = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(book1.PlayStateB1.SONG.song, " ", "-").toLowerCase();
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Hard";
			case 1:
				storyDifficultyText = "Rematch";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		switch(SONG.stage)
		{
			case 'house':
			{
				defaultCamZoom = 0.75;
                curStage = 'house';

				var stagePosX = -700;
				var stagePosY = -520;

				var houseBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/houseBG', 'book1'));
				houseBg.setGraphicSize(Std.int(houseBg.width * 1.6));
				houseBg.updateHitbox();
				houseBg.antialiasing = true;
				houseBg.scrollFactor.set(1, 0.9);
				houseBg.scale.set(1.3, 1.3);
				add(houseBg);

				var bgLight:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/backgroundSmallRedLight(Add-Blend)', 'book1'));
				bgLight.setGraphicSize(Std.int(bgLight.width * 1.6));
				bgLight.updateHitbox();
				bgLight.antialiasing = true;
				bgLight.scrollFactor.set(1, 0.9);
				bgLight.scale.set(1.3, 1.3);
				bgLight.blend = ADD;
				add(bgLight);

				fgLight = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/foregroundLight(Add-Blend)', 'book1'));
				fgLight.setGraphicSize(Std.int(fgLight.width * 1.6));
				fgLight.updateHitbox();
				fgLight.antialiasing = true;
				fgLight.scrollFactor.set(1, 0.9);
				fgLight.scale.set(1.3, 1.3);
				fgLight.blend = ADD;

				bgBlackOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);	
				bgBlackOverlay.scale.set(5, 5);	

				trace("LOADED 'House' STAGE.");	
			}

			case 'piracy':
			{
				defaultCamZoom = 0.7;
                curStage = 'piracy';

				var stagePosX = -700;
				var stagePosY = -520;

				var bg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/glowingBG', 'book1'));
				bg.setGraphicSize(Std.int(bg.width * 1.6));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 0.9);
				bg.scale.set(1.4, 1.4);
				add(bg);

				var ruins:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/bgPiracyRuins', 'book1'));
				ruins.setGraphicSize(Std.int(ruins.width * 1.6));
				ruins.updateHitbox();
				ruins.antialiasing = true;
				ruins.scrollFactor.set(1, 0.9);
				ruins.scale.set(1.4, 1.4);
				add(ruins);

				var strings:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/platformStrings', 'book1'));
				strings.setGraphicSize(Std.int(strings.width * 1.6));
				strings.updateHitbox();
				strings.antialiasing = true;
				strings.scrollFactor.set(1, 0.9);
				strings.scale.set(1.4, 1.4);
				add(strings);

				var pilars:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/platformPilars', 'book1'));
				pilars.setGraphicSize(Std.int(pilars.width * 1.6));
				pilars.updateHitbox();
				pilars.antialiasing = true;
				pilars.scrollFactor.set(1, 0.9);
				pilars.scale.set(1.4, 1.4);
				add(pilars);

				var buildings:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/buildingsAndPlatform', 'book1'));
				buildings.setGraphicSize(Std.int(buildings.width * 1.6));
				buildings.updateHitbox();
				buildings.antialiasing = true;
				buildings.scrollFactor.set(1, 0.9);
				buildings.scale.set(1.4, 1.4);
				add(buildings);

				var backGlow:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/piracyFloorBackGlow(Add-Blend)', 'book1'));
				backGlow.setGraphicSize(Std.int(backGlow.width * 1.6));
				backGlow.updateHitbox();
				backGlow.antialiasing = true;
				backGlow.scrollFactor.set(1, 0.9);
				backGlow.scale.set(1.4, 1.4);
				backGlow.blend = ADD;
				add(backGlow);

				var piracyFloor:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/piracyFightFloor', 'book1'));
				piracyFloor.setGraphicSize(Std.int(piracyFloor.width * 1.6));
				piracyFloor.updateHitbox();
				piracyFloor.antialiasing = true;
				piracyFloor.scrollFactor.set(1, 0.9);
				piracyFloor.scale.set(1.4, 1.4);
				add(piracyFloor);

				deadFans = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/piracy/BGDeadFans', 'book1'));
				deadFans.setGraphicSize(Std.int(deadFans.width * 1.6));
				deadFans.updateHitbox();
				deadFans.antialiasing = true;
				deadFans.scrollFactor.set(1, 0.9);
				deadFans.scale.set(1.4, 1.4);
				deadFans.visible = false;
				add(deadFans);

				bgBlackOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);	
				bgBlackOverlay.scale.set(10, 10);	

				trace("LOADED 'pIrAcY' STAGE.");	
			}
		}

		dad = new book1.Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'pennynormal':
				camPos.x += 400;
				camPos.y += 800;
				dad.y += 60;	
			case 'nmpenny':
				camPos.x += 400;
				camPos.y += 800;
				dad.y += 60;
		   case 'nmwillow':
				camPos.x += 400;
				camPos.y += 800;
				dad.y += 60;							
		}

		boyfriend = new book1.Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'house':
				boyfriend.y -= 160;
			case 'piracy':
				boyfriend.y -= 160;
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
		}

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		if (FlxG.save.data.noteSplashes)
		{
			add(grpNoteSplashes);

			var splashTest:NoteSplash = new NoteSplash(-700, 100, 0);
			grpNoteSplashes.add(splashTest);	
		}

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.03);
		FlxG.camera.zoom = defaultCamZoom;

		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				 
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar', 'shared'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);		

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();

		switch (curSong.toLowerCase()) // setting health bar colours for every song
		{
			case 'locked-in':
			{
				healthBar.createFilledBar(0xFFB13B5B, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'piracy':
			{
				healthBar.createFilledBar(0xFFFF002D, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			default: // in case it doesn't find the song for some reason hjfhihifhd (to prevent crashes)
			{
				// purple color  blue color (dad & bf)
				healthBar.createFilledBar(0xFF8A36D2, 0xFF2A9DF4);
				trace("GENERATED DEFAULT HEALTH BAR COLOURS.");
			}							
		}	

		add(healthBar);	

		if (storyDifficulty == 0)
			currentDifficulty = "Hard";
		else
			currentDifficulty = "Rematch";

		// kys kade watermark
		// alex watermark supremacy
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + currentDifficulty + (Main.watermarks ? " - KE " + book1.MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.alpha = 0;
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;		
		scoreTxt.y += 1000; // goodbye mf
		scoreTxt.alpha = 0;
		add(scoreTxt);

		// new watermark texts retard!!!!!!!
		if (curSong.toLowerCase() == 'change')
			newWatermark = new FlxText(12, FlxG.height - 164, 0, "", 20);
		else
			newWatermark = new FlxText(12, FlxG.height - 144, 0, "", 20);

		newWatermark.setFormat("JackInput", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		newWatermark.scrollFactor.set();
		newWatermark.cameras = [camHUD];

		    newWatermark.text = "FNF PIGGY BOOK 1 " + book1.MainMenuState.fnfPiggyBook1Ver
		                    + "\nKade Engine " + book1.MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	

		lvlText = new FlxText(FlxG.width * 0.7, 5, 0, "", 20);
		lvlText.setFormat(Paths.font("JAi_____.ttf"), 20, FlxColor.WHITE, RIGHT);
		lvlText.text = "Level " + FlxG.save.data.curLevel
		                + "\nXP: " + curXP + "%";
		lvlText.alpha = 0;
		add(lvlText);

		// KE 1.8 judgement Counter
		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("JAi_____.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.cameras = [camHUD];
		judgementCounter.screenCenter(Y);
		judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nMisses: ${misses}';
		add(judgementCounter);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("JAi_____.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}

		// Literally copy-paste of the above, fu 
		// stay mad -Alex
		botplayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botplayTxt.setFormat(Paths.font("JAi_____.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.x += 1000;
		botplayTxt.alpha = 0;
		
		if(FlxG.save.data.botplay && !loadRep) add(botplayTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		add(iconP1);

		if (curSong.toLowerCase() == 'once-for-all')
			iconP1.changeIcon('willow');
		else if (curSong.toLowerCase() == 'hide-and-seek')
			iconP1.changeIcon('zizzy');
		else if (curSong.toLowerCase() == 'almost')
			iconP1.changeIcon('pony');

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		
		if (curSong.toLowerCase() == 'farewell' || curSong.toLowerCase() == 'almost')
			iconP2.visible = false;
		else
			iconP2.visible = true;

		add(iconP2);

		if (curSong.toLowerCase() == 'no-male-bitches' || curSong.toLowerCase() == 'friendzone' || curSong.toLowerCase() == 'extermination')
		{
			curLibrary = 'april-fools';
		}
		else
		{
			if (FlxG.save.data.curBook == 'book1')
			{
				curLibrary = 'book1';
			}
			else
			{
				curLibrary = 'piggy';
			}
		}

		countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + curSong.toLowerCase(), curLibrary));		
		countdownBox.antialiasing = true;
		countdownBox.scrollFactor.set();
        // countdownBox.screenCenter();
		// countdownBox.alpha = 0;
		countdownBox.scale.set(1.2, 1.2);
		countdownBox.x = -1600;

		var downScrPos:Float = -270;
		var upScrPos:Float = -150;

		if (FlxG.save.data.downscroll)
			countdownBox.y = downScrPos;
		else
			countdownBox.y = upScrPos;
		
		add(countdownBox);

		if (curSong.toLowerCase() == 'hide-and-seek')
		{
			zeeJumpscare = new FlxSprite().loadGraphic(Paths.image('inGame/zuzyJumpscare', 'piggy'));
			zeeJumpscare.antialiasing = true;
			zeeJumpscare.scrollFactor.set();
			zeeJumpscare.setGraphicSize(FlxG.width, FlxG.height);
			zeeJumpscare.visible = false;
			add(zeeJumpscare);
		}

		strumLineNotes.cameras = [camHUD];

		if (FlxG.save.data.noteSplashes)
			grpNoteSplashes.cameras = [camHUD];
		
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		add(newWatermark);

		if (curSong.toLowerCase() == 'hide-and-seek')
			zeeJumpscare.cameras = [camHUD];
		
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				default:
					trace("starting countdown..");
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					trace("starting countdown..");
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	public function startCountdown():Void
	{
        var blackCountdown:FlxSprite;

		inCutscene = false;	
		alreadyPlayedCuts = true;

		addingCharacterStuff();

		camHUD.alpha = 0;

		generateStaticArrows(0, 'normal', false);
		generateStaticArrows(1, 'normal', false);		

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		blackCountdown = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackCountdown.scrollFactor.set();
		blackCountdown.scale.set(2, 2);
		blackCountdown.alpha = 1;
		add(blackCountdown);

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			boyfriend.playAnim('idle');

			switch (swagCounter)
			{
				case 0:
					FlxG.camera.zoom = 1.5;
				case 1:
					FlxTween.tween(blackCountdown, {alpha: 0}, 1.5);
					
					// to prevent crashes on other songs since it will go null bc the object wont exist on other songs
					if (curSong.toLowerCase() == 'locked-in' && !FlxG.save.data.photoSens)
						lightFlicker();
				case 2:
					nowPlayingCurSong();
					FlxTween.tween(camHUD, {alpha: 1}, 1);
					FlxTween.tween(FlxG.camera, {zoom: 0.75}, 1, {ease: FlxEase.cubeOut});
				case 3:
					// no x3 x3 x3
				case 4:
					// no x4 x4 x4 x4
			}

			swagCounter += 1;
		}, 5);
	}

	function addingCharacterStuff()
    {
        switch (curSong.toLowerCase())
        {
            default:
                add(dad);
                add(boyfriend);	 
				
			case 'locked-in':
                add(dad);

				dad.x = 190;
				dad.y = 35;

                add(boyfriend);	

				boyfriend.x = 935;
				boyfriend.y = 180;

				add(fgLight);

				add(bgBlackOverlay);
				bgBlackOverlay.alpha = 0;

			case 'piracy':
                add(dad);

				dad.x = -5;
				dad.y = 35;

                add(boyfriend);	

				boyfriend.x = 1000;
				boyfriend.y = 180;

				add(bgBlackOverlay);
				bgBlackOverlay.alpha = 0;
        }
    }

	function forceCamZoom()
    {
        FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.2, {ease: FlxEase.expoOut});
            
        new FlxTimer().start(0.2, function(tmr:FlxTimer)
        {
            FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.2, {ease: FlxEase.expoOut});
        }); 
    }

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function nowPlayingCurSong()
	{
		if (curSong.toLowerCase() == 'overseer')
			countdownBox.alpha = 0;
		
		FlxTween.tween(countdownBox, {x: -600}, 1, {ease: FlxEase.expoInOut});

		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(countdownBox, {x: -1600}, 1.5, {ease: FlxEase.expoInOut});
		});
	}

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(book1.PlayStateB1.SONG.song), FlxG.save.data.instVol, false);
		}

		FlxG.sound.music.onComplete = endSong;

		vocals.play();
		vocals.volume = FlxG.save.data.voicesVol;

		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.CYAN);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		trace("starting song..");
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(book1.PlayStateB1.SONG.song));
		else
			vocals = new FlxSound();	

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(book1.PlayStateB1.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + FlxG.save.data.curBook + '/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1] % 4);
 
					var gottaHitNote:Bool = section.mustHitSection;
 
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
 
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
 
					var daType = songNotes[3];
					var swagNote:Note;
					
					if (gottaHitNote)
					{
						swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, boyfriend.noteSkin);
					}
					else
					{
						swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, dad.noteSkin);
					}

					swagNote.sustainLength = songNotes[2];
 
					swagNote.scrollFactor.set(0, 0);	
 
				var susLength:Float = swagNote.sustainLength;
 
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
 
				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
 
					var sustainNote:Note;

					if (gottaHitNote)
					{
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, boyfriend.noteSkin);
					}
					else
					{
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, dad.noteSkin);
					}
					
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
 
					sustainNote.mustPress = gottaHitNote;
 
					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
 
				swagNote.mustPress = gottaHitNote;
 
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public function generateStaticArrows(player:Int, noteStyle:String, tweenIn:Bool = true):Void
	{
		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * 6));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'insolence':
					babyArrow.frames = Paths.getSparrowAtlas('inGame/NOTE_Insolence_assets', 'piggy');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
					
				case 'white':
					babyArrow.frames = Paths.getSparrowAtlas('notes/white', 'piggy');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				case 'normal':
					if (player == 0) {
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + dad.noteSkin, 'piggy');
					}
					else {
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + boyfriend.noteSkin, 'piggy');
					}

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
						
				default:
					if (player == 0) {
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + dad.noteSkin, 'piggy');
					}
					else {
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + boyfriend.noteSkin, 'piggy');
					}

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			if (curSong.toLowerCase() == 'farewell' && player == 0)
				babyArrow.alpha = 0;
			
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	function tweenCamInPlayer():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 0.95}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		defaultCamZoom = 0.95;
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	public static var paused:Bool = false;
	
	public static var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;


	override public function update(elapsed:Float)
	{
		if (shakeCam)
		{
			FlxG.camera.shake(0.005, 0.10);
		}

		#if !debug
		perfectMode = false;
		#end

		#if debug
		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			endSong();
		#end

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			forceCamZoom();
		}

		super.update(elapsed);

		var curTime:Float = Conductor.songPosition;
		var songCalc:Float = (songLength - curTime);
		var secondsTotalLeft:Int = Math.floor(songCalc / 1000);

		if (curTime < 0)
		{
			curTime = 0;
		}
		
		if (secondsTotalLeft < 0)
		{
			secondsTotalLeft = 0;
		}

		songTimeLeft = FlxStringUtil.formatTime(secondsTotalLeft, false);

		    newWatermark.text = "FNF PIGGY BOOK 1 " + book1.MainMenuState.fnfPiggyBook1Ver
		                    + "\nKade Engine " + book1.MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	

		lvlText.text = "Level " + FlxG.save.data.curLevel
		                + "\nXP: " + curXP + "%";

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		if (health > 2)
			health = 2;
		
		#if debug
		if (FlxG.keys.justPressed.FIVE)
			health = 0.2;
		#end

		if (healthBar.percent < 20)
		{
			iconP1.animation.curAnim.curFrame = 1;

			if (FlxG.save.data.gameDistractions)
				lowHealthWarning();
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			
			if (FlxG.save.data.gameDistractions)
			{
				if (dontSpamFunc)
				{
					warningTwn.cancel();
					remove(warningShit);
		
					dontSpamFunc = false;
				}	
			}
		}

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		getCamOffsets();

		if (generatedMusic && book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)] != null)
		{
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (!FlxG.save.data.parallax)
			{
				if (camFollow.x != dadPos[0] && !book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(dadPos[0], dadPos[1]);
		
					if (book1.PlayStateB1.curSong.toLowerCase() == 'no-male-bitches' || book1.PlayStateB1.curSong.toLowerCase() == 'friendzone' || book1.PlayStateB1.curSong.toLowerCase() == 'extermination')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					}
					else if (book1.PlayStateB1.curSong.toLowerCase() == 'overseer')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.5}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.5;
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
				}
			
				if (camFollow.x != bfPos[0] && book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(bfPos[0], bfPos[1]);
					
					if (book1.PlayStateB1.curSong.toLowerCase() == 'no-male-bitches' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'friendzone' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'extermination' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'overseer')
						tweenCamInPlayer();

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneTurn', []);
					#end
				}					
			}
			else
			{
				if (camFocus != 'dad' && !book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camMovement.cancel();
					camFocus = 'dad';

					if (book1.PlayStateB1.curSong.toLowerCase() == 'no-male-bitches' || book1.PlayStateB1.curSong.toLowerCase() == 'friendzone' || book1.PlayStateB1.curSong.toLowerCase() == 'extermination')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					}
					else if (book1.PlayStateB1.curSong.toLowerCase() == 'overseer')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.5}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.5;
					}

					camMovement = FlxTween.tween(camFollow, {x: dadPos[0], y: dadPos[1]}, camLerp, {ease: FlxEase.quintOut});
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
				}
			
				if (camFocus != 'bf' && book1.PlayStateB1.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camMovement.cancel();
					camFocus = 'bf';

					if (book1.PlayStateB1.curSong.toLowerCase() == 'no-male-bitches' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'friendzone' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'extermination' || 
					book1.PlayStateB1.curSong.toLowerCase() == 'overseer')
						tweenCamInPlayer();

					camMovement = FlxTween.tween(camFollow, {x: bfPos[0], y: bfPos[1]}, camLerp, {ease: FlxEase.quintOut});
					
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneTurn', []);
					#end
				}					
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		#if debug
		if (FlxG.keys.justPressed.F5)
		{
			practiceMode = true;
			camHUD.flash(FlxColor.WHITE, 0.3);
			FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
			trace("enabled practice mode");
		}

		if (FlxG.keys.justPressed.F6)
		{
			practiceMode = false;
			cantDie = false;
			FlxG.sound.play(Paths.sound('cancelMenu', 'preload'));
			trace("disabled practice mode");
		}

		// dad movement
		if (FlxG.keys.justPressed.D)
		{
			dad.y += 5;
			trace("DAD CURRENT POSITION:\nX: " + dad.x + ", Y: " + dad.y);
		}

		if (FlxG.keys.justPressed.F)
		{
			dad.y -= 5;
			trace("DAD CURRENT POSITION:\nX: " + dad.x + ", Y: " + dad.y);
		}

		if (FlxG.keys.justPressed.C)
		{
			dad.x -= 5;
			trace("DAD CURRENT POSITION:\nX: " + dad.x + ", Y: " + dad.y);
		}

		if (FlxG.keys.justPressed.V)
		{
			dad.x += 5;
			trace("DAD CURRENT POSITION:\nX: " + dad.x + ", Y: " + dad.y);
		}

		// boyfriend movement
		if (FlxG.keys.justPressed.H)
		{
			boyfriend.y += 5;
			trace("BOYFRIEND CURRENT POSITION:\nX: " + boyfriend.x + ", Y: " + boyfriend.y);
		}

		if (FlxG.keys.justPressed.J)
		{
			boyfriend.y -= 5;
			trace("BOYFRIEND CURRENT POSITION:\nX: " + boyfriend.x + ", Y: " + boyfriend.y);
		}

		if (FlxG.keys.justPressed.N)
		{
			boyfriend.x -= 5;
			trace("BOYFRIEND CURRENT POSITION:\nX: " + boyfriend.x + ", Y: " + boyfriend.y);
		}

		if (FlxG.keys.justPressed.M)
		{
			boyfriend.x += 5;
			trace("BOYFRIEND CURRENT POSITION:\nX: " + boyfriend.x + ", Y: " + boyfriend.y);
		}

		// dad anim
		if (FlxG.keys.justPressed.Q)
			dad.playAnim('singLEFT');

		if (FlxG.keys.justPressed.W)
			dad.playAnim('singDOWN');

		if (FlxG.keys.justPressed.E)
			dad.playAnim('singUP');

		if (FlxG.keys.justPressed.T)
			dad.playAnim('singRIGHT');

		// boyfriend anim
		if (FlxG.keys.justPressed.U)
			boyfriend.playAnim('singLEFT');

		if (FlxG.keys.justPressed.I)
			boyfriend.playAnim('singDOWN');

		if (FlxG.keys.justPressed.O)
			boyfriend.playAnim('singUP');

		if (FlxG.keys.justPressed.P)
			boyfriend.playAnim('singRIGHT');

		if (FlxG.keys.justPressed.F10)
		{
			defaultCamZoom += 0.01;
			FlxG.camera.zoom += 0.01;
			trace("RAISED VALUE, CURRENT defaultCamZoom IS = " + defaultCamZoom);
		}		

		if (FlxG.keys.justPressed.F9)
		{
			defaultCamZoom -= 0.01;
			FlxG.camera.zoom -= 0.01;
			trace("DECREASED VALUE, CURRENT defaultCamZoom IS = " + defaultCamZoom);
		}	

		if (FlxG.keys.justPressed.F11)
		{
			if (!FlxG.save.data.unlockedRematch)
			{
				FlxG.save.data.unlockedRematch = true;
				FlxG.save.flush();
				trace("unlocked rematch");
			}
			else if (FlxG.save.data.unlockedRematch)
			{
				FlxG.save.data.unlockedRematch = false;
				FlxG.save.flush();
				trace("locked rematch");
			}
		}

		if (FlxG.keys.justPressed.F3)
		{
			if (!FlxG.save.data.botplay)
			{
				FlxG.save.data.botplay = true;
				FlxG.save.flush();
				trace("botplay enabled");
			}
			else if (FlxG.save.data.botplay)
			{
				FlxG.save.data.botplay = false;
				FlxG.save.flush();
				trace("botplay disabled");
			}
		}
		#end
		
		if (health <= 0)
		{
			if (practiceMode)
			{
				cantDie = true; // imagine not being able to die smh
			}
			else
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();

				switch (curSong.toLowerCase())
				{
					default:
						openSubState(new DeathScreen());
				}
	
				#if windows
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
				#end	
			}
		}

 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					switch (curSong.toLowerCase())
					{
						default:
							openSubState(new DeathScreen());
					}
					
					#if windows
			        // Game Over doesn't get his own variable because it's only used here
			        DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			        #end
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									dad.playAnim('singUP' + altAnim, true);

									if (dad.curCharacter == 'nmpenny' || dad.curCharacter == 'nmwillow')
										camGame.shake(0.004, 0.5);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
									
									if (dad.curCharacter == 'nmpenny' || dad.curCharacter == 'nmwillow')
										camGame.shake(0.004, 0.5);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);

									if (dad.curCharacter == 'nmpenny' || dad.curCharacter == 'nmwillow')
										camGame.shake(0.004, 0.5);
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);	

									if (dad.curCharacter == 'nmpenny' || dad.curCharacter == 'nmwillow')
										camGame.shake(0.004, 0.5);						
							}	


						if (camFocus == "dad" && FlxG.save.data.parallax)
							triggerCamMovement(Math.abs(daNote.noteData % 4));

						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);	
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = FlxG.save.data.voicesVol;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (!FlxG.save.data.botplay)
								{
										if (curSong.toLowerCase() == 'farewell')
											health -= 0.025;
										else
											health -= 0.075;
		
										vocals.volume = 0;

										new FlxTimer().start(0.4, function(tmr:FlxTimer)
										{
											vocals.volume = FlxG.save.data.voicesVol;
										});
										
										if (theFunne)
											noteMiss(daNote.noteData, daNote);	
								}
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished)
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		vocals.stop();
		FlxG.sound.music.stop();

		alreadyPlayedCuts = false;

		// disabling practice mode stuff and setting health to 1 (default) so you dont instantly die before the game ends
		health = 1;
		practiceMode = false;
		cantDie = false;

		Lib.application.window.title = "Friday Night Funkin': PIGGY BOOK 1 - 2";

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}	

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('piggyMenu', 'piggy'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
			dad.playAnim('idle');
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{				
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					if (curSong.toLowerCase() == 'almost')
					{
						if (FlxG.save.data.cutscenes)
							playMP4Video();
						else
							FlxG.switchState(new book1.StoryMenuState());
					}
					else
					{
					    FlxG.switchState(new book1.StoryMenuState());
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-hard';

					if (storyDifficulty == 1)
						difficulty = '-rematch';

					trace('LOADING NEXT SONG');
					trace(book1.PlayStateB1.storyPlaylist[0].toLowerCase() + difficulty);					

					prevCamFollow = camFollow;

					book1.PlayStateB1.SONG = Song.loadFromJson(book1.PlayStateB1.storyPlaylist[0].toLowerCase() + difficulty, book1.PlayStateB1.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (book1.CachingSelectionState.noCache)
					{
						FlxG.switchState(new book1.LoadingState(new book1.PlayStateB1(), false));
					}
					else
					{
						LoadingState.loadAndSwitchState(new book1.PlayStateB1());
					}
				}
			}
			else if (isPiracy)
			{
				isPiracy = false;
				FlxG.switchState(new BookSelectionState());
			}
			else if (!isPiracy && curSong.toLowerCase() != 'piracy')
			{
				FlxG.switchState(new book1.MainMenuState());
			}
		}
	}

	function endSongTwo():Void
	{
		vocals.stop();
		FlxG.sound.music.stop();

		alreadyPlayedCuts = false;

		// disabling practice mode stuff and setting health to 1 (default) so you dont instantly die before the game ends
		health = 1;
		practiceMode = false;
		cantDie = false;

		FlxG.switchState(new OpenTxtFile());	
	}

	function playMP4Video()
    {
		switch (curSong.toLowerCase())
		{
			case 'almost':
				var video:MP4Handler = new MP4Handler();
		
				video.playMP4(Paths.video('FinaleCuts'));
				video.finishCallback = function()
				{
					FlxG.save.flush();
					FlxG.switchState(new book1.MainMenuState());
				} 
		}	
    }

	// end deez nuts
	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	// pop up deez nuts
	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			vocals.volume = FlxG.save.data.voicesVol;
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				// shit on deez nuts
					case 'shit':
						score = -300;
						misses++;

						if (!FlxG.save.data.botplay)
						{
							if (curSong.toLowerCase() == 'farewell')
							{
								health -= 0.02;
							}
							else
							{
								health -= 0.2;
							}	
						}

						curXP -= 0.70;
						checkXP();

						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					// be bad with deez nuts
					case 'bad':
						daRating = 'bad';
						score = 0;
						
						if (!FlxG.save.data.botplay)
						{
							if (curSong.toLowerCase() == 'farewell')
							{
								health -= 0.02;
							}
							else
							{
								health -= 0.2;
							}	
						}

						curXP -= 0.20;
						checkXP();

						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					// you are pretty good with deez nuts
					case 'good':
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							if (curSong.toLowerCase() == 'farewell')
								health += 0.02;
						    else
								health += 0.04;

						curXP += 0.50;
						checkXP();

						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;

						if (FlxG.save.data.noteSplashes)
						{
							if (FlxG.save.data.botplay)
							{
								var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
								splash.setupNoteSplash(daNote.x + 57, playerStrums.members[daNote.noteData].y + 50, daNote.noteData);
								grpNoteSplashes.add(splash);	
							}
						}

					// you do sick things with deez nuts
					case 'sick':
						if (health < 2)
							if (curSong.toLowerCase() == 'farewell')
								health += 0.05;
						    else
								health += 0.1;

						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;	
						
						curXP += 1.00;
						checkXP();

						if (FlxG.save.data.noteSplashes)
						{
							var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
                            splash.setupNoteSplash(daNote.x + 57, playerStrums.members[daNote.noteData].y + 50, daNote.noteData);
                            grpNoteSplashes.add(splash);
						}
			}

			if (daRating != 'shit' || daRating != 'bad')
				{

			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			// should be called prision instead of school, since school irl is called prision
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
			
			rating.screenCenter();
			rating.y -= 50;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) {} // ok

			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});
		 
					for (note in dumbNotes)
					{
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}	
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
					    spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (!FlxG.save.data.botplay)
			{
					health -= 0.04;	
	
					misses++;
	
					songScore -= 10;
	
					if (FlxG.save.data.accuracyMod == 1)
					totalNotesHit -= 1;
	
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}	
			}

			if (camFocus == "bf" && FlxG.save.data.parallax)
				triggerCamMovement(direction % 4);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);

			judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nMisses: ${misses}';
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
					}
					else
						totalNotesHit += 1;	

						switch (note.noteData)
						{
							case 2:
								boyfriend.playAnim('singUP', true);
							case 3:
								boyfriend.playAnim('singRIGHT', true);
							case 1:
								boyfriend.playAnim('singDOWN', true); 
							case 0:
								boyfriend.playAnim('singLEFT', true);									
						}
		
					if (camFocus == "bf" && FlxG.save.data.parallax)
						triggerCamMovement(note.noteData % 4);
						
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);					
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = FlxG.save.data.voicesVol;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}

	var startedMoving:Bool = false;

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		if (curSong.toLowerCase() == 'locked-in')
		{
			switch (curStep)
			{
				case 64 | 192 | 320 | 384 | 512 | 640 | 832:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 960:
					bgBlackOverlay.alpha = 1;
					camHUD.alpha = 0;
			}
		}

		if (curSong.toLowerCase() == 'piracy')
		{
			switch (curStep)
			{
				case 1024:
					isPiracy = false;
					if (!FlxG.save.data.photoSens)
						camHUD.flash(FlxColor.RED, 0.5);
					deadFans.visible = true;
					FlxG.camera.zoom = 1.25;
					FlxTween.tween(FlxG.camera, {zoom: 0.7}, 10, {ease: FlxEase.expoOut});
				case 1792:
					nightmareWillowArrives();
				case 2304:
					isPiracy = true;
					bgBlackOverlay.alpha = 1;
					camHUD.alpha = 0;
			}
		}

		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				dad.dance();				
			}			
		}

		// imagine stealing MILF's zooms code, couldn't be you, AlexShadow.
		// also yeah, this controls mid-song zooms, like in MILF
		if (curSong.toLowerCase() == 'locked-in' && curBeat >= 48 && curBeat < 80 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'locked-in' && curBeat >= 96 && curBeat < 128 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'locked-in' && curBeat >= 160 && curBeat < 192 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'locked-in' && curBeat >= 208 && curBeat < 240 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
	}

	var camLerp:Float = 0.4;
	var camFocus:String = "";
	var camMovement:FlxTween;
	var daFunneOffsetMultiplier:Float = 35;

	var dadPos:Array<Float> = [0, 0];
	var bfPos:Array<Float> = [0, 0];

	function triggerCamMovement(num:Float = 0)
	{
		camMovement.cancel();

		if (camFocus == 'bf')
		{
			switch (num)
			{
				case 2:
					camMovement = FlxTween.tween(camFollow, {y: bfPos[1] - daFunneOffsetMultiplier, x: bfPos[0]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 3:
					camMovement = FlxTween.tween(camFollow, {x: bfPos[0] + daFunneOffsetMultiplier, y: bfPos[1]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 1:
					camMovement = FlxTween.tween(camFollow, {y: bfPos[1] + daFunneOffsetMultiplier, x: bfPos[0]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 0:
					camMovement = FlxTween.tween(camFollow, {x: bfPos[0] - daFunneOffsetMultiplier, y: bfPos[1]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
			}
		}
		else
		{
			switch (num)
			{
				case 2:
					camMovement = FlxTween.tween(camFollow, {y: dadPos[1] - daFunneOffsetMultiplier, x: dadPos[0]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 3:
					camMovement = FlxTween.tween(camFollow, {x: dadPos[0] + daFunneOffsetMultiplier, y: dadPos[1]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 1:
					camMovement = FlxTween.tween(camFollow, {y: dadPos[1] + daFunneOffsetMultiplier, x: dadPos[0]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
				case 0:
					camMovement = FlxTween.tween(camFollow, {x: dadPos[0] - daFunneOffsetMultiplier, y: dadPos[1]}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
			}
		}
	}

	function getCamOffsets()
	{
		if (dad.curCharacter == 'penny' || dad.curCharacter == 'kolie')
		{
			dadPos[0] = dad.getMidpoint().x + 165 + dad.camOffset[0];
			dadPos[1] = dad.getMidpoint().y + 20 + dad.camOffset[1];	
		}
		else if (dad.curCharacter == 'tigrymad' || dad.curCharacter == 'tigrydark')
		{
			dadPos[0] = dad.getMidpoint().x + 50 + dad.camOffset[0];
			dadPos[1] = dad.getMidpoint().y - 100 + dad.camOffset[1];
		}
		else
		{
			dadPos[0] = dad.getMidpoint().x + 150 + dad.camOffset[0];
			dadPos[1] = dad.getMidpoint().y - 100 + dad.camOffset[1];
		}

		if (boyfriend.curCharacter == 'bfperspective')
		{
			bfPos[0] = boyfriend.getMidpoint().x - 420 + boyfriend.camOffset[0];
			bfPos[1] = boyfriend.getMidpoint().y - 460 + boyfriend.camOffset[1];	
		}
		else
		{
			bfPos[0] = boyfriend.getMidpoint().x - 100 + boyfriend.camOffset[0];
			bfPos[1] = boyfriend.getMidpoint().y - 100 + boyfriend.camOffset[1];	
		}
	}

	// mid-song events functions below here hadgyuasdgjyuasdasd
	function nightmareWillowArrives()
	{
		bgBlackOverlay.alpha = 1;
		camHUD.alpha = 0;

		remove(dad);
		dad = new Character(100, 160, 'nmwillow');
		add(dad);

		dad.x = 55;
		dad.y = 35;

		iconP2.changeIcon('nmwillow');

		healthBar.createFilledBar(0xFFCA1F7B, 0xFF808080);
		trace("GENERATED HEALTH BAR COLOURS.");

		FlxG.camera.zoom = 1.25;
		FlxTween.tween(FlxG.camera, {zoom: 0.7}, 10, {ease: FlxEase.expoOut});

		FlxTween.tween(bgBlackOverlay, {alpha: 0}, 7);
		FlxTween.tween(camHUD, {alpha: 1}, 7);
	}

	function blackScreenAppear() // im scared of the darkness :(
	{		
		dad.visible = false;
		if (curSong.toLowerCase() != 'hide-and-seek')
			boyfriend.visible = false;

		camHUD.visible = false;

		blackScreen2.visible = true;
	}

	function blackScreenRemove() // oh, everything's back nvm lmfaoo
	{			
		dad.visible = true;
		if (curSong.toLowerCase() != 'hide-and-seek')
			boyfriend.visible = true;

		camHUD.visible = true;

		blackScreen2.visible = false;
	}

	function checkXP()
	{
		if (curXP <= 0.00)
			curXP = 0.00;
		else if (curXP >= 49.99)
			FlxG.save.data.curLevel = 2;
		else if (curXP >= 99.99)
			FlxG.save.data.curLevel = 3;
		else if (curXP >= 149.99)
			FlxG.save.data.curLevel = 4;
		else if (curXP >= 199.99)
			FlxG.save.data.curLevel = 5;
		else if (curXP >= 249.99)
			FlxG.save.data.curLevel = 6;
		else if (curXP >= 299.99)
			FlxG.save.data.curLevel = 7;
		else if (curXP >= 349.99)
			FlxG.save.data.curLevel = 8;
		else if (curXP >= 399.99)
			FlxG.save.data.curLevel = 9;
		else if (curXP >= 449.99)
			FlxG.save.data.curLevel = 10;
		else if (curXP >= 499.99)
			FlxG.save.data.curLevel = 11;
		else if (curXP >= 549.99)
			FlxG.save.data.curLevel = 12;
		else if (curXP >= 599.99)
			FlxG.save.data.curLevel = 13;
		else if (curXP >= 649.99)
			FlxG.save.data.curLevel = 14;
		else if (curXP >= 699.99)
			FlxG.save.data.curLevel = 15;
		else if (curXP >= 700.00)
			curXP = 700.00;	

		FlxG.save.flush();	

		// trace("CURRENT XP: " + curXP);
	}

	function lowHealthWarning()
	{
		if (!dontSpamFunc)
		{
			dontSpamFunc = true;

			warningShit = new HealthWarning(0, 0, 0, 0, true);
			warningShit.alpha = 1;
			add(warningShit);

			eternalTweenLMAO();
		}
	}

	function eternalTweenLMAO()
	{
		warningTwn = FlxTween.tween(warningShit, {alpha: 0}, 0.4, {onComplete: function (twn:FlxTween) {
			eternalTween2LMAO();
		}});
	}
		
	function eternalTween2LMAO()
	{
		warningTwn = FlxTween.tween(warningShit, {alpha: 1}, 0.4, {onComplete: function (twn:FlxTween) {
			eternalTweenLMAO();
		}});
	}

	// light flicking
	function lightFlicker()
	{
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			FlxTween.tween(fgLight, {alpha: 0}, 0.1, {onComplete: function (twn:FlxTween) {
				fgLight.alpha = 1;
				lightFlicker2();
			}});
		});
	}

	function lightFlicker2()
	{
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			FlxTween.tween(fgLight, {alpha: 0}, 0.05, {onComplete: function (twn:FlxTween) {
				fgLight.alpha = 1;
				lightFlicker3();
			}});
		});
	}

	function lightFlicker3()
	{
		FlxTween.tween(fgLight, {alpha: 0}, 0.01, {onComplete: function (twn:FlxTween) {
			fgLight.alpha = 1;
			lightFlicker4();
		}});
	}

	function lightFlicker4()
	{
		new FlxTimer().start(0.4, function(tmr:FlxTimer)
		{
			FlxTween.tween(fgLight, {alpha: 0}, 0.1, {onComplete: function (twn:FlxTween) {
				fgLight.alpha = 1;
				lightFlicker5();
			}});
		});
	}

	function lightFlicker5()
	{
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			FlxTween.tween(fgLight, {alpha: 0}, 0.2, {onComplete: function (twn:FlxTween) {
				fgLight.alpha = 1;
				lightFlicker();
			}});
		});
	}

	var curLight:Int = 0;
}
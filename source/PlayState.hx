package;

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

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;

	public static var isStoryMode:Bool = false;
	public static var isFreeplay:Bool = false;
	public static var isFreeplayTwo:Bool = false;
	public static var isFreeplay3:Bool = false;
	public static var isExtrasMenu:Bool = false;
	public static var isFelixCutscene:Bool = false;
	public static var isExtraFreeplay:Bool = false;
	
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
	public static var gf:Character;
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

	private var gfSpeed:Int = 1;
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

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var alleysBg2:FlxSprite;
	var backBench2:FlxSprite;
	var pillar2:FlxSprite;
	var factoryBg:FlxSprite;

	// triple trouble!!
	var daTTStatic:FlxSprite;
	var lucellaBg:FlxSprite;
	var floorNTrees:FlxSprite;
	var templeFloor:FlxSprite;
	var templeWalls:FlxSprite;

	// some bg variables here cuz yes
	var storeBg:FlxSprite;
	var safePlaceBg:FlxSprite;
	var sewersBg:FlxSprite;
	var portBg:FlxSprite;
	var oldLackBg:FlxSprite;
	var blackbg:FlxSprite;
	var refineryRoomBg:FlxSprite;
	var blackScreenFarewell:FlxSprite;
	var redScreenFarewell:FlxSprite;
	var factoryStairsBg:FlxSprite;
	var factoryHallwayBg:FlxSprite;
	var labHallwayBg:FlxSprite;
	var whiteVoid:FlxSprite;
	var whiteVoidEvil:FlxSprite;
	var distBG:FlxSprite;
	var distBGRed:FlxSprite;

    // bg boppers shit variables
	var doggyOfficer:FlxSprite;
	var ponyStore:FlxSprite;
	var zizzyStore:FlxSprite;
	var filipRefinery:FlxSprite;
	var ponyRefinery:FlxSprite;
	var zeeSewers:FlxSprite;
	var zuzySewers:FlxSprite;
	var willowBg:FlxSprite; // the lesbian bitch
	var ponyDocks:FlxSprite; // he got infected for being such an idiot and try to fight back when he knows that he's a weak mf
	var robbyTemple:FlxSprite; // obv not the one with a chainsaw :)
	var willowCamp:FlxSprite;
	var ponyCamp:FlxSprite;
	var tigryOL:FlxSprite;
	var filipOL:FlxSprite;	
	var coupleFG:FlxSprite;
	var treeFG:FlxSprite;
	
	// winter holiday shit
	var zeeHoliday:FlxSprite;
	var mimiHoliday:FlxSprite;
	var giraffyHoliday:FlxSprite;
	var ponyHoliday:FlxSprite;
	var christmasTree:FlxSprite;

	// insolence note static shit woooooooooo
	var daStaticInsolence:FlxSprite; // stop freezing the game, bitch

	// inGame shit variables
	var blackScreen2:FlxSprite; // naming it blackScreen2 cuz blackScreen is already used for winter horrorland's intro and im too lazy to remove winter horrorland intro code /e cry
                                // edit: well i did, but... its just to organize myself
	var vignette:FlxSprite;
	var vignetteRed:FlxSprite;	
	var snowOverlay:FlxBackdrop; // idk why i love this sm
	var redOverlay:FlxSprite; // so scary :((((
	var promenadeOverlay:FlxBackdrop; 

	// countdown
	var blackCountdown:FlxSprite;
	var countdownBox:FlxSprite;

	var bulletPopup:BulletPopup;

	public var songList:Array<String> = [
		'on-the-hunt',
		'in-stock',
		'encounters',
		'intruders',
		'farewell',
		'metal-escape',
		'underground',
		'our-battle',
		'change',
		'deep-sea',
		'all-aboard',
		'teleport',
		'sneaky',
		'overseer',
		'cold-blood',
		'once-for-all',
		'run-away',
		'promenade',
		'no-male-bitches',
		'friendzone',
		'extermination',
		'frost-fate',
		'hide-and-seek',
		'forgotten-past',
		'swing-it'
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
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	override public function create()
	{
		// PRELOADING INST AND VOICES
		if (storyDifficulty != 1)
		{
			FlxG.sound.cache(Paths.inst(PlayState.SONG.song));
			FlxG.sound.cache(Paths.voices(PlayState.SONG.song));	
		}
		else
		{
			FlxG.sound.cache(Paths.instRematch(PlayState.SONG.song));
			FlxG.sound.cache(Paths.voicesRematch(PlayState.SONG.song));	
		}
		
		// PRELOADING INSOLENCE NOTE SOUND WHEN U MISS AN INSOLENCE EYE NOTE AND ALSO OTHER SOUNDS
		// THIS PRELOAD SHIT ALSO CAN UHHH- TAKE ALOT OF MEMORY SO IDC IF YOUR PC IS A OVEN RN (LIKE MINE)

		// FlxG.sound.cache(Paths.sound('insolenceNote', 'piggy'));

		FlxG.sound.cache(Paths.sound('missnote1', 'shared'));
		FlxG.sound.cache(Paths.sound('missnote2', 'shared'));
		FlxG.sound.cache(Paths.sound('missnote3', 'shared'));

		FlxG.sound.cache(Paths.sound('fnf_loss_sfx', 'shared'));

		// PRELOADING MID-SONG EVENTS ASSETS CUZ THE GAME MAY FREEZE WHEN THE GAME TRIES TO LOAD IT
		if (curSong.toLowerCase() == 'in-stock')
		{
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'IN-STOCK' ASSETS.");	
		}		

		if (curSong.toLowerCase() == 'metal-escape')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(3, 3);
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);
				
			trace("PRELOADED 'METAL-ESCAPE' ASSETS.");	
		}

		if (curSong.toLowerCase() == 'underground')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(3, 3);
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);
				
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			trace("PRELOADED 'UNDERGROUND' ASSETS.");	
		}

		if (curSong.toLowerCase() == 'deep-sea')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(3, 3);
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);
				
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'DEEP-SEA' ASSETS.");	
		}	

		if (curSong.toLowerCase() == 'teleport')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(3, 3);
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);

			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);
				
			redOverlay = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
			redOverlay.scale.set(1.9, 1.9);
			redOverlay.antialiasing = true;
			redOverlay.screenCenter(X);
			redOverlay.updateHitbox();
			redOverlay.scrollFactor.set();	
			redOverlay.visible = false;
			add(redOverlay);

			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'TELEPORT' ASSETS.");	
		}	

		if (curSong.toLowerCase() == 'sneaky')
		{
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);
				
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'SNEAKY' ASSETS.");	
		}

		if (curSong.toLowerCase() == 'cold-blood')
		{
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);
		}

		if (curSong.toLowerCase() == 'run-away')
		{
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);

			trace("PRELOADED 'RUN-AWAY' ASSETS.");	
		}

		if (curSong.toLowerCase() == 'promenade')
		{
			promenadeOverlay = new FlxBackdrop(Paths.image('inGame/promenadeOverlay', 'piggy'));
			promenadeOverlay.alpha = 0.15;
			promenadeOverlay.velocity.set(-40, 0);
			promenadeOverlay.cameras = [camHUD];
			promenadeOverlay.visible = false;
			add(promenadeOverlay);

			trace("PRELOADED 'PROMENADE' ASSETS.");	
		}

		instance = this;
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

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
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		
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

		// if (SONG == null)
		//	SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		switch(SONG.stage)
		{
			case 'alleys':
			{
				defaultCamZoom = 0.75;
                curStage = 'alleys';

				var stagePosX = -700;
				var stagePosY = -520;

				var alleysBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/alleysBG', 'piggy'));
				alleysBg.setGraphicSize(Std.int(alleysBg.width * 1.6));
				alleysBg.updateHitbox();
				alleysBg.antialiasing = true;
				alleysBg.scrollFactor.set(1, 0.9);
				add(alleysBg);

				var backBench:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/blurryBenchLol', 'piggy'));
				backBench.setGraphicSize(Std.int(backBench.width * 1.6));
				backBench.updateHitbox();
				backBench.antialiasing = true;
				backBench.scrollFactor.set(1, 0.9);
				add(backBench);

				var pillar:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter1/randomPillar', 'piggy'));
				pillar.setGraphicSize(Std.int(pillar.width * 1.6));
				pillar.updateHitbox();
				pillar.antialiasing = true;
				pillar.scrollFactor.set(1, 0.9);
				add(pillar);

				if (FlxG.save.data.distractions)
					{
						doggyOfficer = new FlxSprite(-74, 300);
						doggyOfficer.frames = Paths.getSparrowAtlas('bgboppers/doggyOfficer', 'piggy');
						doggyOfficer.animation.addByPrefix('idle', "doggy bop", 24);
						doggyOfficer.antialiasing = true;			
						doggyOfficer.scrollFactor.set(1, 0.9);
						doggyOfficer.setGraphicSize(Std.int(doggyOfficer.width * .7));
						doggyOfficer.updateHitbox();
						add(doggyOfficer);
					}		
				
				trace("LOADED 'Alleys' STAGE.");	
			}

			case 'store':
				{
					defaultCamZoom = 0.75;
					curStage = 'store';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					storeBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter2/storeBG', 'piggy'));
					storeBg.setGraphicSize(Std.int(storeBg.width * 1.6));
					storeBg.updateHitbox();
					storeBg.antialiasing = true;
					storeBg.scrollFactor.set(1, 0.9);
					add(storeBg);
	
					var tv:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter2/wallTV', 'piggy'));
					tv.setGraphicSize(Std.int(tv.width * 1.6));
					tv.updateHitbox();
					tv.antialiasing = true;
					tv.scrollFactor.set(1, 0.9);
					add(tv);

					if (FlxG.save.data.distractions)
						{
							ponyStore = new FlxSprite(175, 330);
							ponyStore.frames = Paths.getSparrowAtlas('bgboppers/ponyStore', 'piggy');
							ponyStore.animation.addByPrefix('idle', "pony bop", 24);
							ponyStore.antialiasing = true;			
							ponyStore.scrollFactor.set(1, 0.9);
							ponyStore.setGraphicSize(Std.int(ponyStore.width * .7));
							ponyStore.updateHitbox();
							add(ponyStore);

							zizzyStore = new FlxSprite(1044, 290);
							zizzyStore.frames = Paths.getSparrowAtlas('bgboppers/zizzyStore', 'piggy');
							zizzyStore.animation.addByPrefix('idle', "zizzy bop", 24);
							zizzyStore.antialiasing = true;			
							zizzyStore.scrollFactor.set(1, 0.9);
							zizzyStore.setGraphicSize(Std.int(zizzyStore.width * .7));
							zizzyStore.updateHitbox();

                            zizzyStore.flipX = true;

							add(zizzyStore);							
						}		

					// stupid black screen for in game scary ambience /e dance
					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Store' STAGE.");						
				}	

			case 'refinery':
				{
					defaultCamZoom = 0.75;
					curStage = 'refinery';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var refineryBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter3/refineryBG', 'piggy'));
					refineryBg.setGraphicSize(Std.int(refineryBg.width * 1.6));
					refineryBg.updateHitbox();
					refineryBg.antialiasing = true;
					refineryBg.scrollFactor.set(1, 0.9);
					add(refineryBg);

					if (FlxG.save.data.distractions)
						{
							ponyRefinery = new FlxSprite(1100, 250);
							ponyRefinery.frames = Paths.getSparrowAtlas('bgboppers/ponyRefinery', 'piggy');
							ponyRefinery.animation.addByPrefix('idle', "pony bop", 24);
							ponyRefinery.antialiasing = true;			
							ponyRefinery.scrollFactor.set(1, 0.9);
							ponyRefinery.setGraphicSize(Std.int(ponyRefinery.width * .7));
							ponyRefinery.updateHitbox();
							add(ponyRefinery);	

							ponyRefinery.flipX = true;					
						}

					trace("LOADED 'Refinery' STAGE.");	
				}		

			case 'safeplace':
				{
					defaultCamZoom = 0.73;
					curStage = 'safeplace';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					safePlaceBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter4/safePlaceBG', 'piggy'));
					safePlaceBg.setGraphicSize(Std.int(safePlaceBg.width * 1.6));
					safePlaceBg.updateHitbox();
					safePlaceBg.antialiasing = true;
					safePlaceBg.scrollFactor.set(1, 0.9);
					add(safePlaceBg);

					var idkWhatIsThis:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter4/theThings', 'piggy'));
					idkWhatIsThis.setGraphicSize(Std.int(idkWhatIsThis.width * 1.6));
					idkWhatIsThis.updateHitbox();
					idkWhatIsThis.antialiasing = true;
					idkWhatIsThis.scrollFactor.set(1, 0.9);
					add(idkWhatIsThis);

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(3, 3);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					trace("LOADED 'Safe Place' STAGE.");
				}		
			case 'sewers':
				{
					defaultCamZoom = 0.75;
					curStage = 'sewers';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					sewersBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter5/sewersBG', 'piggy'));
					sewersBg.setGraphicSize(Std.int(sewersBg.width * 1.6));
					sewersBg.updateHitbox();
					sewersBg.antialiasing = true;
					sewersBg.scrollFactor.set(1, 0.9);
					add(sewersBg);

					var zhugo83:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter5/sussyWater', 'piggy'));
					zhugo83.setGraphicSize(Std.int(zhugo83.width * 1.6));
					zhugo83.updateHitbox();
					zhugo83.antialiasing = true;
					zhugo83.scrollFactor.set(1, 0.9);
					add(zhugo83); // my best friend :)

					var idkWhatIsThis:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter5/theThings', 'piggy'));
					idkWhatIsThis.setGraphicSize(Std.int(idkWhatIsThis.width * 1.6));
					idkWhatIsThis.updateHitbox();
					idkWhatIsThis.antialiasing = true;
					idkWhatIsThis.scrollFactor.set(1, 0.9);
					add(idkWhatIsThis);

					if (FlxG.save.data.distractions)
						{
							zeeSewers = new FlxSprite(0, 270);
							zeeSewers.frames = Paths.getSparrowAtlas('bgboppers/zeeSewers', 'piggy');
							zeeSewers.animation.addByPrefix('idle', "zee bop", 24);
							zeeSewers.antialiasing = true;			
							zeeSewers.scrollFactor.set(1, 0.9);
							zeeSewers.setGraphicSize(Std.int(zeeSewers.width * .8));
							zeeSewers.updateHitbox();
							add(zeeSewers);							

							zuzySewers = new FlxSprite(1044, 290);
							zuzySewers.frames = Paths.getSparrowAtlas('bgboppers/zuzySewers', 'piggy');
							zuzySewers.animation.addByPrefix('idle', "zuzy bop", 24);
							zuzySewers.antialiasing = true;			
							zuzySewers.scrollFactor.set(1, 0.9);
							zuzySewers.setGraphicSize(Std.int(zuzySewers.width * .8));
							zuzySewers.updateHitbox();
							add(zuzySewers);	

							zuzySewers.flipX = true;					
						}
					
					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(3, 3);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);

					trace("LOADED 'Sewers' STAGE.");
				}	
			case 'factory':
				{
					defaultCamZoom = 0.75;
					curStage = 'factory';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var factoryBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter6/factoryBG', 'piggy'));
					factoryBg.setGraphicSize(Std.int(factoryBg.width * 1.6));
					factoryBg.updateHitbox();
					factoryBg.antialiasing = true;
					factoryBg.scrollFactor.set(1, 0.9);
					add(factoryBg);

					trace("LOADED 'Factory' STAGE.");
				}	
			case 'port':
				{
					defaultCamZoom = 0.75;
					curStage = 'port';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					portBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter7/portBG', 'piggy'));
					portBg.setGraphicSize(Std.int(portBg.width * 1.6));
					portBg.updateHitbox();
					portBg.antialiasing = true;
					portBg.scrollFactor.set(1, 0.9);
					add(portBg);

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(3, 3);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.1, 1.1);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);

					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Port' STAGE.");
				}		
			case 'ship':
				{
					defaultCamZoom = 0.75;
					curStage = 'ship';
	
					var stagePosX = -700;
					var stagePosY = -520;

					var shipBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter8/shipBG', 'piggy'));
					shipBg.setGraphicSize(Std.int(shipBg.width * 1.6));
					shipBg.updateHitbox();
					shipBg.antialiasing = true;
					shipBg.scrollFactor.set(1, 0.9);
					add(shipBg);

					if (FlxG.save.data.distractions)
						{
							willowBg = new FlxSprite(400, -80);
							willowBg.frames = Paths.getSparrowAtlas('bgboppers/willowBGShip', 'piggy');
							willowBg.animation.addByPrefix('idle', "willow bop", 24);
							willowBg.antialiasing = true;
							willowBg.scrollFactor.set(1, 0.9);
							willowBg.setGraphicSize(Std.int(willowBg.width * .9));
							willowBg.updateHitbox();
							add(willowBg);											
						}

					// how does a table not float on a shi-.. wait, nvm
					var tables:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter8/tables', 'piggy'));
					tables.setGraphicSize(Std.int(tables.width * 1.6));
					tables.updateHitbox();
					tables.antialiasing = true;
					tables.scrollFactor.set(1, 0.9);
					add(tables);

					trace("LOADED 'Ship' STAGE.");
				}	
			
			case 'docks':
				{
					defaultCamZoom = 0.70;
					curStage = 'docks'; // cocks :troll:
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var docksBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter9/docksBG', 'piggy'));
					docksBg.setGraphicSize(Std.int(docksBg.width * 1.6));
					docksBg.updateHitbox();
					docksBg.antialiasing = true;
					docksBg.scrollFactor.set(1, 0.9);
					add(docksBg);

					if (FlxG.save.data.distractions)
						{
							ponyDocks = new FlxSprite(1100, 250);
							ponyDocks.frames = Paths.getSparrowAtlas('bgboppers/ponyDocks', 'piggy');
							ponyDocks.animation.addByPrefix('idle', "pony bop", 24);
							ponyDocks.antialiasing = true;			
							ponyDocks.scrollFactor.set(1, 0.9);
							ponyDocks.setGraphicSize(Std.int(ponyDocks.width * .7));
							ponyDocks.updateHitbox();
							add(ponyDocks);	

							ponyDocks.flipX = true;					
						}

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'screenSTATIC', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(3, 3);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);
			
					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
			
					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.05, 1.05);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);
							
					redOverlay = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
					redOverlay.scale.set(1.9, 1.9);
					redOverlay.antialiasing = true;
					redOverlay.screenCenter(X);
					redOverlay.updateHitbox();
					redOverlay.scrollFactor.set();	
					redOverlay.visible = false;
					add(redOverlay);
			
					blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);	
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Docks' STAGE.");	
				}

			case 'temple':
				{
					defaultCamZoom = 0.75;
					curStage = 'temple';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var templeBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter10/templeBG', 'piggy'));
					templeBg.setGraphicSize(Std.int(templeBg.width * 1.6));
					templeBg.updateHitbox();
					templeBg.antialiasing = true;
					templeBg.scrollFactor.set(1, 0.9);
					add(templeBg);

					if (FlxG.save.data.distractions)
						{
							robbyTemple = new FlxSprite(1000, -100);
							robbyTemple.frames = Paths.getSparrowAtlas('bgboppers/robbyTemple', 'piggy');
							robbyTemple.animation.addByPrefix('idle', "robby bop", 24);
							robbyTemple.antialiasing = true;			
							robbyTemple.scrollFactor.set(1, 0.9);
							robbyTemple.updateHitbox();
							add(robbyTemple);	

							robbyTemple.flipX = true;					
						}

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
							
					blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);	
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Temple' STAGE.");	
				}

			case 'camp':
				{
					defaultCamZoom = 0.75;
					curStage = 'camp';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var campBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter11/campBG', 'piggy'));
					campBg.setGraphicSize(Std.int(campBg.width * 1.6));
					campBg.updateHitbox();
					campBg.antialiasing = true;
					campBg.scrollFactor.set(1, 0.9);
					add(campBg);

					// do you want to build a sno-
					var snowBalls:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter11/snowBalls', 'piggy'));
					snowBalls.setGraphicSize(Std.int(snowBalls.width * 1.6));
					snowBalls.updateHitbox();
					snowBalls.antialiasing = true;
					snowBalls.scrollFactor.set(1, 0.9);
					add(snowBalls);

					if (FlxG.save.data.distractions)
						{
							willowCamp = new FlxSprite(-50, 200);
							willowCamp.frames = Paths.getSparrowAtlas('bgboppers/willowCamp', 'piggy');
							willowCamp.animation.addByPrefix('idle', "willow bop", 24);
							willowCamp.antialiasing = true;			
							willowCamp.scrollFactor.set(1, 0.9);
							willowCamp.setGraphicSize(Std.int(willowCamp.width * .8));
							willowCamp.updateHitbox();
							add(willowCamp);	

							ponyCamp = new FlxSprite(1100, 250);
							ponyCamp.frames = Paths.getSparrowAtlas('bgboppers/ponyCamp', 'piggy');
							ponyCamp.animation.addByPrefix('idle', "pony bop", 24);
							ponyCamp.antialiasing = true;			
							ponyCamp.scrollFactor.set(1, 0.9);
							ponyCamp.setGraphicSize(Std.int(ponyCamp.width * .75));
							ponyCamp.updateHitbox();
							add(ponyCamp);	

							ponyCamp.flipX = true;					
						}

					snowOverlay = new FlxBackdrop(Paths.image('inGame/snowOverlay', 'piggy'));
					snowOverlay.alpha = 0.80;
					snowOverlay.velocity.set(450, 450);
					snowOverlay.cameras = [camHUD];
					add(snowOverlay);

					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);
					
					trace("LOADED 'Camp' STAGE.");	
				}

			case 'lab':
				{
					defaultCamZoom = 0.75;
					curStage = 'lab';
	
					var stagePosX = -700;  
					var stagePosY = -520;
	
					var labBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter12/labBG', 'piggy'));
					labBg.setGraphicSize(Std.int(labBg.width * 1.7));
					labBg.updateHitbox();
					labBg.antialiasing = true;
					labBg.scrollFactor.set(1, 0.9);
					add(labBg);

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
			
					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.05, 1.05);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);

					trace("LOADED 'Lab' STAGE.");	
				}

			case 'cabin':
				{
					defaultCamZoom = 0.75;
					curStage = 'cabin';
	
					var stagePosX = -700;  
					var stagePosY = -520;
	
					var cabinBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/winterHoliday/cabinBG', 'piggy'));
					cabinBg.setGraphicSize(Std.int(cabinBg.width * 1.7));
					cabinBg.updateHitbox();
					cabinBg.antialiasing = true;
					cabinBg.scrollFactor.set(1, 0.9);
					add(cabinBg);

					if (FlxG.save.data.distractions)
						{
							mimiHoliday = new FlxSprite(-300, 247);
							mimiHoliday.frames = Paths.getSparrowAtlas('bgboppers/mimiHoliday', 'piggy');
							mimiHoliday.animation.addByPrefix('idle', "mimiholiday bop", 24);
							mimiHoliday.antialiasing = true;			
							mimiHoliday.scrollFactor.set(1, 0.9);
							mimiHoliday.updateHitbox();
							add(mimiHoliday);

							zeeHoliday = new FlxSprite(-150, 290);
							zeeHoliday.frames = Paths.getSparrowAtlas('bgboppers/zeeHoliday', 'piggy');
							zeeHoliday.animation.addByPrefix('idle', "zeeholiday bop", 24);
							zeeHoliday.antialiasing = true;			
							zeeHoliday.scrollFactor.set(1, 0.9);
							zeeHoliday.updateHitbox();
							add(zeeHoliday);

							giraffyHoliday = new FlxSprite(1477, 80);
							giraffyHoliday.frames = Paths.getSparrowAtlas('bgboppers/giraffyHoliday', 'piggy');
							giraffyHoliday.animation.addByPrefix('idle', "giraffyholiday bop", 24);
							giraffyHoliday.antialiasing = true;			
							giraffyHoliday.scrollFactor.set(1, 0.9);
							giraffyHoliday.updateHitbox();
							add(giraffyHoliday);

							giraffyHoliday.flipX = true;

							ponyHoliday = new FlxSprite(1800, 270);
							ponyHoliday.frames = Paths.getSparrowAtlas('bgboppers/ponyHoliday', 'piggy');
							ponyHoliday.animation.addByPrefix('idle', "ponyholiday bop", 24);
							ponyHoliday.antialiasing = true;			
							ponyHoliday.scrollFactor.set(1, 0.9);
							ponyHoliday.updateHitbox();
							add(ponyHoliday);	

							ponyHoliday.flipX = true;					
						}

					christmasTree = new FlxSprite(200, -600);
					christmasTree.frames = Paths.getSparrowAtlas('bgs/winterHoliday/christmasTree', 'piggy');
					christmasTree.animation.addByPrefix('idle', "tree", 24);
					christmasTree.antialiasing = true;
					christmasTree.scale.set(1.4, 1.4);	
					// christmasTree.screenCenter();		
					christmasTree.scrollFactor.set(1, 0.9);
					christmasTree.updateHitbox();
					add(christmasTree);

					promenadeOverlay = new FlxBackdrop(Paths.image('inGame/promenadeOverlay', 'piggy'));
					promenadeOverlay.alpha = 0.15;
					promenadeOverlay.velocity.set(-40, 0);
					promenadeOverlay.cameras = [camHUD];
					promenadeOverlay.visible = false;
					add(promenadeOverlay);

					trace("LOADED 'Cabin' STAGE.");	
				}

			case 'oldlack': // idk, this is how i remember the name lmfao
				{
					defaultCamZoom = 0.75;
					curStage = 'oldlack';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					oldLackBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter2/idkHowWasThisCalled', 'piggy'));
					oldLackBg.setGraphicSize(Std.int(oldLackBg.width * 1.6));
					oldLackBg.updateHitbox();
					oldLackBg.antialiasing = true;
					oldLackBg.scrollFactor.set(1, 0.9);
					add(oldLackBg);

					blackbg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter2/blackbg', 'piggy'));
					blackbg.setGraphicSize(Std.int(blackbg.width * 1.6));
					blackbg.updateHitbox();
					blackbg.visible = false;
					blackbg.antialiasing = true;
					blackbg.scrollFactor.set(1, 0.9);
					add(blackbg);
					
					// tigry stinks smh  -Willow
					tigryOL = new FlxSprite(-200, 100);
					tigryOL.frames = Paths.getSparrowAtlas('bgboppers/tigryOL', 'piggy');
					tigryOL.animation.addByPrefix('idle', "Tigry Idle", 24);
					tigryOL.antialiasing = true;			
					tigryOL.scrollFactor.set(1, 0.9);
					tigryOL.setGraphicSize(Std.int(tigryOL.width * .7));
					tigryOL.updateHitbox();
					add(tigryOL);

					filipOL = new FlxSprite(1100, 100);
					filipOL.frames = Paths.getSparrowAtlas('bgboppers/filipOL', 'piggy');
					filipOL.animation.addByPrefix('idle', "Filip Idle", 24);
					filipOL.antialiasing = true;			
					filipOL.scrollFactor.set(1, 0.9);
					filipOL.setGraphicSize(Std.int(filipOL.width * .7));
					filipOL.updateHitbox();
					filipOL.flipX = true;
					add(filipOL);

					coupleFG = new FlxSprite(0, 0);
					coupleFG.frames = Paths.getSparrowAtlas('bgboppers/coupleFG', 'piggy');
					coupleFG.animation.addByPrefix('idle', "couplefg bop", 24);
					coupleFG.antialiasing = true;	
					// coupleFG.screenCenter(X);	
					coupleFG.y += 450; 	
					coupleFG.x -= 200; 	
					coupleFG.scale.set(1.5, 1.5);
					coupleFG.scrollFactor.set(1, 0.9);
					coupleFG.updateHitbox();	

					trace("LOADED 'Old Lack' STAGE.");	
				}

			case 'refineryroom':
				{
					defaultCamZoom = 0.75;
					curStage = 'refineryroom';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					refineryRoomBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter3/refineryRoomBG', 'piggy'));
					refineryRoomBg.setGraphicSize(Std.int(refineryRoomBg.width * 1.6));
					refineryRoomBg.updateHitbox();
					refineryRoomBg.antialiasing = true;
					refineryRoomBg.scrollFactor.set(1, 0.9);
					// refineryRoomBg.flipX = true;
					add(refineryRoomBg);

					redScreenFarewell = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
					redScreenFarewell.scale.set(10, 10);
					redScreenFarewell.updateHitbox();
					redScreenFarewell.antialiasing = true;
					redScreenFarewell.scrollFactor.set(1, 0.9);
					redScreenFarewell.visible = false;
					add(redScreenFarewell);

					blackScreenFarewell = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter2/blackbg', 'piggy'));
					blackScreenFarewell.scale.set(3, 3);
					blackScreenFarewell.updateHitbox();
					blackScreenFarewell.antialiasing = true;
					blackScreenFarewell.scrollFactor.set(1, 0.9);
					blackScreenFarewell.visible = false;
					add(blackScreenFarewell);

					trace("LOADED 'Refinery Room' STAGE.");	
				}

			case 'factorynormal':
				{
					defaultCamZoom = 0.75;
					curStage = 'factorynormal';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					factoryHallwayBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter6/factoryHallwayBG', 'piggy'));
					factoryHallwayBg.setGraphicSize(Std.int(factoryHallwayBg.width * 1.6));
					factoryHallwayBg.updateHitbox();
					factoryHallwayBg.antialiasing = true;
					factoryHallwayBg.scrollFactor.set(1, 0.9);
					factoryHallwayBg.visible = true;
					add(factoryHallwayBg);

					factoryStairsBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter6/factoryStairsBG', 'piggy'));
					factoryStairsBg.setGraphicSize(Std.int(factoryStairsBg.width * 1.6));
					factoryStairsBg.updateHitbox();
					factoryStairsBg.antialiasing = true;
					factoryStairsBg.scrollFactor.set(1, 0.9);
					factoryStairsBg.visible = false;
					add(factoryStairsBg);

					trace("LOADED 'Factory Normal' STAGE.");	
				}

			case 'labnormal':
				{
					defaultCamZoom = 0.75;
					curStage = 'labnormal';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					labHallwayBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/chapter11/labHallwayBG', 'piggy'));
					labHallwayBg.setGraphicSize(Std.int(labHallwayBg.width * 1.6));
					labHallwayBg.updateHitbox();
					labHallwayBg.antialiasing = true;
					labHallwayBg.scrollFactor.set(1, 0.9);
					labHallwayBg.visible = true;
					add(labHallwayBg);

					redScreenFarewell = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
					redScreenFarewell.scale.set(10, 10);
					redScreenFarewell.updateHitbox();
					redScreenFarewell.antialiasing = true;
					redScreenFarewell.scrollFactor.set(1, 0.9);
					redScreenFarewell.visible = false;
					add(redScreenFarewell);

					trace("LOADED 'Lab Normal' STAGE.");	
				}
			case 'whitevoid':
				{
					defaultCamZoom = 0.75;
					curStage = 'whitevoid';

					var stagePosX = -700;
					var stagePosY = -520;
					
					whiteVoid = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/whitevoid', 'april-fools'));
					whiteVoid.setGraphicSize(Std.int(whiteVoid.width * 1.6));
					whiteVoid.updateHitbox();
					whiteVoid.antialiasing = true;
					whiteVoid.scrollFactor.set(1, 0.9);
					add(whiteVoid);	

					trace("LOADED 'White Void' STAGE.");		
				}
			case 'whitevoidevil':
				{
					defaultCamZoom = 0.75;
					curStage = 'whitevoidevil';

					var stagePosX = -700;
					var stagePosY = -520;
					
					whiteVoidEvil = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/whitevoidevil', 'april-fools'));
					whiteVoidEvil.setGraphicSize(Std.int(whiteVoidEvil.width * 1.6));
					whiteVoidEvil.updateHitbox();
					whiteVoidEvil.antialiasing = true;
					whiteVoidEvil.scrollFactor.set(1, 0.9);
					add(whiteVoidEvil);	

					trace("LOADED 'White Void EVIL' STAGE.");		
				}

			case 'winter':
			{
				defaultCamZoom = 0.75;
                curStage = 'winter';

				var stagePosX = -700;
				var stagePosY = -520;

				var bgBG:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/winter/poorlyDrawnIce', 'piggy'));
				bgBG.setGraphicSize(Std.int(bgBG.width * 1.6));
				bgBG.updateHitbox();
				bgBG.antialiasing = true;
				bgBG.scrollFactor.set(1, 0.9);
				add(bgBG);

				var floorOk:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/winter/floor', 'piggy'));
				floorOk.setGraphicSize(Std.int(floorOk.width * 1.6));
				floorOk.updateHitbox();
				floorOk.antialiasing = true;
				floorOk.scrollFactor.set(1, 0.9);
				add(floorOk);

				treeFG = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/winter/fgTrees', 'piggy'));
				treeFG.setGraphicSize(Std.int(treeFG.width * 1.6));
				treeFG.updateHitbox();
				treeFG.antialiasing = true;
				treeFG.scrollFactor.set(1, 0.9);

				snowOverlay = new FlxBackdrop(Paths.image('inGame/snowOverlay', 'piggy'));
				snowOverlay.alpha = 0.80;
				snowOverlay.velocity.set(450, 450);
				snowOverlay.cameras = [camHUD];				
				
				trace("LOADED 'Winter' STAGE.");	
			}

			case 'distraction':
			{
				defaultCamZoom = 0.75;
                curStage = 'distraction';

				var stagePosX = -700;
				var stagePosY = -520;

				distBG = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/distraction/distRefinery', 'piggy'));
				distBG.setGraphicSize(Std.int(distBG.width * 1.6));
				distBG.updateHitbox();
				distBG.antialiasing = true;
				distBG.scrollFactor.set(1, 0.9);
				add(distBG);

				distBGRed = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/distraction/distRefineryRed', 'piggy'));
				distBGRed.setGraphicSize(Std.int(distBGRed.width * 1.6));
				distBGRed.updateHitbox();
				distBGRed.antialiasing = true;
				distBGRed.visible = false;
				distBGRed.scrollFactor.set(1, 0.9);
				add(distBGRed);				
				
				trace("LOADED 'Distraction' STAGE.");	
			}
		}

		var gfVersion:String = 'nogf';

		switch (SONG.gfVersion)
		{
			default:
				gfVersion = 'nogf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'nogf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case 'rash':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'dessa':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 100;	
			case 'tigry':
				camPos.x += 400;
				camPos.y += 100;
				dad.x += 40;
				dad.y += 60;
			case 'raze':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
		    case 'alfis':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'willow':
				camPos.x += 400;
				camPos.y += 100;	
				dad.y += 60;
			case 'dakoda':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'archie':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'markus':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'spidella':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'delta':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'penny':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'zizzyholiday':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;		
			case 'willowstore':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;			
			case 'willowwhite':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'kolie':
				camPos.y -= 100;
			case 'tigrymad':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'felixdumb':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;	
			case 'frostiggy':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;
			case 'zuzy':
				camPos.x += 400;
				camPos.y += 100;
				dad.y += 60;									
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'alleys':
				boyfriend.y -= 160;
			case 'store':
				boyfriend.y -= 160;		
			case 'refinery':
				boyfriend.y -= 160;		
				dad.y += 90;
			case 'safeplace':
				boyfriend.y -= 270;	
			case 'sewers':
				boyfriend.y -= 160;			
			case 'factory':
				boyfriend.y -= 380;	
				boyfriend.x += 150;
				dad.y -= 300;
				dad.x -= 150;
			case 'port':
				boyfriend.y -= 160;
				boyfriend.x += 300;
				dad.x -= 300;
			case 'ship':
				boyfriend.y -= 280;	
				dad.y -= 210;	
			case 'docks':
				boyfriend.y -= 160;
			case 'temple':
				boyfriend.y -= 500;	
				dad.y -= 320;
			case 'camp':
				boyfriend.y -= 160;		
			case 'lab':
				dad.y -= 300;
				dad.x -= 300;
				boyfriend.y -= 100;	
				boyfriend.x += 350;	
			case 'cabin':
				boyfriend.y -= 160;	
				boyfriend.x += 420;		
				dad.x -= 70;		
			case 'oldlack':
				boyfriend.y -= 160;
			case 'factorynormal':
				dad.y -= 300;
				dad.x -= 300;
				boyfriend.y -= 100;	
				boyfriend.x += 350;	
			case 'labnormal':
				dad.y -= 370;
				dad.x += 70;
			case 'whitevoid':
				boyfriend.y -= 160;
				boyfriend.x += 270;
				// dad.y -= 50;
				dad.x -= 100;
			case 'whitevoidevil':
				boyfriend.y -= 160;
				boyfriend.x += 270;
				// dad.y -= 50;
				dad.x -= 100;
			case 'winter':
				boyfriend.y -= 160;
				boyfriend.x += 120;
				dad.x -= 100;
		}

		add(gf);

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

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		// fixed camera scrollin' in game yaayyyyyyy
		// kys kade, why did u made it get controlled by the fps :sob:, its so annoying
		FlxG.camera.follow(camFollow, LOCKON, 0.03);

		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			                             // you should :troll: -Alex
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
			case 'on-the-hunt': // chapter 1
			{
				healthBar.createFilledBar(0xFF808080, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'in-stock': // chapter 2
			{
				healthBar.createFilledBar(0xFF30D5C8, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'intruders': // chapter 3
			{
				healthBar.createFilledBar(0xFFFFA500, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'farewell': // chapter 3
			{
				healthBar.createFilledBar(0xFF710193, 0xFF710193);
				trace("GENERATED HEALTH BAR COLOURS.");
			}		
			case 'metal-escape': // chapter 4
			{
				healthBar.createFilledBar(0xFF964B00, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}		
			case 'underground': // chapter 5
			{
				healthBar.createFilledBar(0xFF006400, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'our-battle': // chapter 6
			{
				healthBar.createFilledBar(0xFF964B00, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'encounters' | 'change' | 'hide-and-seek': // chapter 6 + extra
			{
				healthBar.createFilledBar(0xFFCA1F7B, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}
			case 'deep-sea': // chapter 7
			{
				healthBar.createFilledBar(0xFF9B870C, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}		
			case 'all-aboard' | 'no-male-bitches' | 'friendzone' | 'extermination': // chapter 8 and also april fools lol
			{
				healthBar.createFilledBar(0xFFCC5500, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'teleport': // chapter 9
			{
				healthBar.createFilledBar(0xFF964B00, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'sneaky': // chapter 10
			{
				healthBar.createFilledBar(0xFF171716, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}
			case 'cold-blood': // chapter 11
			{
				healthBar.createFilledBar(0xFFE5E4DB, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}		
			case 'once-for-all': // winter holiday
			{
				healthBar.createFilledBar(0xFF964B00, 0xFFCA1F7B);
				trace("GENERATED HEALTH BAR COLOURS.");
			}
			case 'run-away': // chapter 12
			{
				healthBar.createFilledBar(0xFFB13B5B, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}	
			case 'promenade': // winter holiday
			{
				healthBar.createFilledBar(0xFFB80F0A, 0xFF0B6623);
				trace("GENERATED HEALTH BAR COLOURS.");
			}
			case 'frost-fate': // extra
			{
				var frostiggyHealth = FlxColor.CYAN;

				healthBar.createFilledBar(frostiggyHealth, 0xFF808080);
				trace("GENERATED HEALTH BAR COLOURS.");
			}
			default: // in case it doesn't find the song for some reason hjfhihixgfhd (to prevent crashes)
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
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + currentDifficulty + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
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
		add(scoreTxt);

		// new watermark texts retard!!!!!!!
		if (curSong.toLowerCase() == 'change')
			newWatermark = new FlxText(12, FlxG.height - 164, 0, "", 20);
		else
			newWatermark = new FlxText(12, FlxG.height - 144, 0, "", 20);

		newWatermark.setFormat("JackInput", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		newWatermark.scrollFactor.set();
		newWatermark.cameras = [camHUD];

		if (curSong.toLowerCase() == 'change')
		{
		    newWatermark.text = "FNF PIGGY BOOK 2 " + MainMenuState.fnfPiggyBook2Ver
		                    + "\nKade Engine " + MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nBullet Dodges: " + bulletDodges
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	
		}
		else
		{
		    newWatermark.text = "FNF PIGGY BOOK 2 " + MainMenuState.fnfPiggyBook2Ver
		                    + "\nKade Engine " + MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	
		}

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
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("JAi_____.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.x += 1000;
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		add(iconP1);

		if (curSong.toLowerCase() == 'once-for-all')
			iconP1.changeIcon('willow');

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		
		if (curSong.toLowerCase() == 'farewell')
			iconP2.visible = false;
		else
			iconP2.visible = true;

		add(iconP2);

		switch (curSong.toLowerCase())
        {
            case 'on-the-hunt':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[0], 'piggy'));
            case 'in-stock':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[1], 'piggy'));
            case 'encounters':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[2], 'piggy'));
            case 'intruders':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[3], 'piggy'));
            case 'farewell':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[4], 'piggy'));
            case 'metal-escape':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[5], 'piggy'));
            case 'underground':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[6], 'piggy'));
            case 'our-battle':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[7], 'piggy'));
            case 'change':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[8], 'piggy'));
            case 'deep-sea':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[9], 'piggy'));
            case 'all-aboard':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[10], 'piggy'));
            case 'teleport':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[11], 'piggy'));
            case 'sneaky':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[12], 'piggy'));
            case 'overseer':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[13], 'piggy'));
            case 'cold-blood':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[14], 'piggy'));
            case 'once-for-all':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[15], 'piggy'));
            case 'run-away':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[16], 'piggy'));
            case 'promenade':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[17], 'piggy'));
			case 'no-male-bitches':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[18], 'april-fools'));
            case 'friendzone':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[19], 'april-fools'));
			case 'extermination':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[20], 'april-fools'));
			case 'frost-fate':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[21], 'piggy'));
			case 'hide-and-seek':
                countdownBox = new FlxSprite().loadGraphic(Paths.image('countdown/box-' + songList[22], 'piggy'));
        }

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
			gf.dance();
			boyfriend.playAnim('idle');

			switch (swagCounter)
			{
				case 0:
					FlxG.camera.zoom = 1.5;
				case 1:
					FlxTween.tween(blackCountdown, {alpha: 0}, 1.5);
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
            case 'encounters':
                remove(gf);
                trace("JUST ALEX. (haha funni monika reference)"); // this trace

                add(dad);

                add(boyfriend); 
                add(coupleFG);

				dad.y -= 100;
				dad.x -= 150;
				boyfriend.x += 150;

			case 'farewell':
				remove(gf);
				remove(dad);
                trace("JUST ALEX. (haha funni monika reference)"); // is the

				add(boyfriend);

				boyfriend.scale.set(1.5, 1.5);
				boyfriend.x -= 400;
				boyfriend.y -= 300;

			case 'our-battle':
				remove(gf);
                trace("JUST ALEX. (haha funni monika reference)"); // most cringe

				add(dad);
				add(boyfriend);

				boyfriend.scale.set(2.3, 2.3);
				trace("big player.");

			case 'once-for-all':
				remove(gf);
				remove(boyfriend);
                trace("JUST ALEX. (haha funni monika reference)"); // thing i

				add(dad);
				dad.scale.set(0.8, 0.8);

            case 'run-away':
                remove(gf);
                trace("JUST ALEX. (haha funni monika reference)"); // have written

                add(dad);
                add(boyfriend);	 

                boyfriend.scale.set(2.3, 2.3);
                trace("big player.");

			case 'no-male-bitches' | 'friendzone' | 'extermination': // last year
				remove(gf);
				trace("YOU HAVE NO BITCHES, RETARD!!!");

				add(dad);
				add(boyfriend);

			case 'frost-fate':
                remove(gf);
                trace("JUST ALEX. (haha funni monika reference)");

                add(dad);
                add(boyfriend);	

				add(treeFG);  
				add(snowOverlay);

			case 'hide-and-seek':
                remove(gf);
                trace("JUST ALEX. (haha funni monika reference)");

                add(dad);
                remove(boyfriend);	

            default:
                remove(gf);
                trace("JUST ALEX. (haha funni monika reference)");

                add(dad);
                add(boyfriend);	        
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
		FlxTween.tween(countdownBox, {x: -600}, 1);

		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(countdownBox, {x: -1600}, 2);
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
			if (storyDifficulty != 1)
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), FlxG.save.data.instVol, false);
			else
				FlxG.sound.playMusic(Paths.instRematch(PlayState.SONG.song), FlxG.save.data.instVol, false);
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

		if (storyDifficulty != 1)
		{
			if (SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else
				vocals = new FlxSound();	
		}
		else
		{
			if (SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voicesRematch(PlayState.SONG.song));
			else
				vocals = new FlxSound();	
		}

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
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

		if (curSong.toLowerCase() == 'change')
		{
		    newWatermark.text = "FNF PIGGY BOOK 2 " + MainMenuState.fnfPiggyBook2Ver
		                    + "\nKade Engine " + MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nBullet Dodges: " + bulletDodges
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	
		}
		else
		{
		    newWatermark.text = "FNF PIGGY BOOK 2 " + MainMenuState.fnfPiggyBook2Ver
		                    + "\nKade Engine " + MainMenuState.kadeEngineVer
		                    + "\nScore: " + songScore
							+ "\nMisses: " + misses
							+ "\nAccuracy: " + HelperFunctions.truncateFloat(accuracy, 2) + "%"
		                    + "\n" + SONG.song + " " + songTimeLeft
							+ "\nDifficulty: " + currentDifficulty;	
		}

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

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
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

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (!FlxG.save.data.parallax)
			{
				if (camFollow.x != dadPos[0] && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(dadPos[0], dadPos[1]);
		
					if (PlayState.curSong.toLowerCase() == 'no-male-bitches' || PlayState.curSong.toLowerCase() == 'friendzone' || PlayState.curSong.toLowerCase() == 'extermination')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
				}
			
				if (camFollow.x != bfPos[0] && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(bfPos[0], bfPos[1]);
					
					if (PlayState.curSong.toLowerCase() == 'no-male-bitches' || PlayState.curSong.toLowerCase() == 'friendzone' || PlayState.curSong.toLowerCase() == 'extermination')
						tweenCamInPlayer();

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneTurn', []);
					#end
				}					
			}
			else
			{
				if (camFocus != 'dad' && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camMovement.cancel();
					camFocus = 'dad';

					if (PlayState.curSong.toLowerCase() == 'no-male-bitches' || PlayState.curSong.toLowerCase() == 'friendzone' || PlayState.curSong.toLowerCase() == 'extermination')
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					}

					camMovement = FlxTween.tween(camFollow, {x: dadPos[0], y: dadPos[1]}, camLerp, {ease: FlxEase.quintOut});
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerTwoTurn', []);
					#end
				}
			
				if (camFocus != 'bf' && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camMovement.cancel();
					camFocus = 'bf';

					if (PlayState.curSong.toLowerCase() == 'no-male-bitches' || PlayState.curSong.toLowerCase() == 'friendzone' || PlayState.curSong.toLowerCase() == 'extermination')
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
					case 'farewell':
						openSubState(new GameOverSubstate());
					case 'once-for-all':
						openSubState(new GameOverSubstate());
					case 'promenade':
						openSubState(new GameOverSubstate());
					default:
						openSubState(new GameOverSubstate());
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
						case 'farewell':
							openSubState(new GameOverSubstate());
						case 'once-for-all':
							openSubState(new GameOverSubstate());
						case 'promenade':
							openSubState(new GameOverSubstate());
						default:
							openSubState(new GameOverSubstate());
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
	
						if (daNote.curNoteType != 2)
						{
							switch (Math.abs(daNote.noteData))
							{
								case 2:
									dad.playAnim('singUP' + altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);							
							}	
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
									if (daNote.curNoteType != 2)
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

		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

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

					if (curSong.toLowerCase() == 'run-away')
					{
						if (FlxG.save.data.cutscenes)
							playMP4Video();
						else
							FlxG.switchState(new StoryMenuState());
					}
					else
					{
					    FlxG.switchState(new StoryMenuState());
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
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);					

					prevCamFollow = camFollow;
						
					if (curSong.toLowerCase() == 'sneaky')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		                blackShit.scrollFactor.set();
						add(blackShit);

						FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'));
					}

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (CachingSelectionState.noCache)
					{
						FlxG.switchState(new LoadingState(new PlayState(), false));
					}
					else
					{
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else if (isFreeplay)
			{
				trace('WENT BACK TO THE DEEPEST PART OF DEEZ NUTS???!!!??');
				FlxG.switchState(new FreeplayState());
			}
			else if (isFreeplayTwo)
			{
				trace('WENT BACK TO THE DEEPEST PART OF DEEZ NUTS???!!!??');
				FlxG.switchState(new FreeplayPageTwo());
			}
			else if (isFreeplay3)
			{
				FlxG.switchState(new DumbassFreeplay());
			}
			else if (isExtraFreeplay)
			{
				FlxG.switchState(new ExtraFreeplay());
			}
		}
	}

	function playMP4Video()
    {
		switch (curSong.toLowerCase())
		{
			case 'run-away':
				var video:MP4Handler = new MP4Handler();
		
				video.playMP4(Paths.video('FinaleCuts'));
				video.finishCallback = function()
				{
					FlxG.save.flush();
					FlxG.switchState(new MainMenuState());
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

						if (daNote.curNoteType == 2)
						{
							deathReason = 'insolenceNote';
							health -= 3;	
						}

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

						if (daNote.curNoteType == 2)
						{
							deathReason = 'insolenceNote';
							health -= 3;	
						}

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

						if (daNote.curNoteType == 2)
						{
							deathReason = 'insolenceNote';
							health -= 3;	
						}

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

						if (daNote.curNoteType == 2)
						{
							deathReason = 'insolenceNote';
							health -= 3;	
						}

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
				if (daNote.curNotetype != 2)
				{
					if (curSong.toLowerCase() == 'farewell')
						health -= 0.02;
					else
						health -= 0.04;	
	
					misses++;
	
					songScore -= 10;
	
					if (FlxG.save.data.accuracyMod == 1)
					totalNotesHit -= 1;
	
					FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
	
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

					if (daNote.curNoteType != 2)
					{
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

		if (curSong.toLowerCase() == 'on-the-hunt')
			{
				switch (curStep)
				{
					case 128 | 256 | 384 | 512 | 640 | 768:
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 832: // small, but new shit
						FlxG.camera.fade(FlxColor.WHITE, 2, false);
				}
			}

		if (curSong.toLowerCase() == 'in-stock' && FlxG.save.data.flashing)
			{
				switch (curStep)
				{
					case 256 | 384:
						camHUD.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong.toLowerCase() == 'intruders' && FlxG.save.data.flashing)
			{
				switch (curStep)
				{
					case 256 | 384 | 640 | 768 | 784 | 800 | 816 | 832 | 848 | 864 | 880 | 896:
						camHUD.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong.toLowerCase() == 'metal-escape' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 50 | 57 | 59 | 61 | 63 | 184 | 186 | 188 | 190 | 313 | 315 | 317 | 319:
						daStaticInsolence.visible = true;
					case 54 | 58 | 60 | 62 | 64 | 185 | 187 | 189 | 191 | 314 | 316 | 318 | 320:
						daStaticInsolence.visible = false;
					case 440 | 442 | 444 | 446 | 448 | 572 | 574:
						daStaticInsolence.visible = true;
					case 441 | 443 | 445 | 447 | 449 | 573 | 575:
						daStaticInsolence.visible = false;	
				}
			}	

		if (curSong.toLowerCase() == 'teleport' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 59 | 61 | 63:
						blackScreenAppear();
					case 60 | 62 | 64:
						blackScreenRemove();
					case 119:
						defaultCamZoom = 1;
						FlxTween.tween(vignette, {alpha: 1}, 0.1);
					case 128:
						defaultCamZoom = 0.70;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);	
					case 248:
						blackScreenAppear();
						defaultCamZoom = 1;
						FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);	
					case 256:
						blackScreenRemove();	
						camGame.shake(0.003, 7);
					case 320:		
						defaultCamZoom = 0.70;
						FlxTween.tween(vignetteRed, {alpha: 0}, 0.1);
					case 374:
						dad.visible = false;
						boyfriend.visible = false;
						camHUD.visible = false;
						redOverlay.visible = true;
					case 375:
						blackScreenAppear();
						redOverlay.visible = false;
					case 416 | 800:
						blackScreenRemove();
						redOverlay.visible = false;
						camHUD.flash(FlxColor.WHITE, 0.3);
					case 672 | 696 | 724 | 769 | 771 | 1185:
						blackScreenAppear();
					case 695 | 723 | 768 | 770 | 1184:
						blackScreenRemove();
						dad.visible = false;
						boyfriend.visible = false;
						camHUD.visible = false;
						redOverlay.visible = true;
					case 928:	
						camGame.shake(0.003, 7);
				}
			}	

		if (curSong.toLowerCase() == 'sneaky' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256:
						camHUD.flash(FlxColor.WHITE, 0.3);
					case 284:
						defaultCamZoom = 1;
						FlxTween.tween(vignette, {alpha: 1}, 0.1);
					case 512:
						defaultCamZoom = 0.75;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);
					case 768 | 800 | 832 | 864:
						defaultCamZoom = 1;
					case 784 | 816 | 848 | 880:
					    defaultCamZoom = 0.75;
					case 928:
						blackScreenAppear();
				}
			}

		if (curSong.toLowerCase() == 'cold-blood' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256 | 639:
						defaultCamZoom = 1;
					case 383:
						defaultCamZoom = 0.75;
					case 768:
						defaultCamZoom = 0.75;
						snowOverlay.visible = false;
						camHUD.visible = false;
						blackScreenAppear();					
				}
			}

		if (curSong.toLowerCase() == 'run-away' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256 | 960:	
						defaultCamZoom = 1.1;			
						FlxTween.tween(vignette, {alpha: 1}, 0.35);	
					case 319 | 1023:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.35);
					case 416 | 1120:
						defaultCamZoom = 0.86;
						FlxTween.tween(vignette, {alpha: 1}, 3);
					case 424 | 1128:
						defaultCamZoom = 0.96;
					case 432 | 1136:
						defaultCamZoom = 1.06;
					case 440 | 1144:
						defaultCamZoom = 1.16;
					case 444 | 1148:
						defaultCamZoom = 1.26;
					case 447 | 1151:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);
					case 576 | 1280:
						defaultCamZoom = 0.96;
						camHUD.flash(FlxColor.RED, 0.3);
						FlxTween.tween(vignetteRed, {alpha: 1}, 0.01);
						camGame.shake(0.003, 15);
					case 704:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignetteRed, {alpha: 0}, 1.7);
					case 1408:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.01);
						FlxTween.tween(vignetteRed, {alpha: 0}, 0.01);
						camHUD.flash(FlxColor.RED, 0.3);
					case 1423:
						FlxTween.tween(camHUD, {alpha: 0}, 0.01);
						FlxG.camera.fade(FlxColor.BLACK, 0.01, false);
				}
			}

		if (curSong.toLowerCase() == 'promenade' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 120 | 760:
						defaultCamZoom = 1;
					case 128:
						defaultCamZoom = 0.75;
					case 256 | 640 | 896:
					    FlxTween.tween(promenadeOverlay, {alpha: 0}, 2);
					case 320 | 512 | 960:
						FlxTween.tween(promenadeOverlay, {alpha: 0.25}, 0.1);
						camHUD.flash(FlxColor.WHITE, 0.35);
					case 384 | 1024:
					    FlxTween.tween(promenadeOverlay, {alpha: 0}, 1);
					case 768:
						FlxTween.tween(promenadeOverlay, {alpha: 0.25}, 0.1);
						camHUD.flash(FlxColor.WHITE, 0.35);
					case 1151:
						defaultCamZoom = 1;
					case 1216:
						defaultCamZoom = 0.75;
						camHUD.flash(FlxColor.WHITE, 0.35);
				}
			}

		if (curSong.toLowerCase() == 'encounters' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256 | 512:
						thatOnePartOnEncounters();
						camHUD.flash(FlxColor.BLACK, 0.5);	
						FlxTween.tween(boyfriend, {alpha: 0}, 1);
						FlxTween.tween(FlxG.camera, {zoom: 1}, 3, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 1;	
					case 320 | 576:
						FlxTween.tween(boyfriend, {alpha: 1}, 1);
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 7, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;	
					case 384 | 640:
						thatOnePartOnEncountersButInReverse();
						camHUD.flash(FlxColor.BLACK, 0.5);
					case 768:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 1, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
						FlxTween.tween(camHUD, {alpha: 0}, 2);
					case 832:
						FlxG.camera.fade(FlxColor.BLACK, 0.001, false);
				}
			}

		if (curSong.toLowerCase() == 'farewell' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 672 | 1056 | 1184:
						camHUD.flash(FlxColor.WHITE, 0.3);
					case 1312:
						camHUD.flash(FlxColor.RED, 0.3);
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 3, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;	
						FlxTween.tween(healthBarBG, {alpha: 0}, 0.001);
						FlxTween.tween(healthBar, {alpha: 0}, 0.001);
						FlxTween.tween(iconP1, {alpha: 0}, 0.001);
						FlxTween.tween(iconP2, {alpha: 0}, 0.001);
						FlxTween.tween(judgementCounter, {alpha: 0}, 0.001);
						FlxTween.tween(scoreTxt, {alpha: 0}, 0.001);

					case 1328 | 1344 | 1360 | 1376 | 1392 | 1408 | 1424:
						camHUD.flash(FlxColor.RED, 0.3);
					case 1440 | 1456 | 1472 | 1488 | 1504 | 1520 | 1536 | 1552 | 1568:
						camHUD.flash(FlxColor.RED, 0.3);
					case 1693:
						boyfriend.playAnim('ending', true);
					case 1696:
						FlxG.camera.fade(FlxColor.BLACK, 0.001, false);
					    FlxTween.tween(camHUD, {alpha: 0}, 0.001);
				}
			}
			
		if (curSong.toLowerCase() == 'our-battle' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 120:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;	
					case 128:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;	
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 256:
						goWillow();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 384:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 3, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 412:
						FlxTween.tween(FlxG.camera, {zoom: 0.73}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.73;
					case 416:
						goKolie();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 512:
						goWillow();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 640:
						goKolie();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 760:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;	
					case 768:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;	
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 896:
						goWillow();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1024:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 3, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 1052:
						FlxTween.tween(FlxG.camera, {zoom: 0.73}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.73;
					case 1056:
						goKolie();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1152:
						goWillow();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1280:
						FlxTween.tween(FlxG.camera, {zoom: 0.78}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.78;
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1312:
					    FlxTween.tween(camHUD, {alpha: 0}, 5);
					case 1408:
						FlxG.camera.fade(FlxColor.BLACK, 0.001, false);
				}
			}

		if (curSong.toLowerCase() == 'once-for-all' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 96:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 2, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 128:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 224:
						FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.8;
					case 232:
						FlxTween.tween(FlxG.camera, {zoom: 0.85}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.85;
					case 240:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 248:
						FlxTween.tween(FlxG.camera, {zoom: 0.95}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.95;
					case 256:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					case 264:
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 576:
						FlxTween.tween(FlxG.camera, {zoom: 0.95}, 4, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.95;
					case 640:
						goRed();
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						camGame.shake(0.004, 16);
					case 648:
						camHUD.flash(FlxColor.RED, 0.5);
					case 776:
						camHUD.flash(FlxColor.RED, 0.5);
					case 896:
						goNormal();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1024:
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1248:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 2, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 1280:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1376:
						FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.8;
					case 1384:
						FlxTween.tween(FlxG.camera, {zoom: 0.85}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.85;
					case 1392:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.9;
					case 1400:
						FlxTween.tween(FlxG.camera, {zoom: 0.95}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.95;
					case 1408:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
					case 1416:
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 1728:
						FlxTween.tween(FlxG.camera, {zoom: 0.95}, 4, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.95;
					case 1792:
						goRed();
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.5, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						camGame.shake(0.004, 16);
					case 1800:
						camHUD.flash(FlxColor.RED, 0.5);
					case 1928:
						camHUD.flash(FlxColor.RED, 0.5);
					case 2048:
						goNormal();
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 2176:
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 2304:
						FlxTween.tween(FlxG.camera, {zoom: 0.95}, 4, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.95;
						camHUD.flash(FlxColor.WHITE, 0.5);
					case 2368:
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 4, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						FlxTween.tween(camHUD, {alpha: 0}, 4);
					case 2560:
						FlxG.camera.fade(FlxColor.BLACK, 0.001, false);
				}
			}
		
		if (curSong.toLowerCase() == 'frost-fate')
		{
			switch (curStep)
			{
				case 120:
					FlxTween.tween(FlxG.camera, {zoom: 0.95}, 0.75, {ease: FlxEase.cubeOut});
		            defaultCamZoom = 0.95;
				case 128 | 448:
					FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.6, {ease: FlxEase.cubeOut});
		            defaultCamZoom = 0.75;
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 256 | 576 | 720 | 848:
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 384 | 976:
					FlxTween.tween(FlxG.camera, {zoom: 0.95}, 1.5, {ease: FlxEase.cubeOut});
		            defaultCamZoom = 0.95;
					camHUD.flash(FlxColor.WHITE, 0.5);
				case 704:
					FlxTween.tween(FlxG.camera, {zoom: 0.95}, 1.5, {ease: FlxEase.cubeOut});
		            defaultCamZoom = 0.95;
				case 1104:
					FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.7, {ease: FlxEase.cubeOut});
		            defaultCamZoom = 0.75;
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

		if (curSong == 'Tutorial' && dad.curCharacter == 'nogf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'nogf')
			{
				dad.dance();				
			}			
		}

		// imagine stealing MILF's zooms code, couldn't be you, AlexShadow.
		// also yeah, this controls mid-song zooms, like in MILF
		if (curSong.toLowerCase() == 'on-the-hunt' && curBeat >= 64 && curBeat < 96 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'on-the-hunt' && curBeat >= 160 && curBeat < 192 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}		

		if (curSong.toLowerCase() == 'intruders' && curBeat >= 192 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'metal-escape' && curBeat >= 48 && curBeat < 80 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}		

		if (curSong.toLowerCase() == 'metal-escape' && curBeat >= 115 && curBeat < 144 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 31 && curBeat < 127 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 159 && curBeat < 191 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 223 && curBeat < 271 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'sneaky' && curBeat >= 32 && curBeat < 94 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'sneaky' && curBeat >= 128 && curBeat < 190 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 72 && curBeat < 112 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 144 && curBeat < 176 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 248 && curBeat < 288 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 320 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 32 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 80 && curBeat < 96 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 128 && curBeat < 160 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 192 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 240 && curBeat < 256 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'encounters' && curBeat >= 32 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'encounters' && curBeat >= 96 && curBeat < 192 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'farewell' && curBeat >= 104 && curBeat < 168 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'farewell' && curBeat >= 196 && curBeat < 264 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'farewell' && curBeat >= 296 && curBeat < 392 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'our-battle' && curBeat >= 32 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'our-battle' && curBeat >= 104 && curBeat < 160 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'our-battle' && curBeat >= 192 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'our-battle' && curBeat >= 264 && curBeat < 320 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'once-for-all' && curBeat >= 64 && curBeat < 128 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'once-for-all' && curBeat >= 160 && curBeat < 288 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'once-for-all' && curBeat >= 352 && curBeat < 416 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'once-for-all' && curBeat >= 448 && curBeat < 576 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curStage.startsWith('alleys') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			doggyOfficer.animation.play('idle'); // doggy is so hot in his officer outfi- i mean, y-you.. saw nothing
		}	

		if (curStage.startsWith('store') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			ponyStore.animation.play('idle'); // couple shit (this is gonna be so sad in refinery omg)
			zizzyStore.animation.play('idle'); // couple shit (this is gonna be so sad in refinery omg)
		}				

		if (curStage == 'refinery' && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			ponyRefinery.animation.play('idle'); // he do be saving his gf /j
		}

		if (curStage.startsWith('sewers') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			zeeSewers.animation.play('idle'); // they have no sister now
			zuzySewers.animation.play('idle'); // :(
		}

		if (curStage.startsWith('ship') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			willowBg.animation.play('idle'); // the lesbian bitch
		}

		if (curStage.startsWith('docks') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			ponyDocks.animation.play('idle');
		}

		if (curStage.startsWith('temple') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			robbyTemple.animation.play('idle');
		}

		if (curStage.startsWith('camp') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			ponyCamp.animation.play('idle');
			willowCamp.animation.play('idle');
		}

		if (curStage.startsWith('cabin') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			zeeHoliday.animation.play('idle');
			mimiHoliday.animation.play('idle');
			giraffyHoliday.animation.play('idle');
			ponyHoliday.animation.play('idle');

			christmasTree.animation.play('idle');
		}

	/*
		// idk, i dont wanna use the same code for the christmas tree cuz uhh, like i said.. idk.
		if (SONG.song.toLowerCase() == 'promenade' && curBeat % 1 == 0)
		{
			christmasTree.animation.play('idle');
		}
	*/

	    if (curStage.startsWith('oldlack') && curBeat % 1 == 0 && FlxG.save.data.distractions)
		{
			tigryOL.animation.play('idle');
			filipOL.animation.play('idle');
			coupleFG.animation.play('idle');
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		// mid-song event my beloved
		if (curSong.toLowerCase() == 'on-the-hunt' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64 | 160:
						defaultCamZoom = 0.90;
					case 96 | 192:
						defaultCamZoom = 0.75;
				}
			}

		if (curSong.toLowerCase() == 'in-stock' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 0:
						camHUD.visible = false;
					case 28:
						defaultCamZoom = 0.95;							
					case 32:
						camHUD.visible = true;
						defaultCamZoom = 0.75;
					case 64 | 160:
						defaultCamZoom = 0.9;
					case 96 | 192:
						defaultCamZoom = 0.75;
					case 248:
						blackScreenAppear();
						camHUD.visible = false;
						camZooming = false;
				}
			}

		// i like the events i made for this one
		if (curSong.toLowerCase() == 'intruders' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 0:
						camHUD.visible = false;
					case 28:
						defaultCamZoom = 0.95;
					case 32:
						camHUD.visible = true;
						defaultCamZoom = 0.75;
					case 256:
						defaultCamZoom = 0.95;
					case 264:
						FlxTween.tween(camHUD, {alpha: 0}, 1.3);
					case 268:
						FlxG.camera.fade(FlxColor.BLACK, 1, false);
					case 272:
						camZooming = false; 
				}
			}	

		if (curSong.toLowerCase() == 'metal-escape' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 176:
						FlxG.camera.fade(FlxColor.BLACK, .3, false);
						camHUD.visible = false;
						camZooming = false;
				}
			}		

		if (curSong.toLowerCase() == 'underground' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64 | 176:
						defaultCamZoom = 1.05;
						FlxTween.tween(vignette, {alpha: 0.9}, 0.4);
					case 80 | 192:
						defaultCamZoom = 0.75;
						FlxTween.tween(vignette, {alpha: 0}, 0.4);
					case 256:
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
						FlxTween.tween(camHUD, {alpha: 0}, 0.1);
						camZooming = false;
				}
			}				

		if (curSong.toLowerCase() == 'change' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64:
						defaultCamZoom = 0.95;
					case 95:
					    defaultCamZoom = 0.75;
					case 158:
						addBulletPopup();
					case 159:
						defaultCamZoom = 0.95;
					case 160:
						checkIfPressed();
					case 191:
						defaultCamZoom = 1.05;
					case 222:
						addBulletPopup();
					case 223:
						defaultCamZoom = 0.75;
					case 224:
						checkIfPressed();
					case 271:
						FlxTween.tween(camHUD, {alpha: 0}, 2.2);
					case 286:
						addBulletPopup();
					case 288:
						checkIfPressed();
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
				}
			}	

			if (curSong.toLowerCase() == 'deep-sea' && FlxG.save.data.distractions)
				{
					switch (curBeat)
					{
						case 63:
							defaultCamZoom = 1.10;
							FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);
							camGame.shake(0.004, 14);
						case 96:
							defaultCamZoom = 0.75;
							FlxTween.tween(vignetteRed, {alpha: 0}, 0.1);
						case 126:
							defaultCamZoom = 1.10;
							blackScreenAppear();
						case 128:
							blackScreenRemove();
							FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);
							camGame.shake(0.004, 14);
						case 184:
							FlxTween.tween(vignetteRed, {alpha: 0}, 2);
						case 192:
							FlxG.camera.fade(FlxColor.BLACK, .1, false);
					}			
				}

			if (curSong.toLowerCase() == 'all-aboard' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 16 | 96:
						defaultCamZoom = 1.05;
					case 32 | 112:
						defaultCamZoom = 0.9;
					case 40 | 120:
						defaultCamZoom = 1.10;
					case 47 | 128:
						defaultCamZoom = 0.75;
					case 176:
						FlxTween.tween(camHUD, {alpha: 0}, 2);
						camZooming = false;
					case 192:
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
				}		
			}

		    if (curSong.toLowerCase() == 'promenade' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 32:
						promenadeOverlay.visible = true;
						camHUD.flash(FlxColor.WHITE, 0.35);
				}		
			}

			if (curSong.toLowerCase() == 'farewell' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 328 | 330 | 332 | 334 | 336 | 338 | 340 | 342 | 344 | 346 | 348 | 350 | 352 | 354 | 356 | 358:
						refineryRoomBg.visible = false;
						redScreenFarewell.visible = true;
						blackScreenFarewell.visible = false;

					case 360 | 362 | 364 | 366 | 368 | 370 | 372 | 374 | 376 | 378 | 380 | 382 | 384 | 386 | 388 | 390:
						refineryRoomBg.visible = false;
						redScreenFarewell.visible = true;
						blackScreenFarewell.visible = false;

					case 329 | 331 | 333 | 335 | 337 | 339 | 341 | 343 | 345 | 347 | 349 | 351 | 353 | 355 | 357 | 359:
						refineryRoomBg.visible = false;
						redScreenFarewell.visible = false;
						blackScreenFarewell.visible = true;

					case 361 | 363 | 365 | 367 | 369 | 371 | 373 | 375 | 377 | 379 | 381 | 383 | 385 | 387 | 389 | 391:
						refineryRoomBg.visible = false;
						redScreenFarewell.visible = false;
						blackScreenFarewell.visible = true;

					case 392:
						FlxTween.tween(healthBarBG, {alpha: 1}, 0.001);
						FlxTween.tween(healthBar, {alpha: 1}, 0.001);
						FlxTween.tween(iconP1, {alpha: 1}, 0.001);
						FlxTween.tween(iconP2, {alpha: 1}, 0.001);
						FlxTween.tween(judgementCounter, {alpha: 1}, 0.001);
						FlxTween.tween(scoreTxt, {alpha: 1}, 0.001);
						FlxTween.tween(FlxG.camera, {zoom: 0.75}, 7, {ease: FlxEase.cubeOut});
		                defaultCamZoom = 0.75;
						refineryRoomBg.visible = true;
						redScreenFarewell.visible = false;
						blackScreenFarewell.visible = false;
				}		
			}	

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

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
	function blackScreenAppear() // im scared of the darkness :(
	{		
		dad.visible = false;
		boyfriend.visible = false;

		camHUD.visible = false;

		blackScreen2.visible = true;
	}

	function blackScreenRemove() // oh, everything's back nvm lmfaoo
	{			
		dad.visible = true;
		boyfriend.visible = true;

		camHUD.visible = true;

		blackScreen2.visible = false;
	}

	function thatOnePartOnEncounters()
	{
		remove(dad);
		remove(boyfriend);

		tigryOL.visible = false;
		filipOL.visible = false;
		coupleFG.visible = false;

		oldLackBg.visible = false;
		blackbg.visible = true;

		dad = new Character(100, 160, 'willowwhite');
		boyfriend = new Boyfriend(770, 290, 'bfwhite');

		add(dad);
		add(boyfriend);

		dad.y -= 100;
		dad.x -= 150;
		boyfriend.x += 150;

		FlxTween.tween(healthBarBG, {alpha: 0}, 0.5);
		FlxTween.tween(healthBar, {alpha: 0}, 0.5);
		FlxTween.tween(iconP1, {alpha: 0}, 0.5);
		FlxTween.tween(iconP2, {alpha: 0}, 0.5);
		FlxTween.tween(judgementCounter, {alpha: 0}, 0.5);
		FlxTween.tween(scoreTxt, {alpha: 0}, 0.5);
	}

	function thatOnePartOnEncountersButInReverse()
	{
		remove(dad);
		remove(boyfriend);

		tigryOL.visible = true;
		filipOL.visible = true;
		coupleFG.visible = true;

		oldLackBg.visible = true;
		blackbg.visible = false;

		dad = new Character(100, 160, 'willowstore');
		boyfriend = new Boyfriend(770, 290, 'bf');

		add(dad);
		add(boyfriend);

		dad.y -= 100;
		dad.x -= 150;
		boyfriend.x += 150;

		FlxTween.tween(healthBarBG, {alpha: 1}, 0.5);
		FlxTween.tween(healthBar, {alpha: 1}, 0.5);
		FlxTween.tween(iconP1, {alpha: 1}, 0.5);
		FlxTween.tween(iconP2, {alpha: 1}, 0.5);
		FlxTween.tween(judgementCounter, {alpha: 1}, 0.5);
		FlxTween.tween(scoreTxt, {alpha: 1}, 0.5);
	}

	function goWillow()
	{
		remove(dad);
		remove(boyfriend);

		factoryStairsBg.visible = true;
		factoryHallwayBg.visible = false;

		dad = new Character(100, 160, 'willow');
		boyfriend = new Boyfriend(770, 290, 'bf');

		add(dad);
		add(boyfriend);

		boyfriend.scale.set(1.3, 1.3);
		dad.scale.set(1.3, 1.3);

		// im starting to doubt if this works or no
//		dadPos[0] = dad.getMidpoint().x + 150 + 200 + dad.camOffset[0];
//		dadPos[1] = dad.getMidpoint().y - 100 + dad.camOffset[1];

		// im starting to doubt if this works or no
//		bfPos[0] = boyfriend.getMidpoint().x - 100 + boyfriend.camOffset[0];
//		bfPos[1] = boyfriend.getMidpoint().y - 100 + boyfriend.camOffset[1];

		getCamOffsets();

		iconP2.changeIcon('willow');

		boyfriend.x += 300;

		healthBar.createFilledBar(0xFFCA1F7B, 0xFF808080);
		trace("GENERATED HEALTH BAR COLOURS.");

		defaultCamZoom = 0.73;
	}

	function goKolie()
	{
		remove(dad);
		remove(boyfriend);

		factoryStairsBg.visible = false;
		factoryHallwayBg.visible = true;

		dad = new Character(100, 160, 'kolie');
		boyfriend = new Boyfriend(770, 290, 'bfperspective');

		add(dad);
		add(boyfriend);
		
		boyfriend.scale.set(2.3, 2.3);
		dad.scale.set(1, 1);

		// im starting to doubt if this works or no
//		dadPos[0] = dad.getMidpoint().x + 165 + dad.camOffset[0];
//		dadPos[1] = dad.getMidpoint().y + 20 + dad.camOffset[1];

		// im starting to doubt if this works or no
//		bfPos[0] = boyfriend.getMidpoint().x - 420 + boyfriend.camOffset[0];
//		bfPos[1] = boyfriend.getMidpoint().y - 460 + boyfriend.camOffset[1];

        getCamOffsets();

		iconP2.changeIcon('kolie');

		healthBar.createFilledBar(0xFFFFA500, 0xFF808080);
		trace("GENERATED HEALTH BAR COLOURS.");

		dad.y -= 370;
		dad.x -= 370;
		boyfriend.y -= 100;	
		boyfriend.x += 350;	

		defaultCamZoom = 0.75;
	}

	function goRed()
	{
		remove(dad);

		labHallwayBg.visible = false;
		redScreenFarewell.visible = true;

		dad = new Character(100, 160, 'tigrydark');
		add(dad);

		dad.y -= 370;
		dad.x += 70;

		getCamOffsets();

		FlxTween.tween(healthBarBG, {alpha: 0}, 0.5);
		FlxTween.tween(healthBar, {alpha: 0}, 0.5);
		FlxTween.tween(iconP1, {alpha: 0}, 0.5);
		FlxTween.tween(iconP2, {alpha: 0}, 0.5);
		FlxTween.tween(judgementCounter, {alpha: 0}, 0.5); 
		FlxTween.tween(scoreTxt, {alpha: 0}, 0.5);
	}

	function goNormal()
	{
		remove(dad);

		labHallwayBg.visible = true;
		redScreenFarewell.visible = false;

		dad = new Character(100, 160, 'tigrymad');
		add(dad);

		dad.y -= 370;
		dad.x += 70;

		getCamOffsets();

		FlxTween.tween(healthBarBG, {alpha: 1}, 0.5);
		FlxTween.tween(healthBar, {alpha: 1}, 0.5);
		FlxTween.tween(iconP1, {alpha: 1}, 0.5);
		FlxTween.tween(iconP2, {alpha: 1}, 0.5);
		FlxTween.tween(judgementCounter, {alpha: 1}, 0.5);
		FlxTween.tween(scoreTxt, {alpha: 1}, 0.5);
	}

	function addBulletPopup()
	{
		if (FlxG.save.data.mechanics)
		{
			bulletPopup = new BulletPopup(0, 0, 0, 0, true, true, 0);
			add(bulletPopup);
	
			// bulletPopup.scale.set(0.3, 0.3);
	
			FlxTween.tween(bulletPopup, {alpha: 1}, 0.2);	
		}
	}

	function checkIfPressed()
	{
		if (FlxG.save.data.mechanics)
		{
			new FlxTimer().start(0.001, function(tmr:FlxTimer)
			{
				if (FlxG.keys.pressed.SPACE)
				{
					remove(bulletPopup);
				
					dad.playAnim('singLEFT');
					boyfriend.playAnim('singDOWN');
				
					FlxG.sound.play(Paths.sound('shot', 'piggy'));
				
					bulletDodges += 1;
				}
				else if (!FlxG.keys.pressed.SPACE)
				{
					remove(bulletPopup);
				
					dad.playAnim('singLEFT');
				
					FlxG.sound.play(Paths.sound('shot', 'piggy'));
				
					health = 0;
				}			
			});			
		}
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

	var curLight:Int = 0;
}
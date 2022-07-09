package;

import flash.text.TextField;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayAlmost extends MusicBeatState
{
	var songs:Array<SongMetadata6> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 0;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var freeplayIcon:FlxSprite;
	var freeplayComposer:FlxSprite;
	var bookBG:FlxSprite;

	// just for when i add covers lol
	var freeplayComposers:Array<String> = [
		'alexshadow'
	];

	// funni bgs
	var bookBGS:Array<String> = [
		'almost'
	];		

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist4'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata6(data[0], Std.parseInt(data[2]), data[1]));
		}

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu (Almost Page)", null);
		#end

		PlayState.practiceMode = false;
		PlayState.cantDie = false;

		PlayState.isFreeplay = false;
		
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		bookBG = new FlxSprite();
		bookBG.antialiasing = true;
		add(bookBG);

		var composersbg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplayComposers/BG', 'piggy'));
		composersbg.antialiasing = true;

		freeplayComposer = new FlxSprite();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.offset.x -= 50;
			songText.visible = false;
			songText.alpha = 0;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			icon.visible = false;
			icon.alpha = 0;
			add(icon);
		}

		// icon offset here cuz haxe doesn't let me put it on the code more below (fuck u haxe)
		freeplayIcon = new FlxSprite(230, -215);
		add(freeplayIcon);
		
		add(composersbg);
		add(freeplayComposer);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Press A or D to Switch Pages", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var vignette:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
		vignette.antialiasing = true;
		vignette.alpha = 0.87;
		vignette.scale.set(1.05, 1.05);
		
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("JAi_____.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		add(vignette);

		changeSelection();
		changeDiff();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata6(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		
		if (FlxG.keys.justPressed.A)
		{
			PlayState.isFreeplayTwo = false;

			FlxG.sound.music.stop();
			FlxG.switchState(new FreeplayPageTwo());
		}

		if (FlxG.keys.justPressed.D)
		{
			PlayState.isFreeplayTwo = false;

			FlxG.sound.music.stop();
			FlxG.switchState(new DumbassFreeplay());
		}

		#if debug
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
		#end

		if (upP)
		{
			changeSelection(-1);
		}

		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		
			trace(poop);
			
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());

			PlayState.isStoryMode = false;
			PlayState.isFreeplay = false;
			PlayState.isFreeplayTwo = false;
			PlayState.isFreeplay3 = false;
			PlayState.isExtraFreeplay = false;
			PlayState.isAlmost = true;

			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
			{
				if (CachingSelectionState.noCache)
				{
					FlxG.switchState(new LoadingState(new PlayState(), false));
				}
				else
				{
					LoadingState.loadAndSwitchState(new PlayState());
				}
			});	
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = 0;

		if (curDifficulty < 0)
			curDifficulty = 0;
		if (curDifficulty > 0)
			curDifficulty = 0;

        #if PRELOAD_ALL
		FlxG.sound.music.stop();

		if (curDifficulty != 1)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1);
		else
			FlxG.sound.playMusic(Paths.instRematch(songs[curSelected].songName), 1);
		#end

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "HARD";
			case 1:
				diffText.text = "REMATCH";
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.music.stop();
		
		if (curDifficulty != 1)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1);
		else
			FlxG.sound.playMusic(Paths.instRematch(songs[curSelected].songName), 1);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}

		var assetName2:String = freeplayComposers[0];
		if(curSelected < freeplayComposers.length) assetName2 = freeplayComposers[curSelected];

		freeplayComposer.loadGraphic(Paths.image('freeplayComposers/composer-' + assetName2, 'piggy'));
		freeplayComposer.antialiasing = true;

		var assetName3:String = bookBGS[0];
		if(curSelected < bookBGS.length) assetName3 = bookBGS[curSelected];

		bookBG.loadGraphic(Paths.image('bookBG/bg-' + assetName3, 'piggy'));
		bookBG.antialiasing = true;
	}
}

class SongMetadata6
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

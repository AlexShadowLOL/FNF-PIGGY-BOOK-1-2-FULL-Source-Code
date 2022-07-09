package book1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var rematchPopup:FlxSprite;
	var scoreText:FlxText;

	// cutscene shit
	var isCutscene:Bool = false;
	var video:MP4Handler = new MP4Handler();

	var weekData:Array<Dynamic> = [
		['Locked-In']                    // chapter 1
	];

	var curDifficulty:Int = 0;

	public static var weekUnlocked:Array<Bool> = [
		true
	];

	var weekCharacters:Array<Dynamic> = [
		['', '', '']
	];

	var weekNames:Array<String> = [
		""
	];

	// stolen from psych cuz it looks cooler :troll:
	var weekBackground:Array<String> = [
		'house'
	];

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;
	
	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		// FlxG.sound.playMusic(Paths.music('storyMenuTrack', 'piggy'), 0.85);

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu (Book 1)", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		book1.PlayStateB1.practiceMode = false;
		book1.PlayStateB1.cantDie = false;

		// unused shit
		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("JackInput", 32);
		scoreText.color = 0xFF000000;
		scoreText.offset.x -= 450;

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("JackInput", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.visible = false;

		var rankText:FlxText = new FlxText();
		rankText.setFormat(Paths.font("JAi_____.ttf"), 32);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		var storyBG:FlxSprite = new FlxSprite(0, 56).loadGraphic(Paths.image('storymode/storyMenuBG', 'piggy'));
		storyBG.visible = false; // only re adding this and making it not visible cuz tracks offsets, new storymenu BG and shit
		storyBG.antialiasing = true;
        storyBG.updateHitbox();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/storyMenuBG', 'piggy'));
		bg.antialiasing = true;
		bg.updateHitbox();

        var storyBook:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/storyBook', 'piggy'));
		storyBook.antialiasing = true;
		storyBook.updateHitbox();

		// bg sprite offset here cuz haxe doesn't let me put it on the code more below (fuck u haxe)
		bgSprite = new FlxSprite(230, -215);

		var staticAnim:FlxSprite = new FlxSprite(-1350, -70);
		staticAnim.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
		staticAnim.animation.addByPrefix('idle', "screenSTATIC", 24);
		staticAnim.animation.play('idle', true);
		staticAnim.scale.set(3, 3);
		staticAnim.alpha = 0.25;
		staticAnim.antialiasing = true;
		staticAnim.updateHitbox();	

		grpWeekText = new FlxTypedGroup<MenuItem>();
		grpLocks = new FlxTypedGroup<FlxSprite>();

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, storyBG.y + storyBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			weekThing.offset.x += 250;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.offset.x += 250;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		difficultySelectors = new FlxGroup();

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.visible = false;
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x -= 500;
		sprDifficulty.offset.y += 80;
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.visible = false;
		difficultySelectors.add(rightArrow);

		add(storyBG); // only adding this but making it not visible on the code cuz of storymenu track, etc offsets attached to it and i dont want to remove them /e cry

		txtTracklist = new FlxText(FlxG.width * 0.05, storyBG.x + storyBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFF000000;
		txtTracklist.offset.x -= 900;

        // shitty bgs layering
		add(bg);
		add(bgSprite);
		add(storyBook);

		add(txtTracklist);
		add(difficultySelectors);
		add(grpWeekText);
		add(grpLocks);
		add(txtWeekTitle);
		add(staticAnim);

		updateText();

		super.create();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			movedBack = true;
			FlxG.switchState(new book1.MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			book1.PlayStateB1.storyPlaylist = weekData[curWeek];
			book1.PlayStateB1.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-hard';
				case 1:
					diffic = '-rematch';
			}

			book1.PlayStateB1.storyDifficulty = 0;

			book1.PlayStateB1.SONG = Song.loadFromJson(StringTools.replace(book1.PlayStateB1.storyPlaylist[0]," ", "-").toLowerCase() + '-hard', StringTools.replace(book1.PlayStateB1.storyPlaylist[0]," ", "-").toLowerCase());
			book1.PlayStateB1.storyWeek = curWeek;
			// PlayState.campaignScore = 0;

			FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
			{
				if (book1.CachingSelectionState.noCache)
				{
					FlxG.switchState(new book1.LoadingState(new book1.PlayStateB1(), true));
				}
				else
				{
					book1.LoadingState.loadAndSwitchState(new book1.PlayStateB1(), true);
				}
			});						
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 0;
		if (curDifficulty > 0)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		var assetName:String = weekBackground[0];
		if(curWeek < weekBackground.length) assetName = weekBackground[curWeek];

		bgSprite.loadGraphic(Paths.image('storybgs/menu_' + assetName, 'book1'));
		bgSprite.antialiasing = true;
		bgSprite.scale.set(0.22, 0.22);
		updateText();
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}

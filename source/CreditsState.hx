package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

#if windows
import Discord.DiscordClient;
#end

class CreditsState extends MusicBeatState
{
	var backdrop:FlxBackdrop;
	var square:FlxSprite;
	var iconGrid:FlxSprite;
	var creditTxt:FlxText;

	var curSelected:Int = 0;

	var userList:Array<String> = [
		'alex',
		'zhugo83',
		'neen',
		'kawfu',
		'darkmoon',
		'minitoon',
		'none', // leftijiro
		'none', // darcy
		'none' // saster
	];

	var userDesc:Array<String> = [
		'AlexShadow: Creator, Musician, Main Spriter, Artist & Voice of Player',
		'Zhugo83: Additional Charting Help',
		'TakoNeen: Willow Voice & VA',
		'Kawfu: Pony Voice & Atrocity Tigry VA',
		'DarkMoonPlayz1: Voice of Tigry',
		'MiniToon: Piggy Creator',
		'Leftijiro: Winter Holiday Sprites', // leftijiro
		'Darcy: Voice of Dessa, Penny & Zizzy', // darcy
		'Saster: Atrocity Original Composer' // saster
	];

	override function create()
	{	
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menu", null);
		#end

		backdrop = new FlxBackdrop(Paths.image('credits/bgOverlay', 'piggy'));
		backdrop.velocity.set(-40, -40);
		add(backdrop);

		square = new FlxSprite().loadGraphic(Paths.image('credits/downSquareShit', 'piggy'));
		square.antialiasing = true;
		square.setGraphicSize(FlxG.width, FlxG.height);
		square.updateHitbox();
		add(square);

		creditTxt = new FlxText(0, FlxG.height - 65, FlxG.width, "", 36);
		creditTxt.setFormat(Paths.font("JAi_____.ttf"), 36, FlxColor.WHITE, CENTER);
		creditTxt.screenCenter(X);
		creditTxt.y -= 15;
		add(creditTxt);

		iconGrid = new FlxSprite();
		iconGrid.frames = Paths.getSparrowAtlas('credits/iconGrid', 'piggy');

		iconGrid.animation.addByPrefix('alex', 'alex', 24);
		iconGrid.animation.addByPrefix('zhugo83', 'zhugo', 24);

		iconGrid.animation.addByPrefix('neen', 'neen', 24);
		iconGrid.animation.addByPrefix('kawfu', 'toby', 24);

		iconGrid.animation.addByPrefix('darkmoon', 'darkmoon', 24);
		iconGrid.animation.addByPrefix('minitoon', 'minitoon', 24);

		iconGrid.animation.addByPrefix('none', 'none', 24);

		iconGrid.antialiasing = true;
		iconGrid.scale.set(1.3, 1.3);
		iconGrid.y -= 100;
		iconGrid.screenCenter(X);
		iconGrid.updateHitbox();
		add(iconGrid);

		firstBoot();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.RIGHT)
			nextUser();

		if (FlxG.keys.justPressed.LEFT)
			prevUser();
		
		if (FlxG.keys.justPressed.ENTER)
			openSocialMedia();

		super.update(elapsed);
	}

	function nextUser()
    {
        FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

        curSelected += 1;

        if (curSelected > 8)
            curSelected = 0;

		iconGrid.animation.play(userList[curSelected]);

		creditTxt.text = userDesc[curSelected];
    }

	function prevUser()
    {
        FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

        curSelected += -1;

        if (curSelected < 0)
            curSelected = 8;

		iconGrid.animation.play(userList[curSelected]);

		creditTxt.text = userDesc[curSelected];
    }

	function firstBoot()
    {
        curSelected = 0;

		iconGrid.animation.play('alex');
		creditTxt.text = userDesc[0];
    }

	function openSocialMedia()
	{
		switch (curSelected)
		{
			case 0:
				fancyOpenURL("https://www.twitter.com/AlexDaShadow");
			case 1:
				FlxG.sound.play(Paths.sound('locked', 'piggy'), 0.7);
			case 2:
				fancyOpenURL("https://www.twitter.com/TakoNeen");
			case 3:
				fancyOpenURL("https://www.twitter.com/kawfu_");
			case 4:
				fancyOpenURL("https://www.twitter.com/DarkMoonPlayz1");
			case 5:
				fancyOpenURL("https://www.twitter.com/DaRealMiniToon");
			case 6:
				FlxG.sound.play(Paths.sound('locked', 'piggy'), 0.7);
			case 7:
				FlxG.sound.play(Paths.sound('locked', 'piggy'), 0.7);
			case 8:
				fancyOpenURL("https://www.twitter.com/sub0ru");
		}
	}
}

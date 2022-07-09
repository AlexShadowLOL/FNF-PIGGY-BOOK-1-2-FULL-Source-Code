package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class CachingSelectionState extends MusicBeatState
{
	public static var canMove:Bool = false;
	public static var noCache:Bool = false;

    var txt:FlxText;
    var bg:FlxSprite;
    var bgBlackOverlay:FlxSprite;

    override function create()
    {
		// -------------------------------------------------------------
		
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// -------------------------------------------------------------

        bg = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1', 'piggy'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.alpha = 0;
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		bgBlackOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0;
		add(bgBlackOverlay);

	    txt = new FlxText(0, 0, FlxG.width,
			"Hey There!"
			+ "\nThis Mod has Alot of Huge Assets, and i Don't Want\nTo See Your Pc Burning Because of Them."
			+ "\nYou can:"
            + "\n- Preload all The Images n' Songs by Pressing ENTER (Will Only Preload Once.)"
            + "\nOr"
			+ "\n- You Can Disable the Preload by Pressing ESC and Load the Assets Normaly When Choosing a Song/Week.\nWhat do You Say?",
			32);
		
		txt.setFormat("JackInput", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.alpha = 0;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

		changeAlpha();

		super.create();
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			if (canMove)
			{
				noCache = false;
				FlxG.switchState(new Cache());
			}
		}
		else if (FlxG.keys.justPressed.ESCAPE)
		{
			if (canMove)
			{
				noCache = true;
				FlxG.switchState(new MainMenuState());
			}
		}
	}

	function changeAlpha()
	{
		FlxTween.tween(bg, {alpha: 1}, 2);
		FlxTween.tween(bgBlackOverlay, {alpha: 0.6}, 2);
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			changeAlpha2();
		});
	}

	function changeAlpha2()
	{
		FlxTween.tween(txt, {alpha: 1}, 2);

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			canMove = true;
		});
	}
}
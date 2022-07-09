package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import haxe.ValueException;
import haxe.Exception;

class AntiPiracy extends MusicBeatState
{
    override function create()
    {
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        FlxG.sound.play(Paths.sound('glitch', 'piggy'), 1, true);

        startTimer();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function startTimer()
    {
        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            // throwException('PIRACY DETECTED. GAME HAS BEEN CLOSED, PLEASE REPORT THIS UNAUTHORIZED COPY OF FNF PIGGY BOOK 1-2 AND DOWNLOAD THE ACTUAL MOD FROM GAMEBANANA OR GAMEJOLT. ERROR CODE: 0x00. STARTUP ERROR AT: "FNF PIGGY BOOK 1-2/FNF Piggy Book 1-2.js", "FNF PIGGY BOOK 1-2/index.html"');
            FlxG.save.data.curBook = 'book1';
            FlxG.save.flush();

            trace(FlxG.save.data.curBook);
            
            book1.PlayStateB1.SONG = Song.loadFromJson('piracy-hard', 'piracy');
            book1.PlayStateB1.isStoryMode = false;
            book1.PlayStateB1.isPiracy = true;
            book1.PlayStateB1.storyDifficulty = 0;
            book1.PlayStateB1.storyWeek = 14;

            FlxG.switchState(new book1.PlayStateB1());
        });
    }

    function throwException(excepMsg:String)
	{
		throw new ValueException(excepMsg);
	}
}
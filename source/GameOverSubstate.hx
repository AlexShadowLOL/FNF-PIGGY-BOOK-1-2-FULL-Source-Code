package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;

class GameOverSubstate extends MusicBeatSubstate
{
    var blackShit:FlxSprite;
    var redShit:FlxSprite;
    var whiteShit:FlxSprite;
    var gameOver:FlxSprite;

    // var finishedTween:Bool = false;
    // var finishedPlayingVL:Bool = false;
    var dontPlayAnything:Bool = false;

    // var randomInt = FlxG.random.int(1, 5);
    var voiceLine:FlxSound;
    var gameOverAnim:FlxTween;

    public function new()
    {
        super();

        blackShit = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		blackShit.scale.set(2, 2);
		blackShit.alpha = 1;
		add(blackShit);

        gameOver = new FlxSprite(250, 0).loadGraphic(Paths.image('gameover/text', 'piggy'));
        gameOver.antialiasing = true;
        gameOver.setGraphicSize(FlxG.width, FlxG.height);
        gameOver.screenCenter(Y);
        gameOver.scrollFactor.set(0, 0);
        gameOver.updateHitbox();
        add(gameOver);

        redShit = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.RED);
		redShit.scrollFactor.set();
		redShit.scale.set(12, 12); // huge coc- Ehm- i mean- uh.. huge red rectangle you got there?..
		redShit.alpha = 1;
		add(redShit);

        whiteShit = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		whiteShit.scrollFactor.set();
		whiteShit.scale.set(2, 2);
		whiteShit.alpha = 0;
		add(whiteShit);

        startGameOver();
        eternalTweenLMAO();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            restartSong();
        }
        else if (FlxG.keys.justPressed.ESCAPE)
        {
            exitSong();
        }
    }

    function startGameOver()
    {
        FlxTween.tween(redShit, {alpha: 0}, 2);

        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            // finishedTween = true;

            if (PlayState.curSong.toLowerCase() != 'farewell')
            {
                switch (PlayState.SONG.player2)
                {
                    case 'willow' | 'willowstore' | 'willowwhite':
                        var randomInt = FlxG.random.int(1, 5);
                        var voiceLine = FlxG.sound.play(Paths.sound('gameOver/willow/willow' + randomInt, 'piggy'));
                    // case 'felixdumb':
                    //    var randomInt = FlxG.random.int(1, 3);
                    //    var voiceLine = FlxG.sound.play(Paths.sound('gameOver/april-fools/felix' + randomInt, 'piggy'));
                    case 'zuzy':
                        var voiceLine = FlxG.sound.play(Paths.sound('gameOver/zuzyLaugh', 'piggy'));
                    default:
                        dontPlayAnything = true;
                }    
            }
            else if (PlayState.curSong.toLowerCase() == 'farewell')
            {
                switch (PlayState.SONG.player1)
                {
                    case 'zizzy':
                        var voiceLine = FlxG.sound.play(Paths.sound('gameOver/zizzyVL', 'piggy'));
                    default:
                        dontPlayAnything = true;
                }
            }
        });
    }

    // i hate myself
//    function playVoiceline(soundPath:String, library:String)
//    {
//        voiceLine = new FlxSound().loadEmbedded('assets/' + library + '/sounds/' + soundPath + '.ogg', false, false, kindaUselessFunc);
//        
//        if (voiceLine == null) // stupid fix
//            kindaUselessFunc();
//       else
//            voiceLine.play(false);
//    }

    function restartSong():Void
    {
        redShit.alpha = 1;

        gameOverAnim.cancel();
        remove(gameOver);

        FlxTween.tween(redShit, {alpha: 0}, 1.5);

        new FlxTimer().start(2.3, function(tmr:FlxTimer)
        {
            // finishedTween = false;
            // finishedPlayingVL = false;
            LoadingState.loadAndSwitchState(new PlayState());
        });    
    }

    function exitSong()
    {
        FlxTween.tween(whiteShit, {alpha: 1}, 1);

        gameOverAnim.cancel();
        gameOver.alpha = 1; // shitty fix so it doesn't stays invisible random times
        gameOverAnim = FlxTween.tween(gameOver, {y: -1900}, 1.5);

        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            if (PlayState.isStoryMode)
                FlxG.switchState(new StoryMenuState());
            else if (PlayState.isFreeplay)
                FlxG.switchState(new FreeplayState());
            else if (PlayState.isFreeplayTwo)
                FlxG.switchState(new FreeplayPageTwo());
            else if (PlayState.isFreeplay3)
                FlxG.switchState(new DumbassFreeplay());
            else if (PlayState.isExtraFreeplay)
                FlxG.switchState(new ExtraFreeplay());
                            
            PlayState.loadRep = false;    
        });
    }

//    function kindaUselessFunc()
//    {
//        finishedPlayingVL = true;
//    }

    // not that eternal but yk what i mean
    function eternalTweenLMAO()
    {
        gameOverAnim = FlxTween.tween(gameOver, {alpha: 0}, 0.8, {onComplete: function (twn:FlxTween) {
            eternalTween2LMAO();
        }});
    }

    // not that eternal but yk what i mean
    function eternalTween2LMAO()
    {
        gameOverAnim = FlxTween.tween(gameOver, {alpha: 1}, 0.8, {onComplete: function (twn:FlxTween) {
            eternalTweenLMAO();
        }});
    }
}
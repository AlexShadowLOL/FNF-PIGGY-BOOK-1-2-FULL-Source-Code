package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class DeathScreen extends MusicBeatSubstate
{
    var redRed:FlxSprite;

    public function new()
    {
        super();

        redRed = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
        redRed.scale.set(10, 10);
		add(redRed);

        youDied();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function youDied()
    {
        FlxG.sound.play(Paths.sound('Lights_Turn_On', 'shared'));
        FlxTween.tween(redRed, {alpha: 0}, 2);

        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            FlxG.switchState(new PlayState());
        });
    }
}
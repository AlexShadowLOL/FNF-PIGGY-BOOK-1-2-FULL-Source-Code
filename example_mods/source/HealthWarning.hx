package;

import flixel.FlxSprite;
import flixel.FlxG;

class HealthWarning extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, scrX:Float = 0, scrY:Float = 0, setOnCenter:Bool = false)
    {
        super(x, y);

        loadGraphic(Paths.image('inGame/warningHealth', 'piggy'));

        antialiasing = true;
        scrollFactor.set(scrX, scrY);
        setGraphicSize(FlxG.width, FlxG.height);

        if (setOnCenter)
            screenCenter();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
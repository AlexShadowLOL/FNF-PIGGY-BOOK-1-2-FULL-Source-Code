package;

import flixel.FlxSprite;
import flixel.FlxG;

class BulletPopup extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, scrollFactorX:Int = 0, scrollFactorY:Int = 0, enableAntialiasing:Bool = false, centerOnScreen:Bool = false, curAlpha:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('inGame/bulletWarning', 'piggy'));
        scrollFactor.set(scrollFactorX, scrollFactorY);
        antialiasing = enableAntialiasing;
        if (centerOnScreen)
            screenCenter();
        alpha = curAlpha;
        setGraphicSize(FlxG.width, FlxG.height);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
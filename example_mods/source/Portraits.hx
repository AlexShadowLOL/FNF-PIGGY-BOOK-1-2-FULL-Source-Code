package;

import flixel.FlxSprite;

class Portraits extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, charNum:Int = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('extraFP/char$charNum', 'piggy'));
        scale.set(0.5, 0.5);
        antialiasing = true;
    }
}
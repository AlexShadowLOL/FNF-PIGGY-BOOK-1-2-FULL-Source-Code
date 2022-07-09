package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, note:Int = 0)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('notes/noteSplashes', 'piggy');

        animation.addByPrefix("splash-0", "purple splash", 24, false);
        animation.addByPrefix("splash-1", "blue splash", 24, false);
        animation.addByPrefix("splash-2", "green splash", 24, false);
        animation.addByPrefix("splash-3", "red splash", 24, false);

        setupNoteSplash(x, y, note);
        antialiasing = true;
    }

    public function setupNoteSplash(x:Float, y:Float, note:Int = 0)
    {
        setPosition(x, y);

        alpha = 0.9;
        animation.play('splash-' + note, false);
        scale.set(1.05, 1.05);
        updateHitbox();
        offset.set(0.5 * width, 0.5 * height);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (animation.curAnim.finished)
            kill();
    }
}
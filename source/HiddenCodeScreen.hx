package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class HiddenCodeScreen extends MusicBeatState
{
    var checkForCode:Array<Bool> = [false, false, false];
    var hasEnteredCode:Bool = false;

    var txt:FlxText;
    var staticAnim:FlxSprite;

    override function create()
    {
        FlxG.sound.playMusic(Paths.music('seizureTrack', 'piggy'));
        
        txt = new FlxText(0, 0, FlxG.width, "", 32);
		txt.setFormat("JackInput", 32, FlxColor.WHITE, CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
        txt.text = "0 | 0 | 0";
		add(txt);

        staticAnim = new FlxSprite(-1350, -70);
		staticAnim.frames = Paths.getSparrowAtlas('mainmenu/staticNormal', 'piggy');
		staticAnim.animation.addByPrefix('idle', "screenSTATIC", 24);
		staticAnim.animation.play('idle', true);
		staticAnim.scale.set(3, 3);
		staticAnim.alpha = 0.15;
		staticAnim.antialiasing = true;
		staticAnim.updateHitbox();
        add(staticAnim);

        super.create();   
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ONE && checkForCode[1] == false && checkForCode[2] == false)
		{
            checkForCode[0] = true;

            txt.text = "1 | 0 | 0";

            FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));
        }

		if (FlxG.keys.justPressed.FIVE && checkForCode[0] == true && checkForCode[2] == false)
		{
            checkForCode[1] = true;

            txt.text = "1 | 5 | 0";

            FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));
        }

		if (FlxG.keys.justPressed.NINE && checkForCode[0] == true && checkForCode[1] == true)
		{
            checkForCode[2] = true;

            txt.text = "1 | 5 | 9";

            FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));
            hasEnteredCode = true;
        }

        if (hasEnteredCode)
        {
            FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

            FlxTween.tween(txt, {alpha: 0}, 2);
            FlxTween.tween(staticAnim, {alpha: 0}, 2);

            FlxG.switchState(new MP4RandomVideoScreen());
        }
    }
}
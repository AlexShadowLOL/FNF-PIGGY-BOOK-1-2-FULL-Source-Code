package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;

class Jumpscare extends MusicBeatSubstate
{
    var whiteShit:FlxSprite;

    var curCharacter:String = "";
    var canPress:Bool = false;

    public function new(jumpscareChar:String)
    {
        super();

        whiteShit = new FlxSprite().loadGraphic(Paths.image('jumpscare/gameover', 'piggy'));
		whiteShit.scrollFactor.set(0, 0);
		whiteShit.setGraphicSize(FlxG.width, FlxG.height);
        whiteShit.antialiasing = true;
		whiteShit.alpha = 0;
		add(whiteShit);

        startVideo(jumpscareChar);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            if (canPress)
            {
                FlxG.switchState(new PlayState());
            }
        }
        else if (FlxG.keys.justPressed.ESCAPE)
        {
            if (canPress)
            {
                if (PlayState.isStoryMode)
				{
					trace("STORY MODE!!");
					FlxG.switchState(new StoryMenuState());
				}
				else if (PlayState.isFreeplay)
				{
					trace("FREE PLAY!!");
					FlxG.switchState(new FreeplayState());
				}
				else if (PlayState.isFreeplayTwo)
				{
					trace("FREE PLAY!!");
					FlxG.switchState(new FreeplayPageTwo());
				}
				else if (PlayState.isFreeplay3)
                {
					FlxG.switchState(new DumbassFreeplay());
				}
                else if (PlayState.isExtraFreeplay)
                {
					FlxG.switchState(new ExtraFreeplay());
				}
				else if (PlayState.isAlmost)
                {
					FlxG.switchState(new FreeplayAlmost());
				}
            }
        }
    }

    function startVideo(char:String)
    {
        switch (char)
        {
            case 'rash': curCharacter = 'rash';
            case 'dessa': curCharacter = 'dessa';
            case 'willow': curCharacter = 'willow';
            case 'willowstore': curCharacter = 'willow';
            case 'tigry': curCharacter = 'tigry';
            case 'tigrymad': curCharacter = 'tigrymad';
            case 'zizzy': curCharacter = 'zizzy';
            case 'zizzyholiday': curCharacter = 'zizzyholiday';
            case 'raze': curCharacter = 'raze';
            case 'alfis': curCharacter = 'alfis';
            case 'kolie': curCharacter = 'kolie';
            case 'dakoda': curCharacter = 'dakoda';
            case 'archie': curCharacter = 'archie';
            case 'markus': curCharacter = 'markus';
            case 'spidella': curCharacter = 'spidella';
            case 'delta': curCharacter = 'delta';
            case 'penny': curCharacter = 'penny';
        }

        var video:MP4Handler = new MP4Handler();
		
		video.playMP4(Paths.video('deaths/Death' + FlxG.random.int(1, 10)));
		video.finishCallback = function()
		{
		    whiteShit.alpha = 1;          
			canPress = true;
		} 
    }
}
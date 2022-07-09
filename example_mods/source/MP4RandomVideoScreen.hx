package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
 
class MP4RandomVideoScreen extends MusicBeatState
{
    var onTextScreen:Bool = false;
    var canMove:Bool = false;
    var playingVideo:Bool = false;

    var txt:FlxText;
    var bgBlackOverlay:FlxSprite;
    var bg:FlxSprite;

    // idk i was bored
    var videoNames:Array<String> = [  
		'assets/videos/cursedvideos/bonk.mp4',                // 1 
		'assets/videos/cursedvideos/youreNotImportant.mp4',   // 2  
		'assets/videos/cursedvideos/fastFriends.mp4',         // 3    
		'assets/videos/cursedvideos/takeItFourFingers.mp4',   // 4
		'assets/videos/cursedvideos/openYourEyes.mp4',        // 5     
		'assets/videos/cursedvideos/attractionWhat.mp4',      // 6      
		'assets/videos/cursedvideos/school.mp4',              // 7  
        'assets/videos/cursedvideos/breakdown.mp4',           // 8
        'assets/videos/cursedvideos/iWantToEatYou.mp4',       // 9
        'assets/videos/cursedvideos/earrape.mp4'              // 0       
	];

    override function create()
    {
        bg = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1', 'piggy'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		bgBlackOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0.6;
		add(bgBlackOverlay);

        txt = new FlxText(0, 0, FlxG.width,
			"Hi "
			+ "\nThis is a Random Screen for When You're Bored. Here you Can Press a Number Key"
			+ "\nof 1 to 0 (on the number pad) to Play a Random Cursed Vid (i may add more keys if i add more vids)"
			+ "\nBe Aware that Some May Contain Earrapes, Jumpscares, Such 'Themes or They Dont Have Sense\n\nAnyways, Enjoy! :)",
			32);
		
		txt.setFormat("JackInput", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

        onTextScreen = true;

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER && onTextScreen)
        {
            removeText();
        }

        if (FlxG.keys.justPressed.ESCAPE && canMove)
        {
            FlxG.switchState(new MainMenuState());
        }

        if (FlxG.keys.justPressed.ONE && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/bonk'));

            trace("Playing " + '"' + videoNames[0] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.TWO && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/youreNotImportant'));

            trace("Playing " + '"' + videoNames[1] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        // spine
        // spine
        // spine
        if (FlxG.keys.justPressed.THREE && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/fastFriends'));

            trace("Playing " + '"' + videoNames[2] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.FOUR && canMove && !playingVideo) // kit kat? no, take it 4 fingers :troll:
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/takeItFourFingers'));

            trace("Playing " + '"' + videoNames[3] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.FIVE && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/openYourEyes'));

            trace("Playing " + '"' + videoNames[4] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.SIX && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/attractionWhat'));

            trace("Playing " + '"' + videoNames[5] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.SEVEN && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/school'));

            trace("Playing " + '"' + videoNames[6] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.EIGHT && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/breakdown'));

            trace("Playing " + '"' + videoNames[7] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.NINE && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/iWantToEatYou'));

            trace("Playing " + '"' + videoNames[8] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }

        if (FlxG.keys.justPressed.ZERO && canMove && !playingVideo)
        {
            canMove = false;
            playingVideo = true;

            var video:MP4Handler = new MP4Handler();
            video.playMP4(Paths.video('cursedvideos/earrape'));

            trace("Playing " + '"' + videoNames[9] + '"');

            video.finishCallback = function()
            {
                canMove = true;
                playingVideo = false;
            }   
        }
    }

    function removeText()
    {
        FlxTween.tween(txt, {alpha: 0}, 0.5);
        FlxTween.tween(bgBlackOverlay, {alpha: 0}, 0.5);

        onTextScreen = false;
        canMove = true;
    }
}
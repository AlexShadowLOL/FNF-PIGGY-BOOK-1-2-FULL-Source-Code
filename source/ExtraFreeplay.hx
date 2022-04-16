package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ExtraFreeplay extends MusicBeatState
{
    var charPortrait:Portraits;
    var curSelected:Int = 0;
    var charTween:FlxTween;
    var songBG:FlxSprite;
    var bg:FlxSprite; 

    var songTexts:Array<String> = [
        'Forgotten Past',
        'Hide And Seek',
        'Frost Fate',
        'Overseer',
        'Swing It',
        'Atrocity',
        'Catalysis',
        'Souless',
        'Linked Toon'
    ];

    var songTexts_TheMovie:Array<String> = [
        'forgottenPast',
        'hideAndSeek',
        'frostFate',
        'overseer',
        'swingIt',
        'atrocity',
        'catalysis',
        'souless',
        'linkedToon'
    ];

    override function create()
    {
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Extra Freeplay Menu", null);
		#end

        bg = new FlxSprite().loadGraphic(Paths.image('loadingBGS/loadingBG_1Blur', 'piggy'));
        bg.antialiasing = true;
        bg.setGraphicSize(FlxG.width, FlxG.height);
        bg.updateHitbox();
        add(bg);

        firstBoot();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.DOWN)
            nextSong();

        if (FlxG.keys.justPressed.UP)
            prevSong();

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());

        if (FlxG.keys.justPressed.ENTER)
        {
            // FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

            if (curSelected == 0)
            {
                PlayState.SONG = Song.loadFromJson('forgotten-past-hard', 'forgotten-past');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 1)
            {
                PlayState.SONG = Song.loadFromJson('hide-and-seek-hard', 'hide-and-seek');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 2)
            {
                PlayState.SONG = Song.loadFromJson('frost-fate-hard', 'frost-fate');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 3)
            {
                PlayState.SONG = Song.loadFromJson('overseer-hard', 'overseer');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 4)
            {
                PlayState.SONG = Song.loadFromJson('swing-it-hard', 'swing-it');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 5)
            {
                PlayState.SONG = Song.loadFromJson('atrocity-hard', 'atrocity');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 6)
            {
                PlayState.SONG = Song.loadFromJson('catalysis-hard', 'catalysis');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 7)
            {
                PlayState.SONG = Song.loadFromJson('souless-hard', 'souless');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
            else if (curSelected == 8)
            {
                PlayState.SONG = Song.loadFromJson('linked-toon-hard', 'linked-toon');
                PlayState.isStoryMode = false;
                PlayState.isExtraFreeplay = true;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 14;
    
                FlxG.camera.fade(FlxColor.BLACK, 1.6, false, function()
                {
                    if (CachingSelectionState.noCache)
                    {
                        FlxG.switchState(new LoadingState(new PlayState(), false));
                    }
                    else
                    {
                        LoadingState.loadAndSwitchState(new PlayState());
                    }
                });	
            }
        }
    }

    function nextSong()
    {
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

        // charTween.cancel();

        remove(charPortrait);
        remove(songBG);

        curSelected += 1;

        if (curSelected > 6)
            curSelected = 0;

        charPortrait = new Portraits(-180, -215, curSelected);
        // charPortrait.alpha = 0;
        add(charPortrait);

        songBG = new FlxSprite().loadGraphic(Paths.image('extraFP/bg' + curSelected, 'piggy'));
        songBG.antialiasing = true;
        songBG.setGraphicSize(FlxG.width, FlxG.height);
        songBG.updateHitbox();
        add(songBG);

        // charTween = FlxTween.tween(charPortrait, {alpha: 1, x: 0}, 1);

        FlxG.sound.playMusic(Paths.music(songTexts_TheMovie[curSelected] + 'VCR', 'piggy'));

        trace("CURRENT SONG: " + songTexts[curSelected]);       
    }

    function prevSong()
    {
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

        // charTween.cancel();

        remove(charPortrait);
        remove(songBG);

        curSelected += -1;

        if (curSelected < 0)
            curSelected = 6;

        charPortrait = new Portraits(-180, -215, curSelected);
        // charPortrait.alpha = 0;
        add(charPortrait);

        songBG = new FlxSprite().loadGraphic(Paths.image('extraFP/bg' + curSelected, 'piggy'));
        songBG.antialiasing = true;
        songBG.setGraphicSize(FlxG.width, FlxG.height);
        songBG.updateHitbox();
        add(songBG);

        // charTween = FlxTween.tween(charPortrait, {alpha: 1, x: 0}, 1);

        FlxG.sound.playMusic(Paths.music(songTexts_TheMovie[curSelected] + 'VCR', 'piggy'));

        trace("CURRENT SONG: " + songTexts[curSelected]);       
    }

    function firstBoot()
    {
        curSelected = 0;

        charPortrait = new Portraits(-180, -215, curSelected);
        // charPortrait.alpha = 0;
        add(charPortrait);

        songBG = new FlxSprite().loadGraphic(Paths.image('extraFP/bg' + curSelected, 'piggy'));
        songBG.antialiasing = true;
        songBG.setGraphicSize(FlxG.width, FlxG.height);
        songBG.updateHitbox();
        add(songBG);

        // charTween = FlxTween.tween(charPortrait, {alpha: 1, x: 0}, 1);

        FlxG.sound.playMusic(Paths.music('forgottenPastVCR', 'piggy'));

        trace("CURRENT SONG: " + songTexts[curSelected]);       
    }
}
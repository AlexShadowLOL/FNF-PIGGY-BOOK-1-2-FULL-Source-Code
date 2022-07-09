package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OpenTxtFile extends MusicBeatState
{
    override function create()
    {
        var enterText:FlxText = new FlxText(0, FlxG.height - 65, FlxG.width, "", 36);
		enterText.setFormat(Paths.font("JAi_____.ttf"), 36, FlxColor.WHITE, CENTER);
		enterText.screenCenter(X);
        enterText.text = "Press ENTER to Go to Main Menu";
        add(enterText);

        openFile();

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.switchState(new MainMenuState());
        }
    }

    function openFile()
    {
        #if sys
        Sys.command('start assets/piggy/data/theEnd.txt');
        #end
    }
}
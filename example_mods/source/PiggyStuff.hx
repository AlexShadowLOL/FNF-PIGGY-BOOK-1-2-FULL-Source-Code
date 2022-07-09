package;

import flixel.FlxG;
import flixel.FlxState;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

#if FEATURE_FILESYSTEM
import sys.io.Process;
import sys.FileSystem;
#end

using StringTools;

// made this to not fill CoolUtil.hx with shit i add and bc uh... i wanted to be more.. organized?
// or just bc i want this mod to be more professional :troll:

class PiggyStuff
{
//	----------- thank you ddto ---------------
	public static var programList:Array<String> = [
        'obs32',
        'obs64',
        'streamlabs obs',
        'bdcam',
        'fraps',
        'xsplit',
        'hycam2',
        'twitchstudio'
    ]; 

    public static function isRecording():Bool
    {
        #if FEATURE_OBS
        var taskList:Process = new Process('tasklist', []);
        var readableList:String = taskList.stdout.readAll().toString().toLowerCase();
        var isOBS:Bool = false;

        for (i in 0...programList.length)
        {
            if (readableList.contains(programList[i]))
                isOBS = true;
        }

        taskList.close();
        readableList = '';

        return isOBS;
        #else
        return false;
        #end
    }
//	----------- thank you ddto ---------------
}
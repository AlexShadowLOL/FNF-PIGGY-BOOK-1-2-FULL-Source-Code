import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.zooms == null)
			FlxG.save.data.zooms = true;

		if (FlxG.save.data.shaders == null)
			FlxG.save.data.shaders = true;

		if (FlxG.save.data.curBook == null)
			FlxG.save.data.curBook = 'book2';

        // dfjk my nuts
		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.firstBoot == null)
			FlxG.save.data.firstBoot = true;

		if (FlxG.save.data.photoSens == null)
			FlxG.save.data.photoSens = false;

		if (FlxG.save.data.blood == null)
			FlxG.save.data.blood = true;

		if (FlxG.save.data.showPopup == null)
			FlxG.save.data.showPopup = false;
		
		if (FlxG.save.data.shownPopupAlready == null)
			FlxG.save.data.shownPopupAlready = false;

		if (FlxG.save.data.gameDistractions == null)
			FlxG.save.data.gameDistractions = true;

		if (FlxG.save.data.mechanics == null)
			FlxG.save.data.mechanics = true;

		if (FlxG.save.data.cutscenes == null)
			FlxG.save.data.cutscenes = true;

		if (FlxG.save.data.parallax == null)
			FlxG.save.data.parallax = true;

		if (FlxG.save.data.noteSplashes == null)
			FlxG.save.data.noteSplashes = true;
	
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songsBeaten == null)
			FlxG.save.data.songsBeaten = 0;

		if (FlxG.save.data.unlockedRematch == null)
			FlxG.save.data.unlockedRematch = false;

		if (FlxG.save.data.curLevel == null)
			FlxG.save.data.curLevel = 1;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = true; // fps counter is enabled forever!!!!1!!1!11!

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 180; // so you don't lag!!!11!!1!

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 180; // baby proof so you can't hard lock ur copy of kade engine
		                                 // we'll see about that!!11!1!!!1!
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.voicesVol == null)
			FlxG.save.data.voicesVol = 1;

		if (FlxG.save.data.instVol == null)
			FlxG.save.data.instVol = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = true;
		
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = false;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;
		
		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;
	}
}
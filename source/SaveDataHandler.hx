package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

/**
 * handles save data initialization
*/
class SaveDataHandler
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.freeplayCuts == null)
			FlxG.save.data.freeplayCuts = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.eyesores == null)
			FlxG.save.data.eyesores = true;

		if (FlxG.save.data.modchart == null)
			FlxG.save.data.modchart = false;

		if (FlxG.save.data.makefair == null)
			FlxG.save.data.makefair = false;

		if (FlxG.save.data.donoteclick == null)
			FlxG.save.data.donoteclick = false;

		if (FlxG.save.data.healthdrain == null)
			FlxG.save.data.healthdrain = false;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.opponentside == null)
			FlxG.save.data.opponentside = false;

		if (FlxG.save.data.newInput != null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "pre-beta2";
		
		if (FlxG.save.data.newInput == null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "beta2";
    }
}
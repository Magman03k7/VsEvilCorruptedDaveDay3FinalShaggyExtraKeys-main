package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var matt:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float,char:String)
	{
		var daStage = PlayState.curStage;
		var daMatt:Bool = PlayState.bfChar == "matt";
		var daBf:String = '';
		switch (char)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
			default:
				daBf = 'bf-death';
		}
		if (char == "bf-pixel")
		{
			char = "bf-pixel-dead";
		}
		if (char == "what-lmao")
		{
			char = "bambi-bevel";
		}
		if (char == "bf-car")
		{
			char = "bf-death";
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, char);
		if(bf.animation.getByName('firstDeath') == null)
		{
			bf = new Boyfriend(x, y, 'bf');
		}
		add(bf);

		if (char == 'matt')
		{
			matt = new Boyfriend(x, y, 'matt-lost');
			add(matt);
			bf.alpha = 0;
			FlxG.sound.play(Paths.sound('fnf_loss_sfx-matt'));
		}
		else
		{
			FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		}

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		if (char == 'matt') matt.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.SONG.song.toLowerCase() == 'disability') {
				trace("WUH OH!!!");

				FlxG.save.data.foundRecoveredProject = true;

				var poop:String = Highscore.formatSong('recovered-project', 0);

				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, 'recovered-project');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 0;

				PlayState.storyWeek = 1;
				LoadingState.loadAndSwitchState(new PlayState());
			}
			else
				FlxG.switchState(new MainMenuState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			
				bf.playAnim('deathConfirm', true);
				if (bf.alpha == 0) matt.playAnim('deathConfirm', true);
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
				new FlxTimer().start(0.7, function(tmr:FlxTimer)
				{
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				});
			
		}
	}
}

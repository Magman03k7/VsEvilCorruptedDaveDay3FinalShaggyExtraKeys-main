package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import FreeplayState.SongMetadata;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class ExtraSongState extends MusicBeatState
{

    var songs:Array<SongMetadata> = [];

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
    var curSelected:Int = 0;
	var curDifficulty:Int = 0;
	var difficultySelectors:FlxGroup;
	var diffText:FlxText;
	
	private var maniaSong:Bool;
	private var noexforyou:Bool;

    private var iconArray:Array<HealthIcon> = [];

    var swagText:FlxText = new FlxText(0, 0, 0, 'my poop is brimming', 85);

    var songColors:Array<FlxColor> = [
    	0xFFca1f6f, // GF
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI r slur (i cant reclaim)
		0xFF00FFFF, //SPLIT THE THONNNNN
		0xFF000000 // sart.
    ];
    
    private var grpSongs:FlxTypedGroup<Alphabet>;

    override function create() 
	{

		
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

        #if desktop DiscordClient.changePresence("In the Extra Songs Menu", null); #end

        bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);
        
		addWeek(['Sugar-Rush', 'Origin', 'Metallic', 'Strawberry', 'Keyboard', 'Ugh', 'Cycles'], 2, ['bandu-candy', 'bandu-origin', 'ringi', 'bambom', 'bendu', 'bandu-origin', 'sart-producer']);
        addWeek(['Thunderstorm', 'Wheels', 'Dave-x-Bambi-Shipping-Cute', 'RECOVERED-PROJECT'], 1, ['dave-png', 'dave-wheels', 'dave-good', 'RECOVERED_PROJECT']);
		addWeek(['Sart-Producer'], 4, ['sart-producer']);
		addWeek(['Old-Strawberry'], 2, ['bambom']);

        grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

        swagText.setFormat(Paths.font("vcr.ttf"), 47, FlxColor.BLACK, LEFT);
		swagText.screenCenter(X);
		swagText.y += 50;
		add(swagText);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

            var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			if(songs[i].blackoutIcon)
			{
				icon.color = FlxColor.BLACK;
			}

			iconArray.push(icon);
			add(icon);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		var scoreBG:FlxSprite = new FlxSprite(FlxG.width * 0.8 - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 42, 0xFF000000);
		scoreBG.alpha = 0.6;
		difficultySelectors.add(scoreBG);

		diffText = new FlxText(FlxG.width * 0.8, 5, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		difficultySelectors.add(diffText);

		changeSelection();
		changeDiff();

        super.create();
    }

    public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
            if ((song.toLowerCase() == 'dave-x-bambi-shipping-cute' && !FlxG.save.data.shipUnlocked) || (song.toLowerCase() == 'recovered-project' && !FlxG.save.data.foundRecoveredProject))
                addSong('unknown', weekNum, songCharacters[num], true);
            else
			    addSong(song, weekNum, songCharacters[num], false);

			if (songCharacters.length != 1)
				num++;
		}
	}

    public function addSong(songName:String, weekNum:Int, songCharacter:String, blackoutIcon:Bool = false)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, blackoutIcon));
	}

    override function update(p:Float)
	{
		maniaSong = curSelected == 0 || curSelected == 7 || curSelected == 8;
		noexforyou = curSelected == 5 || curSelected == 6;
		difficultySelectors.visible = !noexforyou;

		if (!maniaSong && curDifficulty == 2) {
			curDifficulty = 1;
			updateDifficultyText();
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

        super.update(p);

        if (controls.UP_P)
            changeSelection(-1);

        if (controls.DOWN_P)
            changeSelection(1);

		if (!noexforyou) {
			if (controls.RIGHT_P)
				changeDiff(1);
			if (controls.LEFT_P)
				changeDiff(-1);
		}

		if (controls.BACK)
            FlxG.switchState(new PlayMenuState());

        if (controls.ACCEPT)
		{
            switch (songs[curSelected].songName.toLowerCase()) {
                case 'unknown':
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                default:
					if (noexforyou) curDifficulty = 0;
                    var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

                    trace(poop);

                    PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
                    PlayState.isStoryMode = false;
                    PlayState.storyDifficulty = curDifficulty;
                    PlayState.xtraSong = true;

					PlayState.formoverride = 'none';

                    PlayState.storyWeek = songs[curSelected].week;
					if(songs[curSelected].songName.toLowerCase() == 'cycles')
					{
						LoadingState.loadAndSwitchState(new PlayState());
					}
					else if(songs[curSelected].songName.toLowerCase() == 'dave-x-bambi-shipping-cute' && curDifficulty == 1)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					}
					else
					{
						LoadingState.loadAndSwitchState(new CharacterSelectState());
					}
            }
		}
    }

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (maniaSong) {
			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
		}
		else {
			if (curDifficulty < 0)
				curDifficulty = 1;
			if (curDifficulty > 1)
				curDifficulty = 0;
		}

		updateDifficultyText();
	}

	function updateDifficultyText()
	{
		switch (curDifficulty)
		{
			case 0:
				diffText.text = 'HARD';
			case 1:
				diffText.text = 'EXTRA KEYS';
			case 2:
				diffText.text = '4K MANIA';
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		changeDiff();
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

        switch(songs[curSelected].songName.toLowerCase()) {
            case 'unknown':
                swagText.text = 'A secret is required to\nunlock this song!';
                swagText.visible = true;
            default:
                swagText.visible = false;
        }

		#if PRELOAD_ALL
		if(songs[curSelected].songName.toLowerCase() != 'unknown')
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

        for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}
}
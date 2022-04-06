package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class Strum extends FlxSprite
{
    var trueCoords:Array<Float>;
    var size:Array<Float>;

    public var resetAnim:Float = 0;
	private var noteData:Int = 0;

   public function new(x, y, leData:Int)
    {
        noteData = leData;
        super(x, y);
        resetTrueCoords();
    }

    public function resetTrueCoords():Void
    {
        trueCoords = [x, y];
        size = [width, height];
    }

    public function smartCenterOffsets():Void
    {
        return;
        centerOffsets();
        setPosition(trueCoords[0], trueCoords[1]);
        x -= width - size[0];
        y -= height - size[1];
    }

    override function update(t:Float) {
        if(resetAnim > 0) {
			resetAnim -= t;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}

       super.update(t);
        //if (PlayState.SONG.song.toLowerCase() == 'disability') centerOffsets();
    }

    public function playAnim(anim:String, ?force:Bool = false) {
        animation.play(anim, force);
        updateHitbox();
        offset.x = frameWidth / 2;
        offset.y = frameHeight / 2;

        offset.x -= 156 * Note.scales[PlayState.SONG.mania] / 2;
        offset.y -= 156 * Note.scales[PlayState.SONG.mania] / 2;
	}
}
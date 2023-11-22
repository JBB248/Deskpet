package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var buddy:BuddySprite;

	override public function create()
	{
		#if debug
		add(new FlxSprite(0, 0, AssetPaths.windows_xp_bliss__png));
		#end

		buddy = new BuddySprite();
		buddy.screenCenter();
		add(buddy);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
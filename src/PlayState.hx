package;

import burst.buddy.BuddySprite;
import burst.ui.BurstWindow;

import flixel.FlxState;

class PlayState extends FlxState
{
	var buddy:BuddySprite;

	override public function create()
	{
		#if debug
		add(new flixel.FlxSprite(0, 0, AssetPaths.windows_xp_bliss__png));
		#end

		buddy = new BuddySprite();
		buddy.screenCenter();
		add(buddy);

		var window = new BurstWindow();
		insert(members.indexOf(buddy), window);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
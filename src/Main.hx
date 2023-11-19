package;

import flixel.FlxG;
import flixel.FlxGame;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, BuddyState, true));

		ui.WindowManager.init();
		
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
	}
}
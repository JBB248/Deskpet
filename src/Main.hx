package;

import flixel.FlxG;
import flixel.FlxGame;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, PlayState, true));

		#if !debug
		ui.WindowManager.init();
		#end
		
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
	}
}
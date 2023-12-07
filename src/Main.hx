package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.system.Capabilities;
import ui.WindowManager;

class Main extends openfl.display.Sprite
{
	public function new()
	{
		super();

		#if debug
		addChild(new FlxGame(PlayState, true));
		#else
		WindowManager.resolution.x = Std.int(Capabilities.screenResolutionX);
		WindowManager.resolution.y = Std.int(Capabilities.screenResolutionY);
		addChild(new FlxGame(WindowManager.resolution.x, WindowManager.resolution.y, PlayState, true));
		WindowManager.init();
		#end

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
	}
}
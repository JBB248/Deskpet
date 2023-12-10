package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.system.Capabilities;
import ui.WindowManager;

class Main extends Sprite
{
	public function new()
	{
		super();

		initWindow();
		#if (!debug) WindowManager.init(); #end

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
	}

	function initWindow():Void
	{
		WindowManager.resolution.width = Std.int(Capabilities.screenResolutionX);
		WindowManager.resolution.height = Std.int(Capabilities.screenResolutionY);

		addChild(new FlxGame(WindowManager.resolution.width, WindowManager.resolution.height, PlayState, true));

		#if (debug)
		WindowManager.resolution.width = 1280;
		WindowManager.resolution.height = 720;
		#end
	}
}
package;

import burst.ui.WindowManager;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.system.Capabilities;

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
		// Store the user's primary monitor resolution
		WindowManager.resolution.width = Std.int(Capabilities.screenResolutionX);
		WindowManager.resolution.height = Std.int(Capabilities.screenResolutionY);

		addChild(new FlxGame(1920, 1080, PlayState, true));

		#if (debug)
		WindowManager.resolution.width = 1280;
		WindowManager.resolution.height = 720;
		#end
	}
}
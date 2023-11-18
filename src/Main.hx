package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.system.Capabilities;

@:cppFileCode('#define NOMINMAX\n#include <windows.h>')
class Main extends Sprite
{
	/**
	 * The color used to clear the application background
	 */
	public static var reserveColor(default, set):Int;

	static function set_reserveColor(value:Int):Int
	{
		setWindowTransparency(false, (reserveColor >> 16) & 0xff, (reserveColor >> 8) & 0xff, reserveColor & 0xff);
		setWindowTransparency(true, (value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff);

		return reserveColor = FlxG.cameras.bgColor = Lib.application.window.stage.color = value;
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
		if(value)
		{
			// Set WS_EX_LAYERED on this window
			SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);

			// Set the pixels with the specified rgb values transparent
			SetLayeredWindowAttributes(hWnd, RGB(red, green, blue), 0, LWA_COLORKEY);
		}
		else
		{
			// Remove WS_EX_LAYERED from this window styles
			SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) & ~WS_EX_LAYERED);

			// Ask the window to repaint
			RedrawWindow(hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_FRAME);
		}

		SetWindowPos(hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);
    ')
	public static function setWindowTransparency(value:Bool, red:Int = 0, green:Int = 0, blue:Int = 0):Void {}

	@:functionCode('
		HWND hWnd = GetActiveWindow();
		SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) & ~(WS_CAPTION | WS_THICKFRAME | WS_SYSMENU));
		SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) & ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));
	')
	public static function removeBorder():Void {}

	public static var resolution(default, null):FlxPoint;

	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, PlayState, true));
		
		Main.reserveColor = FlxColor.fromRGB(1, 1, 1);
		Main.resolution = FlxPoint.get(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.resizeWindow(Std.int(resolution.x), Std.int(resolution.y));
		Lib.application.window.move(0, 0);
		Main.removeBorder();
	}
}
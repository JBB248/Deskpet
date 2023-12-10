package ui;

import flixel.FlxG;
import lime.ui.Window;
import openfl.Lib;

@:cppFileCode(
    #if windows
   '#define NOMINMAX
    #include <windows.h>'
    #end
)
class WindowManager
{
	public static var resolution(default, never) = {width: 1920, height: 1080};

    public static var window(get, never):Window;

    @:noCompletion static inline function get_window():Window
        return Lib.application.window;

    /**
     * The color used to clear the application background.
     *
     * NOTE: All semi-transparent pixels will become this color
     */
    public static var reserveColor(default, set):Int;

    @:noCompletion static function set_reserveColor(value:Int):Int
    {
        restorePixels();
        removePixels((value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff);

        return reserveColor = FlxG.cameras.bgColor = Lib.application.window.stage.color = value;
    }

    @:allow(Main.new)
    static function init(color:Int = 0xFF010101)
    {
		reserveColor = color;
        move(0, 0);
		resize(resolution.width, resolution.height);
		setBorderless(true);
    }

    /**
     * Sets every pixel with the corrosponding rgb value transparent
	 *
	 * NOTE: Only functional on Windows OS
     */
    @:functionCode(
        #if windows
       'HWND hWnd = GetActiveWindow();

        SetWindowLongPtrW(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        SetLayeredWindowAttributes(hWnd, RGB(red, green, blue), 0, LWA_COLORKEY);
        SetWindowPos(hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);'
        #end
    )
    @:noCompletion static function removePixels(red:Int = 0, green:Int = 0, blue:Int = 0):Void { }

	/**
	 * Sets all previously transparent pixels opaque
	 *
	 * NOTE: Only functional on Windows OS
	 */
    @:functionCode(
        #if windows
       'HWND hWnd = GetActiveWindow();

        SetWindowLongPtrW(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        RedrawWindow(hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_FRAME);
        SetWindowPos(hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);'
        #end
    )
    @:noCompletion static function restorePixels():Void { }

	/**
	 * Moves the application window
	 */
    public static inline function move(x:Int, y:Int)
        Lib.application.window.move(x, y);

    /**
     * Resizes the application window
     */
    public static inline function resize(width:Int, height:Int)
        Lib.application.window.resize(width, height);

    /**
     * Adds or removes the window border depending on `value`.
     *
     * NOTE: Only functional on Windows OS
     */
    @:functionCode(
        #if windows 
       'HWND hWnd = GetActiveWindow();
        LONG lStyle = GetWindowLong(hWnd, GWL_STYLE);
        LONG lEXStyle = GetWindowLong(hWnd, GWL_EXSTYLE);
        if(value)
        {
            lStyle &= ~(WS_CAPTION | WS_THICKFRAME | WS_SYSMENU);
            lEXStyle &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
        }
        else
        {
            lStyle |= (WS_CAPTION | WS_THICKFRAME | WS_SYSMENU);
            lEXStyle |= (WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
        }

        SetWindowLongPtrW(hWnd, GWL_STYLE, lStyle);
        SetWindowLongPtrW(hWnd, GWL_EXSTYLE, lEXStyle);
        SetWindowPos(hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);'
        #end
    )
    public static function setBorderless(value:Bool):Void { }

    /**
     * Gets the mouse x-position relative to the screen
     */
    #if (!debug)
	@:functionCode(
        #if windows 
       'POINT p;
        if(!GetCursorPos(&p)) 
            return -1;
        return p.x;' 
        #end
    )
    #end
	public static function getCursorX():Int return FlxG.mouse.screenX;

    /**
     * Gets the mouse y-position relative to the screen
     */
    #if (!debug)
    @:functionCode(
        #if windows 
       'POINT p;
        if(!GetCursorPos(&p)) 
            return -1;
        return p.y;' 
        #end
    )
    #end
	public static function getCursorY():Int return FlxG.mouse.screenY;
}
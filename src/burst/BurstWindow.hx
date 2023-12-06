package burst;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;

/**
 * Sort of misleading
 */
class BurstWindow extends flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FlxSprite>
{
    public static inline var DEFAULTWIDTH:Int = 640;
    public static inline var DEFAULTHEIGHT:Int = 480;

    public static var colorPref:FlxColor = FlxColor.WHITE;

    public var windowSprite:BurstWindowSprite;

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);

        windowSprite = new BurstWindowSprite();
        add(windowSprite);
    }
}

@:final class BurstWindowSprite extends FlxEffectSprite
{
    static inline var RADIUS:Int = 15;

    var sprite:FlxSprite;
    var border:FlxOutlineEffect;

    public function new()
    {
        sprite = new FlxSprite(new BitmapData(BurstWindow.DEFAULTWIDTH, BurstWindow.DEFAULTHEIGHT, true, 0));

        FlxSpriteUtil.drawRoundRectComplex(sprite, 0, 0, sprite.width, sprite.height, 
            BurstWindowSprite.RADIUS, BurstWindowSprite.RADIUS, BurstWindowSprite.RADIUS, BurstWindowSprite.RADIUS, BurstWindow.colorPref);

        border = new FlxOutlineEffect(FlxColor.BLUE);

        super(sprite, [border]);

        setPosition((FlxG.width - BurstWindow.DEFAULTWIDTH) / 2, (FlxG.height - BurstWindow.DEFAULTHEIGHT) / 2);
    }
}
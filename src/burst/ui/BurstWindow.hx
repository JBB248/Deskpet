package burst.ui;

import burst.ui.frontend.Home;
import burst.ui.frontend.Styles;

import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

/**
 * Sort of misleading
 */
class BurstWindow extends FlxTypedSpriteGroup<FlxSprite>
{
    public static var colorPref:FlxColor = FlxColor.WHITE;

    public var windowSprite:BurstWindowSprite;

    public var home:Home;
    public var styles:Styles;

    public function new(x:Float, y:Float, pack:String)
    {
        super(x, y);

        windowSprite = new BurstWindowSprite();
        add(windowSprite);

        home = new Home(pack);
        styles = new Styles(pack);
    }
}

class BurstWindowSprite extends FlxEffectSprite
{
    public static inline var DEFAULTWIDTH:Int = 640;
    public static inline var DEFAULTHEIGHT:Int = 480;

    var sprite:FlxSprite;
    var border:FlxOutlineEffect;

    public function new()
    {
        sprite = new FlxSprite(new BitmapData(BurstWindowSprite.DEFAULTWIDTH, BurstWindowSprite.DEFAULTHEIGHT, true, 0));
        border = new FlxOutlineEffect(FlxColor.BLUE);

        super(sprite, [border]);

        setPosition((FlxG.width - BurstWindowSprite.DEFAULTWIDTH) / 2, (FlxG.height - BurstWindowSprite.DEFAULTHEIGHT) / 2);
    }
}
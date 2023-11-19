package;

import flixel.FlxSprite;

class BuddySprite extends FlxSprite
{
    public function new(X:Int = 0, Y:Int = 0)
    {
        super(X, Y);

		loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		animation.add("dance", [for (i in 0...44) i]);
		animation.play("dance");
    }
}
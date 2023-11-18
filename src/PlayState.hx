package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import ui.WindowManager;

class PlayState extends FlxState
{
	var pichu:FlxSprite;

	override public function create()
	{
		pichu = new FlxSprite();
		pichu.loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		pichu.animation.add("dance", [for(i in 0...44) i]);
		pichu.animation.play("dance");
		pichu.screenCenter();
		add(pichu);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(FlxG.keys.justPressed.R)
			WindowManager.reserveColor = FlxColor.RED;
		else if(FlxG.keys.justPressed.G)
			WindowManager.reserveColor = FlxColor.GREEN;
		else if (FlxG.keys.justPressed.B)
			WindowManager.reserveColor = FlxColor.BLUE;
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var clipRect:FlxSprite;
	var pichu:FlxSprite;

	override public function create()
	{
		clipRect = new FlxSprite().makeGraphic(1, 1, FlxColor.BLUE);
		// add(clipRect);

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
		
		clipRect.setPosition(pichu.x, pichu.y);
		clipRect.setGraphicSize(pichu.frameWidth, pichu.frameHeight);
		clipRect.updateHitbox();

		if(FlxG.keys.justPressed.R)
			Main.reserveColor = FlxColor.RED;
		else if(FlxG.keys.justPressed.G)
			Main.reserveColor = FlxColor.GREEN;
		else if (FlxG.keys.justPressed.B)
			Main.reserveColor = FlxColor.BLUE;
		else if(FlxG.keys.justPressed.C)
			Main.setWindowTransparency(false);
	}
}
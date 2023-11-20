package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var buddy:BuddySprite;
	var border:Border;

	override public function create()
	{
		#if debug
		add(new FlxSprite(0, 0, AssetPaths.windows_xp_bliss__png));
		#end

		border = new Border();
		border.forEach(function(sprite) {
			sprite.elasticity = FlxG.random.float(0.1, 2.5);
			sprite.solid = true;
			sprite.immovable = true;
		});

		buddy = new BuddySprite();
		buddy.screenCenter(X);
		buddy.velocity.x = 400;
		buddy.acceleration.y = 700;
		add(buddy);
	}

	override public function update(elapsed:Float)
	{
		FlxG.collide(buddy, border, function(sprite, border) {
			sprite.elasticity = FlxG.random.float(0.1, 2.5);
		});

		if(buddy.velocity.x > -300 && buddy.velocity.x < 300)
			buddy.velocity.x = buddy.velocity.x < 0 ? -300 : 300;

		super.update(elapsed);
	}
}
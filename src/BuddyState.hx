package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

class BuddyState extends FlxState
{
	var buddy:BuddySprite;
	var border:FlxTypedGroup<FlxObject>;

	override public function create()
	{
		#if debug
		add(new FlxSprite(0, 0, AssetPaths.windows_xp_bliss__png));
		#end

		border = new FlxTypedGroup();
		border.add(new FlxObject(-1, -1, 1, FlxG.height)); // Left wall
		border.add(new FlxObject(-1, -1, FlxG.width, 1)); // Top Wall
		border.add(new FlxObject(FlxG.width, -1, 1, FlxG.height)); // Right wall
		border.add(new FlxObject(-1, FlxG.height, FlxG.width, 1)); // Bottom Wall
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
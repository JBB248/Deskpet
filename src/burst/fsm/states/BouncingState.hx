package burst.fsm.states;

import burst.buddy.BuddySprite;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.util.FlxFSM;
import flixel.tweens.FlxTween;

class BouncingState extends BaseState
{
    public static inline var MINSPEEDX:Int = 300;

	override public function enter(owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void
	{
        super.enter(owner, fsm);
        
        owner.velocity.set(8000, 8000).copyTo(owner.maxVelocity);
        if(FlxG.mouse.deltaScreenX / FlxG.elapsed < 0)
            owner.velocity.x *= -1;
        if(FlxG.mouse.deltaScreenY / FlxG.elapsed < 0)
            owner.velocity.y *= -1;

        owner.acceleration.y = 0;
        owner.elasticity = 2.0;

        FlxTween.tween(owner.maxVelocity, {x: FlxG.width, y: FlxG.height}, 5.0, 
            {onComplete: (twn) -> owner.acceleration.y = BuddySprite.GRAVITY});
	}

	override public function update(elapsed:Float, owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void 
    { 
        if(Math.abs(owner.velocity.x) < BouncingState.MINSPEEDX)
			owner.velocity.x = owner.velocity.x < 0 ? -BouncingState.MINSPEEDX : BouncingState.MINSPEEDX;
    }

    override public function onCollide(sprite:FlxObject, wall:FlxObject):Void
    {
        sprite.elasticity = FlxG.random.float(0.5, 3.0);
    }

    override public function exit(owner:StatefulSprite) 
    {
        owner.velocity.set();
        owner.maxVelocity.set();
        owner.elasticity = BuddySprite.BOUNCINESS;
    }
}
package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

class BuddySprite extends FlxSprite
{
    public static inline var GRAVITY:Float = 600;

    public var border(default, null):Border = new Border();

    var _stateWatcher:FlxFSM<BuddySprite>;

    public function new(X:Int = 0, Y:Int = 0)
    {
        super(X, Y);

		loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		animation.add("dance", [for (i in 0...44) i]);
		animation.play("dance");

        acceleration.y = BuddySprite.GRAVITY;

		initStates();
    }

    function initStates():Void
    {
        _stateWatcher = new FlxFSM(this);

        _stateWatcher.transitions.add(IdleState, GrabbedState, Condition.grabbed);
        _stateWatcher.transitions.add(GrabbedState, IdleState, (sprite) -> !Condition.grabbed(sprite));

        _stateWatcher.transitions.start(IdleState);
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(this, border, _stateWatcher.state != null ? cast(_stateWatcher.state, BuddyState).onCollide : null);

        super.update(elapsed);

        _stateWatcher.update(elapsed);

        if(!isOnScreen()) // For now, just bring him back if he falls off-screen
            setPosition();
    }

    override public function destroy():Void
    {
        super.destroy();

        _stateWatcher = FlxDestroyUtil.destroy(_stateWatcher);
    }
}

@:allow(BuddySprite)
class Condition
{
    static function grabbed(sprite:BuddySprite):Bool
    {
        return FlxG.mouse.pressed && FlxG.mouse.overlaps(sprite);
    }
    
	static function shouldBounce(sprite:BuddySprite):Bool
    {
        return FlxG.mouse.justPressed && FlxG.mouse.overlaps(sprite);
    }
}

class BuddyState extends FlxFSMState<BuddySprite>
{
    public function onCollide(object1:FlxObject, object2:FlxObject):Void { }
}

class IdleState extends BuddyState
{
	override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    {
        owner.acceleration.y = BuddySprite.GRAVITY; // Restore gravity

        trace("Entered idle state");
    }
}

class GrabbedState extends BuddyState
{
    override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void
    {
        owner.velocity.set();
        owner.maxVelocity.set();
        owner.acceleration.set();
        owner.drag.set();

        trace("Entered grabbed state");
    }

    override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    {
        owner.x += FlxG.mouse.deltaScreenX;
        owner.y += FlxG.mouse.deltaScreenY;
    }

    override public function exit(owner:BuddySprite):Void
    {
        owner.velocity.x = FlxG.mouse.deltaScreenX / FlxG.elapsed;
        owner.velocity.y = FlxG.mouse.deltaScreenY / FlxG.elapsed;
        owner.maxVelocity.set(1400, 1000);

        owner.drag.x = Math.abs(owner.velocity.x) * 0.3;
    }
}

class BouncingState extends BuddyState
{
	override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void
	{
        owner.y -= 10;
        owner.velocity.x = owner.velocity.x > 0 ? -400 : 400;
        owner.velocity.y = -BuddySprite.GRAVITY * 0.5;
        owner.maxVelocity.set(1400, 1000);
        owner.drag.set();
        owner.elasticity = 2.0;

        trace("Entered bouncing state");
	}

	override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    { 
        if(Math.abs(owner.velocity.x) < 300)
			owner.velocity.x = owner.velocity.x < 0 ? -300 : 300;
    }

    override public function onCollide(sprite:FlxObject, wall:FlxObject):Void
    { 
        sprite.elasticity = FlxG.random.float(0.5, 3.0);
    }

    override public function exit(owner:BuddySprite) 
    {
        owner.drag.x = owner.maxVelocity.x * 0.35;

        FlxTween.tween(owner, {elasticity: 0}, 3.0, {
            onComplete: function(twn:FlxTween) {
                owner.maxVelocity.set();
                owner.drag.set();
            }
        });
    }
}
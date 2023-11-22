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

    public var border(default, never):Border = new Border();

    @:allow(Condition)
    var _stateWatcher:FlxFSM<BuddySprite>;

    public function new(X:Int = 0, Y:Int = 0)
    {
        super(X, Y);

		loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		animation.add("dance", [for (i in 0...44) i]);
		animation.play("dance");

        acceleration.y = BuddySprite.GRAVITY;

		_stateWatcher = new FlxFSM(this);
        _stateWatcher.transitions.add(IdleState, BouncingState, Condition.shouldBounce);
        _stateWatcher.transitions.add(BouncingState, IdleState, Condition.shouldStopBounce);
        _stateWatcher.transitions.start(IdleState);
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(this, border, _stateWatcher.state != null ? cast(_stateWatcher.state, BuddyState).onCollide : null);

        super.update(elapsed);

        _stateWatcher.update(elapsed);
    }

    override public function destroy():Void
    {
        super.destroy();

        _stateWatcher = FlxDestroyUtil.destroy(_stateWatcher);
    }
}

class Condition
{
	public static function shouldBounce(sprite:BuddySprite):Bool
    {
        return sprite._stateWatcher.stateClass == IdleState 
            && FlxG.mouse.justPressed 
            && sprite.getHitbox().containsPoint(FlxG.mouse.getScreenPosition());
    }

    public static function shouldStopBounce(sprite:BuddySprite):Bool
    {
        return sprite._stateWatcher.stateClass == BouncingState
            && FlxG.mouse.justPressed 
            && sprite.getHitbox().containsPoint(FlxG.mouse.getScreenPosition());
    }
}

interface BuddyState
{
    function onCollide(object1:FlxObject, object2:FlxObject):Void;
}

class IdleState extends FlxFSMState<BuddySprite> implements BuddyState
{
	override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    { 
        trace("Entered idle state");
    }

	override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void { }

    public function onCollide(object1:FlxObject, object2:FlxObject):Void { }
}

class BouncingState extends FlxFSMState<BuddySprite> implements BuddyState
{
	override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void
	{
        owner.y -= 10;
        owner.velocity.x = owner.velocity.x > 0 ? -400 : 400;
        owner.velocity.y = -BuddySprite.GRAVITY * 0.5;
        owner.maxVelocity.x = 1400;
        owner.maxVelocity.y = 1000;
        owner.drag.set();
        owner.elasticity = 2.0;

        trace("Entered bouncing state");
	}

	override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    { 
        if(owner.velocity.x > -300 && owner.velocity.x < 300)
			owner.velocity.x = owner.velocity.x < 0 ? -300 : 300;
    }

    public function onCollide(sprite:FlxObject, wall:FlxObject):Void
    { 
        sprite.elasticity = FlxG.random.float(0.5, 3.0);
    }

    override public function exit(owner:BuddySprite) 
    {
        owner.drag.x = owner.maxVelocity.x * 0.35;

        FlxTween.tween(owner, {elasticity: 0}, 3.0);
    }
}
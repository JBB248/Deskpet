package;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

class BuddySprite extends FlxSprite
{
    public static inline var GRAVITY:Float = 600;
    public static inline var BOUNCINESS:Float = 0.4;

    public var border(default, null):Border = new Border();

    var _stateWatcher:FlxFSM<BuddySprite>;

    public function new(X:Int = 0, Y:Int = 0)
    {
        super(X, Y);

		loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		animation.add("dance", [for (i in 0...44) i]);
		animation.play("dance");

        acceleration.y = BuddySprite.GRAVITY;
        elasticity = BuddySprite.BOUNCINESS;

		initStates();
    }

    function initStates():Void
    {
        _stateWatcher = new FlxFSM(this);

        _stateWatcher.transitions.add(IdleState, GrabbedState, Condition.grabbed);

        _stateWatcher.transitions.add(GrabbedState, IdleState, (sprite) -> !Condition.shaken && !Condition.grabbed(sprite));
        _stateWatcher.transitions.add(GrabbedState, BouncingState, (sprite) -> Condition.shaken && !Condition.grabbed(sprite));

        _stateWatcher.transitions.add(BouncingState, GrabbedState, Condition.grabbed);

        _stateWatcher.transitions.start(IdleState);
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(this, border, _stateWatcher.state != null ? cast(_stateWatcher.state, BuddyState).onCollide : null);

        super.update(elapsed);

        _stateWatcher.update(elapsed);

        if(!isOnScreen()) // For now, just bring him back if he falls off-screen
            screenCenter();
    }

    override public function destroy():Void
    {
        super.destroy();

        _stateWatcher = FlxDestroyUtil.destroy(_stateWatcher);
    }
}

class Condition
{
    public static var shaken:Bool = false;

    public static function grabbed(sprite:BuddySprite):Bool
    {
        return FlxG.mouse.pressed && FlxG.mouse.overlaps(sprite);
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
    public static inline var OSC:Float = 1.0;
    public static inline var THRESHOLD:Int = 4;
    public static inline var COOLDOWN:Int = 3;

    var period:Float;
    var ticks:Int;
    var lastVelocity:Float;

    override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void
    {
        owner.velocity.set();
        owner.maxVelocity.set();
        owner.acceleration.set();
        owner.drag.set();

        initVars();

        trace("Entered grabbed state");
    }

    function initVars():Void
    {
        period = 0;
        ticks = 0;
        lastVelocity = 0;
    }

    override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    {
        owner.x += FlxG.mouse.deltaScreenX;
        owner.y += FlxG.mouse.deltaScreenY;

        if(!Condition.shaken && isShaking())
            FlxTween.shake(owner, 0.02, 5.0, null, 
                {onComplete: (twn) -> Condition.shaken = false});
    }

    /**
     * This only checks for _vertical_ shaking (up and down)
     */
    function isShaking():Bool
    {
        if(Condition.shaken) return true;

        period += FlxG.elapsed;
        var velocity = FlxG.mouse.deltaScreenY / FlxG.elapsed;
        if(velocity * lastVelocity < 0)
        {
            if(period <= GrabbedState.OSC) ticks++;
               period = 0;

            if(ticks >= GrabbedState.THRESHOLD)
                return Condition.shaken = true;
        }
        else if(period >= GrabbedState.COOLDOWN)
            ticks = 0;

        lastVelocity = velocity;
        return false;
    }

    override public function exit(owner:BuddySprite):Void
    {
        if(!Condition.shaken)
        {
            owner.velocity.x = FlxG.mouse.deltaScreenX / FlxG.elapsed;
            owner.velocity.y = FlxG.mouse.deltaScreenY / FlxG.elapsed;
            owner.maxVelocity.set(1400, 1000);
            owner.drag.x = Math.abs(owner.velocity.x) * 0.3;
        }

        owner.offset.set();
        Condition.shaken = false;
    }
}

class BouncingState extends BuddyState
{
    public static inline var MINSPEEDX:Int = 300;

	override public function enter(owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void
	{
        owner.velocity.set(8000, 8000).copyTo(owner.maxVelocity);
        if(FlxG.mouse.deltaScreenX / FlxG.elapsed < 0)
            owner.velocity.x *= -1;
        if(FlxG.mouse.deltaScreenY / FlxG.elapsed < 0)
            owner.velocity.y *= -1;

        owner.acceleration.y = 0;
        owner.elasticity = 2.0;

        FlxTween.tween(owner.maxVelocity, {x: FlxG.width, y: FlxG.height}, 5.0, 
            {onComplete: (twn) -> owner.acceleration.y = BuddySprite.GRAVITY});

        trace("Entered bouncing state");
	}

	override public function update(elapsed:Float, owner:BuddySprite, fsm:FlxFSM<BuddySprite>):Void 
    { 
        if(Math.abs(owner.velocity.x) < BouncingState.MINSPEEDX)
			owner.velocity.x = owner.velocity.x < 0 ? -BouncingState.MINSPEEDX : BouncingState.MINSPEEDX;
    }

    override public function onCollide(sprite:FlxObject, wall:FlxObject):Void
    {
        sprite.elasticity = FlxG.random.float(0.5, 3.0);
    }

    override public function exit(owner:BuddySprite) 
    {
        owner.velocity.set();
        owner.maxVelocity.set();
        owner.elasticity = BuddySprite.BOUNCINESS;
    }
}
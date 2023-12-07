package burst.fsm.states;

import burst.fsm.StatefulSprite;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.tweens.FlxTween;

class GrabbedState extends BaseState
{
    public static inline var OSC:Float = 1.0;
    public static inline var THRESHOLD:Int = 4;
    public static inline var COOLDOWN:Int = 3;

    public static var shaken:Bool = false;

    public static function grabbed(sprite:FlxSprite):Bool
    {
        return FlxG.mouse.pressed && FlxG.mouse.overlaps(sprite);
    }

    var period:Float;
    var ticks:Int;
    var lastVelocity:Float;

    override public function enter(owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void
    {
        super.enter(owner, fsm);

        owner.velocity.set();
        owner.maxVelocity.set();
        owner.acceleration.set();
        owner.drag.set();

        resetVars();
    }

    function resetVars():Void
    {
        GrabbedState.shaken = false;

        period = 0;
        ticks = 0;
        lastVelocity = 0;
    }

    override public function update(elapsed:Float, owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void 
    {
        owner.x += FlxG.mouse.deltaScreenX;
        owner.y += FlxG.mouse.deltaScreenY;

        if(!GrabbedState.shaken && isShaking())
            FlxTween.shake(owner, 0.02, 5.0, null, 
                {onComplete: (twn) -> GrabbedState.shaken = false});
    }

    /**
     * This _only_ checks for vertical shaking (up and down)
     */
    function isShaking():Bool
    {
        if(GrabbedState.shaken) return true;

        period += FlxG.elapsed;
        var velocity = FlxG.mouse.deltaScreenY / FlxG.elapsed;
        if(velocity * lastVelocity < 0)
        {
            if(period <= GrabbedState.OSC) ticks++;
               period = 0;

            if(ticks >= GrabbedState.THRESHOLD)
                return GrabbedState.shaken = true;
        }
        else if(period >= GrabbedState.COOLDOWN)
            ticks = 0;

        lastVelocity = velocity;
        return false;
    }

    override public function exit(owner:StatefulSprite):Void
    {
        if(GrabbedState.shaken) return;
        
        owner.velocity.x = FlxG.mouse.deltaScreenX / FlxG.elapsed;
        owner.velocity.y = FlxG.mouse.deltaScreenY / FlxG.elapsed;
        owner.maxVelocity.set(1400, 1000);
        owner.drag.x = Math.abs(owner.velocity.x) * 0.3;
    }
}
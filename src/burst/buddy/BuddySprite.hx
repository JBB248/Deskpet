package burst.buddy;

import burst.fsm.StatefulSprite;
import burst.fsm.states.*;

import flixel.addons.util.FlxFSM;

class BuddySprite extends StatefulSprite
{
    public static inline var GRAVITY:Float = 600;
    public static inline var BOUNCINESS:Float = 0.4;

    public var border(default, null):Border = new Border();

    public var lastClicked(default, null):Int = -1;

    public function new(X:Int = 0, Y:Int = 0)
    {
        super(X, Y);

		loadGraphic(AssetPaths.pichu__png, true, 175, 175);
		animation.add("dance", [for (i in 0...44) i]);
		animation.play("dance");

        acceleration.y = BuddySprite.GRAVITY;
        elasticity = BuddySprite.BOUNCINESS;
    }

    override function initStates():Void
    {
        super.initStates();

        state.transitions.add(IdleState, GrabbedState, GrabbedState.grabbed);

        state.transitions.add(GrabbedState, IdleState, (sprite) -> !GrabbedState.shaken && !GrabbedState.grabbed(sprite));
        state.transitions.add(GrabbedState, BouncingState, (sprite) -> GrabbedState.shaken && !GrabbedState.grabbed(sprite));

        state.transitions.add(BouncingState, GrabbedState, GrabbedState.grabbed);

        state.transitions.start(IdleState);
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(this, border, state.state != null ? (cast state.state).onCollide : null);

        super.update(elapsed);

        lastClicked = FlxG.mouse.justPressedTimeInTicks;

        if(!isOnScreen()) // For now, just bring him back if he falls off-screen
            screenCenter();
    }
}

class Condition
{
    public static inline var DELTACLICK:Int = 400; // 0.4 seconds

    public static function doubleClicked(sprite:BuddySprite):Bool
    {
        return FlxG.mouse.justPressedTimeInTicks - sprite.lastClicked <= Condition.DELTACLICK;
    }
}

class IdleState extends BaseState
{
	override public function enter(owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void 
    {
        super.enter(owner, fsm);
        
        owner.acceleration.y = BuddySprite.GRAVITY; // Restore gravity
    }
}
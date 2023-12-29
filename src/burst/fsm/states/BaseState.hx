package burst.fsm.states;

import burst.fsm.StatefulSprite;

import flixel.FlxObject;
import flixel.addons.util.FlxFSM;

/**
 * More or less the "idle" state which may be extended for more robust activity. 
 * By default, the sprite simply plays their default animation without motion.
 */
class BaseState extends FlxFSMState<StatefulSprite>
{
    override public function enter(owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void
    {
        #if debug
        FlxG.log.add("Entered: " + Type.getClassName(Type.getClass(this)));
        #end
    }

    public function onCollide(object1:FlxObject, object2:FlxObject):Void { }
}
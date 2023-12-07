package burst.fsm.states;

import burst.fsm.StatefulSprite;

import flixel.FlxObject;
import flixel.addons.util.FlxFSM;

class BaseState extends FlxFSMState<StatefulSprite>
{
    public function new()
    {
        super();    
    }

    override public function enter(owner:StatefulSprite, fsm:FlxFSM<StatefulSprite>):Void
    {
        #if debug
        flixel.FlxG.log.add("Entered: " + Type.getClassName(Type.getClass(this)));
        #end
    }

    public function onCollide(object1:FlxObject, object2:FlxObject):Void { }
}
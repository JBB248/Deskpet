package burst.fsm;

import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;

/**
 * An extension of FlxSprite that manages its activities through a finite state machine
 */
class StatefulSprite extends FlxSprite
{
    public var state(default, null):FlxFSM<StatefulSprite>;

    public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(x, Y, SimpleGraphic);

        state = new FlxFSM<StatefulSprite>(this);
        initStates();
    }

    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);
        state.update(elapsed);
    }

    @:noCompletion
    function initStates():Void { }

    override public function destroy():Void
    {
        super.destroy();

        state = FlxDestroyUtil.destroy(state);
    }
}
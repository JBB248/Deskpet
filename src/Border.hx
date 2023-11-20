package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class Border extends FlxTypedGroup<FlxObject>
{
    public var leftWall(get, never):FlxObject;
	public var topWall(get, never):FlxObject;
	public var bottomWall(get, never):FlxObject;
	public var rightWall(get, never):FlxObject;

    public function new()
    {
        super(4);

		add(new FlxObject(-1, -1, 1, FlxG.height));
		add(new FlxObject(-1, -1, FlxG.width, 1));
		add(new FlxObject(-1, FlxG.height, FlxG.width, 1));
		add(new FlxObject(FlxG.width, -1, 1, FlxG.height));
    }

    function get_leftWall():FlxObject
    {
        return members[0];
    }

    function get_topWall():FlxObject
    {
        return members[1];
    }

	function get_bottomWall():FlxObject
	{
		return members[2];
	}

	function get_rightWall():FlxObject
	{
		return members[3];
	}
}
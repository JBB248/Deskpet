package;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Surrounds the screen and serves as the sprite's boundaries
 */
class Border extends FlxTypedGroup<FlxObject>
{
    public var leftWall(get, never):FlxObject;
	public var topWall(get, never):FlxObject;
	public var bottomWall(get, never):FlxObject;
	public var rightWall(get, never):FlxObject;

    public function new()
    {
        super(4);

		var wall = new FlxObject(-1, -1, 1, FlxG.height);
		wall.allowCollisions = RIGHT;
		wall.immovable = true;
		add(wall);

		wall = new FlxObject(-1, -1, FlxG.width, 1);
		wall.allowCollisions = DOWN;
		wall.immovable = true;
		add(wall);

		wall = new FlxObject(-1, FlxG.height, FlxG.width, 1);
		wall.allowCollisions = UP;
		wall.immovable = true;
		add(wall);

		wall = new FlxObject(FlxG.width, -1, 1, FlxG.height);
		wall.allowCollisions = LEFT;
		wall.immovable = true;
		add(wall);
	}

    function get_leftWall():FlxObject
        return members[0];

    function get_topWall():FlxObject
        return members[1];

	function get_bottomWall():FlxObject
		return members[2];

	function get_rightWall():FlxObject
		return members[3];
}
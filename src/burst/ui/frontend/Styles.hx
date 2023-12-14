package burst.ui.frontend;

import haxe.DynamicAccess;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class Styles
{
    public var styleData:DynamicAccess<String>;

    public function new(pack:String)
    {
        read(pack);
    }

    function read(pack:String):Void
    {
        var key = 'add-ons/${pack}/styles.json';
        if(!FileSystem.exists(key))
            throw 'Add-on lacks a "styles" file';

        styleData = Json.parse(File.getContent(key));
    }
}
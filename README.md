# Deskpet
At the moment, just a fun little project.

This creates a screensaver of sorts that _may_ recieve better functionality in the future.

## Building
- __First__: [Download](https://github.com/JBB248/Deskpet/archive/refs/heads/main.zip) the source code or [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repository (the latter requires [git](https://git-scm.com/))

- __Second__: Download and install [Haxe](https://haxe.org)

- __Third__: Follow the instructions to [install HaxeFlixel](https://haxeflixel.com/documentation/getting-started/)

- __Fourth__: If you aren't going to use Neko, you'll need to set lime up for your OS
    - Windows: [Setup Windows](https://lime.openfl.org/docs/advanced-setup/windows/)
    - <s>MacOS: [Setup MacOS](https://lime.openfl.org/docs/advanced-setup/macos/)</s>
    - <s>Linux: [Setup Linux](https://lime.openfl.org/docs/advanced-setup/linux/)</s>

- __Fifth__: The instructions to compile the app are included in the links above

### Notes
This currently only works on Windows OS :)

Currently, compiling with `-debug` enabled will create a fake desktop enviroment to test the sprite in

## Warning!!!
There is a bug that causes the screen to flash white rapidly. 
It's only occurred on one of four devices I've tested it on, but I haven't been able to determine
what exactly is causing it.
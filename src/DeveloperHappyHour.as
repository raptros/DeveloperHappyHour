package  
{

	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

    import org.flixel.*;

    [SWF(width="800", height="480", backgroundColor="#000000")];
    [Frame(factoryClass="Preloader")];

    /**
     * start up the game. Create the level objects with all the settings for rising difficulty.
     */
	public class DeveloperHappyHour extends FlxGame
	{
        public static var WIDTH:int = 400, HEIGHT:int = 240;

		public function DeveloperHappyHour()
		{
            super(WIDTH, HEIGHT, StartGameState);
            //this makes it easy ... incrementing FlxG.level to advance through the array.
            FlxG.levels.push(new LevelSettings(1, 5));
            FlxG.levels.push(new LevelSettings(1, 7));
            FlxG.levels.push(new LevelSettings(2, 5));
            FlxG.levels.push(new LevelSettings(2, 7));
            FlxG.levels.push(new LevelSettings(2, 11));
		}

	}
}

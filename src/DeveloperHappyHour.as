package  
{

	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

    import org.flixel.*;

    [SWF(width="800", height="480", backgroundColor="#000000", frameRate=30)];
    [Frame(factoryClass="Preloader")];

    /**
     * start up the game. Create the level objects with all the settings for rising difficulty.
     */
	public class DeveloperHappyHour extends FlxGame
	{
        public static var WIDTH:int = 800, HEIGHT:int = 480;

		public function DeveloperHappyHour()
		{
            super(WIDTH, HEIGHT, StartGameState, 1);
            //this makes it easy ... incrementing FlxG.level to advance through the array.
            //order: maxPatrons, patronsToClear, patronStep, pushBack, patronGap, whenMoney
            FlxG.levels.push(new LevelSettings(1,  5, 20, 40, 10, 3));
            FlxG.levels.push(new LevelSettings(1,  7, 20, 30, 10, 4));
            FlxG.levels.push(new LevelSettings(2,  5, 20, 35, 10, 5));
            FlxG.levels.push(new LevelSettings(2,  7, 20, 30, 10, 6));
            FlxG.levels.push(new LevelSettings(2, 11, 20, 20, 10, 7));
		}

	}
}

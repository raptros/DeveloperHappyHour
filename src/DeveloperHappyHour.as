package  
{

	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

    import flash.ui.Multitouch;
    import flash.ui.MultitouchInputMode;

    import org.flixel.*;

    
    [SWF(width="800", height="480", backgroundColor="#000000", frameRate=30)];
    //[SWF(width="400", height="240", backgroundColor="#000000", frameRate=30)];
    [Frame(factoryClass="Preloader")];

    /**
     * start up the game. Create the level objects with all the settings for rising difficulty.
     */
	public class DeveloperHappyHour extends FlxGame
	{
        public static var WIDTH:int = 800, HEIGHT:int = 480;
        //public static var WIDTH:int = 400, HEIGHT:int = 240;

		public function DeveloperHappyHour()
		{
            CONFIG::mobile {
                WIDTH /= 2;
                HEIGHT /= 2;
            }
            super(WIDTH, HEIGHT, StartGameState, 1);

            //var cfg:MeasuresConfig = new MeasuresConfig();

            FlxG.scores[2] = 1.0;
            CONFIG::mobile {
                Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
                FlxG.mobile = true;
                FlxG.scores[2] = 3.0;
            }

            //this makes it easy ... incrementing FlxG.level to advance through the array.
            //order: maxPatrons, patronStep, pushBack, patronGap, probPatron, whenMoney
            FlxG.levels.push(new LevelSettings(1, 10, 50, 10, 0.4, 3, 50));
            FlxG.levels.push(new LevelSettings(1, 20, 40, 10, 0.5, 4, 50));
            FlxG.levels.push(new LevelSettings(2, 20, 45, 10, 0.5, 5, 50));
            FlxG.levels.push(new LevelSettings(2, 20, 40, 10, 0.5, 6, 50));
            FlxG.levels.push(new LevelSettings(2, 20, 35, 10, 0.5, 7, 100));
		}

	}
}

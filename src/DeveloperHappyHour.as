package  
{

	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

    import org.flixel.*;

    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

	public class DeveloperHappyHour extends FlxGame
	{
        public static var WIDTH:int = 640, HEIGHT:int = 480;

		public function DeveloperHappyHour():void
		{
            super(WIDTH, HEIGHT, PlayState);
		}

	}
}

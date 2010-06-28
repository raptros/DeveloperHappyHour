package  
{

	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

    import org.flixel.*;

    [SWF(width="320", height="240", backgroundColor="#000000")];
    [Frame(factoryClass="Preloader")];

	public class DeveloperHappyHour extends FlxGame
	{
        public static var WIDTH:int = 320, HEIGHT:int = 240;

		public function DeveloperHappyHour()
		{
            super(WIDTH, HEIGHT, PlayState);
		}

	}
}

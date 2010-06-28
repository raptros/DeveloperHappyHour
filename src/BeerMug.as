package
{
    import org.flixel.*;

    public class BeerMug extends FlxSprite
    {
        public static var COLOR:uint = 0xff0000;
        public var startPos:FlxPoint;

        public function BeerMug(initX:Number, initY:Number)
        {
            super(initX, initY);
            createGraphic(5,5);
            color = COLOR;

            startPos = new FlxPoint(initX, initY);

            exists = false;
        }

        public function throwMug():void
        { 
            reset(startPos.x, startPos.y);
            velocity.x = -200;
            velocity.y = 0;
        }

        override public function update():void
        {
            super.update();
            if (!onScreen())
            {

                kill();
            }
        }
        

    }
}

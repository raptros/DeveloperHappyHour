package
{
    import org.flixel.*;

    public class BeerMug extends FlxSprite
    {
        public static var COLOR:uint = 0xff0000;
        public var startPos:FlxPoint;
        public static var SIZE:Number = 10;

        private var leftB:Number;
        private var rightB:Number;

        public function BeerMug(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY);
            createGraphic(SIZE, SIZE);
            color = COLOR;

            leftB = leftBound;
            rightB = rightBound;

            startPos = new FlxPoint(initX, initY);
            
            exists = false;
        }

        public function prepare():void
        { 
            reset(startPos.x, startPos.y);
        }

        override public function update():void
        {
            super.update();
            if (x < leftB)
                kill();
            else if (x > rightB)
                kill();
        }
        

    }
}

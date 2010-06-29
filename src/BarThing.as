package
{
    import org.flixel.*;

    public class BarThing extends FlxSprite
    {
        public static var COLOR:uint = 0x999999;
        public var startPos:FlxPoint;
        public static var SIZE:Number = 10;

        private var leftB:Number;
        private var rightB:Number;

        public function BarThing(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
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
            if (x < leftB)
                dieLeft();
            else if (right > rightB)
                dieLeft();
            super.update();
        }

        public function dieLeft():void
        {
            kill();
        }
        
        public function dieRight():void
        {
            kill();
        }

    }
}

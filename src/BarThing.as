package
{
    import org.flixel.*;

    /**
     * This represents any object that sits on a bar.
     * it has logic for falling off the edge of the bar.
     */
    public class BarThing extends FlxSprite
    {
        public var startPos:FlxPoint;
        public static var SIZE:Number = 10;

        private var leftB:Number;
        private var rightB:Number;

        public var whichBar:Number; //needed only by playstate
        public var onDieLeft:Function, onDieRight:Function;

        /**
         * set up the item to be bounded by the bar, and be placed properly.
         */
        public function BarThing(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY);

            leftB = leftBound;
            rightB = rightBound;

            startPos = new FlxPoint(initX, initY);
            
            exists = false;
        }
        
        /**
         * calls reset using the current value of startpos.
         */
        public function prepare():void
        { 
            reset(startPos.x, startPos.y);
        }
        
        /**
         * has it fallen off the edge yet?
         */
        override public function update():void
        {
            if (x < leftB)
                dieLeft();
            else if (right > rightB)
                dieRight();
            super.update();
        }

        /**
         * fall off the edge and run the callback to notify
         * that it's gone off the left.
         */
        public function dieLeft():void
        {
            kill();
            if (onDieLeft != null)
                onDieLeft(this);
        }
        
        /**
         * fall off the edge and run the callback to notify
         * that it's gone off the right.
         */
        public function dieRight():void
        {
            kill();
            if (onDieRight != null)
                onDieRight(this);
        }

    }
}

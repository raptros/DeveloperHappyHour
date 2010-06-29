package
{
    import org.flixel.*;

    /**
     * a patron is a kind of bar thing that makes the player lose
     * only if it reaches the right edge of the bar.
     * it can also be pushed back by mugs.
     */
    public class Patron extends BarThing
    {
        public static var COLOR1:uint = 0x00ff00;
        public static var COLOR2:uint = 0x00ffff;
        public static var SIZE:Number = 10;

        public var pushbackComplete:Function;
        public var mugged:Function;

        public var whichBar:Number; //needed only by playstate

        public var targetX:Number;
        public var inPushBack:Boolean = false;

        private var deltaX:Number=1; //this has to be a factor of howMuch.
        private var isMoving:Boolean = false, isAnimating:Boolean = false;
        private var animTime:Number;


        public function Patron(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);
            color = COLOR1;
            collideLeft = false;
            collideRight = true;

        }
        

        override public function update():void
        {
            //logic for determining what it should do next, when
            //in pushback mode and not animating
            if (inPushBack && !isAnimating)
            {
                //this bit might get split out 
                //for stepwise moving.
                if (!isMoving && x != targetX)
                    isMoving = true;
                //oddly enough, so might this. the
                //inPushBack check would go into here
                if (isMoving && x == targetX)
                {
                    //start the animation here.
                    animTime = 2.0;
                    isMoving = false;
                    isAnimating = true;
                }
                else if (!isMoving)
                    pushbackComplete(this);

            }
            //move towards targetX
            if (isMoving)
                x -= deltaX;

            //here we work out when the animation is over.
            if (isAnimating)
            {
                animTime -= FlxG.elapsed;
                if (animTime <= 0)
                    isAnimating = false;
            }
            super.update();
        }

        /**
         * because a patron going off the left doesn't end the game...
         */
        override public function dieLeft():void
        {
            super.dieLeft();
            isMoving = false;
            isAnimating = false;
            inPushBack = false;
            collideRight = true;
        }

        override public function hitRight(c:FlxObject, v:Number):void
        {
            var mug:BeerMug = c as BeerMug;
            if (mug != null)
                mugged(c, this);
        }
    }
}

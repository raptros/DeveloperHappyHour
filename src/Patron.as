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
        public static var WIDTH:Number = 59, HEIGHT:Number=31;
        //public static var SIZE:Number = 40;
        public static var lengthSheetPart:Number = 4;

        [Embed(source="../build/assets/sprites-patrons.png")]
        private var PatronSprite:Class;

        public var pushbackComplete:Function;
        public var mugged:Function;
        
        public var moveStep:Number; //how far the patron moves each step.

        public var targetX:Number;
        public var inPushBack:Boolean = false;
        public var isAnimating:Boolean = false;

        private var deltaX:Number=1; 
        private var animTime:Number;

        private var patronStartIndex:Number;


//        public var worth; //how many points this patron is worth.


        public function Patron(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);

            //this is going to have to hold every single patron sprite, the way I see it.
            loadGraphic(PatronSprite, false, false, WIDTH, HEIGHT);
            
            //there are different patrons every n levels. pick one.
            //var whichPatron:Number = Math.floor(Math.random() * 5); //one of four, times n
            //patronStartIndex = whichPatron * lengthSheetPart; 
            patronStartIndex = 0;
            
            addAnimation("walk", [1, 0, 0, 0, 0, 1], 6, true);
            addAnimation("rant", [2, 3], 4, true);
            addAnimation("catch", [4], 1, true);
            addAnimation("drink", [5, 6, 7, 8], 1, false);

            collideLeft = false;
            collideRight = true;

        }
        

        override public function update():void
        {
            if (isAnimating)
            {
                animTime -= FlxG.elapsed;
                if (animTime <= 0)
                {
                    isAnimating = false;
                    targetX = x + moveStep;
                    if (inPushBack) 
                    {
                        y += 3; //realign the patron after completing the drink animation
                        pushbackComplete(this);
                    }
                    else
                        play("walk");
                }
            }
            else 
            {
                //move to the targetX. if we're there, start animating.
                if (x > targetX)
                    x -= deltaX;
                else if (x < targetX)
                    x += deltaX;
                else
                {
                    //start the animation here.
                    isAnimating = true;
                    if (inPushBack)
                    {
                        animTime = 2.0;
                        //make sure that the patron will be aligned during the drink animation
                        y -= 3;
                        play("drink");
                    }
                    else
                    {
                        animTime = 1.0;
                        play("rant");
                    }
                }
            }

            super.update();
                    
        }

        /**
         * because a patron going off the left doesn't end the game...
         */
        override public function dieLeft():void
        {
            super.dieLeft();
            //we need these so that this doesn't screw up if reused.
            isAnimating = true;
            animTime = 0;
            inPushBack = false;
            collideRight = true;
        }

        /**
         * a beermug made contact with this.
         */
        override public function hitRight(c:FlxObject, v:Number):void
        {
            var mug:BeerMug = c as BeerMug;
            if (mug != null)
                mugged(c, this);
        }
    }
}

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
        public var drinking:Boolean = false;
        public var doBurp:Boolean = false;

        private var deltaX:Number=1; 
        private var animTime:Number;

        private var psi:Number; //Patron Start Index


//        public var worth; //how many points this patron is worth.


        public function Patron(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);

            //this is going to have to hold every single patron sprite, the way I see it.
            loadGraphic(PatronSprite, false, false, WIDTH, HEIGHT);
            var numPatrons:Number = 1;
            var whichPatron:Number = Math.floor(Math.random() * (numPatrons + 1));
            //psi = whichPatron * lengthSheetPart; 
            psi = 0;
            
            addAnimationCallback(onAnimationChange);
            addAnimation("walk", [psi + 1, psi, psi, psi, psi, psi+1], 6, true);
            addAnimation("rant", [psi+2, psi+3], 4, true);
            addAnimation("catch", [psi+4], 1, true);
            addAnimation("drink", [psi+5, psi+6, psi+7, psi+8, psi+9], 2, false);
            addAnimation("drinkBurp", [psi+5, psi+6, psi+7, psi+8, psi+9, psi, psi+10], 2, false);
            addAnimation("burp", [psi+10, psi], 2, false);

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
                        if (doBurp) // almost working.
                        {
                            isAnimating = true;
                            targetX = x;
                            animTime = 1.0;
                            play("burp");
                        }
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
                        animTime = 2.5;
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
                    
            if (drinking)
            {
                if (frame == psi + 9)
                    y = startPos.y + 3;
                else 
                    y = startPos.y;
            }

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
            doBurp = false;
            drinking = false;
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

        public function onAnimationChange(name:String, fNum:uint, fIdx:uint):void
        {
            y = startPos.y;
            drinking = false
            if (name == "catch")
                y+=3;
            else if (name == "drink" || name == "drinkBurp")
            {
                drinking = true;
            }
        }
    }
}

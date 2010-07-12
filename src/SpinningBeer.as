package
{
    import org.flixel.*;

    public class SpinningBeer extends FlxSprite
    {
        [Embed(source="../build/assets/sprites-mug.png")]
        private var BeerMugSprite:Class;

        public static var WIDTH:Number = 31;
        public static var HEIGHT:Number = 25;
        
        public static var S_INIT:Number=0;
        public static var S_MOVEUP:Number=1;
        public static var S_MOVEDOWN:Number=2;
        public static var S_BREAK:Number=3;
        public static var S_DONE:Number=4;

        public var sNum:Number=S_INIT;

        private var startPt:FlxPoint;
        private var endPt:FlxPoint;

        public function SpinningBeer(playerPos:FlxPoint, hitHead:Boolean=true)
        {
            startPt = new FlxPoint(playerPos.x + 30, playerPos.y);
            endPt = new FlxPoint(playerPos.x + 15, playerPos.y - 10);
            if (!hitHead)
            {
                endPt.x -= 10;
                endPt.y += 20;
            }

            super(startPt.x, startPt.y);
            loadGraphic(BeerMugSprite, false, false, WIDTH, HEIGHT);
            addAnimation("breaking", [3,4], 4, false);
            //loadRotatedGraphic(BeerMugSprite, 16, 5);
            
        }

        public function get done():Boolean
        {
            return sNum == S_DONE;
        }

        override public function update():void
        {
            if (sNum == S_INIT)
            { //get it going!
                velocity.y = -150;
                velocity.x = velocity.y * (startPt.x - endPt.x) /(200 + (startPt.y - endPt.y)) ;
                angularVelocity = 2000;
                sNum = S_MOVEUP;
                frame = 2;
            }
            else if (sNum == S_MOVEUP && y <= startPt.y - 100)
            {   //top of arc.
                velocity.y = -1*velocity.y;
                sNum = S_MOVEDOWN

            }
            else if (sNum == S_MOVEDOWN && y >= endPt.y)
            {
                //break.
                velocity.x  = 0;
                velocity.y = 0;
                angularVelocity = 0;
                sNum = S_BREAK;
                play("breaking");
            }
            else if (sNum == S_BREAK && finished)
            {
                sNum = S_DONE;
                kill();
            }
            super.update();
            
        }
        
    }
}

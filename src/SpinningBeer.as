package
{
    import org.flixel.*;

    public class SpinningBeer extends FlxSprite
    {
        public static var cfg:Class = MeasuresConfig;

        //public static var WIDTH:Number = 31;
        //public static var HEIGHT:Number = 25;
        
        public static var S_INIT:Number=0;
        public static var S_MOVEUP:Number=1;
        public static var S_MOVEDOWN:Number=2;
        public static var S_BREAK:Number=3;
        public static var S_DONE:Number=4;

        public var sNum:Number=S_INIT;

        private var startPt:FlxPoint;
        private var endPt:FlxPoint;

        private var arcHeight:Number;

        public function SpinningBeer(playerPos:FlxPoint, hitHead:Boolean=true)
        {
            //figure out the start and end positions relative to the player.
            startPt = new FlxPoint(playerPos.x + (cfg.playerCfg.width / 2), 
                    playerPos.y);

            endPt = new FlxPoint(playerPos.x + (cfg.playerCfg.width / 4),
                    playerPos.y - (cfg.playerCfg.height / 5));
            
            //modify positions if the ending is not hit head
            if (!hitHead)
            {
                endPt.x = playerPos.x + (cfg.playerCfg.width / 12.0);
                endPt.y = playerPos.y + (cfg.playerCfg.height / 5.0);
            }

            arcHeight = cfg.mugCfg.throwHeight;

            super(startPt.x, startPt.y);
            loadGraphic(Resources.beerMugSprite, false, false, cfg.mugCfg.width, cfg.mugCfg.height);
            addAnimation("breaking", [3,4], 4, false);
        }

        public function get done():Boolean
        {
            return sNum == S_DONE;
        }

        /**
         * update is a state machine. there are 5 states.
         */
        override public function update():void
        {
            //init state - set up the velocities.
            if (sNum == S_INIT)
            { //get it going!
                velocity.y = cfg.mugCfg.throwSpeed;
                //the endpoint x must be reached at the same time that the endpoint y is reached.
                //this calculates v_x in v_x / v_y = delta_x / delta_y;
                velocity.x = velocity.y * (startPt.x - endPt.x) / (2*arcHeight + (startPt.y - endPt.y)) ;
                angularVelocity = 2000;
                sNum = S_MOVEUP;
                frame = 2;
            }
            //end of move up state - top of arc has been reached
            else if (sNum == S_MOVEUP && y <= startPt.y - arcHeight)
            {   //so start moving down
                velocity.y = -1*velocity.y;
                sNum = S_MOVEDOWN

            }
            //end of move down state - endpoint has been reached
            else if (sNum == S_MOVEDOWN && y >= endPt.y)
            {
                //stop the mug here
                velocity.x  = 0;
                velocity.y = 0;
                angularVelocity = 0;
                //and break the mug
                sNum = S_BREAK;
                play("breaking");
            }
            //break animation is done. kill mug and finish.
            else if (sNum == S_BREAK && finished)
            {
                sNum = S_DONE;
                kill();
            }
            super.update();
            
        }
        
    }
}

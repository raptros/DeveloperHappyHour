package
{
    import org.flixel.*;

    public class SpinningBeer extends FlxSprite
    {
        public static var cfg:Class = MeasuresConfig;

        [Embed(source="../build/assets/sprites-mug.png")]
        private var BeerMugSprite:Class;

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
            startPt = new FlxPoint(playerPos.x + (cfg.playerCfg.width / 2), playerPos.y);
            endPt = new FlxPoint(playerPos.x + (cfg.playerCfg.width / 4), playerPos.y - (cfg.playerCfg.height / 5));
            if (!hitHead)
            {
                endPt.x = playerPos.x + (cfg.playerCfg.width / 12.0);
                endPt.y = playerPos.y + (cfg.playerCfg.height / 5.0);
            }

            arcHeight = cfg.mugCfg.throwHeight;

            super(startPt.x, startPt.y);
            loadGraphic(BeerMugSprite, false, false, cfg.mugCfg.width, cfg.mugCfg.height);
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
                velocity.y = cfg.mugCfg.throwSpeed;
                velocity.x = velocity.y * (startPt.x - endPt.x) /(2*arcHeight + (startPt.y - endPt.y)) ;
                angularVelocity = 2000;
                sNum = S_MOVEUP;
                frame = 2;
            }
            else if (sNum == S_MOVEUP && y <= startPt.y - arcHeight)
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

package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        public static var cfg:Class = MeasuresConfig;

        public var isDancing:Boolean=false; 
        public var isDrinking:Boolean=false; 

        public function Player(pos:FlxPoint)
        {
            super(pos.x, pos.y);
            var speedfactor:Number = cfg.speedFactor;

            loadGraphic(Resources.bartenderSprite, true, true, cfg.playerCfg.width, cfg.playerCfg.height);
            addAnimation("standing", [0], 10 , false);
            addAnimation("throwing", [1, 0], cfg.playerCfg.throwFps, false);
            addAnimation("dropped", [2], 1, false);
            addAnimation("running", [3, 4, 5, 6], cfg.playerCfg.runFps, true);
            addAnimation("switching", [7, 7, 8, 9, 10], cfg.playerCfg.switchFps, false);
            
            //TODO find out if these need to be speedfactored.
            addAnimation("dance", [13, 14, 13, 14], 4, false)
            //TODO this needs a bunch more of the real frames.
            addAnimation("drink", [15, 15, 15, 15], 2, false);
            addAnimation("kick", [16, 16, 16, 16,0], 4, false);
            
        }

        override public function update():void
        {
            super.update();
        }
    }
}

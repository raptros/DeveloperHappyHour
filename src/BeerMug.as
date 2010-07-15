package
{
    import org.flixel.*;

    /**
     * A beermug is a barthing that makes the player lose
     * if it hits either end of the bar.
     */
    public class BeerMug extends BarThing
    {
        public static var cfg:Class = MeasuresConfig;

        private var _full:Boolean;
        public var dropping:Boolean=false;
        public var targetY:Number;

        private var breaking:Boolean=false;

        public function BeerMug(initX:Number, initY:Number, leftBound:Number, rightBound:Number, full:Boolean = true)
        {
            super(initX, initY, leftBound, rightBound);

            this.full = full;

            loadGraphic(Resources.beerMugSprite, false, false, cfg.mugCfg.width, cfg.mugCfg.height);
            addAnimation("idle",[0]);
            addAnimation("fast",[1]);
            addAnimation("empty",[2]);
            addAnimation("break",[3,4], 2, false);

            collideRight = false;
            collideLeft = true;
        }

        public function get full():Boolean
        {
            return _full;
        }

        override public function update():void
        {
            if (dropping)
            {
                if (y >= targetY)
                {
                    velocity.x=0;
                    velocity.y=0;
                    acceleration.y=0;
                    breaking=true;
                    play("break");
                }
                else if (breaking && finished)
                {
                    dropping=false;
                    kill();
                }
            }
            super.update();
        }

        public function set full(value:Boolean):void
        {
            _full = value;

            if(value)
            {
                play("idle");
            }
            else
            {
                play("empty");
            }
        }
    }
}

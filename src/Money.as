package
{
    import org.flixel.*;
    /**
     * A tip dropped by a patron. it does not move, but sits on the bar,
     * and can be picked up by the player. it expires after 10 seconds.
     */
    public class Money extends BarThing
    {
        public static var COLOR:uint=0xff00ff;
        private var lifeTime:Number=10.0;
       
       public function Money(initX:Number, initY:Number, leftBound:Number, rightBound:Number) 
        {
            super(initX, initY, leftBound, rightBound);
            color = COLOR;
            collideLeft=false;
            collideRight=false;
        }

        override public function prepare():void
        {
            super.prepare();
            lifeTime = 10.0; //reset the timer
        }

        override public function update():void
        {
            super.update();
            lifeTime -= FlxG.elapsed;
            if (lifeTime <= 0)
                kill();
        }


                    
    }
}

package
{
    import org.flixel.*;

    /**
     * A beermug is a barthing that makes the player lose
     * if it hits either end of the bar.
     */
    public class BeerMug extends BarThing
    {
        public static var COLOR1:uint = 0xff0000;
        public static var COLOR2:uint = 0xffff00;
        public static var SIZE:Number = 10;

        public function BeerMug(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);
            color = COLOR1;
            collideRight = false;
            collideLeft = true;
        }
    }
}

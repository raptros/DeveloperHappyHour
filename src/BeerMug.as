package
{
    import org.flixel.*;

    public class BeerMug extends BarThing
    {
        public static var COLOR:uint = 0xff0000;
        public static var SIZE:Number = 10;

        public function BeerMug(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);
            color = COLOR;

        }
    }
}

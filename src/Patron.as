package
{
    import org.flixel.*;

    public class Patron extends BarThing
    {
        public static var COLOR:uint = 0x00ff00;
        public static var SIZE:Number = 10;

        public function Patron(initX:Number, initY:Number, leftBound:Number, rightBound:Number)
        {
            super(initX, initY, leftBound, rightBound);
            color = COLOR;

        }
    }
}

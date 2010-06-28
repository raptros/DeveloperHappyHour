package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        public function Player(pos:FlxPoint)
        {
            super(pos.x, pos.y);
            createGraphic(10,10);
            color = 0x0000ff;
        }

        override public function update():void
        {
            super.update();
        }
    }
}

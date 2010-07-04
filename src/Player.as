package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        [Embed(source="../build/assets/bartender_placeholder.png")]
        private var BartenderSprite:Class;

        public function Player(pos:FlxPoint)
        {
            super(pos.x, pos.y);

            //TODO this needs to be cleaned up by the correct graphics
            loadGraphic(BartenderSprite, false, false, 32, 51);

            //createGraphic(10,20);
            //color = 0x0000ff;
        }

        override public function update():void
        {
            super.update();
        }
    }
}

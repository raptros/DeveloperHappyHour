package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        [Embed(source="../build/assets/animation-player.png")]
        private var BartenderSprite:Class;

        public function Player(pos:FlxPoint)
        {
            super(pos.x, pos.y);

            //TODO add more animations.
            loadGraphic(BartenderSprite, true, true, 60, 52);
            addAnimation("standing", [0], 10, false);
            addAnimation("throwing", [1, 0], 2, false);
            addAnimation("dropped", [2, 2, 0], 1, false);
            addAnimation("running", [3, 4, 5, 6], 8, true);

            //createGraphic(10,20);
            //color = 0x0000ff;
        }

        override public function update():void
        {
            super.update();
        }
    }
}

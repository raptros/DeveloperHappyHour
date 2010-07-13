package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        [Embed(source="../build/assets/sprites-player.png")]
        private var BartenderSprite:Class;

        public var isDancing:Boolean=false; 
        public var isDrinking:Boolean=false; 

        public function Player(pos:FlxPoint)
        {
            super(pos.x, pos.y);
            var speedfactor:Number = FlxG.scores[2];

            //TODO add more animations.
            loadGraphic(BartenderSprite, true, true, 65, 51);
            addAnimation("standing", [0], 10 , false);
            addAnimation("throwing", [1, 0], 2* speedfactor, false);
            addAnimation("dropped", [2], 1, false);
            addAnimation("running", [3, 4, 5, 6], 12 * speedfactor, true);
            addAnimation("switching", [7, 7, 8, 9, 10], 25 * speedfactor, false);
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

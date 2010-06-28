package
{
    import org.flixel.*;

    public class Player extends FlxSprite
    {
        private var _mugs:FlxGroup;

        public function Player(initX:Number, initY:Number, mugs:FlxGroup)
        {
            super(initX, initY);
            createGraphic(10,10);
            _mugs = mugs;
            color = 0x0000ff;
        }

        override public function update():void
        {

            super.update();

            if (FlxG.keys.justPressed("SPACE"))
            {
                //chuck a mug from the current position.
                throwMug(getMug());
            }

        }

        public function getMug():BeerMug
        {
            var m:BeerMug = _mugs.getFirstAvail() as BeerMug;
            var pos:FlxPoint = getScreenXY();
            pos.y +=2.5;
            if (!m)
            {
                m = new BeerMug(pos.x, pos.y);
                _mugs.add(m);
            }
            else
                m.startPos=pos
            return m;
        }

        public function throwMug(mug:BeerMug):void
        {
            mug.throwMug();
        }


    }
}

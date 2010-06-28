package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        private var playerStart:FlxPoint = new FlxPoint(390, 120);
        private var _player:Player;
        private var _mugs:FlxGroup;

        private var mugCount:Number;
        private var counter:FlxText;

        override public function create():void
        {
            FlxG.mouse.show();
            _mugs = new FlxGroup();
            add(_mugs);
            var p:Player = new Player(playerStart.x, playerStart.y, _mugs);
            add(p);

            counter = new FlxText(20, 10, 20, "0");
            counter.alignment = "right";
            counter.color = 0xff0000;
            counter.size = 12;
            add(counter);


        }

        override public function update():void
        {
            super.update();
            mugCount = _mugs.members.length;
            counter.text=mugCount.toString();
        }
        
    }
}

package
{
    import org.flixel.*;
    public class LevelClearedState extends FlxState
    {
        private var cleared:Number;
        private var congrats:FlxText;
        public function LevelClearedState(numCleared:Number)
        {
            super();
            cleared = numCleared;
        }

        override public function create():void
        {
            FlxG.mouse.show();
            
            congrats = new FlxText(0, 120, 400, "You cleared the level of " + cleared + " patrons!");
            congrats.setFormat(null, 10, 0xffffff, "center", 0);
            add(congrats);
        }

        override public function update():void
        {
            if (FlxG.mouse.justReleased()) 
            {
                FlxG.state = new StartGameState();
            }
            super.update();
        }
            
            
    }
}

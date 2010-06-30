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
            
            congrats = new FlxText(0, 10, 400, "You cleared level " + FlxG.level + " of " + cleared + " patrons!");
            congrats.setFormat(null, 10, 0xffffff, "center", 0);

            //var b:FlxButton = new FlxButton(

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
        

        public function nextLevel():void
        {
            FlxG.state = new PlayState(FlxG.levels[FlxG.level]);
        }

    }
}

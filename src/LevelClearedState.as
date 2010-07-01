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

        override public function update():void
        {
            super.update();
        }

        override public function create():void
        {
            FlxG.mouse.show();
            
            congrats = new FlxText(0, 30, 400, "You cleared level " + FlxG.level + ". Your score is " + FlxG.score + ".");
            congrats.setFormat(null, 10, 0xffffff, "center", 0);
            add(congrats);

            FlxG.level++;
            if (FlxG.level < FlxG.levels.length)
            {
                var nextLevelSprite:FlxSprite = new FlxSprite(0,0).createGraphic(200, 20, 0x000000);
                var nextLevelMsg1:FlxText = new FlxText(0, 0, 200, "Proceed to next level.").setFormat(null, 8, 0xaaaaaa, "center", 0);
                var nextLevelMsg2:FlxText = new FlxText(0, 0, 200, "Proceed to next level.").setFormat(null, 8, 0xffffff, "center", 0);
                var bNextLevel:FlxButton = new FlxButton(100, 120, nextLevel);
                bNextLevel.loadGraphic(nextLevelSprite).loadText(nextLevelMsg1, nextLevelMsg2);
                bNextLevel.width = 200;
                //add(nextLevelMsg);
                add(bNextLevel);
            }
            var quitSprite:FlxSprite = new FlxSprite(0,0).createGraphic(200, 20, 0x000000);
            var quitMsg1:FlxText = new FlxText(0, 0, 200, "Quit game.").setFormat(null, 8, 0xaaaaaa, "center", 0);
            var quitMsg2:FlxText = new FlxText(0, 0, 200, "Quit game.").setFormat(null, 8, 0xffffff, "center", 0);
            var bQuit:FlxButton = new FlxButton(100, 180, quitGame);
            bQuit.loadGraphic(quitSprite).loadText(quitMsg1, quitMsg2);
            bQuit.width=200;
            //add(quitMsg);
            add(bQuit);


        }

        public function nextLevel():void
        {
            FlxG.state = new PlayState(FlxG.levels[FlxG.level]);
        }

        public function quitGame():void
        {
            FlxG.state = new StartGameState();
        }

    }
}

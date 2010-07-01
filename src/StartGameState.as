package
{
    import org.flixel.*;
    
    /**
     * To be displayed upon starting the game, or after ending a game.
     */
    public class StartGameState extends FlxState
    {
        private var title:FlxText;
        private var prompter:FlxText;
    
        override public function create():void
        {
            FlxG.mouse.show();
            //reset level and score.
            FlxG.level = 0;
            FlxG.score = 0;
            title = new FlxText(0, 60, 400, "Developer Happy Hour");
            title.setFormat(null, 12, 0xffffff, "center", 0);
            add(title);

            prompter = new FlxText(0, 120, 400, "Click to start");
            prompter.setFormat(null, 8, 0xffffff, "center", 0);
            add(prompter);
        }

        override public function update():void
        {
            if (FlxG.mouse.justReleased()) 
            {
                FlxG.state = new PlayState(FlxG.levels[FlxG.level]);
            }
            super.update();
        }
    }
}

package
{
    import org.flixel.*;
    public class StartGameState extends FlxState
    {
        private var title:FlxText;
        private var prompter:FlxText;
    

        override public function create():void
        {
            FlxG.mouse.show();

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
                FlxG.state = new PlayState(1, 10);
            }
            super.update();
        }
    }
}

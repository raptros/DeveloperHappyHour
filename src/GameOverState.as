package
{
    import org.flixel.*;
    
    public class GameOverState extends FlxState
    {
        private var over:FlxText;

        override public function create():void
        {
            FlxG.mouse.show();
            
            over = new FlxText(0, 120, 400, "Game Over. Your score: " + FlxG.score + " .");
            over.setFormat(null, 10, 0xffffff, "center", 0);
            add(over);
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

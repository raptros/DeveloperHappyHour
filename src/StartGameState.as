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

        [Embed(source="../build/assets/opening_screen.png")]
        private var TitleSprite:Class;

        [Embed(source="../build/assets/opening_screen_animation.png")]
        private var BeerMugSprite:Class;

        override public function create():void
        {

            add(new FlxSprite(0,0,TitleSprite));

            var mug:FlxSprite = new FlxSprite(430,151);
            mug.loadGraphic(BeerMugSprite,true, true, 118,166);
            mug.addAnimation("fill", [0,1,2,3,4,5,6,7,8,9,10], 5, false);
            add(mug);

            FlxG.mouse.show();

            //reset level and score.
            FlxG.level = 0;
            FlxG.score = 0;

            //TODO This should be on a timer
            mug.play("fill");
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

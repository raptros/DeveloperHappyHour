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
        public var cfg:Class = MeasuresConfig;

        override public function create():void
        {
            add(new FlxSprite(0,0, Resources.titleScreen));

            //run that mug filling animation
            var mug:FlxSprite = new FlxSprite(cfg.imgCfg.openMug.x, cfg.imgCfg.openMug.y);
            mug.loadGraphic(Resources.openingAnimationSprite,
                true, true, cfg.imgCfg.openMug.w, cfg.imgCfg.openMug.h);
            mug.addAnimation("fill", [0,1,2,3,4,5,6,7,8,9,10], 5, false);
            add(mug);

            FlxG.mouse.show();

            //reset level, lives, and scores
            FlxG.level = 0;
            FlxG.score = 0;
            FlxG.scores[1] = 3;

            //TODO This should be on a timer - what?
            mug.play("fill");
        }

        override public function update():void
        {
            //start the game
            if (FlxG.mouse.justReleased() || FlxG.keys.justPressed("SPACE")) 
            {
                FlxG.state = new ScoreShowState();
            }
            super.update();
        }
    }
}

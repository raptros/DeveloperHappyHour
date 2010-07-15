package
{    
    import org.flixel.*;
    
    public class PrepareState extends FlxState
    {
        
        public var cfg:Class = MeasuresConfig;

        private var tapping:FlxSprite;

        override public function create():void
        {
            var bg:FlxSprite = new FlxSprite();
            bg.createGraphic(FlxG.width, FlxG.height);
            bg.color=0x002449;
            add(bg);
            var prompter:FlxText = new FlxText(0, FlxG.height/4, FlxG.width, "GET READY TO SERVE");
            prompter.setFormat(null, cfg.fontSize, 0xdbff00, "center", 0);
            add(prompter);

            tapping = new FlxSprite((FlxG.width - cfg.imgCfg.prepImg.width) / 2,
                    (FlxG.height - cfg.imgCfg.prepImg.height)/2);

            tapping.loadGraphic(Resources.prepareImg, 
                    true, false, cfg.imgCfg.prepImg.width, cfg.imgCfg.prepImg.height);

            tapping.addAnimation("yoink", [0, 1], 1, false);
            add(tapping);
            tapping.play("yoink");
        }

        override public function update():void
        {
            if (tapping.finished)
            {
                FlxG.state = new PlayState(FlxG.levels[FlxG.level]);
            }
            super.update();
        }

    }
}

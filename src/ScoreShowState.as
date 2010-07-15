package
{
    import org.flixel.*;

    public class ScoreShowState extends FlxState
    {
        public var cfg:Class = MeasuresConfig;
        private var lifetime:Number=1.0;

        override public function create():void
        {
            
            var bgfill:FlxSprite = new FlxSprite(0,0).createGraphic(FlxG.width, FlxG.height);
            bgfill.color = 0x002449;
            add(bgfill);

            var prompter:FlxText = new FlxText(0, cfg.textCfg.prompter.y0, FlxG.width, "CLEAR ALL CUSTOMERS");
            prompter.setFormat(null, cfg.fontSize, 0xdbff00, "center", 0);
            add(prompter);

            prompter = new FlxText(0, cfg.textCfg.prompter.y1, FlxG.width, "TO ADVANCE");
            prompter.setFormat(null, cfg.fontSize, 0xdbff00, "center", 0);
            add(prompter); 

            var pts:Array = ["100 PTS", "50 PTS", "75 PTS", "100 PTS", "150 PTS", "1500 PTS"];
            var icons:Array = [Resources.iconMug, Resources.iconPatron1, Resources.iconPatron2,
                Resources.iconPatron3, Resources.iconPatron4, Resources.iconTip];
            var ylin:Number;

            var scoreLine:FlxText;
            
            for (var i:int=0; i < 6; i++)
            {
                ylin = cfg.textCfg.ptsLine.yinit + 3*cfg.fontSize*i;
                scoreLine = new FlxText(0, ylin, cfg.textCfg.ptsLine.w, pts[i]);
                scoreLine.setFormat(null, cfg.fontSize, 0xdbff00, "right", 0);
                add(scoreLine);
                add(new FlxSprite(cfg.imgCfg.strip.x, ylin + cfg.imgCfg.strip.offsets[i], icons[i]));
            }

        }

        override public function update():void
        {
            lifetime -= FlxG.elapsed;
            if (lifetime <= 0)
                FlxG.state = new PrepareState();
            super.update();
        }
    }

}

package
{    
    import org.flixel.*;
    
    public class PrepareState extends FlxState
    {
        
        [Embed(source="../build/assets/sprites-getready.png")]
        private var PrepareImg:Class;

        private var tapping:FlxSprite;

        override public function create():void
        {
            var bg:FlxSprite = new FlxSprite();
            bg.createGraphic(800, 480);
            bg.color=0x002449;
            add(bg);
            var prompter:FlxText = new FlxText(0, 120, 800, "GET READY TO SERVE");
            prompter.setFormat(null, 15, 0xdbff00, "center", 0);
            add(prompter);

            tapping = new FlxSprite(375, 206);
            tapping.loadGraphic(PrepareImg, true, false, 50, 68);
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

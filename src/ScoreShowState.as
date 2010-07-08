package
{
    import org.flixel.*;

    public class ScoreShowState extends FlxState
    {
        [Embed(source="../build/assets/icons-mug.png")]
        private var IconMug:Class;
        [Embed(source="../build/assets/icons-patron1.png")]
        private var IconPatron1:Class;
        [Embed(source="../build/assets/icons-patron2.png")]
        private var IconPatron2:Class;
        [Embed(source="../build/assets/icons-patron3.png")]
        private var IconPatron3:Class;
        [Embed(source="../build/assets/icons-patron4.png")]
        private var IconPatron4:Class;
        [Embed(source="../build/assets/icons-tip.png")]
        private var IconTip:Class;

        private var lifetime:Number=2.0;

        override public function create():void
        {
            
            var bgfill:FlxSprite = new FlxSprite(0,0).createGraphic(800,480);
            bgfill.color = 0x002449;
            add(bgfill);

            var prompter:FlxText = new FlxText(0, 80, 800, "CLEAR ALL CUSTOMERS");
            prompter.setFormat(null, 15, 0xdbff00, "center", 0);
            add(prompter);

            prompter = new FlxText(0, 110, 800, "TO ADVANCE");
            prompter.setFormat(null, 15, 0xdbff00, "center", 0);
            add(prompter); 

            var scoreLine:FlxText;

            scoreLine = new FlxText(0, 155, 460, "100 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 153, IconMug));

            scoreLine = new FlxText(0, 200, 460, "50 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 193, IconPatron1));
            
            scoreLine = new FlxText(0, 245, 460, "75 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 237, IconPatron2));
            
            scoreLine = new FlxText(0, 290, 460, "100 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 285, IconPatron3));

            scoreLine = new FlxText(0, 335, 460, "150 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 328, IconPatron4));
            
            scoreLine = new FlxText(0, 380, 460, "1500 PTS");
            scoreLine.setFormat(null, 15, 0xdbff00, "right", 0);
            add(scoreLine);
            add(new FlxSprite(340, 387, IconTip));
            
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

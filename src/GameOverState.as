package
{
    import org.flixel.*;
    
    /**
     * To be displayed after running out of lives.
     */
    public class GameOverState extends FlxState
    {
        
        public var cfg:Class = MeasuresConfig;

        private var over:FlxText;
        private var saved:FlxSave;
        private var scores:Array;
        private var highScored:Boolean = false;
        private var newScore:Object;
        private var newScorePosition:Number = -1;

        private var whichInitial:Number=0;//the index of the initial being input, 0 through 2
        private var whichLetter:Number=0;//what the current letter is, 0 through 26

        private var newScoreInitials:FlxText;


        override public function create():void
        {
            FlxG.mouse.show();

            saved = new FlxSave();
            if (saved.bind("dhh-save-test8"))
                scores = saved.data.scores as Array;
            if (!scores)
            {
                scores = new Array();
                saved.data.scores = scores;
            }
            var score:Object;


            var textItem:FlxText;
            var ypos:Number;
            
            if (!scores[0])
            {
                score = {value:FlxG.score, initials:""};
                scores.push(score);
                newScore = score;
                highScored = true;
                newScorePosition = 0;
            }
            for (var i:Number = 0; i < scores.length; i++)
            {
                score = scores[i];
                if (!highScored && score.value <= FlxG.score)
                {
                    score = {value:FlxG.score, initials:""};
                    newScorePosition = i;
                    scores.splice(i, 0, score);
                    if (scores.length > 10)
                        scores.pop();
                    highScored = true;
                    newScore = score;
                    break;
                }
            }
            if (!highScored && scores.length < 10)
            {
                score = {value:FlxG.score, initials:""};
                scores.push(score);
                newScorePosition = scores.length -1;
                highScored = true;
                newScore = score;
            }

                
            for (i=0; i < scores.length; i++)
            {
                score = scores[i];
                //display the current score.
                ypos = cfg.textCfg.scoreItem.y0 +i*cfg.textCfg.scoreItem.step;
                //index
                textItem = new FlxText(cfg.textCfg.scoreItem.x0, ypos, cfg.textCfg.scoreItem.w0, (i+1).toString());
                textItem.setFormat(null, cfg.fontSize, 0x2492ff,"left",0);
                add(textItem);

                //initials
                textItem = new FlxText(cfg.textCfg.scoreItem.x1, ypos, cfg.textCfg.scoreItem.w1, score.initials);
                if (i == newScorePosition)
                {
                    textItem.setFormat(null, cfg.fontSize, 0xFF0000,"left",0);
                    newScoreInitials = textItem;
                }
                else
                    textItem.setFormat(null, cfg.fontSize, 0x2492ff,"left",0);
                add(textItem);

                //score
                textItem = new FlxText(cfg.textCfg.scoreItem.x2, ypos, cfg.textCfg.scoreItem.w2, score.value.toString());
                textItem.setFormat(null, cfg.fontSize, 0x2492ff,"right",0);
                add(textItem);
            }

            //so a high score was added. throw up the signs telling user how to enter text.
            if (highScored)
            {
                textItem = new FlxText(0, FlxG.height / 20, FlxG.width, "ENTER YOUR INITIALS");
                textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
                add(textItem);
                
                var bottomLine:Number = cfg.textCfg.scoreItem.step * 9 + cfg.textCfg.scoreItem.y0 + cfg.fontSize;
                var hLowLine:Number = Math.round(bottomLine + (FlxG.height - bottomLine) / 2);

                textItem = new FlxText(0, hLowLine - cfg.fontSize, FlxG.width, "USE JOYSTICK TO SELECT LETTER");
                textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
                add(textItem);


                textItem = new FlxText(0, hLowLine + 1, FlxG.width, "USE TAPPER TO ENTER LETTER");
                textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
                add(textItem);

                add(new FlxSprite(Math.round((cfg.textCfg.scoreItem.x0 - cfg.imgCfg.goImg.width) / 2),
                            cfg.textCfg.scoreItem.y0+newScorePosition*cfg.textCfg.scoreItem.step - cfg.imgCfg.goImg.vOffset,
                            Resources.iconGameOver));

            }
            
            //over = new FlxText(0, 120, 800, "Game Over. Your score: " + FlxG.score + ".");
            //over.setFormat(null, 10, 0xffffff, "center", 0);
            //add(over);
        }

        override public function update():void
        {

            if (highScored)
            {
                var str:String = newScore.initials;
                
                //deal w/ keyboard input for selecting high score
                if (FlxG.keys.justPressed("UP"))
                    whichLetter = (whichLetter + 26) % 27;
                else if (FlxG.keys.justPressed("DOWN") || (FlxG.mouse.justPressed() && FlxG.mouse.x < 400))
                    whichLetter = (whichLetter + 1) % 27;
                else if (FlxG.keys.justPressed("LEFT"))
                {    
                    whichInitial = (whichInitial + 2) % 3;
                    whichLetter = str.charCodeAt(whichInitial) - 64;
                    if (whichLetter < 0)
                        whichLetter = 0;
                }
                else if (FlxG.keys.justPressed("RIGHT"))
                {    
                    whichInitial = (whichInitial + 1) % 3;
                    whichLetter = str.charCodeAt(whichInitial) - 64;
                    if (whichLetter < 0)
                        whichLetter = 0;
                }
                else if (FlxG.keys.justPressed("SPACE") || (FlxG.mouse.justPressed() && FlxG.mouse.x > 400))
                {
                    if (whichInitial < 3)
                    {
                        whichInitial++;
                        whichLetter = str.charCodeAt(whichInitial) - 64;
                        if (whichLetter < 0)
                            whichLetter = 0;
                    }
                    else
                        FlxG.state = new StartGameState();
                }
                
                //now, update the string.
                var arr:Array = new Array();
                for (var i:Number = 0; i < 3; i++)
                {
                    if (i >= str.length)
                        arr[i] = 32;
                    else
                        arr[i] = str.charCodeAt(i);
                }
                if (whichLetter == 0)
                    arr[whichInitial] = 32; //space
                else 
                    arr[whichInitial] = 64+whichLetter; //some uppercase letter
                
                str = String.fromCharCode(arr[0], arr[1], arr[2]);
                newScore.initials = str;
                newScoreInitials.text = str;
                
            }
            else if (FlxG.keys.justPressed("SPACE"))
            {
                FlxG.state = new StartGameState();
            }
            super.update();
        }
            
            
    }
}

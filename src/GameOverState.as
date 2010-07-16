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

        private var leftArrow:FlxText, rightArrow:FlxText, upArrow:FlxText, downArrow:FlxText;

        //private var newScoreInitials:FlxText;
        private var newInitials:Array;


        override public function create():void
        {
            FlxG.mouse.show();

            //load the high scores object
            saved = new FlxSave();
            if (saved.bind("dhh-save"))
                scores = saved.data.scores as Array;
            if (!scores)
            {
                scores = new Array();
                saved.data.scores = scores;
            }
            var score:Object;


            var textItem:FlxText;
            var ypos:Number;
            
            //find out if score can be inserted at the beginning
            if (!scores[0])
            {
                score = {value:FlxG.score, initials:""};
                scores.push(score);
                newScore = score;
                highScored = true;
                newScorePosition = 0;
            }
            //first loop: find out if score can be inserted in middle
            for (var i:Number = 0; i < scores.length; i++)
            {
                score = scores[i];
                if (highScored)
                    break; 
                else if (score.value <= FlxG.score)
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
            //find out if score can be inserted at end
            if (!highScored && scores.length < 10)
            {
                score = {value:FlxG.score, initials:""};
                scores.push(score);
                newScorePosition = scores.length -1;
                highScored = true;
                newScore = score;
            }

            newInitials = new Array();

            var xpos:Number;
            //second loop lay out the current high scores.
            for (i=0; i < scores.length; i++)
            {
                score = scores[i];
                //display the current score.
                ypos = cfg.textCfg.scoreItem.y0 +i*cfg.textCfg.scoreItem.s;
                //index
                textItem = new FlxText(cfg.textCfg.scoreItem.x0, ypos, cfg.textCfg.scoreItem.w0, (i+1).toString());
                textItem.setFormat(null, cfg.fontSize, 0x2492ff,"left",0);
                add(textItem);

                //initials - loop to position each separately.
                for (var j:Number = 0; j < 3; j++)
                {
                    xpos = cfg.textCfg.scoreItem.x1 + j * cfg.fontSize;
                    textItem = new FlxText(xpos, ypos, cfg.fontSize, score.initials.charAt(j));
                    //new high score text gets colored red.
                    if (i == newScorePosition)
                    {   
                        textItem.setFormat(null, cfg.fontSize, 0xFF0000,"center",0);
                        newInitials.push(textItem);
                    }
                    else
                        textItem.setFormat(null, cfg.fontSize, 0x2492ff,"center",0);
                    add(textItem);
                }

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
                
                //positioning line for the two lower pieces of text
                var bottomLine:Number = cfg.textCfg.scoreItem.s * 9 + cfg.textCfg.scoreItem.y0 + cfg.fontSize;
                var hLowLine:Number = Math.round(bottomLine + (FlxG.height - bottomLine) / 2);

                textItem = new FlxText(0, hLowLine - cfg.fontSize, FlxG.width, "USE JOYSTICK TO SELECT LETTER");
                textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
                add(textItem);

                textItem = new FlxText(0, hLowLine + 1, FlxG.width, "USE TAPPER TO ENTER LETTER");
                textItem.setFormat(null, cfg.fontSize, 0xFF0000, "center",0);
                add(textItem);

                var newItemPos:Number = cfg.textCfg.scoreItem.y0 + newScorePosition* cfg.textCfg.scoreItem.s;

                //game over pic points to the player's score line
                add(new FlxSprite(Math.round((cfg.textCfg.scoreItem.x0 - cfg.imgCfg.goImg.width) / 2),
                            newItemPos - cfg.imgCfg.goImg.vOffset,
                            Resources.iconGameOver));

                //add in arrows for displaying position and possible motions
                leftArrow = new FlxText(newInitials[0].left - cfg.fontSize, newInitials[0].y, cfg.fontSize, " ");
                leftArrow.setFormat(null, cfg.fontSize, 0xFF0000, "left", 0);
                add(leftArrow);

                rightArrow = new FlxText(newInitials[2].right, newInitials[0].y, cfg.fontSize, " ");
                rightArrow.setFormat(null, cfg.fontSize, 0xFF0000, "right", 0);
                add(rightArrow);

                upArrow = new FlxText(newInitials[0].left, newInitials[0].y - cfg.fontSize, cfg.fontSize, "+");
                upArrow.setFormat(null, cfg.fontSize, 0xFF0000, "center", 0);
                add(upArrow);

                downArrow = new FlxText(newInitials[0].left, newInitials[0].y + cfg.fontSize, cfg.fontSize, "-")
                downArrow.setFormat(null, cfg.fontSize, 0xFF0000, "center", 0);
                add(downArrow);

            }
        }

        override public function update():void        
        {
            if (highScored)
            {
                var str:String = newScore.initials;
                
                var clkX:Number = FlxG.mouse.x;
                var clkY:Number = FlxG.mouse.y;

                //figure out what motion needs to be done
                var letterUp:Boolean = FlxG.keys.justPressed("UP") ||
                    (FlxG.mouse.justPressed() && clkY < newInitials[0].top && clkX > newInitials[0].left && clkX < newInitials[2].right);

                var letterDown:Boolean = FlxG.keys.justPressed("DOWN") || 
                    (FlxG.mouse.justPressed() && clkY > newInitials[0].bottom && clkX > newInitials[0].left && clkX < newInitials[2].right);

                var letterLeft:Boolean = whichInitial > 0 && (FlxG.keys.justPressed("LEFT") ||
                        (FlxG.mouse.justPressed() && clkX < newInitials[0].left));

                var letterRight:Boolean = whichInitial < 2 && (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("SPACE") ||
                        (FlxG.mouse.justPressed() && clkX > newInitials[2].right));

                var doneEdit:Boolean = whichInitial == 2 && (FlxG.keys.justPressed("SPACE") || 
                        (FlxG.mouse.justPressed() && clkX > newInitials[2].right));

                //perform said motions
                if (letterUp)
                    whichLetter = (whichLetter + 26) % 27;
                else if (letterDown)
                    whichLetter = (whichLetter + 1) % 27;
                else if (letterLeft)
                {   
                    whichInitial--;
                    whichLetter = str.charCodeAt(whichInitial) - 64;
                    if (whichLetter < 0)
                        whichLetter = 0;
                }
                else if (letterRight)
                {    
                    whichInitial++;
                    whichLetter = str.charCodeAt(whichInitial) - 64;
                    if (whichLetter < 0)
                        whichLetter = 0;
                }
                else if (doneEdit)
                    FlxG.state = new StartGameState();

                //update the arrows.
                leftArrow.text = "<";
                rightArrow.text = ">";
                
                if (whichInitial == 0)
                    leftArrow.text = " ";
                else if (whichInitial == 2)
                    rightArrow.text = "/";

                upArrow.x = newInitials[whichInitial].left;
                downArrow.x = upArrow.x;

                
                //update the string.
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
                newScore.initials = str; //store the string
                for (i = 0; i < 3; i++) //update the display
                    newInitials[i].text = str.charAt(i);
                
            }
            else if (FlxG.keys.justPressed("SPACE") || FlxG.mouse.justPressed()) //no new highscore.
            {
                FlxG.state = new StartGameState();
            }
            super.update();
        }
            
            
    }
}

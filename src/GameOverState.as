package
{
    import org.flixel.*;
    
    /**
     * To be displayed after running out of lives.
     */
    public class GameOverState extends FlxState
    {
        
        [Embed(source="../build/assets/sprites-gameover.png")]
        private var GOPic:Class;

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
                ypos = 100+i*30;
                //index
                textItem = new FlxText(200, ypos, 50, (i+1).toString());
                textItem.setFormat(null, 15, 0x2492ff,"left",0);
                add(textItem);

                //initials
                textItem = new FlxText(250, ypos, 150, score.initials);
                if (i == newScorePosition)
                {
                    textItem.setFormat(null, 15, 0xFF0000,"left",0);
                    newScoreInitials = textItem;
                }
                else
                    textItem.setFormat(null, 15, 0x2492ff,"left",0);
                add(textItem);

                //score
                textItem = new FlxText(400, ypos, 200, score.value.toString());
                textItem.setFormat(null, 15, 0x2492ff,"right",0);
                add(textItem);
            }

            //so a high score was added. throw up the signs telling user how to enter text.
            if (highScored)
            {
                textItem = new FlxText(0, 40, 800, "ENTER YOUR INITIALS");
                textItem.setFormat(null, 15, 0xFF0000, "center",0);
                add(textItem);

                textItem = new FlxText(0, 418, 800, "USE JOYSTICK TO SELECT LETTER");
                textItem.setFormat(null, 15, 0xFF0000, "center",0);
                add(textItem);

                textItem = new FlxText(0, 434, 800, "USE TAPPER TO ENTER LETTER");
                textItem.setFormat(null, 15, 0xFF0000, "center",0);
                add(textItem);

                add(new FlxSprite(70, 92+newScorePosition*30, GOPic));

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
                else if (FlxG.keys.justPressed("DOWN"))
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
                else if (FlxG.keys.justPressed("SPACE"))
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

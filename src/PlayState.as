package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        //Assets
        [Embed(source="../build/assets/bar_background_modded.png")]
        private var BarSprite:Class;

        [Embed(source="../build/assets/sprites-tap.png")]
        private var BarTap:Class;

        //speeds
        private var playerStep:Number = 2;
        private var mugSpeed:Number = 100;
        
        //points for events
        private var giveMugPoints:Number = 1;
        private var collectMugPoints:Number = 2;
        private var pushOutPatronPoints:Number = 5;
        private var collectMoneyPoints:Number = 10;
    
        //level settings
        private var maxPatrons:Number;
        private var patronsToClear:Number;
        private var patronSpeed:Number; 
        private var pushBack:Number; //pixels
        private var patronGap:Number; //seconds
        private var whenMoney:Number;
        
        //position
        private var barNum:Number = 0;
        
        //time till next wave
        private var countDown:Number;

        //ARRAYS
        //rects
        private var bars:Array;
        //groups
        private var barMugs:Array;
        private var barPatrons:Array;
        private var moneyOnBars:Array;
        //sprites
        private var taps:Array;
        //points
        private var tapperPositions:Array;
        private var mugPositions:Array;
        private var patronPositions:Array;

        //counters
        private var patronsOut:Number = 0;
        private var mugsGiven:Number = 0;
        private var lives:Number;

        //animation freeze for dropping something
        private var freezer:Number;
        private var frozen:Boolean=false;
        private var oldFrame:Number;
        
        //state flags
        private var isSwitching:Boolean=false;
        private var isFilling:Boolean=false;
        
        //displays
        private var lifeCounter:FlxText;
        private var scoreDisp:FlxText;

        private var player:Player;


        /**
         * get all the settings for the level to be played.
         */
        public function PlayState(ls:LevelSettings)
        {
            super();
            maxPatrons = ls.maxPatrons;
            patronsToClear = ls.patronsToClear;
            patronSpeed = ls.patronSpeed;
            pushBack = ls.pushBack;
            patronGap = ls.patronGap;
            whenMoney = ls.whenMoney;
        }

        /**
         * sets up the place.
         */
        override public function create():void
        {

            //create bar background
            add(new FlxSprite(0, 0, BarSprite));

            FlxG.mouse.hide();

            //set life count
            lives = 3;
            lifeCounter = new FlxText(300, 10, 50, lives.toString());
            lifeCounter.setFormat(null, 8, 0xffffff, "right");
            add(lifeCounter);

            //display scores
            scoreDisp = new FlxText(0, 10, 50, FlxG.score.toString());
            scoreDisp.setFormat(null, 8, 0xffffff, "right");
            add(scoreDisp);

            countDown = 0; //so that they come right away.

            //arrays that contain information about the bars and their
            //locations and object groups.
            bars = new Array();
            barMugs = new Array();
            barPatrons = new Array();
            moneyOnBars = new Array();
            taps = new Array();
            tapperPositions = new Array();
            mugPositions = new Array();
            patronPositions = new Array();
                        
            bars[0] = new FlxRect(206, 133, 361, 37);
            bars[1] = new FlxRect(174, 209, 423, 37);
            bars[2] = new FlxRect(142, 284, 489, 37);
            bars[3] = new FlxRect(110, 360, 553, 37);

            var tapOffsets:Array=[5, 7, 5, 5];

            //var barShow:FlxSprite;
            // generate the bar groups and position arrays.
            for (var i:int = 0; i < bars.length; i++)
            {
                //barShow = new FlxSprite(bars[i].x, bars[i].y).createGraphic(bars[i].width, bars[i].height);
                //add(barShow);

                barMugs[i] = new FlxGroup();
                add(barMugs[i]);

                barPatrons[i] = new FlxGroup();
                add(barPatrons[i]);
                
                moneyOnBars[i] = new FlxGroup();
                add(moneyOnBars[i]);

                taps[i] = new FlxSprite(bars[i].right+tapOffsets[i], bars[i].top - 40); //+9, -40
                taps[i].loadGraphic(BarTap, false, false, 62,53);
                taps[i].addAnimation("filling", [1,2,3,4,5,6,7,8], 16, false);
                taps[i].frame=0;
                add(taps[i]);

                tapperPositions[i] = new FlxPoint(bars[i].right + tapOffsets[i] - 39, bars[i].top - 12);
                mugPositions[i] = new FlxPoint(bars[i].right - BeerMug.SIZE, bars[i].top-20);
                patronPositions[i] = new FlxPoint(bars[i].left, bars[i].top - 27);
            }
            
            player = new Player(tapperPositions[0]);
            add(player);

        }

        override public function update():void
        {
            //make sure text displays are up to date
            lifeCounter.text = lives.toString();
            scoreDisp.text = FlxG.score.toString();
            
            //test for level clear.
            if (patronsToClear <= patronsOut)
            {
                FlxG.state = new LevelClearedState(patronsOut);
            }

            //test for frozen (stops animations except one)
            if (frozen)
            {
                freezer -= FlxG.elapsed;
                if (freezer <= 0)
                {
                    frozen = false;
                    player.frame=0;
                    isFilling=false;
                }
                player.update();
                return ;
            }

            //test for done switching
            if (isSwitching && player.finished)
            {
                player.x = tapperPositions[barNum].x;
                player.y = tapperPositions[barNum].y;
                isSwitching = false;
                player.frame=0;
            }

            //test for game over
            if (lives <= 0)
            {
                FlxG.state = new GameOverState();
            }

            //IMPORTANT.
            super.update();

            //get references from the arrays.
            var curBar:FlxRect = bars[barNum];
            var curMugs:FlxGroup = barMugs[barNum];
            var curPatrons:FlxGroup = barPatrons[barNum];
            var curBase:FlxPoint = tapperPositions[barNum];

            var pos:FlxPoint;

            //Handle input.
            if (FlxG.keys.justPressed("SPACE") && player.x == curBase.x && player.y == curBase.y)
            { //run the filling animation
                isFilling=true;
                taps[barNum].play("filling");
                player.frame=11;
            }
            if (isFilling && !taps[barNum].finished && FlxG.keys.justReleased("SPACE"))
            { //mug didn't fill - player let go of tap too early.
                player.frame=0;
                taps[barNum].frame=0;
                isFilling=false;
            }
            else if (isFilling && FlxG.keys.justReleased("SPACE"))
            { //run the throwing animation, and throw a mug.
                player.play("throwing");
                taps[barNum].frame=0;
                isFilling=false;
                //chuck a mug from the current position. reuse available mug objects
                //by checking with the mug group.
                pos = mugPositions[barNum];
                var mug:BeerMug = curMugs.getFirstAvail() as BeerMug;
                if (!mug)
                {   //no available mugs-create a new one
                    mug = new BeerMug(pos.x, pos.y, curBar.left, curBar.right);
                    mug.whichBar = barNum;
                    mug.onDieLeft = mugDroppedLeft;
                    mug.onDieRight = mugDroppedRight;
                    curMugs.add(mug);
                }
                else
                {   //found one, make sure that it looks like a new one
                    mug.startPos = pos;
                }
                mug.full = true;
                mug.prepare();
                mug.velocity.x = -1*mugSpeed; //send it to the left
                mug.velocity.y = 0;
            }
            //move the player up or down a bar.
            else if (FlxG.keys.justPressed("UP") && !isFilling)
            {
                isSwitching=true;
                player.facing = FlxSprite.RIGHT;
                barNum--;
                if (barNum < 0)
                    barNum = bars.length - 1;
                player.play("switching");
            }
            else if (FlxG.keys.justPressed("DOWN")  && !isFilling)
            {
                isSwitching=true;
                player.facing = FlxSprite.RIGHT;
                barNum++;
                if (barNum >= bars.length)
                    barNum = 0;
                player.play("switching");
            }
            //move player left or right along bar
            else if (FlxG.keys.LEFT && player.x > curBar.left && !isFilling)
            {
                player.facing = FlxSprite.RIGHT;
                player.x -= playerStep;
                if (!isSwitching)
                    player.play("running");
            }
            else if (FlxG.keys.RIGHT && player.x < curBase.x && !isFilling)
            {
                player.facing = FlxSprite.LEFT;
                player.x += playerStep;
                if (!isSwitching)
                    player.play("running");
            }

            //stop the running.
            if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT && !isFilling && (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT")))
            {
                player.facing = FlxSprite.RIGHT;
                player.frame = 0;
            }
                
            //check overlap of player and empty mugs
            FlxU.overlap(player, curMugs, playerMugged);

            //check for overlap between player and money.
            FlxU.overlap(player, moneyOnBars[barNum], moneyCollect);

            //take a look at the countdown
            var patronTime:Boolean = false;
            var flip:Number;
            countDown -= FlxG.elapsed;
            if (countDown <= 0)
            {
                //reset, and flag for patron toss.
                countDown = patronGap;
                patronTime = true;
            }

            //Loop over the bars. add patrons if it is time. check overlaps between patrons and mugs.
            for (var i:int = 0; i < bars.length; i++)
            {
                curBar = bars[i];
                curMugs = barMugs[i];
                curPatrons = barPatrons[i];

                //see if we can add a patron at this time.
                if (patronTime && curPatrons.countLiving() < maxPatrons)
                {
                    //flip coin, add a patron if yes.
                    flip = Math.random();
                    if (flip > 0.5)
                    {
                        //This is the same process as for mugs - look for a patron
                        //object that isn't in play.
                        pos = patronPositions[i];
                        var patron:Patron = curPatrons.getFirstAvail() as Patron;
                        if (!patron)
                        {   //there isn't one available, so make a new one with right props
                            patron = new Patron(pos.x, pos.y, curBar.left, curBar.right);
                            patron.pushbackComplete = pushbackComplete;
                            patron.mugged = patronMugged;
                            patron.whichBar = i;
                            patron.onDieLeft = patronPushedOut;
                            patron.onDieRight = patronAttacks;
                            curPatrons.add(patron);
                        }
                        else
                        {   //get the one we found set up right.
                            patron.inPushBack = false;
                            patron.startPos = pos;
                        }
                        //send it along
                        patron.prepare();
                        patron.velocity.x = patronSpeed;
                        patron.velocity.y = 0;
                    }
                }

                //check for collisions between mugs and patrons
                //FlxU.overlap(curMugs, curPatrons, patronMugged);
                FlxU.collide(curMugs, curPatrons);
            }

        }

        /**
         * Callback for FlxU.overlap; when a mug has run into a patron, this gets called.
         * if a patron is already dealing with a mug, this doesn't do anything.
         * otherwise, it kills the mug and tells the patron to get pushed back.
         */
        public function patronMugged(mugObject:FlxObject, patronObject:FlxObject):void
        {
            var mug:BeerMug = mugObject as BeerMug;
            var patron:Patron = patronObject as Patron;
            //don't stop the mug if patron's already got one.
            if (patron.inPushBack)
                return ;
            //award points and stop patron and mug
            FlxG.score += giveMugPoints;
            mugsGiven++;

            mug.kill();
            patron.velocity.x = 0;
            patron.velocity.y = 0;
            //push back patron, and let it animate. when it finishes, it'll call pushbackComplete
            patron.inPushBack = true;
            patron.collideRight = false;
            patron.targetX = patron.x - pushBack;
        }

        /**
         * Callback from Patron for when it's done being pushed back,
         * i.e. the movements and animations are completed.
         * This function sends out an empty mug from the patron,
         * and sends the patron back towards the edge.
         * Note that a patron can be killed before this gets called -
         * if the patron gets pushed out of the bar.
         */
        public function pushbackComplete(patron:Patron):void
        {
            //patron.color = Patron.COLOR1;
            patron.velocity.x = patronSpeed;
            
            //we'll need these references soon.
            var curBar:FlxRect = bars[patron.whichBar];
            var curMugs:FlxGroup = barMugs[patron.whichBar];
            var curMoney:FlxGroup = moneyOnBars[patron.whichBar];

            var pos:FlxPoint = new FlxPoint(patron.right + 1, mugPositions[patron.whichBar].y)
            // the only difference between this bit of code and the code for
            //handling spacebar is the color,placement, and direction of the mug.
            var mug:BeerMug = curMugs.getFirstAvail() as BeerMug;
            if (!mug)
            {
                mug = new BeerMug(pos.x, pos.y, curBar.left, curBar.right);
                mug.whichBar = patron.whichBar;
                mug.onDieLeft = mugDroppedLeft;
                mug.onDieRight = mugDroppedRight;
                curMugs.add(mug);
            }
            else
                mug.startPos = pos;
            mug.full = false;
            mug.prepare();
            mug.velocity.x = mugSpeed / 2;
            
            pos.x = patron.x;
            pos.y = patron.bottom;
            //check up on dropping money
            if (mugsGiven >= whenMoney)
            {
                mugsGiven = 0;
                var money:Money = curMoney.getFirstAvail() as Money;
                if (!money)
                {
                    money = new Money(pos.x, pos.y, curBar.left, curBar.right);
                    money.whichBar = patron.whichBar;
                    curMoney.add(money);
                }
                else
                    money.startPos = pos;
                money.prepare();
            }

            patron.collideRight = true;
            patron.inPushBack = false;
        }

        /**
         * always lose in this case.
         */
        public function mugDroppedLeft(mug:BeerMug):void
        {
            lives--;
            frozen = true;
            freezer = 2.0;
            taps[barNum].frame=0;
            player.play("dropped");
        }

        /**
         * only lose if player isn't at that bar.
         */
        public function mugDroppedRight(mug:BeerMug):void
        {
            if (barNum == mug.whichBar)
                FlxG.score += collectMugPoints;
            else
            {
                lives--;
                frozen = true;
                freezer = 2.0;
                taps[barNum].frame=0;
                player.play("dropped");
            }
        }

        /**
        * never causes lose. it is a good thing.
        */
        public function patronPushedOut(patron:Patron):void
        {
            patronsOut++;
            FlxG.score += pushOutPatronPoints;
        }

        /**
         * always lose in this case.
         */
        public function patronAttacks(patron:Patron):void
        {
            lives--;
            frozen = true;
            freezer = 1.0;
            taps[barNum].frame=0;
        }

        /**
         * allows player to collect empty mugs. it's a callback for FlxU.overlap
         */
        public function playerMugged(playerObj:FlxObject, mugObj:FlxObject):void
        {
            var mug:BeerMug = mugObj as BeerMug;
            if (mug != null && !mug.full)
            {
                mug.kill();
                FlxG.score += collectMugPoints;
            }
        }

        /**
         * allows player to collect money. it's a callback for FlxU.overlap
         */
        public function moneyCollect(playerObj:FlxObject, moneyObj:FlxObject):void
        {
            FlxG.score += collectMoneyPoints;
            moneyObj.kill();
        }
    }
}

package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        public static var mugSpeed:Number = 100;
        public static var patronSpeed:Number = 5; 
        public static var pushBack:Number = 20; //pixels
        public static var patronGap:Number = 10.0; //seconds

        private var barNum:Number = 0;
        private var countDown:Number;

        private var scoreDisp:FlxText;

        private var scoreString:String;

        private var bars:Array;
        private var barMugs:Array;
        private var barPatrons:Array;
        private var tapperPositions:Array;
        private var mugPositions:Array;
        private var patronPositions:Array;

        private var maxPatrons:Number;
        private var patronsToClear:Number;

        private var mugsOnLeft:Number = 0, mugsOnRight:Number = 0;
        private var patronsOut:Number = 0, patronsUnstopped:Number = 0;

        private var freezer:Number;
        private var frozen:Boolean=false;

        private var lives:Number;
        private var lifeCounter:FlxText;

        private var player:Player;

        public function PlayState(maxPerBar:Number, numToClear:Number)
        {
            super();
            maxPatrons = maxPerBar;
            patronsToClear = numToClear;
        }

        /**
         * sets up the place.
         */
        override public function create():void
        {
            FlxG.mouse.hide();

            //set life count
            lives = 3;
            lifeCounter = new FlxText(350, 10, 40, lives.toString());
            lifeCounter.setFormat(null, 8, 0xffffff, "right");
            add(lifeCounter);

            countDown = 0; //so that they come right away.

            //arrays that contain information about the bars and their
            //locations and object groups.
            bars = new Array();
            barMugs = new Array();
            barPatrons = new Array();
            tapperPositions = new Array();
            mugPositions = new Array();
            patronPositions = new Array();
            
            bars[0] = new FlxRect(10, 50, 380, 10);
            bars[1] = new FlxRect(10, 110, 380, 10);
            bars[2] = new FlxRect(10, 170, 380, 10);
            
            var barShow:FlxSprite;
            // generate the bar groups and position arrays.
            for (var i:int = 0; i < bars.length; i++)
            {
                barShow = new FlxSprite(bars[i].x, bars[i].y).createGraphic(bars[i].width, bars[i].height);
                add(barShow);

                barMugs[i] = new FlxGroup();
                add(barMugs[i]);

                barPatrons[i] = new FlxGroup();
                add(barPatrons[i]);
                
                tapperPositions[i] = new FlxPoint(bars[i].right, bars[i].bottom);
                mugPositions[i] = new FlxPoint(bars[i].right - BeerMug.SIZE, bars[i].top);
                patronPositions[i] = new FlxPoint(bars[i].left, bars[i].top);
            }
            
            player = new Player(tapperPositions[0]);
            add(player);

        }

        override public function update():void
        {
            //make sure text displays are up to date
            lifeCounter.text = lives.toString();
            
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
                    frozen = false;
                return ;
            }

            //test for game over
            if (lives <= 0)
            {
                FlxG.state = new GameOverState();
            }

            //IMPORTANT.
            super.update();

            var curBar:FlxRect = bars[barNum];
            var curMugs:FlxGroup = barMugs[barNum];
            var curPatrons:FlxGroup = barPatrons[barNum];
            var pos:FlxPoint;

            //Handle input.
            if (FlxG.keys.justPressed("SPACE")) 
            {
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
                    mug.color = BeerMug.COLOR1;
                    mug.startPos = pos;
                }
                mug.prepare();
                mug.velocity.x = -1*mugSpeed; //send it to the left
                mug.velocity.y = 0;
            }
            //move the player up or down a bar.
            else if (FlxG.keys.justPressed("UP"))
            {
                barNum--;
                if (barNum < 0)
                    barNum = bars.length - 1;
                player.x = tapperPositions[barNum].x;
                player.y = tapperPositions[barNum].y;
            }
            else if (FlxG.keys.justPressed("DOWN"))
            {
                barNum++;
                if (barNum >= bars.length)
                    barNum = 0;
                player.x = tapperPositions[barNum].x;
                player.y = tapperPositions[barNum].y;
            }
            
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
                        {//there isn't one available, so make a new one with right props
                            patron = new Patron(pos.x, pos.y, curBar.left, curBar.right);
                            patron.pushbackComplete = pushbackComplete;
                            patron.mugged = patronMugged;
                            patron.whichBar = i;
                            patron.onDieLeft = patronPushedOut;
                            patron.onDieRight = patronAttacks;
                            curPatrons.add(patron);
                        }
                        else
                        {//get the one we found set up right.
                            patron.inPushBack = false;
                            patron.startPos = pos;
                            patron.color = Patron.COLOR1;
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
            mug.kill();
            patron.velocity.x = 0;
            patron.velocity.y = 0;
            patron.color = Patron.COLOR2;
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
            patron.color = Patron.COLOR1;
            patron.velocity.x = patronSpeed;
            var curBar:FlxRect = bars[patron.whichBar];
            var curMugs:FlxGroup = barMugs[patron.whichBar];

            var pos:FlxPoint = new FlxPoint(patron.right + 1, patron.y)
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
            mug.color = BeerMug.COLOR2;
            mug.prepare();
            mug.velocity.x = mugSpeed / 2;

            patron.collideRight = true;
            patron.inPushBack = false;
        }

        /**
         * always lose in this case.
         */
        public function mugDroppedLeft(mug:BeerMug):void
        {
            mugsOnLeft++;
            lives--;
            frozen = true;
            freezer = 1.0;
        }

        /**
         * only lose if player isn't at that bar.
         */
        public function mugDroppedRight(mug:BeerMug):void
        {
            if (barNum != mug.whichBar)
            {
                mugsOnRight++;
                lives--;
                frozen = true;
                freezer = 1.0;
            }
        }

        /**
        * never causes lose. it is a good thing.
        */
        public function patronPushedOut(patron:Patron):void
        {
            patronsOut++;
        }

        /**
         * always lose in this case.
         */
        public function patronAttacks(patron:Patron):void
        {
            patronsUnstopped++;
            lives--;
            frozen = true;
            freezer = 1.0;
        }

        public function updateScoreString():void
        {
            scoreString = "full mugs lost: " + mugsOnLeft + " empty mugs lost: " + mugsOnRight + " patrons out: " + patronsOut + " patrons unstopped: " + patronsUnstopped;
        }
    }
}

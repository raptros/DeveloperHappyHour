package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        public var cfg:Class = MeasuresConfig;

        //speeds
        private var speedfactor:Number;
        private var playerStep:Number = 2;
        private var mugSpeed:Number;
        
        //points for events
        private var collectMugPoints:Number = 100;
        private var collectMoneyPoints:Number = 1500;
    
        private var pushOutPatronPoints:Number;
        //level settings
        private var maxPatrons:Number;
        private var patronStep:Number; 
        private var pushBack:Number; //pixels
        private var patronGap:Number; //seconds
        private var probPatron:Number; //percent probability
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
        //objects
        private var tchs:Array; //touch points for switching.
        //points
        private var tapperPositions:Array;
        private var mugPositions:Array;
        private var patronPositions:Array;

        //counters
        //private var patronsOut:Number = 0;
        private var mugsGiven:Number = 0;
        private var patronCount:Number = 0;

        //animation freeze for dropping something
        private var freezer:Number;
        private var frozen:Boolean=false;
        private var oldFrame:Number;
        private var keepUpdating:FlxGroup;
        
        //state flags
        private var isSwitching:Boolean=false;
        private var isFilling:Boolean=false;
        private var doThrowOut:Boolean=false;
        private var mugChucked:Boolean=false;

        private var hitHead:Boolean=true;
        
        //displays
        private var lifeCounter:FlxText;
        private var scoreDisp:FlxText;
        private var debugDisp:FlxText;
        private var mon:FlxMonitor;

        //ugh.
        private var pushingPatron:Patron;
        private var spinner:SpinningBeer;

        private var player:Player;


        /**
         * get all the settings for the level to be played.
         */
        public function PlayState(ls:LevelSettings)
        {
            super();
            maxPatrons = ls.maxPatrons;
            patronStep = ls.patronStep;
            pushBack = ls.pushBack;
            patronGap = ls.patronGap;
            probPatron = ls.probPatron;
            whenMoney = ls.whenMoney;
            pushOutPatronPoints = ls.ptsPatron;

            speedfactor = cfg.speedFactor;
            playerStep = cfg.playerCfg.step;
            mugSpeed = cfg.mugCfg.speed;
        }

        //life counter.
        public function get lives():Number
        {
            return FlxG.scores[1];
        }

        public function set lives(value:Number):void
        {
            FlxG.scores[1]=value;
        }

        /**
         * sets up the place.
         */
        override public function create():void
        {

            //create bar background
            add(new FlxSprite(0, 0, Resources.barScreen));

            FlxG.mouse.hide();

            //set life count
            lifeCounter = new FlxText(cfg.textCfg.lifeCounter.x, cfg.textCfg.lifeCounter.y, cfg.textCfg.lifeCounter.w, lives.toString());
            lifeCounter.setFormat(null, cfg.fontSize, 0x2593ff, "right");
            add(lifeCounter);

            //display scores
            scoreDisp = new FlxText(cfg.textCfg.scoreDisp.x, cfg.textCfg.scoreDisp.y, cfg.textCfg.scoreDisp.w, FlxG.score.toString());
            scoreDisp.setFormat(null, cfg.fontSize, 0x2593ff, "right");
            add(scoreDisp);

            //set the countdown for patrons.
            countDown = patronGap; 

            //arrays that contain information about the bars and their locations and object groups.
            bars = cfg._bars;
            barMugs = new Array();
            barPatrons = new Array();
            moneyOnBars = new Array();
            taps = new Array();
            tchs = new Array();

            tapperPositions = new Array();
            mugPositions = new Array();
            patronPositions = new Array();
                        
            var tapOffsets:Array = cfg._tapOffsets;

            // generate the bar groups and position arrays.
            var pos:FlxPoint;
            var patron:Patron;
            for (var i:int = 0; i < bars.length; i++)
            {
                barMugs[i] = new FlxGroup();
                add(barMugs[i]);

                barPatrons[i] = new FlxGroup();
                add(barPatrons[i]);
                
                moneyOnBars[i] = new FlxGroup();
                add(moneyOnBars[i]);
                
                //position the bar-switch and tap-pull touch areas
                tchs[i] = new FlxObject(bars[i].right+tapOffsets[i], bars[i].top - cfg.tapCfg.vOffset,
                                        FlxG.width - (bars[i].right+tapOffsets[i]), bars[i].height+cfg.tapCfg.vOffset);
                add(tchs[i]);
                
                //position the tap sprites
                taps[i] = new FlxSprite(bars[i].right+tapOffsets[i], bars[i].top - cfg.tapCfg.vOffset); //+9, -40
                taps[i].loadGraphic(Resources.barTapSprite, false, false, cfg.tapCfg.width, cfg.tapCfg.height);
                taps[i].addAnimation("filling", [1,2,3,4,5,6,7,8], cfg.tapCfg.animFps, false);
                taps[i].addAnimation("highlight", [9], 1, false);
                taps[i].frame=0;
                add(taps[i]);

                //where the player starts when getting to a bar
                tapperPositions[i] = new FlxPoint(bars[i].right + tapOffsets[i] - cfg.playerCfg.hOffset, bars[i].top - cfg.playerCfg.vOffset);
                //initial positions for mugs
                mugPositions[i] = new FlxPoint(bars[i].right - cfg.mugCfg.width, bars[i].top - cfg.mugCfg.hOffset);
                //inital positions for patrons
                patronPositions[i] = new FlxPoint(bars[i].left, bars[i].top - cfg.patronCfg.vOffset);
                
                //deploy the maximum number of patrons right away.
                for (var p:int = 0; p < maxPatrons; p++)
                {
                    pos = new FlxPoint(patronPositions[i].x, patronPositions[i].y);
                    pos.x += p*cfg.patronCfg.width;
                    patron = new Patron(pos.x, pos.y, bars[i].left, bars[i].right);
                    patron.pushbackComplete = pushbackComplete;
                    patron.mugged = patronMugged;
                    patron.whichBar = i;
                    patron.onDieLeft = patronPushedOut;
                    patron.onDieRight = patronAttacks;
                    patron.moveStep = patronStep;
                    barPatrons[i].add(patron);
                    //send it along
                    patron.prepare();
                    patron.play("walk");
                    patronCount++;
                }
            }
            
            player = new Player(tapperPositions[0]);
            add(player);
            
            //highlight surrounding taps
            taps[(barNum + 1) % 4].play("highlight");
            taps[(barNum + 3) % 4].play("highlight");

        }

        override public function update():void
        {
            /* --State ending animation runner.--
                When an event occurs to end the state, the gameplay logic is suspended, and 
                a specific sequence of animations are run.
            */
            if (frozen)
            {   // deal with chained animations.
                //first, let the switch animation be completed
                if (isSwitching && !player.finished)
                {
                    player.update();
                }
                //and move onto the next part of the animation once that's done
                else if (isSwitching)
                {
                    player.x = tapperPositions[barNum].x;
                    player.y = tapperPositions[barNum].y;
                    isSwitching = false;
                    player.update();
                    //because the throwout animation will sometimes start with switching
                    if (doThrowOut)
                    {
                        //prepare player for sliding animation
                        player.frame=12;
                        player.y -= cfg.playerCfg.slideOffset;
                    }
                }
                //victory animation part 1 - victory dance - finished
                else if (player.isDancing && player.finished)
                {
                    player.isDancing = false;
                    player.x = tapperPositions[barNum].x;
                    player.y = tapperPositions[barNum].y;
                    keepUpdating.add(taps[barNum]);
                    taps[barNum].play("filling");
                    player.frame=11;
                    isFilling = true;
                    player.isDrinking = true;
                }
                //victory animation part 2 - filling mug - finished
                else if (player.isDrinking && isFilling && taps[barNum].finished)
                {
                    taps[barNum].frame = 0;
                    isFilling = false;
                    player.isDrinking=true;
                    player.play("drink");

                }
                //victory animation part 3 - taking a drink - finished
                else if (player.isDrinking && !isFilling && player.finished)
                {
                    player.isDrinking=false;
                    //start up animation for mug chucking
                    flip = Math.random(); //decide which ending it will have
                    hitHead = flip <= 0.5;

                    mugChucked = true;
                    //get that spining beer onto the screen
                    spinner = new SpinningBeer(player, hitHead);
                    add(spinner);
                    keepUpdating.add(spinner);
                    player.frame = 0;
                    player.facing = FlxSprite.LEFT;
                    spinner.frame=2;
                }
                //victory animation part 4 - mug chuck - just as breaking
                else if (mugChucked && spinner.sNum == SpinningBeer.S_BREAK)
                {   
                    //have the player do the correct response for the ending
                    player.facing = FlxSprite.RIGHT;
                    if (hitHead)
                        player.play("dropped");
                    else 
                        player.play("kick");
                    keepUpdating.update();
                }
                //victory animation is complete
                else if (mugChucked && spinner.done)
                {
                    mugChucked = false;
                    freezer = 0;
                }
                //when not at a state boundary, keep updating the animations
                else
                {
                    //keep the player right in front of the patron if it's that
                    //animation
                    if (doThrowOut)
                        player.x = pushingPatron.x - 5;
                    freezer -= FlxG.elapsed;
                    if (keepUpdating != null)
                        keepUpdating.update();
                }
                //once the animation is over, transition to a different state.
                if (freezer <= 0)
                {
                    //game over
                    if (lives < 0)
                        FlxG.state = new GameOverState();
                    //level clear.
                    else if (patronCount <= 0)
                    {
                        FlxG.level++;
                        if (FlxG.level < FlxG.levels.length)
                            FlxG.state = new PrepareState();
                        else
                            FlxG.state = new GameOverState();
                    }
                    //life loss situation
                    else
                        FlxG.state = new PrepareState();
                }
                return ;
            }
            /* --End of ending animations-- */

            //make sure text displays are up to date
            lifeCounter.text = lives.toString();
            scoreDisp.text = FlxG.score.toString();
            
            //get back to normal once switching is finished
            if (isSwitching && player.finished)
            {
                player.x = tapperPositions[barNum].x;
                player.y = tapperPositions[barNum].y;
                isSwitching = false;
                player.frame=0;
            }

            //get references from the arrays.
            var curBar:FlxRect = bars[barNum];
            var curMugs:FlxGroup = barMugs[barNum];
            var curPatrons:FlxGroup = barPatrons[barNum];
            var curBase:FlxPoint = tapperPositions[barNum];

            var pos:FlxPoint;

            /* -- Input Handling --
                deals with keyboard events and mouse events.
                This lets controls be either keyboard or mouse or even touchscreen.
            */

            //figure out what needs to be done based on input and constraints.
            var pressedTapper:Boolean = !isFilling && player.x == curBase.x && player.y == curBase.y && 
                                            (FlxG.keys.SPACE || (FlxG.mouse.pressed() &&
                                                tchs[barNum].overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)));

            var releasedTapper:Boolean = isFilling && (FlxG.keys.justReleased("SPACE") || FlxG.mouse.justReleased());

            var canceledTapper:Boolean = isFilling && FlxG.mouse.pressed() && !tchs[barNum].overlapsPoint(FlxG.mouse.x, FlxG.mouse.y);
            
            var choseTapUp:Boolean = !isSwitching && (FlxG.keys.justPressed("UP") || (FlxG.mouse.pressed() && 
                                                            tchs[(barNum + 3) % 4].overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)));

            var choseTapDown:Boolean = !isSwitching && (FlxG.keys.justPressed("DOWN") || (FlxG.mouse.pressed() && 
                                                            tchs[(barNum + 1) % 4].overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)));

            var goLeft:Boolean = player.x > curBar.left && (FlxG.keys.LEFT || (FlxG.mouse.pressed() && FlxG.mouse.x < player.x));
            var goRight:Boolean = player.x < curBase.x && (FlxG.keys.RIGHT || (FlxG.mouse.pressed() && FlxG.mouse.x > player.right));

            //run the filling animation
            if (pressedTapper)
            {
                isFilling=true;
                taps[barNum].play("filling");
                player.frame=11;
                player.facing = FlxSprite.RIGHT;
            }
            //mug didn't fill - player let go of tap too early or canceled.
            if ((releasedTapper && !taps[barNum].finished) || canceledTapper)
            { 
                player.frame=0;
                taps[barNum].frame=0;
                isFilling=false;
            }
            //run the throwing animation, and throw a mug.
            else if (releasedTapper)
            { 
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
            /* Bar movements - these actions cancel a filling operation and run some animation.*/
            else if (choseTapUp || choseTapDown || goLeft || goRight)
            {
                if (isFilling)
                {
                    isFilling = false;
                    taps[barNum].frame = 0;
                }
                //switch bars up or down
                if (choseTapUp || choseTapDown)
                {
                    //dehighlight taps.
                    taps[(barNum + 1) % 4].frame = 0;
                    taps[(barNum + 3) % 4].frame = 0;

                    //find bar up or down one.
                    barNum = choseTapUp ? (barNum + 3) % 4 : (barNum + 1) % 4;

                    //highlight surrounding taps
                    taps[(barNum + 1) % 4].play("highlight");
                    taps[(barNum + 3) % 4].play("highlight");

                    player.facing = FlxSprite.RIGHT;
                    isSwitching = true;
                    player.play("switching")
                }
                //run left or right
                else
                {
                    // don't do this animation if switching
                    if (!isSwitching)
                        player.play("running");
                    player.facing = goLeft ? FlxSprite.RIGHT : FlxSprite.LEFT; //decide which way to face
                    goLeft ? player.x -= playerStep : player.x += playerStep; //decide which way to move the player.
                }
            }
            //stops the running.
            else if (!isFilling && !isSwitching && (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.mouse.justReleased()))
            {
                player.facing = FlxSprite.RIGHT;
                player.frame = 0;
                player.finished=true;
            }

            /*--IMPORTANT.--*/
            super.update();
                
            /* --Overlap/collision detection-- */

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

                //check for collisions between mugs and patrons
                FlxU.collide(curMugs, curPatrons);

                //see if we can add a patron at this time.
                if (patronTime && curPatrons.countLiving() < maxPatrons)
                {
                    //flip coin, add a patron if yes.
                    flip = Math.random();
                    if (flip < probPatron)
                    {
                        //This is the same process as for mugs - look for a patron
                        //object that isn't in play. 
                        pos = patronPositions[i];
                        var patron:Patron = curPatrons.getFirstAvail() as Patron;
                        //get the one we found set up right.
                        patron.inPushBack = false;
                        patron.startPos = pos;
            
                        //send it along
                        patron.prepare();
                        patronCount++;
                        patron.play("walk");
                    }
                }
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
            //push back patron, and let it animate. when it finishes, it'll call pushbackComplete
            patron.inPushBack = true;
            patron.isAnimating=false;
            patron.collideRight = false;
            patron.targetX = patron.x - pushBack;
            patron.play("catch");
            //count mugs; is it time to drop money?
            mugsGiven++;
            if (mugsGiven >= whenMoney)
            {
                patron.doBurp = true;
                mugsGiven = 0;
            }

        }

        /**
         * Callback from Patron for when it's done being pushed back, i.e. the movements and animations are completed.
         * This function sends out an empty mug from the patron, and sends the patron back towards the edge.
         * Note that a patron can be killed before this gets called - if the patron gets pushed out of the bar.
         */
        public function pushbackComplete(patron:Patron):void
        {
            //we'll need these references soon.
            var curBar:FlxRect = bars[patron.whichBar];
            var curMugs:FlxGroup = barMugs[patron.whichBar];
            var curMoney:FlxGroup = moneyOnBars[patron.whichBar];
            var pos:FlxPoint = new FlxPoint(patron.right, mugPositions[patron.whichBar].y)

            // Same principle as mug generator for filling.
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

            //check up on whether or not the patron is supposed to drop money.
            if (patron.doBurp)
            {
                patron.doBurp = false;
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
         * callback from a mug falling off left end of bar - always lose in this case.
         */
        public function mugDroppedLeft(mug:BeerMug):Boolean
        {
            //if already frozen, don't do anything.
            if (frozen)
                return false;
            //prepare the freeze
            frozen = true;
            freezer = 1.0;
            keepUpdating = new FlxGroup();
            keepUpdating.add(player);
            keepUpdating.add(mug);

            //stop the filling animation - otherwise the overlay will stick around and look weird
            if (isFilling)
            {
                taps[barNum].frame = 0;
                isFilling = false;
                keepUpdating.add(taps[barNum]);
            }
            //dehighlight taps.
            taps[(barNum + 1) % 4].frame = 0;
            taps[(barNum + 3) % 4].frame = 0;

            //now do animation and game data updates.
            lives--;
            player.play("dropped");

            //mug should do a little arc before crashing on floor.
            mug.dropping = true;
            mug.angle = 315;
            mug.targetY = mug.y + cfg.mugCfg.dropHeight; //whatever the "height" of the bar is.
            mug.velocity.x /= speedfactor;
            mug.acceleration.y = cfg.mugCfg.accel;

            if (lives < 0)
                displayGameOver();
            return false;//hang onto the mug
        }

        /**
         * callback from a beermug hitting the right end of the bar 
         * if the player is in position to catch it, then it won't fall off
         */
        public function mugDroppedRight(mug:BeerMug):Boolean
        {
            if (barNum == mug.whichBar && player.x >= mug.x)
            {
                //increase the score and kill the mug
                FlxG.score += collectMugPoints;
                return true;
            }
            //ignore callback if freeze is already in effect
            else if (frozen)
                return false;
            else
            {
                //prepare the freeze
                frozen = true;
                freezer = 1.0;
                keepUpdating = new FlxGroup();
                keepUpdating.add(player);
                keepUpdating.add(mug);
                //stop the filling animation - otherwise the overlay will stick around and look weird
                if (isFilling)
                {
                    taps[barNum].frame = 0;
                    isFilling = false;
                    keepUpdating.add(taps[barNum]);
                }
                //dehighlight taps.
                taps[(barNum + 1) % 4].frame = 0;
                taps[(barNum + 3) % 4].frame = 0;

                //now do animation and game data updates.
                lives--;
                player.play("dropped");

                mug.dropping = true;
                mug.angle = 45;
                mug.targetY = mug.y + cfg.mugCfg.dropHeight; //whatever the "height" of the bar is.
                mug.acceleration.y = cfg.mugCfg.accel;

                if (lives < 0)
                    displayGameOver();
                return false;
            }
        }

        /**
         * Callback from patron that hits the left edge of the bar. 
         * during gameplay, this is a good thing. during the freeze
         * it means the pushout animation is nearly done
         */
        public function patronPushedOut(patron:Patron):Boolean
        {
            //finish up the pushout animation
            if (frozen)
            {   
                freezer = 0.5;
                player.kill();
                return true;
            }
            //decrease the patron count and award points
            patronCount--;
            FlxG.score += pushOutPatronPoints;
            //the level has been cleared, run the victory animation
            if (patronCount <= 0)
            {
                //prepare for freeze
                frozen = true;
                freezer = 10.0;
                keepUpdating = new FlxGroup();
                keepUpdating.add(player);
                //dehighlight taps.
                taps[(barNum + 1) % 4].frame = 0;
                taps[(barNum + 3) % 4].frame = 0;
                //get those animation going!
                player.play("dance");
                player.isDancing=true;
            }
            return true;
        }

        /**
         * callback from patron hitting right end of bar, which
         * is like losing a mug. runs the push out animation
         */
        public function patronAttacks(patron:Patron):Boolean
        {
            //don't do anything during the freeze
            if (frozen)
                return false;
            //prepare for the  freeze
            frozen = true;
            freezer = 10.0;
            keepUpdating = new FlxGroup();
            keepUpdating.add(player);
            keepUpdating.add(patron); 
            //stop the flling animation if it's running
            if (isFilling)
            {
                taps[barNum].frame = 0;
                isFilling = false;
                keepUpdating.add(taps[barNum]);
            }
            //dehighlight taps.
            taps[(barNum + 1) % 4].frame = 0;
            taps[(barNum + 3) % 4].frame = 0;
            //figure out where the patron is
            player.facing = FlxSprite.RIGHT;
            var curBase:FlxPoint = tapperPositions[patron.whichBar];
            //move the player to that bar and position if neccesary
            if (barNum != patron.whichBar && player.x != curBase.x && player.y != curBase.y)
            {
                isSwitching=true;
                barNum = patron.whichBar;
                player.play("switching");
            }
            //otherwise just get ready for the animation
            else
            {
                player.frame=12;
                player.y -= cfg.playerCfg.slideOffset;
            }
            //get the patron ready for the animation
            patron.facing = FlxSprite.LEFT;
            patron.targetX = bars[barNum].x - 5;
            doThrowOut = true;
            pushingPatron = patron;
            patron.deltaX = 2 * patron.deltaX; //speed this way up!
            
            //lose a life
            lives--;
            if (lives < 0)
                displayGameOver();
            return false;
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
        
        /**
         * throws up the game over display
         */
        public function displayGameOver():void
        {
            var gameOver:FlxText = new FlxText(0, FlxG.height * 11 / 12, FlxG.width, "GAME OVER");
            gameOver.setFormat(null, cfg.fontSize, 0xdbff00, "center", 0);
            add(gameOver);
            if (keepUpdating != null)
                keepUpdating.add(gameOver);
        }
    }
}

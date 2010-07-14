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
            add(new FlxSprite(0, 0, BarSprite));

            FlxG.mouse.hide();

            //set life count
            lifeCounter = new FlxText(cfg.textCfg.lifeCounter.x, cfg.textCfg.lifeCounter.y, cfg.textCfg.lifeCounter.w, lives.toString());
            lifeCounter.setFormat(null, cfg.fontSize, 0x2593ff, "right");
            add(lifeCounter);

            //display scores
            scoreDisp = new FlxText(cfg.textCfg.scoreDisp.x, cfg.textCfg.scoreDisp.y, cfg.textCfg.scoreDisp.w, FlxG.score.toString());
            scoreDisp.setFormat(null, cfg.fontSize, 0x2593ff, "right");
            add(scoreDisp);

            /*CONFIG::debugdisp
            {
                mon = new FlxMonitor(8);
                debugDisp = new FlxText(200, 460, 100, "0");
                debugDisp.setFormat(null, 15, 0x2593ff, "right");
                add(debugDisp);
            }*/

            //set the countdown for patrons.
            countDown = patronGap; 

            //arrays that contain information about the bars and their
            //locations and object groups.
            //bars = new Array();
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
                
                tchs[i] = new FlxObject(bars[i].right+tapOffsets[i], bars[i].top - cfg.tapCfg.vOffset,
                                        FlxG.width - (bars[i].right+tapOffsets[i]), bars[i].height+cfg.tapCfg.vOffset);
                add(tchs[i]);
                
                taps[i] = new FlxSprite(bars[i].right+tapOffsets[i], bars[i].top - cfg.tapCfg.vOffset); //+9, -40
                taps[i].loadGraphic(BarTap, false, false, cfg.tapCfg.width, cfg.tapCfg.height);
                taps[i].addAnimation("filling", [1,2,3,4,5,6,7,8], cfg.tapCfg.animFps, false);
                taps[i].frame=0;
                add(taps[i]);



                tapperPositions[i] = new FlxPoint(bars[i].right + tapOffsets[i] - cfg.playerCfg.hOffset, bars[i].top - cfg.playerCfg.vOffset);
                
                mugPositions[i] = new FlxPoint(bars[i].right - cfg.mugCfg.width, bars[i].top - cfg.mugCfg.hOffset);
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

        }

        override public function update():void
        {
            //Update the fps meter.
            CONFIG::debugdisp
            {
                mon.add(FlxG.elapsed*1000);
                debugDisp.text = "" + uint(1000/mon.average());
                debugDisp.update();
            }
            /* --State ending animation runner.--
                When an event occurs to end the state, the gameplay logic is suspended, and 
                a specific sequence of animations are run.
            */
            if (frozen)
            {
                //Deal with animation chains.
                if (isSwitching && !player.finished)
                {
                    player.update();
                }
                else if (isSwitching)
                {
                    player.x = tapperPositions[barNum].x;
                    player.y = tapperPositions[barNum].y;
                    isSwitching = false;
                    player.update();
                    if (doThrowOut)
                    {
                        //do something w/player
                        player.frame=12;
                        player.y -= 15;
                    }
                }
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
                else if (player.isDrinking && isFilling && taps[barNum].finished)
                {
                    taps[barNum].frame = 0;
                    isFilling = false;
                    player.isDrinking=true;
                    player.play("drink");

                }
                else if (player.isDrinking && !isFilling && player.finished)
                {
                    player.isDrinking=false;
                    //animation after this is mug throwing.
                    //freezer = 0;
                    flip = Math.random();
                    hitHead = flip <= 0.5;

                    mugChucked = true;
                    spinner = new SpinningBeer(player, hitHead);
                    add(spinner);
                    keepUpdating.add(spinner);
                    player.frame = 0;
                    player.facing = FlxSprite.LEFT;
                    spinner.frame=2;
                }
                else if (mugChucked && spinner.sNum == SpinningBeer.S_BREAK)
                {
                    player.facing = FlxSprite.RIGHT;
                    if (hitHead)
                        player.play("dropped");
                    else 
                        player.play("kick");
                    keepUpdating.update();
                }
                else if (mugChucked && spinner.done)
                {
                    mugChucked = false;
                    freezer = 0;
                }
                else
                {
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
            /* --End of EOS animation -- */

            //make sure text displays are up to date
            lifeCounter.text = lives.toString();
            scoreDisp.text = FlxG.score.toString();
            
            //test for done switching
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
            /* Bar movements - these events cancel a filling operation and run some animation.*/
            //move the player up one bar. The !isSwitching makes it one bar at a time.
            else if (choseTapUp)
            {
                if (isFilling)
                {
                    isFilling = false;
                    taps[barNum].frame = 0;
                }
                isSwitching=true;
                player.facing = FlxSprite.RIGHT;
                barNum = (barNum + 3) % 4;
                /*if (barNum < 0)
                    barNum = bars.length - 1;*/
                player.play("switching");
            }
            //move the player down one bar.
            else if (choseTapDown)
            {
                if (isFilling)
                {
                    isFilling = false;
                    taps[barNum].frame = 0;
                }
                isSwitching=true;
                player.facing = FlxSprite.RIGHT;
                barNum = (barNum + 1) % 4;
                /*if (barNum >= bars.length)
                    barNum = 0;*/
                player.play("switching");
            }
            //move player left along bar
            else if (goLeft)
            {
                if (isFilling)
                {
                    isFilling = false;
                    taps[barNum].frame = 0;
                }
                player.facing = FlxSprite.RIGHT;
                player.x -= playerStep;
                if (!isSwitching)
                    player.play("running");
            }
            //move player right along bar
            else if (goRight)
            {
                if (isFilling)
                {
                    isFilling = false;
                    taps[barNum].frame = 0;
                }
                player.facing = FlxSprite.LEFT;
                player.x += playerStep;
                if (!isSwitching)
                    player.play("running");
            }

            //stops the running.
            if (!goLeft && !goRight && !isFilling && !isSwitching && (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.mouse.justReleased()))
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
         * Callback from Patron for when it's done being pushed back,
         * i.e. the movements and animations are completed.
         * This function sends out an empty mug from the patron,
         * and sends the patron back towards the edge.
         * Note that a patron can be killed before this gets called -
         * if the patron gets pushed out of the bar.
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
         * always lose in this case.
         */
        public function mugDroppedLeft(mug:BeerMug):Boolean
        {
            if (frozen)
                return false;
            //prepare for freezing most of the animations.
            frozen = true;
            freezer = 2.0;
            keepUpdating = new FlxGroup();
            keepUpdating.add(player);
            keepUpdating.add(mug);
            if (isFilling)
            {
                taps[barNum].frame = 0;
                isFilling = false;
                keepUpdating.add(taps[barNum]);
            }

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
         * only lose if player isn't at that bar.
         */
        public function mugDroppedRight(mug:BeerMug):Boolean
        {
            if (barNum == mug.whichBar)
            {
                FlxG.score += collectMugPoints;
                return true;
            }
            else if (frozen)
                return false;
            else
            {
                //prepare for freezing most of the animations.
                frozen = true;
                freezer = 2.0;
                keepUpdating = new FlxGroup();
                keepUpdating.add(player);
                keepUpdating.add(mug);
                if (isFilling)
                {
                    taps[barNum].frame = 0;
                    isFilling = false;
                    keepUpdating.add(taps[barNum]);
                }

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
        * never causes lose. it is a good thing.
        */
        public function patronPushedOut(patron:Patron):Boolean
        {
            if (frozen)
            {   
                freezer = 0.5;
                player.kill();
                return true;
            }
            patronCount--;
            FlxG.score += pushOutPatronPoints;
            if (patronCount <= 0)
            {
                //prepare for freezing most of the animations.
                frozen = true;
                freezer = 10.0;
                keepUpdating = new FlxGroup();
                keepUpdating.add(player);
                //get those animation going!
                player.play("dance");
                player.isDancing=true;
            }
            return true;
        }

        /**
         * always lose in this case.
         */
        public function patronAttacks(patron:Patron):Boolean
        {
            if (frozen)
                return false;
            //prepare for freezing most of the animations.
            frozen = true;
            freezer = 10.0;
            keepUpdating = new FlxGroup();
            keepUpdating.add(player);
            keepUpdating.add(patron); 
            //move the player to where the patron is.
            if (isFilling)
            {
                taps[barNum].frame = 0;
                isFilling = false;
                keepUpdating.add(taps[barNum]);
            }
            player.facing = FlxSprite.RIGHT;
            var curBase:FlxPoint = tapperPositions[patron.whichBar];
            if (barNum != patron.whichBar && player.x != curBase.x && player.y != curBase.y)
            {
                isSwitching=true;
                barNum = patron.whichBar;
                player.play("switching");
            }
            else
            {
                player.frame=12;
                player.y -= 15;
            }
            //get ready for throwout anim

            patron.facing = FlxSprite.LEFT;
            patron.targetX = bars[barNum].x - 5;
            doThrowOut = true;
            pushingPatron = patron;
            patron.deltaX = 2 * patron.deltaX; //speed this way up!
            
            //now do maintainence.
            lives--;
            //animate interaction between player and patron.
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
            var gameOver:FlxText = new FlxText(0, 440, 800, "GAME OVER");
            gameOver.setFormat(null, 15, 0xdbff00, "center", 0);
            add(gameOver);
            if (keepUpdating != null)
                keepUpdating.add(gameOver);
        }
    }
}

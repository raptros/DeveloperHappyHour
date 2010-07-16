package
{
    import org.flixel.FlxRect;
    /**
     * Contains measurements for laying out sprites and timing animations. has two 
     * separate configurations, for mobile vs desktop versions.
     */
    public class MeasuresConfig
    {
        public static var _bars:Array; 
        public static var _tapOffsets:Array;

        public static var patronCfg:Object, playerCfg:Object, mugCfg:Object, tapCfg:Object, moneyCfg:Object, textCfg:Object, imgCfg:Object;
        
        public static var speedFactor:Number = 3.0; 
        
        public static var fontSize:Number = 15;

        /*static constructor. */
        {
            _bars = new Array();
            
            if (CONFIG::mobile)
            {
                fontSize = 7;
                //rectangles describing the positions of the 4 bars
                _bars[0] = new FlxRect(103, 67, 181, 19); //206, 133, 361, 37
                _bars[1] = new FlxRect(87, 105, 212, 19); // 174, 209, 423, 37
                _bars[2] = new FlxRect(71, 142, 245, 19); // 142, 284, 489, 37
                _bars[3] = new FlxRect(55, 180, 277, 19); //110, 360, 553, 37

                //offsets for placing the taps.
                _tapOffsets = [2, 4, 3, 3];
                //_tapOffsets = [5, 7, 5, 5];
                
                mugCfg = {
                    width       : 16, //width of mug image
                    height      : 13, //height of mug image
                    hOffset     : 10, //how far up from the bar the mug should be placed 
                    speed       : 50 * speedFactor, //velocity going left
                    accel       : 1000 * speedFactor, //acceleration y on the fall animation
                    dropHeight  : 20, //how far the fall animation needs to drop the mug
                    throwHeight : 50, //how far up the mug goes in the level clear animation
                    throwSpeed  : -150 * speedFactor //how fast the mug goes up
                };
                patronCfg = {
                    width      : 30, //59 width of a patron frame
                    height     : 16, //31 height of a patron frame
                    vOffset    : 16, //29 how far up the patrons need to be initially placed
                    correction : 2.0, //3.0 the vertical correction when the patron does the catch animation
                    burpTime   : 1.0 / speedFactor, //how long the burp animation should run
                    drinkTime  : 2.5 / speedFactor, //" drink "
                    rantTime   : 1.0 / speedFactor, //" rant "
                    deltaX     : 1.0 * speedFactor, //how many pixels the patron should move each time update gets called
                    walkFps    : 6 * speedFactor, //how fast the walk animation should run
                    rantFps    : 4 * speedFactor, //" rant "
                    catchFps   : 1 * speedFactor, //" catch "
                    drinkFps   : 2 * speedFactor, //" drink "
                    burpFps    : 2 * speedFactor  //" burp "
                };
                playerCfg = {
                    width       : 33, //65 width of player frame
                    height      : 26, //51 height of same
                    step        : 1 * speedFactor, //how many pixels player should move each update when running along bar
                    throwFps    : 2 * speedFactor, //how fast throw animation should run
                    runFps      : 12 * speedFactor, // " run "
                    switchFps   : 25 * speedFactor, // " switch "
                    hOffset     : 19, //39 horizontal offset from a tap at a bar
                    vOffset     :  6,  //12 vertical offset from the top of bar
                    slideOffset :  8 //15 how far up the player needs to be moved when doing the thrown-out animation

                };
                tapCfg = {
                    width   : 31, //62 width of tap fram
                    height  : 27, //53 height of tap frame 
                    animFps :  8 * speedFactor, //16 how fast the filling animation should run
                    vOffset : 20  //40 how far up from the bar the tap should be placed
                };
                moneyCfg = {w: 14, h: 7}; //27, 13 size of the tip image
                textCfg = {
                    lifeCounter : {x: 200, y: 2, w: 100}, //400, 5, 200 position of life coutner 
                    scoreDisp   : {x: 0, y: 2, w: 100}, //0, 5, 200 position of score counter
                    //reference points for laying out the scores on the game over scren
                    scoreItem   : {x0:100, x1:125, x2:200, w0:25, w1:21, w2:100, y0: 50, s:15},
                    //scoreItem   : {x0:200, x1:250, x2:400, w0:50, w1:150, w2:200, y0: 100, s:30}
                    //refernce positions for each line of the score show screen
                    ptsLine     : {yinit: 78, w:230}, //155, 460
                    //position of the promter on the score show screen.
                    prompter    : {y0:40, y1:55} //80, 110
                };  
                imgCfg = {
                    //size and vertical offset for the image on the game over screen
                    goImg   : {width: 31, height:24, vOffset:4}, //61, 48, 8
                    //size of the get-ready image
                    prepImg : {width: 25, height:34}, //50, 68
                    //size and position of the animated mug on start screen
                    openMug : {w:59, h:83, x:215, y:76}, //118, 166, 430, 151
                    //size and offsets for the score show screen icons
                    strip   : {x:170, offsets:[-1, -4, -4, -3, -4, 4]}
                    //strip   : {x:340, offsets:[-2, -7, -7, -5, -7, 7]}
                };
            }
            else
            {
                //everything down here is the same as above, except for the desktop, full sized version.
                _bars[0] = new FlxRect(206, 133, 361, 37);
                _bars[1] = new FlxRect(174, 209, 423, 37);
                _bars[2] = new FlxRect(142, 284, 489, 37);
                _bars[3] = new FlxRect(110, 360, 553, 37);
                _tapOffsets = [5, 7, 5, 5];

                mugCfg = {
                    width       : 31,
                    height      : 25,
                    hOffset     : 20,
                    speed       : 100,
                    accel       : 1000,
                    dropHeight  : 40,
                    throwHeight : 100,
                    throwSpeed  : -150
                };
                patronCfg = {
                    width      : 59,
                    height     : 31,
                    vOffset    : 29,
                    correction : 3.0,
                    burpTime   : 1.0,
                    drinkTime  : 2.5,
                    rantTime   : 1.0,
                    deltaX     : 2.0,
                    walkFps    : 6,
                    rantFps    : 4,
                    catchFps   : 1,
                    drinkFps   : 2,
                    burpFps    : 2
                };
                playerCfg = {
                    width       : 65,
                    height      : 51,
                    step        : 2,
                    throwFps    : 2,
                    runFps      : 12,
                    switchFps   : 25,
                    hOffset     : 39,
                    vOffset     : 12,
                    slideOffset : 15
                };
                tapCfg = {
                    width   : 62,
                    height  : 53,
                    animFps : 16,
                    vOffset : 40
                };
                moneyCfg = {w: 27, h: 13};
                textCfg = {
                    lifeCounter : {x: 400, y: 5, w: 200},
                    scoreDisp   : {x: 0, y: 5, w: 200},
                    scoreItem   : {x0:200, x1:250, x2:400, w0:50, w1:60, w2:200, y0:100, s:30},
                    ptsLine     : {yinit: 155, w:460},
                    prompter    : {y0:80, y1:110}
                };  
                imgCfg = {
                    goImg   : {width: 61, height:48, vOffset:8},
                    prepImg : {width: 50, height:68},
                    openMug : {w:118, h:166, x:430, y:151},
                    strip   : {x:340, offsets:[-2, -7, -7, -5, -7, 7]}
                };
            }
        }



        
    }
}

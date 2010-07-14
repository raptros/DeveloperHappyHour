package
{
    import org.flixel.FlxRect;
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
                //fontSize = 7;
                _bars[0] = new FlxRect(206, 133, 361, 37);
                _bars[1] = new FlxRect(174, 209, 423, 37);
                _bars[2] = new FlxRect(142, 284, 489, 37);
                _bars[3] = new FlxRect(110, 360, 553, 37);

                _tapOffsets = [5, 7, 5, 5];
                
                mugCfg = {
                    width       : 31,
                    height      : 25,
                    hOffset     : 20,
                    speed       : 100 * speedFactor,
                    accel       : 1000 * speedFactor,
                    dropHeight  : 40,
                    throwHeight : 100,
                    throwSpeed  : -150 * speedFactor
                };
                patronCfg = {
                    width      : 59,
                    height     : 31,
                    vOffset    : 29,
                    correction : 3.0,
                    burpTime   : 1.0 / speedFactor,
                    drinkTime  : 2.5 / speedFactor,
                    rantTime   : 1.0 / speedFactor,
                    deltaX     : 1.0 * speedFactor,
                    walkFps    : 6 * speedFactor,
                    rantFps    : 4 * speedFactor,
                    catchFps   : 1 * speedFactor,
                    drinkFps   : 2 * speedFactor,
                    burpFps    : 2 * speedFactor
                };
                playerCfg = {
                    width       : 65,
                    height      : 51,
                    step        : 2 * speedFactor,
                    throwFps    : 2 * speedFactor,
                    runFps      : 12 * speedFactor,
                    switchFps   : 25 * speedFactor,
                    hOffset     : 39,
                    vOffset     : 12

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
                    scoreItem   : {x0:200, x1:250, x2:400, w0:50, w1:150, w2:200, y0: 100, s:30},
                    ptsLine     : {yinit: 155, w:460},
                    prompter    : {y0:80, y1:110}
                };  
                imgCfg = {
                    goImg   : {width: 1, height:48, vOffset:8},
                    prepImg : {width: 50, height:68},
                    openMug : {w:118, h:166, x:430, y:151},
                    strip   : {x:340, offsets:[-2, -7, -7, -5, -7, 7]}
                };
            }
            else
            {
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
                    deltaX     : 1.0,
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
                    vOffset     : 12
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
                    scoreItem   : {x0:200, x1:250, x2:400, w0:50, w1:150, w2:200, y0:100, s:30},
                    ptsLine     : {yinit: 155, w:460},
                    prompter    : {y0:80, y1:110}
                };  
                imgCfg = {
                    goImg   : {width: 1, height:48, vOffset:8},
                    prepImg : {width: 50, height:68},
                    openMug : {w:118, h:166, x:430, y:151},
                    strip   : {x:340, offsets:[-2, -7, -7, -5, -7, 7]}
                };
            }
        }



        
    }
}

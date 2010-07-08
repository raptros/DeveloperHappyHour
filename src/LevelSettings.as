package
{
    /**
     * object to carry numbers that tweak the difficulty of a level.
     * number of them get created by devhappyhour, get carried around
     * by FlxG.levels, and passed to PlayState for construction.
     */
    public class LevelSettings
    {
        public var maxPatrons:Number; //number of patrons on a bar
        public var patronsToClear:Number; 
        public var patronStep:Number;  //pixels/second?
        public var pushBack:Number; //pixels
        public var patronGap:Number; //seconds
        public var whenMoney:Number; //number of patrons given mugs
        
        public function LevelSettings(maxPatrons:Number=1,
                                      patronsToClear:Number=5,
                                      patronStep:Number=30,
                                      pushBack:Number=20,
                                      patronGap:Number=10.0,
                                      whenMoney:Number=3)
        {
            this.maxPatrons = maxPatrons;
            this.patronsToClear = patronsToClear;
            this.patronStep = patronStep;
            this.pushBack = pushBack;
            this.patronGap = patronGap;
            this.whenMoney=whenMoney;
        }
    }
}

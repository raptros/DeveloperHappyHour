package
{
    /**
     * object to carry numbers that tweak the difficulty of a level.
     * number of them get created by devhappyhour, get carried around
     * by FlxG.levels, and passed to PlayState for construction.
     */
    public class LevelSettings
    {
        public var patronSpeed:Number;  //pixels/second?
        public var pushBack:Number = 20; //pixels
        public var patronGap:Number = 10.0; //seconds
        public var maxPatrons:Number = 1; //number of patrons on a bar
        public var patronsToClear:Number = 5; 
        public var whenMoney:Number = 3; //number of patrons given mugs
        
        public function LevelSettings(maxPatrons:Number=1,
                                      patronsToClear:Number=5,
                                      patronSpeed:Number=5,
                                      pushBack:Number=20,
                                      patronGap:Number=10.0,
                                      whenMoney:Number=3)
        {
            this.maxPatrons = maxPatrons;
            this.patronsToClear = patronsToClear;
            this.patronSpeed = patronSpeed;
            this.pushBack = pushBack;
            this.patronGap = patronGap;
            this.whenMoney=whenMoney;
        }
    }
}

package
{
    public class LevelSettings
    {
        public var patronSpeed:Number; 
        public var pushBack:Number = 20; //pixels
        public var patronGap:Number = 10.0; //seconds
        public var maxPatrons:Number = 1;
        public var patronsToClear:Number = 5;
        
        public function LevelSettings(maxPatrons:Number=1,
                                      patronsToClear:Number=5,
                                      patronSpeed:Number=5,
                                      pushBack:Number=20,
                                      patronGap:Number=10.0)
        {
            this.maxPatrons = maxPatrons;
            this.patronsToClear = patronsToClear;
            this.patronSpeed = patronSpeed;
            this.pushBack = pushBack;
            this.patronGap = patronGap;
        }
    }
}

package
{
    import org.flixel.*;

    /**
     * Contains all of the embedded images, both full sized and scaled down versions.
     * has accessor functions for these images that return the image appropriate for the
     * type of build (mobile or desktop)
     */
    public class Resources
    {
        //Full Sized
        //  Animated Sprites
        //      Gameplay animations
        [Embed(source="../build/assets/sprites-mug.png")]
        private static var BeerMugSprite:Class;

        [Embed(source="../build/assets/sprites-money.png")]
        private static var MoneySprite:Class;

        [Embed(source="../build/assets/sprites-patrons.png")]
        private static var PatronSprite:Class;

        [Embed(source="../build/assets/sprites-tap.png")]
        private static var BarTapSprite:Class;

        [Embed(source="../build/assets/sprites-player.png")]
        private static var BartenderSprite:Class;
        
        //      Non Gameplay Animations
        [Embed(source="../build/assets/sprites-getready.png")]
        private static var PrepareImg:Class;

        [Embed(source="../build/assets/sprites-opening-screen.png")]
        private static var OpeningAnimationSprite:Class;

        //  Icon sprites
        //      Score Screen icons
        [Embed(source="../build/assets/sprites-icon-mug.png")]
        private static var IconMug:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron1.png")]
        private static var IconPatron1:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron2.png")]
        private static var IconPatron2:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron3.png")]
        private static var IconPatron3:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron4.png")]
        private static var IconPatron4:Class;
        
        [Embed(source="../build/assets/sprites-icon-tip.png")]
        private static var IconTip:Class;
        
        //      Other icon
        [Embed(source="../build/assets/sprites-gameover.png")]
        private static var IconGameOver:Class;

        //  Full screen image sprites
        [Embed(source="../build/assets/sprites-startscreen.png")]
        private static var TitleScreen:Class;

        [Embed(source="../build/assets/sprites-barbg.png")]
        private static var BarScreen:Class;

        //Scaled by half.
        //  Animated Sprites
        //      Gameplay animations
        [Embed(source="../build/assets/sprites-mug-scale-50.png")]
        private static var BeerMugSpriteShrunk:Class;

        [Embed(source="../build/assets/sprites-money-scale-50.png")]
        private static var MoneySpriteShrunk:Class;

        [Embed(source="../build/assets/sprites-patrons-scale-50.png")]
        private static var PatronSpriteShrunk:Class;

        [Embed(source="../build/assets/sprites-tap-scale-50.png")]
        private static var BarTapSpriteShrunk:Class;

        [Embed(source="../build/assets/sprites-player-scale-50.png")]
        private static var BartenderSpriteShrunk:Class;
        
        //      Non Gameplay Animations
        [Embed(source="../build/assets/sprites-getready-scale-50.png")]
        private static var PrepareImgShrunk:Class;

        [Embed(source="../build/assets/sprites-opening-screen-scale-50.png")]
        private static var OpeningAnimationSpriteShrunk:Class;

        //  Icon sprites
        //      Score Screen icons
        [Embed(source="../build/assets/sprites-icon-mug-scale-50.png")]
        private static var IconMugShrunk:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron1-scale-50.png")]
        private static var IconPatron1Shrunk:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron2-scale-50.png")]
        private static var IconPatron2Shrunk:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron3-scale-50.png")]
        private static var IconPatron3Shrunk:Class;
        
        [Embed(source="../build/assets/sprites-icon-patron4-scale-50.png")]
        private static var IconPatron4Shrunk:Class;
        
        [Embed(source="../build/assets/sprites-icon-tip-scale-50.png")]
        private static var IconTipShrunk:Class;
        
        //      Other icon
        [Embed(source="../build/assets/sprites-gameover-scale-50.png")]
        private static var IconGameOverShrunk:Class;

        //  Full screen image sprites
        [Embed(source="../build/assets/sprites-startscreen-scale-50.png")]
        private static var TitleScreenShrunk:Class;

        [Embed(source="../build/assets/sprites-barbg-scale-50.png")]
        private static var BarScreenShrunk:Class;


        // Conditional Access time


        public static function get barScreen():Class
        {
            if (CONFIG::mobile)
                return BarScreenShrunk;
            else
                return BarScreen;
        }

        public static function get titleScreen():Class
        {
            if (CONFIG::mobile)
                return TitleScreenShrunk;
            else
                return TitleScreen;
        }

        public static function get iconGameOver():Class
        {
            if (CONFIG::mobile)
                return IconGameOverShrunk;
            else
                return IconGameOver;
        }

        public static function get iconTip():Class
        {
            if (CONFIG::mobile)
                return IconTipShrunk;
            else
                return IconTip;
        }

        public static function get iconPatron4():Class
        {
            if (CONFIG::mobile)
                return IconPatron4Shrunk;
            else
                return IconPatron4;
        }

        public static function get iconPatron3():Class
        {
            if (CONFIG::mobile)
                return IconPatron3Shrunk;
            else
                return IconPatron3;
        }

        public static function get iconPatron2():Class
        {
            if (CONFIG::mobile)
                return IconPatron2Shrunk;
            else
                return IconPatron2;
        }

        public static function get iconPatron1():Class
        {
            if (CONFIG::mobile)
                return IconPatron1Shrunk;
            else
                return IconPatron1;
        }

        public static function get iconMug():Class
        {
            if (CONFIG::mobile)
                return IconMugShrunk;
            else
                return IconMug;
        }

        public static function get openingAnimationSprite():Class
        {
            if (CONFIG::mobile)
                return OpeningAnimationSpriteShrunk;
            else
                return OpeningAnimationSprite;
        }

        public static function get prepareImg():Class
        {
            if (CONFIG::mobile)
                return PrepareImgShrunk;
            else
                return PrepareImg;
        }

        public static function get bartenderSprite():Class
        {
            if (CONFIG::mobile)
                return BartenderSpriteShrunk;
            else
                return BartenderSprite;
        }

        public static function get barTapSprite():Class
        {
            if (CONFIG::mobile)
                return BarTapSpriteShrunk;
            else
                return BarTapSprite;
        }

        // Note that this could be used to randomly pick among a multitude of patrons, getting rid of
        // the whole psi thing in Patron.as
        public static function get patronSprite():Class
        {
            if (CONFIG::mobile)
                return PatronSpriteShrunk;
            else
                return PatronSprite;
        }

        public static function get moneySprite():Class
        {
            if (CONFIG::mobile)
                return MoneySpriteShrunk;
            else
                return MoneySprite;
        }

        public static function get beerMugSprite():Class
        {
            if (CONFIG::mobile)
                return BeerMugSpriteShrunk;
            else
                return BeerMugSprite;
        }

    }
}

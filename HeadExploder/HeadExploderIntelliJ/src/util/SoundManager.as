/**
 * Created by bobolicious3000 on 10/21/15.
 */
package util {

import flash.media.Sound;
import flash.media.SoundChannel;

public class SoundManager {

    private var _model:Model;
    private static var instance:SoundManager = new SoundManager();
    public const TADA:String = "TADA";
    public const SECRET:String = "SECRET";
    public const EXPLOSION:String = "EXPLOSION";
    private var taDaSound:Sound;
    private var taDaSoundChannel:SoundChannel;
    private var secretSound:Sound;
    private var secretSoundChannel:SoundChannel;
    private var explosionSoundChannel:SoundChannel;
    private var explosionSound:Sound;

    public function SoundManager() {

        _model = Model.getInstance();
        if(instance)
        {
            throw new Error ("We cannot create a new instance.Please use SoundManager.getInstance()");
        }

        initSounds();
    }

    private function initSounds():void {
        taDaSound = new AssetEmbeds_1x.TaDaSound as Sound;
        taDaSoundChannel = new SoundChannel();

        secretSound = new AssetEmbeds_1x.SecretSound as Sound;
        secretSoundChannel = new SoundChannel();

        explosionSound = new AssetEmbeds_1x.ExplosionSound as Sound;
        explosionSoundChannel = new SoundChannel();
    }

    public static function getInstance():SoundManager
    {

        return instance;
    }

    public function playSound(type:String):void
    {
        trace("type of sound to play: " + type);

        switch (type)
        {
            case TADA:
                trace("was tada");

                _model.taDaSound = taDaSound;
                _model.taDaSoundChannel = taDaSoundChannel;
                _model.taDaSoundChannel = _model.taDaSound.play();
                break;
                
            case SECRET:
                trace("was secret sound");

                secretSoundChannel = secretSound.play();
                break;
            
            case EXPLOSION:
            trace("was secret sound");

            explosionSoundChannel = explosionSound.play();
            break;
        }
    }



}
}

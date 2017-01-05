//
//  MusicTools.swift
//  音乐的基本播放
//
//  Created by 睿 on 16/11/25.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit
import AVFoundation

class MusicTools {
    fileprivate static var player : AVAudioPlayer?
//    static var url : URL?
}

extension MusicTools{
    class func play(_ name : String){

//        if let player = player {
//            player.play()
//            return
//        }

        //获取对应URL 资源
        guard let playURL = Bundle.main.url(forResource: name, withExtension: nil)  else {
            return
        }
//        self.url = playURL
        if self.player?.url == playURL {
            player?.play()
            return
        }
        //根据URL 资源 创建播放对象

        guard let player  =  try? AVAudioPlayer(contentsOf: playURL) else {return}
        //播放
        self.player = player
        player.play()
        
    }

    class func pause(){
        player?.pause()
        
    }
    class func stop(){
        player?.stop()
        player?.currentTime = 0
    }
    class func forward(){
        player?.currentTime += 15
    }

    class func next(){
        
        
    }
    class func changeVolume( _ sender : UISlider ){
        player?.volume = sender.value

    }

    class func setCurrentTime(_ time : TimeInterval){
        player?.currentTime = time
    }


    class func getDuration () -> TimeInterval{
        return player?.duration ?? 0
    }

    class  func getCurrentTime() ->TimeInterval{
        return player?.currentTime ?? 0
    }



}

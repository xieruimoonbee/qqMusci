//
//  MusicModel.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/27.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit

class MusicModel: NSObject {


    //歌曲名称

    var name : String = ""
    /// MP3文件的名称
    var filename : String = ""
    /// 歌词文件的名称
    var lrcname : String = ""
    /// 歌手的名称
    var singer : String = ""
    /// 封面的图片名称
    var icon : String = ""


    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }


}

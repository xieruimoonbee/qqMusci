//
//  LrcMode.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/29.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit

class LrcMode: NSObject {

    var lrcText : String = ""
    var lrcTime : TimeInterval = 0
    init(_ lrcString : String) {

        let lrcStrings = lrcString.components(separatedBy: "]")
        lrcText = lrcStrings[1]
        let lrcTimes = lrcStrings[0].components(separatedBy: "[")[1]
        let min = Double(lrcTimes.components(separatedBy: ":")[0])!
        let second = Double(lrcTimes.components(separatedBy: ":")[1])!
        let time = min * 60 + second
        lrcTime = time
        
    }

}

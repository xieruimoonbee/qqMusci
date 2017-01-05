//
//  LrcTools.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/29.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit

class LrcTools: NSObject {


}

extension LrcTools{
    class func parseLrc(_ lrcname : String) -> [LrcMode]? {
        //1.获取路径
        guard let path = Bundle.main.path(forResource: lrcname, ofType: nil) else {
            return nil
        }
        //2.取出路径中的内容

        guard let totalLrcString = try? String(contentsOfFile:path) else {
            return nil
        }
        //3.分割内容
        var lrclines : [LrcMode] = [LrcMode]()

        let lrcLineString = totalLrcString.components(separatedBy: "\n")
        for lrc in lrcLineString{
            if lrc.contains("ti") || lrc.contains("ar") || lrc.contains("al") || !lrc.contains("["){
                continue

            }
            let lrcM = LrcMode(lrc)
            lrclines.append(lrcM)
        }
        return lrclines







    }
}

//
//  lrcTableViewCell.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/29.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit

class lrcTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textAlignment = .center
        //取消点击
        selectionStyle = .none
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  lrcScrollview.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/29.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit
private let lrcCellID = "lrcID"
class LrcScrollView: UIScrollView {

    // MARK:内部属性
    fileprivate lazy var tableView : UITableView = UITableView()
    fileprivate var lrcLines : [LrcMode]?
    var currrentIndex : Int = 0





    // MARK:外部属性
    var lrcname : String = "" {
        didSet{
            tableView.setContentOffset(CGPoint(x : 0, y : -bounds.height * 0.5), animated: true)
            lrcLines = LrcTools.parseLrc(lrcname)
            tableView.reloadData()
//            currrentIndex = 0
        }



    }
    func setContentOffset(){
        tableView.setContentOffset(CGPoint(x : 0, y : -bounds.height * 0.5), animated: true)

    }

    var currentTime : TimeInterval = 0 {
        didSet{
            //1.校验歌词是否有值
            guard let lrcLines = lrcLines else {
                return
            }
            //2.遍历所有的歌词
            let count = lrcLines.count
            for i in 0..<count {
                //1.取出当前歌曲
                let currentM = lrcLines[i]



                //2.取出下一首歌曲

                let nextIndex = i + 1
//                let nextM = lrcLines[nextIndex]
                if nextIndex > count - 1{
                    continue
                }
                let nextM = lrcLines[nextIndex]

                if currentTime > currentM.lrcTime && currentTime < nextM.lrcTime && i != currrentIndex{

                    let indexPath = IndexPath(row: i, section: 0)
                    let preIndexPath = IndexPath(row: currrentIndex, section: 0)
                    
                    currrentIndex = i

                   tableView.reloadRows(at: [indexPath,preIndexPath], with: .none)
                   tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

                }
            }

        }
    }




    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}
extension LrcScrollView {
    fileprivate func setupUI() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(lrcTableViewCell.self, forCellReuseIdentifier: lrcCellID)
        tableView.rowHeight = 35


    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let x : CGFloat = bounds.width
        let y : CGFloat = 0
        let width : CGFloat = bounds.width
        let hight : CGFloat = bounds.height
        tableView.frame = CGRect(x: x, y: y, width: width, height: hight)
        tableView.contentInset = UIEdgeInsets(top: bounds.height * 0.5, left: 0, bottom: bounds.height * 0.5, right: 0)
//        tableView.setContentOffset(CGPoint(x : 0, y : -bounds.height * 0.5), animated: true)
        //会产生一旦拖拽就重新布局导致跳回去
        //这句的作用就是为了一进来能滚到对应的位置


    }

}

extension LrcScrollView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcLines?.count ?? 0
    }

    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lrcCellID, for: indexPath)
        if indexPath.row == currrentIndex {
            cell.textLabel?.textColor = UIColor.green
        }else{
            cell.textLabel?.textColor = UIColor.white
        }

        let lrc = lrcLines![indexPath.row]
        cell.textLabel?.text = lrc.lrcText
        return cell
    }
    
    
}

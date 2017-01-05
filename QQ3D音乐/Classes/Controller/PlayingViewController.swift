//
//  PlayingViewController.swift
//  QQ3D音乐
//
//  Created by 睿 on 16/11/25.
//  Copyright © 2016年 rui. All rights reserved.
//

import UIKit

class PlayingViewController:

UIViewController {
    @IBOutlet weak var musicName: UILabel!

    @IBOutlet weak var singer: UILabel!

    @IBOutlet weak var progress: UISlider!

    @IBOutlet weak var preMusic: UIButton!

    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var nextMusic: UIButton!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    @IBOutlet weak var iconImage: UIImageView!


    @IBOutlet weak var playImageview: UIImageView!


    @IBOutlet weak var iconCons: NSLayoutConstraint!

    var music : MusicModel!

    @IBOutlet weak var lrcScrollView: LrcScrollView!

    @IBOutlet weak var lrcLabel: UILabel!





    fileprivate lazy var musicModel : [MusicModel] = [MusicModel]()
    fileprivate var progressTimer : Timer?
    fileprivate var  lrcTimer : CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI界面
        setupUI()
        //加载数据
        loadMusicData()
        //播放音乐
        music = musicModel[0]
        play()


    }

    override func viewDidAppear(_ animated: Bool) {
       lrcScrollView.setContentOffset()

    }



}

extension PlayingViewController{
    fileprivate func loadMusicData(){
        //获取路径
        guard let filePath = Bundle.main.path(forResource: "Musics.plist", ofType: nil)else {
            return
        }
        //获取Plist 文件中的数据

        guard let musicArray = NSArray(contentsOfFile : filePath) as? [[String : Any]]else {
            return
        }
       //字典转模型
        for dict in musicArray{
            musicModel.append(MusicModel(dict: dict))
        }
    }
}
extension PlayingViewController{
    fileprivate func play(){
        //1.取出某一首歌进行播放
//        let random = arc4random_uniform(UInt32(musicModel.count))
//        let music = musicModel[Int(random)]
        MusicTools.play(music.filename)
        //2.改变界面中的内容
        musicName.text = music.name
        singer.text = music.singer
        iconImage.image = UIImage(named: music.icon)
        playImageview.image = UIImage(named: music.icon)
        progress.value = 0

        //3.改变时间
        totalTimeLabel.text = stringWithTime(MusicTools.getDuration())
        addProgressTimer()

        //4.添加旋转动画
        addRotationAnim()

        //5.添加歌词
         lrcScrollView.lrcname = music.lrcname

        //6.添加定时器
        addLrcTimer()


        





    }
    fileprivate func stringWithTime (_ time : TimeInterval) -> String{
        let min = Int(time)/60
        let second = Int(time)%60
        return String(format: "%02d:%02d", min,second)

    }
}

extension PlayingViewController{
    fileprivate func setupUI() {
        //设置毛玻璃效果
      setupBlurView()
        iconCons.constant = UIScreen.main.bounds.width * -0.3
        iconImage.layer.cornerRadius = view.bounds.width * 0.7 * 0.5
        iconImage.layer.masksToBounds = true
        iconImage.layer.borderWidth = 8
        iconImage.layer.borderColor = UIColor.black.cgColor
        //设置歌词拉伸的View
         lrcScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 0)

    }



}
extension PlayingViewController{
    fileprivate func setupBlurView(){
        //添加一个毛玻璃
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = CGRect(x: 0, y: 0, width: 414, height: 667)
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        playImageview.addSubview(blurView)

    }
  override  var preferredStatusBarStyle : UIStatusBarStyle{
        return .lightContent
    }
}

// MARK: 定时器
extension PlayingViewController{
    fileprivate func addProgressTimer(){
        progressTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateProgerss), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: .commonModes)

    }

    @objc fileprivate func updateProgerss(){
          currentTimeLabel.text = stringWithTime(MusicTools.getCurrentTime())

         progress.value = Float(MusicTools.getCurrentTime()/MusicTools.getDuration())


    }

    fileprivate func removeTimer(){
        progressTimer?.invalidate()
        progressTimer = nil
    }


    fileprivate func addLrcTimer(){
        lrcTimer = CADisplayLink(target: self, selector: #selector(updateLrc))
        lrcTimer?.add(to: RunLoop.main, forMode: .commonModes)

    }

    fileprivate func removeTier(){
        lrcTimer?.invalidate()
        lrcTimer = nil

    }

    @objc func updateLrc(){
        lrcScrollView.currentTime = MusicTools.getCurrentTime()

    }
}
extension PlayingViewController{
    fileprivate func addRotationAnim(){
        //1.创建一个动画
        let rotationAnimi = CABasicAnimation(keyPath: "transform.rotation.z")
        //2.设置动画的属性
        rotationAnimi.fromValue = 0
        rotationAnimi.toValue = M_PI * 2
        rotationAnimi.repeatCount = MAXFLOAT
        rotationAnimi.duration = 30
        //3.添加动画
        iconImage.layer.add(rotationAnimi, forKey: nil)

    }


}

extension PlayingViewController{
    @IBAction func touchDownSlider(){
        removeTimer()


    }
    @IBAction func sliderValueChange(){
        let time = Double(progress.value) * MusicTools.getDuration()
        currentTimeLabel.text = stringWithTime(time)

    }
    @IBAction func touchUpInside(){
    updateCurrentTime()

    }
    @IBAction func touUpOutside(){
        updateCurrentTime()
    }

    fileprivate func updateCurrentTime(){
        let time = Double(progress.value) * MusicTools.getDuration()
        MusicTools.setCurrentTime(time)
        addProgressTimer()

    }

    @IBAction func tapGes(_ sender : UITapGestureRecognizer){
        let point = sender.location(in: progress)
        let rotio = point.x / progress.bounds.width

         let time = Double(rotio) * MusicTools.getDuration()
         MusicTools.setCurrentTime(time)
         updateProgerss()

    }




}

extension PlayingViewController{
    @IBAction func previousMusic(){
        switchMusic(isNext: false)

    }

    @IBAction func nextOneMusic(){
        switchMusic(isNext: true)

    }
    /*
     - (void)pauseLayer:(CALayer*)layer
     {
     CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
     layer.speed = 0.0;
     layer.timeOffset = pausedTime;
     }


     //继续layer上面的动画
     - (void)resumeLayer:(CALayer*)layer
     {
     CFTimeInterval pausedTime = [layer timeOffset];
     layer.speed = 1.0;
     layer.timeOffset = 0.0;
     layer.beginTime = 0.0;
     CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
     layer.beginTime = timeSincePause;
     }
     */
    fileprivate func pauseLayer(layer : CALayer){
        let pause = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pause
    }

    fileprivate func resumeLayer(layer : CALayer){

    }

    @IBAction func playOrPauseMusic(_ sender : UIButton){

        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            MusicTools.play(music.filename)
        }else{
            MusicTools.pause()

        }
        
    }
  

    fileprivate func switchMusic(isNext : Bool){

        var i : Int = 0
        if isNext {
             i = musicModel.index(of: music)!
            var index = i + 1
            if index > musicModel.count - 1 {
                index = 0
            }
            i = index
        }else{
            i = musicModel.index(of: music)!
            var index = i - 1
            if index < 0 {
                index = musicModel.count - 1
            }
            i = index


        }
        music = musicModel[i]
        play()


    }


}
extension PlayingViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio = scrollView.contentOffset.x / scrollView.bounds.width
        lrcLabel.alpha = 1 - ratio
        iconImage.alpha = 1 - ratio
    }
    

}














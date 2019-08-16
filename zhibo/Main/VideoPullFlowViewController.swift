//
//  VideoPullFlowViewController.swift
//  zhibo
//
//  Created by huangczh on 2019/8/15.
//  Copyright © 2019 ZH-ZHG. All rights reserved.
//
/**
 *拉流
 **/
import UIKit
import IJKMediaFramework
class VideoPullFlowViewController: UIViewController {
    private lazy var player : IJKFFMoviePlayerController = {
        var player  = IJKFFMoviePlayerController()
        IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
        let options : IJKFFOptions = IJKFFOptions.byDefault()
        //        //解决秒开问题
        //        options.setOptionIntValue(0, forKey: "skip_frame", of: kIJKFFOptionCategoryCodec)
        //        options.setOptionIntValue(0, forKey: "skip_loop_filter", of: kIJKFFOptionCategoryCodec)
        //        options.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        //        options.setOptionIntValue(60, forKey: "max-fps", of: kIJKFFOptionCategoryPlayer)
        
        let url = URL.init(string: "rtmp://192.168.0.189:1935/rtmplive/room")
        player = IJKFFMoviePlayerController.init(contentURL: url, with: options)
        player.shouldAutoplay = true
        var arm1 = UIView.AutoresizingMask.init(rawValue: 0)
        arm1.insert(UIView.AutoresizingMask.flexibleWidth)
        arm1.insert(UIView.AutoresizingMask.flexibleHeight)
        player.view.autoresizingMask = arm1
        player.scalingMode = .aspectFit
        player.shouldAutoplay = true
        self.view.autoresizesSubviews = true
        player.view.frame = UIScreen.main.bounds
        //        player.shouldShowHudView = true
        
        return player
    }()
    private lazy var startButton : UIButton = {
        let startButton = UIButton()
        startButton.backgroundColor = .blue
        startButton.setTitle("暂停", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        startButton .setTitle("开始", for: .selected)
        startButton.addTarget(self, action:#selector(buttonClick(button:)), for: .touchUpInside)
        return startButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "拉流"
        initPlayerView()
        self.view.addSubview(player.view)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func initPlayerView(){
        
    }
    @objc func buttonClick(button:UIButton){
        if button.isSelected {
            
            button.isSelected = true
            self.player.play()
            
        }else{
            
            button.isSelected = false
            self.player.pause()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.player.prepareToPlay()
        self.player.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

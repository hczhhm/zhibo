//
//  VideoPlugFlowViewController.swift
//  zhibo
//
//  Created by huangczh on 2019/8/14.
//  Copyright © 2019 ZH-ZHG. All rights reserved.
//
/**
 *视频推流
 **/
import UIKit
import LFLiveKit
class VideoPlugFlowViewController: UIViewController,LFLiveSessionDelegate {
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.medium)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
//        videoConfiguration?.videoSize = CGSize.init(width: 540, height: 960)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.running = true
        session?.captureDevicePosition = .back
        session?.preView = self.preview
        session?.showDebugInfo = true
        return session!
    }()
//    lazy var videoConfiguration : LFLiveVideoConfiguration = {
//
//        let videoConfiguration = LFLiveVideoConfiguration()
//
//        videoConfiguration.videoSize = CGSize.init(width: 540, height: 960)
//
//        videoConfiguration.videoBitRate = 800*1024
//
//        videoConfiguration.videoMaxBitRate = 1000*1024
//
//        videoConfiguration.videoMinBitRate = 500*1024
//
//        videoConfiguration.videoFrameRate = 20
//
//        videoConfiguration.videoMaxKeyframeInterval = 40
//
//        videoConfiguration.outputImageOrientation = .portrait
//
//        videoConfiguration.sessionPreset =  .captureSessionPreset720x1280
//
//        return videoConfiguration
//    }()
//
//    lazy var audioConfiguration : LFLiveAudioConfiguration = {
//
//        let audioConfiguration = LFLiveAudioConfiguration()
//
//        audioConfiguration.numberOfChannels = 2
//
//        audioConfiguration.audioBitrate = ._128Kbps
//
//        audioConfiguration.audioSampleRate =  ._44100Hz
//
//        return audioConfiguration
//    }()
//
//    lazy var session : LFLiveSession = {
//
//        let session = LFLiveSession.init(audioConfiguration: self.audioConfiguration, videoConfiguration: self.videoConfiguration)
//
//        session?.preView = self.preview
//
//        session?.delegate = self
//
//        session?.running = true
//
//        session?.showDebugInfo = true
//
//        return session!
//    }()
    lazy var preview: UIView = {
        let preview = UIView.init(frame: UIScreen.main.bounds)
        return preview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "推流"
        // Do any additional setup after loading the view.
        self.view.addSubview(preview)
//        session.preView = preview
        startLive()
    }
    
    func startLive() -> Void {
        session.running = true
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://192.168.2.3/rtmplive/room"    //your server rtmp url
        session.startLive(stream)
    }
    func stopLive() -> Void {
        session.running = false
        session.stopLive()
    }
    
    //MARK: - callback
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print(debugInfo ?? LFLiveDebug.self)
    }
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        if state == LFLiveState.ready{
           print("准备")
        }
        else if state == LFLiveState.pending{
           print("连接中")
        }
        else if state == LFLiveState.start{
            print("已连接")
        }
        else if state == LFLiveState.stop{
            print("已断开")
        }
        else if state == LFLiveState.error{
           print("连接出错")
        }
        else if state == LFLiveState.refresh{
           print("正在刷新")
        }
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        if errorCode == LFLiveSocketErrorCode.preView {
            print("预览失败")
        }else if errorCode == LFLiveSocketErrorCode.getStreamInfo{
            print("获取流媒体信息失败")
        }else if errorCode == LFLiveSocketErrorCode.connectSocket{
            print("连接socket失败")
        }else if errorCode == LFLiveSocketErrorCode.verification{
            print("验证服务器失败")
        }else if errorCode == LFLiveSocketErrorCode.reConnectTimeOut{
            print("重新连接服务器超时")
        }
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

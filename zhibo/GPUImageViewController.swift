//
//  GPUImageViewController.swift
//  zhibo
//
//  Created by huangczh on 2019/8/13.
//  Copyright © 2019 ZH-ZHG. All rights reserved.
//

import UIKit
import GPUImage
import AVKit
class GPUImageViewController: UIViewController,GPUImageVideoCameraDelegate {
    //注：为了可以进行拍照，这里用子类GPUImageStillCamera代替GPUImgeVideoCamera
    private lazy var camera : GPUImageStillCamera = GPUImageStillCamera()
    private lazy var showView = GPUImageView(frame: self.view.bounds)
    let bilateralFilter = GPUImageBilateralFilter()//磨皮
    let exposureFilter = GPUImageExposureFilter()//曝光
    let brightnessFilter = GPUImageBrightnessFilter()//美白
    let satureationFilter = GPUImageSaturationFilter()//饱和
    private lazy var stopButton = UIButton()
    //视频写入类
    private lazy var movieWriter : GPUImageMovieWriter = {
        [unowned self] in
        let write = GPUImageMovieWriter(movieURL: self.fileURL, size: self.view.bounds.size)
        return write!
        
    }()
    //视频沙盒地址
    private lazy var fileURL : URL = {
        [unowned self] in
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())movie\(arc4random()).mp4")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "CPUImage"
        //设置摄像头方向为垂直
        camera.outputImageOrientation = .portrait
        camera.horizontallyMirrorRearFacingCamera = true //前置摄像头
        //加入预览图层
        view.insertSubview(showView, at: 0)
        
        //获取滤镜组
        let filterGroup = getGroupFilters()
        
        //设置GPUImage的响应链
        camera.addTarget(filterGroup)
        filterGroup.addTarget(showView)
        
        //3.开始采集画面
        camera.startCapture()
        
        //配置写入文件
        movieWriter.encodingLiveVideo = true
        filterGroup.addTarget(movieWriter)
        camera.delegate = self
        camera.audioEncodingTarget = movieWriter
        
        movieWriter.startRecording()
        initSubViews()
    }
    private func initSubViews(){
        view.addSubview(stopButton)
        stopButton.backgroundColor = .blue
        stopButton.titleLabel?.font = .systemFont(ofSize: 14)
        stopButton.setTitle("停止", for: .normal)
        stopButton.addTarget(self, action: #selector(stopClick(button:)), for: .touchUpInside)
        stopButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    @objc func stopClick(button:UIButton){
        print(fileURL)
        camera.stopCapture()
        showView.removeFromSuperview()
        movieWriter.finishRecording()
        let playerVc = AVPlayerViewController()
        playerVc.player = AVPlayer(url: fileURL)
        present(playerVc, animated: true, completion: nil)
        
    }
    private func getGroupFilters() -> GPUImageFilterGroup{
        //创建滤镜组
        let filterGroup = GPUImageFilterGroup()
        //设置滤镜关系链
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        //设置滤镜组，终点filter
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = satureationFilter
    
        return filterGroup
        
    }
    
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集画面")
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

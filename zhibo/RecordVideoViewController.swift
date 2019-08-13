//
//  RecordVideoViewController.swift
//  zhibo
//
//  Created by huangczh on 2019/8/12.
//  Copyright © 2019 ZH-ZHG. All rights reserved.
//
//https://blog.csdn.net/dolacmeng/article/details/81268622
import UIKit
import AVFoundation
import SnapKit
class RecordVideoViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{

    private lazy var session : AVCaptureSession = AVCaptureSession()
    private var videoOutput : AVCaptureVideoDataOutput?
    private var previewLayer : AVCaptureVideoPreviewLayer?
    private var videoInput : AVCaptureDeviceInput?
    private lazy var startButton : UIButton = UIButton()
    private lazy var endButton : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "视频录制";
        self.view.backgroundColor = .white;
        initSubViews()
        setUpVideoInputOutput()
        setuoAudioInputOutput()
        setupPreviewLayer()
    }
    private func initSubViews(){
        startButton.backgroundColor = .blue
        startButton.setTitle("开始", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(startButton)
        startButton .setTitle("结束", for: .selected)
        startButton.addTarget(self, action:#selector(buttonClick(button:)), for: .touchUpInside)
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
    }
    @objc func buttonClick(button:UIButton){
        if button.isSelected {
            button.isSelected = false
            session.stopRunning()
        }else{
            button.isSelected = true
            session.startRunning()
        }
    }
    //视频采集
    fileprivate func setUpVideoInputOutput(){
        //1.获取视频输入设备列表
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes:[.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        guard let device = devices.filter({$0.position == .back}).first else {return}
         //3.创建输入
      
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        videoInput = input
//        videoInput = zd;
        
        let outPut = AVCaptureVideoDataOutput()
        let queue = DispatchQueue.global()
        outPut.setSampleBufferDelegate(self, queue: queue)
        videoOutput = outPut
        //3.添加输入&输出
        addInputOutputToSession(input, outPut)
    }
    
    fileprivate func setuoAudioInputOutput(){
        //1.获取麦克风输入设备
        guard let device = AVCaptureDevice.default(for: .audio) else {return}
        //2.创建输入
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        //2.创建输出
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue.global()
        output.setSampleBufferDelegate(self, queue: queue)
        
        //3.添加输入&输出
        addInputOutputToSession(input, output)
        
    }
    //添加预览层
    fileprivate func setupPreviewLayer(){
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        
        view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer;
        
    }
    
   //音视频添加输入&输出的公用方法
    private func addInputOutputToSession(_ input : AVCaptureInput,_ output : AVCaptureOutput ){
        session.beginConfiguration()
        //将输入连接到session
        if session.canAddInput(input){
            session.addInput(input)
        }
        //将输出连接到session
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        session.commitConfiguration()
    }
    //MARK: SampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if videoOutput?.connection(with: .video) == connection {
            print("采集视频")
        }else{
            print("采集音频")
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


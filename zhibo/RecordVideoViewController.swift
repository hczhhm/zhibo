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

class RecordVideoViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{

    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    fileprivate var videoOutput : AVCaptureVideoDataOutput?
    fileprivate var previewLayer : AVCaptureVideoPreviewLayer?
    fileprivate var videoInput : AVCaptureDeviceInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        self.navigationItem.title = "视频录制";
        self.view.backgroundColor = .white;
        setUpVideoInputOutput();
    }
    //视频采集
    fileprivate func setUpVideoInputOutput(){
        //1.获取视频输入设备列表
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes:[.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        guard let device = devices.filter({$0.position == .front}).first else {return}
         //3.创建输入
      
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        videoInput = input
//        videoInput = zd;
        
        let outPut = AVCaptureVideoDataOutput()
        let queue = DispatchQueue.global()
        outPut.setSampleBufferDelegate(self as! AVCaptureVideoDataOutputSampleBufferDelegate, queue: queue)
        videoOutput = outPut
        //3.添加输入&输出
        addInputOutputToSession(input, outPut)
    }
   
    private func addInputOutputToSession(_ input : AVCaptureInput,_ output : AVCaptureOutput ){
        let session = AVCaptureSession()
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


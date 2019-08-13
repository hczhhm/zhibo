//
//  GPUImageViewController.swift
//  zhibo
//
//  Created by huangczh on 2019/8/13.
//  Copyright © 2019 ZH-ZHG. All rights reserved.
//

import UIKit
import GPUImage
class GPUImageViewController: UIViewController,GPUImageVideoCameraDelegate {
    //注：为了可以进行拍照，这里用子类GPUImageStillCamera代替GPUImgeVideoCamera
    private lazy var camera : GPUImageStillCamera = GPUImageStillCamera()
    private lazy var filter = GPUImageBrightnessFilter()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "CPUImage"
        //设置摄像头方向为垂直
        camera.outputImageOrientation = .portrait
        //1.添加滤镜
        camera .addTarget(filter)
        camera.delegate = self
        //2.添加一个用于实时显示画面的GPUImageView
        let showView = GPUImageView(frame: view.bounds)
        view.addSubview(showView)
        filter.addTarget(showView)
        
        //3.开始采集画面
        camera.startCapture()
        
        
        
        
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

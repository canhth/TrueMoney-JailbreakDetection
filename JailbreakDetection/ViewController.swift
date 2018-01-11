//
//  ViewController.swift
//  JailbreakDetection
//
//  Created by Tran Hoang Canh on 11/1/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var deviceTypeTextField: UITextField!
    @IBOutlet weak var osVersionTextField: UITextField!
    @IBOutlet weak var uuidTextView: UITextView!
    @IBOutlet weak var isJailbrokenSwitch: UISwitch!
    @IBOutlet weak var saveScreenShotButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        PHPhotoLibrary.requestAuthorization { (status) in
            self.saveScreenShotButton.isEnabled = (status == .authorized)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func setupViews() {
        deviceTypeTextField.text = UIDevice.modelName
        osVersionTextField.text = UIDevice.version
        uuidTextView.text = UIDevice.uuidString
        isJailbrokenSwitch.setOn(JaibreakDetection.isJailbroken(), animated: true)
        
        uuidTextView.layer.cornerRadius = 4
        uuidTextView.layer.borderColor = UIColor.lightGray.cgColor
        uuidTextView.layer.borderWidth = 1
    }
    
    
    
    @IBAction func saveImageButtonTapped(_ sender: UIButton) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else { return }
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        if let screenshot = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        } else {
            print("Can not save image")
        }
    }
    
}


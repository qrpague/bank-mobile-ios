//
//  LauchScreenController.swift
//  qrpague
//
//  Created by Marcos Magalhães on 31/01/2019.
//  Copyright © 2019 QRPAGUE. All rights reserved.
//
import UIKit
import AVFoundation

class InitController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(notificationCameraQrcode),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc func notificationCameraQrcode() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        if ( appDelegate.sufixUrl == nil ) {
            let storyBoard: UIStoryboard = self.storyboard!
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "qrcodeViewController") as! QrcodeController
            self.present(newViewController, animated: true, completion: nil)
    
        } else {
            self.openWebview(tipo: "QRCODE", code: appDelegate.sufixUrl)
        }
    }
    
    func openWebview(tipo: String,  code: String) {
        var bodyCode  = code.replacingOccurrences(of: " ", with: "")
        
        let storyBoard: UIStoryboard = self.storyboard!
        let viewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        viewController.code = bodyCode
        viewController.tipo = tipo
        self.present(viewController, animated: true, completion: nil)
    }
    
}

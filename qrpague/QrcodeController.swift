//
//  ViewController.swift
//  qrpague
//
//  Created by LEONARDO A SILVEIRA on 11/11/2018.
//  Copyright © 2018 QRPAGUE. All rights reserved.
//

import UIKit
import AVFoundation

class QrcodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    private var boletoTipo:String = "QRCODE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(notificationCameraQrcode),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        view.backgroundColor = UIColor.black
       
        startCaptureSession()
        layoutQrcode()
        
    }
    func startCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } else {
            failed()
            return
        }
        
        let f = view.layer.bounds
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = f //CGRect(x: (f.width/4), y: f.height/4 , width: f.width/2, height: f.height/4 )
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    func layoutBarCode(){
        
        let f = view.layer.bounds
        let degrees : Double = 90;
        
        let labelBack = UILabel()
        labelBack.textAlignment = .center
        labelBack.text = " <- "
        labelBack.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
        labelBack.sizeToFit()
        let w = labelBack.frame.width + 10
        let h =  labelBack.frame.height + 20
        labelBack.frame = CGRect(x: f.width - w , y: labelBack.frame.height , width: w , height: h )
        labelBack.textColor = UIColor.white
//        labelBack.center = CGPoint(x: f.width - labelBack.frame.width , y: labelBack.frame.height )
        
        labelBack.layer.cornerRadius = 9
        labelBack.layer.borderWidth = 1
        labelBack.layer.borderColor  = UIColor.white.cgColor
        labelBack.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(QrcodeController.choiceCodQrCode(sender:)))
        labelBack.isUserInteractionEnabled = true
        labelBack.addGestureRecognizer(tap)
        
        let layerLeft = CAShapeLayer()
        layerLeft.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: f.width/4, height: f.height ) , cornerRadius : 0).cgPath
        layerLeft.opacity = 0.5
        
        let layerRight = CAShapeLayer()
        layerRight.path = UIBezierPath(roundedRect: CGRect(x: (f.width/2 + f.width/4), y: 0 , width: f.width/4 , height: f.height ) , cornerRadius : 0).cgPath
        layerRight.opacity = 0.5
        
        let layerLineScan = CAShapeLayer()
        layerLineScan.path = UIBezierPath(roundedRect: CGRect(x: f.width/2 , y: 0 , width: 2 , height: f.height ) , cornerRadius : 0).cgPath
        layerLineScan.fillColor = UIColor.red.cgColor
 
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.8
        animation.repeatCount = Float.greatestFiniteMagnitude
        layerLineScan.add(animation, forKey: nil)
        
        
        let labelD = UILabel()
        labelD.textAlignment = .center
        labelD.text = "Posicione o código de barras no centro"
        labelD.sizeToFit()
        labelD.textColor = UIColor.white
        labelD.center = CGPoint(x: (f.width - labelD.frame.height ), y: (f.height/2))
        
        labelD.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
        
        labelD.tag = 88
        labelBack.tag = 88
        
        self.view.addSubview(labelD)
        self.view.addSubview(labelBack)
        
        layerLineScan.name = "layoutBarCode"
        layerLeft.name = "layoutBarCode"
        layerRight.name = "layoutBarCode"
        
        view.layer.addSublayer(layerLineScan)
        view.layer.addSublayer(layerLeft)
        view.layer.addSublayer(layerRight)

    }
    func layoutQrcode(){
        let f = view.layer.bounds
        let labelWidth = ((f.width/2) )


        let layerO = CAShapeLayer()
        layerO.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: f.width, height:((f.height)/2)/2 ) , cornerRadius : 0).cgPath
        layerO.opacity = 0.5
        
        let layerInferior = CAShapeLayer()
        layerInferior.path = UIBezierPath(roundedRect: CGRect(x: 0, y: (f.height)/2 , width: f.width, height:((f.height)/2) ) , cornerRadius : 0).cgPath
        layerInferior.opacity = 0.5
        
        let layerEsquerda = CAShapeLayer()
        layerEsquerda.path = UIBezierPath(roundedRect: CGRect(x: 0, y: ((f.height)/4) , width: (f.width/4), height:((f.height)/4) ) , cornerRadius : 0).cgPath
        layerEsquerda.opacity = 0.5

        let layerDireira = CAShapeLayer()
        layerDireira.path = UIBezierPath(roundedRect: CGRect(x: (f.width - f.width/4), y: ((f.height)/4) , width: (f.width/4), height:((f.height)/4) ) , cornerRadius : 0).cgPath
        layerDireira.opacity = 0.5

        
        layerInferior.name = "layoutQrcode"
        layerEsquerda.name = "layoutQrcode"
        layerO.name = "layoutQrcode"
        layerDireira.name = "layoutQrcode"
        
        view.layer.addSublayer(layerDireira)
        view.layer.addSublayer(layerEsquerda)
        view.layer.addSublayer(layerO)
        view.layer.addSublayer(layerInferior)

        
        var gradeView = UIImageView( frame : CGRect(x: (f.width/4), y: f.height/4 , width: f.width/2, height: f.height/4 ));
        gradeView.image = UIImage(named:"Group.png")
        

         var logoView = UIImageView();
        logoView.image = UIImage(named:"logo-qr-pague.png")
        logoView.sizeToFit()
        logoView.center =  CGPoint(x: labelWidth, y: (f.height/4 - logoView.frame.height ) )
        
 
        let labelD = UILabel()
        labelD.textAlignment = .center
        labelD.text = "Escaneie um código QRPAGUE"
        labelD.sizeToFit()
        labelD.textColor = UIColor.white
        labelD.center = CGPoint(x: (f.width/2), y: (f.height/2 + f.height/4 ) + labelD.frame.height )
        
        
        
        let labelTIPO = UILabel()
        labelTIPO.textAlignment = .center
        labelTIPO.text = "BOLETO / CONVENIOS"
        labelTIPO.sizeToFit()
        let w = labelTIPO.frame.width + 20
        let h =  labelTIPO.frame.height + 20
        labelTIPO.frame = CGRect(x: 0, y: 0, width: w , height: h )

        labelTIPO.textColor = UIColor.white
        labelTIPO.center = CGPoint(x: (f.width/2), y: (f.height/2 + f.height/8) + labelD.frame.height )
        
        labelTIPO.layer.cornerRadius = 9
        labelTIPO.layer.borderWidth = 1
        labelTIPO.layer.borderColor  = UIColor(red: 27/255, green: 100/255, blue: 90/255,  alpha: 1.0).cgColor
        labelTIPO.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(QrcodeController.choiceCodBarLayout))
        labelTIPO.isUserInteractionEnabled = true
        labelTIPO.addGestureRecognizer(tap)
        
        gradeView.tag = 99
        logoView.tag = 99
        labelD.tag = 99
        labelTIPO.tag = 99
        
        self.view.addSubview(gradeView)
        self.view.addSubview(logoView)
        self.view.addSubview(labelD)
//        self.view.addSubview(labelTIPO)

    }
    
    @objc
    func choiceCodQrCode(sender:UITapGestureRecognizer) {
        self.removeLayersAndViews( tag : 88, name: "layoutBarCode" )
        self.boletoTipo = "QRCODE"
//        startCaptureSession()
        layoutQrcode()
    }
    
    @objc
    func choiceCodBarLayout(sender:UITapGestureRecognizer) {
       
        self.removeLayersAndViews( tag : 99, name: "layoutQrcode" )
        self.boletoTipo = "CODIGOBARRA"
//        startCaptureSession()
        layoutBarCode()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        soundAlert()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.openWebview( tipo: self.boletoTipo, code: stringValue )
            captureSession.stopRunning()
            self.dismiss(animated: true)
        } 
        

    }
    
    enum AppDirectories : String
    {
        case Documents = "Documents"
        case Inbox = "Inbox"
        case Library = "Library"
        case Temp = "tmp"
    }
    
    @objc func notificationCameraQrcode() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if ( appDelegate.sufixUrl == nil ) {
            return
        }
        
        if ( !appDelegate.sufixUrl.contains("file://") )  {
            let url = appDelegate.sufixUrl!
            self.openWebview(tipo: "QRCODE", code: url)
        } else {
            
            let url = URL( string:  appDelegate.sufixUrl )

                do {  
                    let data = try Data(contentsOf: url! )
                    let dataString = String(data: data, encoding: .utf8)
                    self.openWebview(tipo: "CAMERA-NATIVA-QRCODE", code: dataString! )
                    
                } catch  {
                    print(error)
                }

            
        }
    }
    func openWebview(tipo: String,  code: String) {
        var bodyCode  = code.replacingOccurrences(of: " ", with: "")
 
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        webview = (webview != nil) ?  webview : storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        let view = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        view.code = bodyCode
        view.tipo = tipo
        DispatchQueue.main.async {
            self.present(view, animated: true, completion: nil)
        }
         
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    


    func soundAlert() {
 
        do {
            let systemSoundID: SystemSoundID = 1015

            AudioServicesPlaySystemSound (systemSoundID)


        } catch {
            // couldn't load file :(
        }



    }
    
    func removeLayersAndViews( tag: Int , name: String ) {
        self.view.layer.sublayers?.forEach { layer in
            if layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
        
        self.view.subviews.forEach { v in
            if v.tag == tag {
                v.removeFromSuperview()
            }
        }
        
    }
    
    
}


//
//  ViewController.swift
//  qrpague
//
//  Created by LEONARDO A SILVEIRA on 11/11/2018.
//  Copyright © 2018 QRPAGUE. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
    var webView: WKWebView!
    var contentController = WKUserContentController()
    
    var code:String!
    var tipo:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true

        
        print( code , tipo )
 
        let theConfiguration = WKWebViewConfiguration()
        contentController.add(self, name: "callbackHandler")
        
        theConfiguration.userContentController = contentController
        
        let codeEncode = self.code.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        
        webView = WKWebView(frame: self.view.frame, configuration: theConfiguration)
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www")!
        let urlWithParams =  URL.init( string: url.absoluteString + "#/home?code=" + codeEncode! + "&tipo=" + self.tipo)
        if ( urlWithParams ==  nil ) {
            return openQrcodeView()
        }
        webView.loadFileURL(urlWithParams!, allowingReadAccessTo: urlWithParams!)
        
        
        webView.configuration.userContentController.add(self, name: "backWebview")
        webView.configuration.userContentController.add(self, name: "showToast")
        webView.configuration.userContentController.add(self, name: "openQrcodeView")
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        view.backgroundColor = UIColor.red
        view = webView
        
    }

 
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finish to load")
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
     
        switch (message.name) {
        case "backWebview":
                webView.goBack()
            break
        case "showToast":
            popUpMsg( msg: message.body as! String)
            break
        case "openQrcodeView":
            openQrcodeView()
            break
        default:
            print("JavaScript is sending a message \(message.body)")
            break
            
        }
    }
    
    
    
    
    func popUpMsg( msg: String ) {
        let alert = UIAlertController(title: "Aviso!", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{ 
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)

    }
    
    func openQrcodeView() {
        self.dismiss(animated: true, completion: nil)
 
    }




}


//
//  RBWebViewController.swift
//  Reliability
//
//  Created by ESystems on 28/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit
import WebKit

class ReposWebViewController: UIViewController {
    
    @IBOutlet weak var webKitView: WKWebView!
    var urlStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //webKitView.loadHTMLString(specifcnDataStr, baseURL: nil)
        if let url = URL(string: urlStr) {
        let urlReq = URLRequest(url: url)
        webKitView.load(urlReq)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}

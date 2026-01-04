//
//  WebviewVC.swift
//  actb
//
//  Created by Khushal iOS on 03/10/25.
//

import UIKit
import WebKit

class WebviewVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var lblHeader: UILabel!
    var urlString: String?
    var headerString: String?
    
    @IBOutlet weak var webview_k: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblHeader.text = headerString ?? ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            loadWebsite()
        }

    func loadWebsite() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            guard let urlString = self.urlString, let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            self.webview_k.load(request)
        }
        
            
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        print("WebView failed: \(error.localizedDescription)")
    }
}

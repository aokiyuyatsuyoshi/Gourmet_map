//
//  webViewController.swift
//  Gourmet_map
//
//  Created by Yuya Aoki on 2021/07/14.
//

import UIKit
import WebKit
import SDWebImage

class webViewController: UIViewController {
    //ViewControllerから渡される値
    var URL = String()
    var ShopName = String()
    var ImageURL = String()
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sdImageにセットする
        ImageView.sd_setImage(with: NSURL(string: ImageURL)! as URL,completed:nil)
        let request = URLRequest(url: NSURL(string: URL) as! URL)
        webView.load(request)

        // Do any additional setup after loading the view.
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

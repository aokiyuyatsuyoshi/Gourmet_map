//
//  ViewController.swift
//  Gourmet_map
//
//  Created by Yuya Aoki on 2021/07/14.
//

import UIKit
import MapKit
import Lottie

class ViewController: UIViewController {
    //検索ワードを入力するTextField
    @IBOutlet weak var SearchField: UITextField!
    //マップを使用する
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //アニメーションを実行する関数
    func StartAnimation(){
        //AnimationViewのインスタンス
        let animationView = AnimationView()
        //どのアニメーションを呼ぶか指定
        let animationName = Animation.named("loadong")
        //全画面にアニメーションを適用させる
        animationView.frame = view.bounds
        //アニメーションはanimationNameを選択する
        animationView.animation = animationName
        //フィットサイズはscaleAspectFit
        animationView.contentMode = .scaleAspectFit
        //loopを有効化する
        animationView.loopMode = .loop
        //アニメーションを実行する
        animationView.play()
        //viewにanimationviewを追加する
        view.addSubview(animationView)
        
    }


}


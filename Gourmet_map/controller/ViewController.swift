//
//  ViewController.swift
//  Gourmet_map
//
//  Created by Yuya Aoki on 2021/07/14.
//

import UIKit
import MapKit
import Lottie

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    //検索ワードを入力するTextField
    @IBOutlet weak var SearchField: UITextField!
    //マップを使用する
    @IBOutlet weak var mapview: MKMapView!
    //CLLocationMAnagerのインスタンス
    var locationManager = CLLocationManager()
    //現在の経度
    var CurrentLatitude = 0.0
    //現在の緯度
    var CurrentLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthorizationLocation()
        StatusLocation()
        
        
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
    //現在地の取得が許可されていない場合、許可するか否かの画面が表示される
    func AuthorizationLocation(){
    
        locationManager.requestAlwaysAuthorization()
        //かなり正確な現在地を選択できる
        let status = CLAccuracyAuthorization.fullAccuracy
        //上記が選択された場合現在地を更新する
        if status == .fullAccuracy{
            locationManager.startUpdatingLocation()
        }
        
    
    }
    //現在地取得に関する詳細を設定
    func StatusLocation(){
        locationManager.delegate = self
        //かなり正確な精度を指定する
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //許可を常にする?
        locationManager.requestAlwaysAuthorization()
        //10mおきに現在地を更新
        locationManager.distanceFilter = 10
        //現在地を更新
        locationManager.startUpdatingLocation()
        
        mapview.delegate = self
        //mapのタイプをstandardに設定
        mapview.mapType = .standard
        //現在地からマップがスタートするかどうか
        mapview.userTrackingMode = .followWithHeading
        
    }
    //現在地が変化するごとに勝手に呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //最初に取れた現在地を使用(定型？)
        let location = locations.first
        //経度を取得
        CurrentLatitude = (location?.coordinate.latitude)!
        //緯度を取得
        CurrentLongitude = (location?.coordinate.longitude)!
        
    }
    
    


}


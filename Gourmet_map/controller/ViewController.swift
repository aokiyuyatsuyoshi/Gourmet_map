//
//  ViewController.swift
//  Gourmet_map
//
//  Created by Yuya Aoki on 2021/07/14.
//

import UIKit
import MapKit
import Lottie

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,GetShopdataDelegate{
    //検索ワードを入力するTextField
    @IBOutlet weak var SearchField: UITextField!

    @IBOutlet weak var mapView: MKMapView!
    //CLLocationMAnagerのインスタンス
    var locationManager = CLLocationManager()
    //現在の経度
    var CurrentLatitude = 0.0
    //現在の緯度
    var CurrentLongitude = 0.0
    //ショップの情報を格納する配列
    var ShopArray = [StructData]()
    //検索結果の数を格納する変数
    var ShopCount : Int = 0
    //AnimationViewのインスタンス
    let animationView = AnimationView()
    //アノテーションを行うURLを格納する配列
    var URLArray = [String]()
    //アノテーションを行うイメージのURLを格納する配列
    var ImageArray = [String]()
    //アノテーションを行う店舗名を格納する配列
    var NameArray = [String]()
    //MKPointAnnotationのインスタンス
    var Annotation = MKPointAnnotation()
    //現在呼ばれているアノテーションの場所(配列ない)
    var SelectedNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthorizationLocation()
        StatusLocation()
        
        
    }
    
    //アニメーションを実行する関数
    func StartAnimation(){

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
        
        mapView.delegate = self
        //mapのタイプをstandardに設定
        mapView.mapType = .standard
        //現在地からマップがスタートするかどうか
        mapView.userTrackingMode = .followWithHeading
        
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
    
    //サーチボタンが押された時の処理
    @IBAction func Search(_ sender: Any) {
        //アノテーションを消去する
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        //テキストフィールドを閉じる
        SearchField.resignFirstResponder()
        //アニメーションを開始
        StartAnimation()
        
        //実際にリクエストを投げるURL
        let API = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=d8b3d2e9d5b9007c&lat=\(CurrentLatitude)&lng=\(CurrentLongitude)&keyword=\(SearchField.text!)&range=3&format=json"
        print("APIのキーは:" + API)
        //GetApiModelに現在の緯度経度とURLを渡す
        var getApiModel = GetApiModel(latitude: CurrentLatitude, longitude: CurrentLongitude, url: API)
        //delegateの委任先をviewcontrollerへ
        getApiModel.getShopDelegate = self
        //実際にAlamofireで取得する
        getApiModel.GetData()
        }
    //delegateから渡された値
    func GetData(array: Array<StructData>, count: Int) {
             //アニメーションを閉じる
             animationView.removeFromSuperview()
             //取得した店舗の情報を格納
             ShopArray = array
             //取得すうを格納
             ShopCount = count
        
        MapAnnotation(shopArray: ShopArray)
         }
    
    //mapにアノテーションをつける
    func MapAnnotation(shopArray:[StructData]){

        //新しくアノテーションを行うので空にする
        URLArray = []
        ImageArray = []
        NameArray = []
        if ShopCount == 0 {
            
        }else{
            for i in 0...ShopCount-1{
                //MKPointAnnotationのインスタンス
                var Annotation = MKPointAnnotation()
                //緯度経度をアノテーションにセットする
                Annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(String(shopArray[i].CurrentLatitude!))!, CLLocationDegrees(String(shopArray[i].CurrentLongitude!))!)
                //アノテーションのタイトルに店の名前
                Annotation.title = shopArray[i].CurrentShopName
                //URLを配列に格納
                URLArray.append(shopArray[i].CurrentURL!)
                //imageURLを配列に格納
                ImageArray.append(shopArray[i].CurrentShopImage!)
                //店舗名を配列に格納
                NameArray.append(shopArray[i].CurrentShopName!)
                //アノテーションに追加
                mapView.addAnnotation(Annotation)
                
            }

        }

//        //テキストフィールドを閉じる
//        SearchField.resignFirstResponder()
        
        
    }
    //アノテーションが選択された時に呼ばれる
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //これで現在どこが選択されているかがわかる
        SelectedNumber = NameArray.firstIndex(of: (view.annotation?.title)!!)!
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! webViewController
        webVC.ShopName = NameArray[SelectedNumber]
        webVC.URL = URLArray[SelectedNumber]
        webVC.ImageURL = ImageArray[SelectedNumber]
        
    }
    
}


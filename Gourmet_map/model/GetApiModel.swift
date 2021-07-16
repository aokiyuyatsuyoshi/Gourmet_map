//
//  GetApiModel.swift
//  Gourmet_map
//
//  Created by Yuya Aoki on 2021/07/15.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol GetShopdataDelegate{
    func GetData(array:Array<StructData>,count:Int)
}

class GetApiModel{
    //ViewControllerから渡ってきた値を渡されるプロパティ
    var CurrentLatitude = 0.0
    var CurrentLongitude = 0.0
    var URL = ""
    //StruxtDataを入れる配列
    var StructDataArray = [StructData]()
    //GetShopDelegateを使用するインスタンス
    var getShopDelegate :GetShopdataDelegate?
    //ViewControllerから値を受け渡される
    init(latitude:Double,longitude:Double,url:String){
        CurrentLatitude = latitude
        CurrentLongitude = longitude
        URL = url
    }
    //実際にHTTPS通信を行う
    func GetData(){
        let EncodingURL:String = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF.request(EncodingURL).responseJSON{
            response in
        
            
            switch response.result{
            //レスポンスが成功の場合
            case .success:
                do {
                    let json:JSON = try JSON(data: response.data!)
                    //取得できた店の数
                    var totalCount = json["results"]["results_available"].int
                    
                    for i in 0...totalCount!-1{
                        let  Response_Results = StructData(CurrentLatitude:json["results"]["shop"][i]["lat"].double, CurrentLongitude: json["results"]["shop"][i]["lng"].double,CurrentURL:json["results"]["shop"][i]["urls"]["pc"].string,CurrentShopName:json["results"]["shop"][i]["name"].string,CurrentShopImage:json["results"]["shop"][i]["logo_image"].string)
                        //取得したデータをどんどん配列へ格納する
                        self.StructDataArray.append(Response_Results)
                        print("lat:" + String(json["results"]["shop"][i]["lat"].double!))
                        print("log:" + String(json["results"]["shop"][i]["lng"].double!))
                        print("URL:" + json["results"]["shop"][i]["urls"]["pc"].string!)
                        print("Name:" + json["results"]["shop"][i]["name"].string!)
                        print("Image:" + json["results"]["shop"][i]["logo_image"].string!)


          

                    }
                    //プロトコルを使用して値を渡す
                    self.getShopDelegate?.GetData(array: self.StructDataArray, count: totalCount!)
                } catch  {
                    print("エラーが発生しました")
                }
                break
            case .failure:
                print("失敗してます")
            break
                
            }
        }
    }
    
    
    
}

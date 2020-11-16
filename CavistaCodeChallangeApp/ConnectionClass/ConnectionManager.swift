//
//  UserViewModel.swift
//  CavistaCodeChallangeApp
//
//  Created by Susanta Mukherjee on 30/10/2020.
//  Copyright © 2020 Susanta Mukherjee. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

protocol APIManagerDelegate {
    
    func makeRequest()
}

class ConnectionManager: APIManagerDelegate{
    
    let realm = try! Realm()
        
    var aContents : [Contents]?
    var aDataPresentationLogic : DataPresentationDelegate?
    var delegate: APIManagerDelegate?
    
    
    func makeRequest(){
                
        let endPoint = "/AxxessTech/Mobile-Projects/master/challenge.json"
        
        AF.request(BASE_URL + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).response { (responceData) in
            
            
                    switch(responceData.result){
                        
                    case .success(_):
                        if (responceData.data != nil){
                            let jsonString = String(data: responceData.data!, encoding: .utf8)!
                            print("\(jsonString)")
                            
                            if let responseArr = [Contents](JSONString: jsonString){
                                
                                print("\(responseArr)")
                                
                                let realm = try! Realm()
                                realm.beginWrite()
                                realm.add(responseArr, update: Realm.UpdatePolicy.modified)
                                if realm.isInWriteTransaction {
                                    try! realm.commitWrite()
                                }
                                self.aContents = responseArr
                                self.aDataPresentationLogic?.PresentData(response: responseArr)
                            }
                        }
                        else{
                             let realm = try! Realm()
                                let results =  realm.objects(Contents.self)
                                if let data = results.first{
                                    self.aContents = [data]
                                    self.aDataPresentationLogic?.PresentData(response: [data])
                                }
                            
                        }
                    case .failure(_):
                        
                       let realm = try! Realm()
                       let results =  realm.objects(Contents.self)
                       if let data = results.first{
                           self.aContents = [data]
                           self.aDataPresentationLogic?.PresentData(response: [data])
                       }
                    }
                }
    }
    

}




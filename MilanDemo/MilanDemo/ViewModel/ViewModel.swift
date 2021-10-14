//
//  ViewModel.swift
//  MilanDemo
//
//  Created by Milan on 03/09/21.
//  Copyright © 2021 Milan. All rights reserved.
//

import Foundation

class ViewModel : NSObject {
    
    //MARK:- Properties
    var arrResult = [Results]()
    
    
    //MARK:- Functions
    func getAllData(completionHandeler:@escaping ((_ success:Bool, _ message:String)->()) ){
        let utility = MHttpUtility.shared // using the shared instance of the utility to make the API call
        let requestUrl = URL(string: "https://www.hackingwithswift.com/samples/petitions-1.json")
        let request = HURequest(withUrl: requestUrl!, forHttpMethod: .get)
        
        utility.request(huRequest: request, resultType: BaseModel.self) { (response) in
            switch response {
                
            case .success(let data):
                guard let results = data?.results else {
                    completionHandeler(false, "")
                    return
                }
                
                self.arrResult = results
                
                completionHandeler(true, "")
                
            case .failure(let error):
                print(error)
                completionHandeler(false, error.localizedDescription)
            }
        }
    }
}


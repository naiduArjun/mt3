//
//  NetworkManger.swift
//  MapPrrTask
//
//  Created by ESystems on 26/11/18.
//  Copyright © 2018 Naidu. All rights reserved.
//

import UIKit

typealias networkCompletionHandler = (_ response: URLResponse?, _ json: AnyObject?, _ error: Error?) -> Void

class NetworkManager: NSObject {
   
    static let shared: NetworkManager! = NetworkManager()
    private override init() {
        super.init()
    }
    
    func loadDetailsFromService(with urlStr: String,_ completionHanlder: @escaping networkCompletionHandler) {
        let url = URL(string: urlStr)!
       // var request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    completionHanlder(nil, nil, error)
                }
                return
            }
            do {
//                if let dataStr = String(data: data, encoding: .utf8) {
//                    print(dataStr)
//                }
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject {
                    print(responseJSON)
                    completionHanlder(response, responseJSON as AnyObject, nil)
                }
            }catch let error {
                debugPrint(error)
            }
        }
        task.resume()
    }
}


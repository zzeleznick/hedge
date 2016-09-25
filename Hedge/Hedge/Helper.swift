//
//  Helper.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/25/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import Foundation


class Helper {
    
    var result: [String:String] = [:]
    class func parseText(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
            return nil
    }
    class func get(callback: @escaping (_ result: [String:Any]) -> Void ) {
        let requestURL = URL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let request = NSMutableURLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
            }
            if let urlContent = data {
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    print(jsonResult)
                    
                    if let json = jsonResult as? [String:Any] {
                        var pResult: [String: Any] = [:] //["foo": "bar"]
                        for (key, value) in json {
                            print("\(key) - \(value) ")
                            // pResult[key] = "\(value)"
                            /* if let sjson = value as? [String:Any] {
                                for (skey, svalue) in sjson {
                                    pResult[skey] = "\(svalue)"
                                }
                            } */
                            let pcontainer = value as! [ [String:Any] ]
                            for (id, container) in pcontainer.enumerated() {
                                let scontainer = container as [String:AnyObject]
                                var sid = 0
                                for (skey, svalue) in scontainer {
                                    pResult["\(sid)"] = ["\(skey)": "\(svalue)"]
                                    sid += 1
                                }
                            }
                        }
                        
                        callback(pResult)
                    }
                    
                } catch {
                    
                    print("JSON Processing Failed")
                }
            }
        }
        task.resume()
    }
}

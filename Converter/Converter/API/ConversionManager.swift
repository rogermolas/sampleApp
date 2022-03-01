//
//  ConversionManager.swift
//  Converter
//
//  Created by Roger Molas on 3/1/22.
//

import Foundation
import RMHttp

let baseURL = "http://api.evp.lt/currency/commercial/exchange"

class ConversionManager {
    
    func convert(amount: Double, from:String, to:String, completionHandler:@escaping CompletionBlock<ResultModel>) {
        
        let endpoint = "\(baseURL)/\(amount)-\(from)/\(to)/latest"
        let request = RMRequest(endpoint, .GET(.URLEncoding), nil, nil)
        RMHttp.JSON(request: request, model: ResultModel.self) { response, error in
            print("Sending request to : \(endpoint)")
            guard error == nil else {
                if let data = error?.response?.data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data as Data, options: []) as? [String : Any]
                        completionHandler(nil, (json!["error_description"] as! String))
                    } catch {
                        completionHandler(nil, "Unknown")
                    }
                } else {
                    completionHandler(nil, "Unknown")
                }
                return
            }
            print(response!)
            completionHandler(response, nil)
        }
    }
}

extension ConversionManager {
   // Expected response for any type of Models
   internal typealias CompletionBlock<T> = (_ response: T?, _ error: String?) -> Void
}

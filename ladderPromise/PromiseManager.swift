//
//  PromiseManager.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/24/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import Foundation

class PromiseManager {
    
    var promises = [Promise]()
    var delegate: PromiseManagerDelegate? = nil
    
    func getData(url: String) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil else {
                print("error, no data found")
                return
            }
            if error != nil {
                print("Error: '\(error!)'")
            }
            let json = JSON(data!)
            let promises = json.array!
            print(promises)
            
            for promise in promises {
                let dataId = promise["id"].int
                let completed = promise["completed"].bool
                let promise = promise["promise"].string
                
                let promiseObject = Promise(id: dataId!, promise: promise!, completed: completed!)
                
                self.promises.append(promiseObject)
                
            }
            print(self.promises)
            
            if let delegate = self.delegate {
                DispatchQueue.main.async {
                    delegate.loadedPromises()
                }
            }
            
        }
        task.resume()
        
    }
    
    
    func postData(){
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/promises/")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newPost = ["promise" : "I won't eat chips"]
        let jsonedPost = try! JSONSerialization.data(withJSONObject: newPost, options: [])
        request.httpBody = jsonedPost
        
        print(newPost)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let data = data
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
            }
            
            let responseString = JSON(data)
            print(responseString)
        }
        task.resume()
    }

}

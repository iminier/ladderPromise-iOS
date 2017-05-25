//
//  PromiseManager.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/24/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import Foundation

class PromiseManager {
    
    // Declare an array of Promise objects
    var promises = [Promise]()
    
    // Hard coded list, later can be pulled from list of suggestions based on 
    // user trends, user specific data, workout ruitine specific, etc that can
    // be user or coach specific
    var promiseSuggestions = ["I will walk xx minutes.",
                              "I will stand for xx minutes.",
                              "I will read for xx minutes.",
                              "I won't use my phone xx minutes before bed.",
                              "I won't eat processed sugars"]
    
    var delegate: PromiseManagerDelegate? = nil // class delegate declaration
    
    // GET
    func getData(url: String) {
        
        let request = URLRequest(url: URL(string: url)!) // Convert url to URL
        
        // Start task (background) task to get data from api
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check that there is data
            guard data != nil else {
                print("error, no data found")
                return
            }
            
            // Check for error code from server in error
            if error != nil {
                print("Error: '\(error!)'")
            }
            
            // Convert to array of type JSON from (swiftyJSON.swift)
            let json = JSON(data!)
            
            // Convert to swift array otherwise we can't parse as JSON array throws error when you try to pull data in coming for loop
            let promises = json.array!
            
            // Add each promise to array
            for promise in promises {
                let dataId = promise["id"].int
                let completed = promise["completed"].bool
                let promise = promise["promise"].string
                
                let promiseObject = Promise(id: dataId!, promise: promise!, completed: completed!)
                
                self.promises.append(promiseObject)
                
            }
            
            // Run loadedPromises methon on main queue in order to reload the tableview
            if let delegate = self.delegate {
                DispatchQueue.main.async {
                    delegate.loadedPromises()
                }
            }
        }
        
        task.resume()
    }
    
    // DELETE
    func deleteData(url: String) {
        var request = URLRequest(url: URL(string: url)!) // Convert url to URL
        request.httpMethod = "DELETE" // Set request type to DELETE
        
        // Start background task to delete selected row in tableview
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for error code from server in error
            if error != nil {
                print("Error: '\(error!)'")
            }
        }
        
        task.resume()
        
    }
    
    // POST
    func postData(url: String, promise: String) {
        var request = URLRequest(url: URL(string: url)!) // Convert url to URL
        request.httpMethod = "POST" // Set request to POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // Set request value to json
        let newPost = ["promise" : promise] // New post String:String dictionary
        let jsonedPost = try! JSONSerialization.data(withJSONObject: newPost, options: []) // Convert post to json
        request.httpBody = jsonedPost //Set http body to json from jsonedPost
        
        // Start background task to send new promise
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for error code from server in error
            if error != nil {
                print("Error: '\(error!)'")
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
            }
            
            // Run loadedPromises method on main queue in order to reload the tableview
            self.getData(url: url)
            if let delegate = self.delegate {
                DispatchQueue.main.async {
                    delegate.loadedPromises()
                }
            }
        }
        
        task.resume()
    }

}

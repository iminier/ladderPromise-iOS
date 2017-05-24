//
//  Promise.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/24/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import Foundation

import Foundation

//

class Promise {
    
    var id: Int?
    var promise: String?
    var completed: Bool?
    
    init(id: Int, promise: String, completed: Bool) {
        self.id = id
        self.promise = promise
        self.completed = completed
    }
}

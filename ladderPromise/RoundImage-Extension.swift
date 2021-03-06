//
//  RoundImage-Extension.swift
//  ladderPromise
//
//  Created by Ivan Minier on 5/22/17.
//  Copyright © 2017 Ivan Minier. All rights reserved.
//

import UIKit

// makes square image round. Used to make profile image round.
extension UIImageView {
    
    func makeImageRound() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}

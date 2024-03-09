//
//  UserInfo.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit
import CoreML

struct UserInfo {
    let gender: String
    let animal: String
    let hobbie: String
    
    var prompt: String {
        gender + " " + animal + " " + hobbie
    }
}

struct User {
    let info: UserInfo
    let embedding: MLMultiArray
    let avatar: UIImage
}

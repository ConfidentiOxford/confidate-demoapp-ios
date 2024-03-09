//
//  PrivatarViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation
import CoreML

final class PrivatarViewModel {
    weak var view: PrivatarViewController?
    var userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    func finishTapped() {
        // Create embedding
        let embedder = UserEmbedder()
        let embedding = try? embedder.embed(userInfo: userInfo)
        if let embedding = embedding {
            print(embedding)
        }
    }
    
    func regenerateTapped() {
        
    }
}

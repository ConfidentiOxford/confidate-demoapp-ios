//
//  PrivatarViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit
import CoreML

final class PrivatarViewModel {
    weak var view: PrivatarViewController?
    let generator: AvatarGenerator
    
    var userInfo: UserInfo
    var lastImage: UIImage?
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.generator = AvatarGenerator()
    }
    
    func finishTapped() {
        // Create embedding
        let embedder = UserEmbedder()
        let embedding = try? embedder.embed(userInfo: userInfo)
        if let embedding = embedding, let lastImage = lastImage {
            // MARK: - WE HAVE USER AVATAR AND EMBEDDING
            let user = User(info: userInfo,
                            embedding: embedding,
                            avatar: lastImage)
            let vc = MVVMBuilder.setUpWalletConnectVC(user: user)
            view?.present(vc)
        } else {
            view?.showAllert()
        }
    }
    
    func regenerateTapped() async {
        await view?.set(image: nil)
        await view?.startAnimating()
        let image = await generator.generate(userInfo: userInfo)
        if let image = image {
            lastImage = image
            await view?.set(image: image)
            await view?.stopAnimating()
        }
    }
}

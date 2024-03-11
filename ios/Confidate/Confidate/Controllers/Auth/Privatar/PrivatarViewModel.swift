//
//  PrivatarViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit
import CoreML
import Combine
import SwiftUI
import UIKit
import WalletConnectSign
import Web3Modal

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
            let userData = UserData(user: user)
            
            
            let projectId = "a8c9ba3d40503f0e4f97518fdd1b2b71"
            
            var disposeBag = Set<AnyCancellable>()
            var socketConnectionManager = SocketConnectionManager()
            
            let methods: Set<String> = ["eth_sendTransaction", "personal_sign", "eth_signTypedData", "eth_signTransaction"]
            let events: Set<String> = ["chainChanged", "accountsChanged"]
            let blockchains: Set<Blockchain> = [Blockchain("eip155:1")!, Blockchain("eip155:137")!]
            let namespaces: [String: ProposalNamespace] = [
                "eip155": ProposalNamespace(
                    chains: blockchains,
                    methods: methods,
                    events: events
                )
            ]

            let defaultSessionParams =  SessionParams(
                                            requiredNamespaces: namespaces,
                                            optionalNamespaces: nil,
                                            sessionProperties: nil
                                        )
            


            let metadata = AppMetadata(
                name: "Web3Modal Swift Dapp",
                description: "Web3Modal DApp sample",
                url: "www.confidenti.io",
                icons: ["https://avatars.githubusercontent.com/u/37784886"],
                redirect: .init(native: "w3mdapp://", universal: nil)
            )

            Networking.configure(
                groupIdentifier: "group.com.walletconnect.web3modal",
                projectId: projectId,
                socketFactory: DefaultSocketFactory()
            )

            Web3Modal.configure(
                projectId: projectId,
                metadata: metadata,
                sessionParams: defaultSessionParams,
                customWallets: [
                    .init(
                         id: "swift-sample",
                         name: "Swift Sample Wallet",
                         homepage: "https://walletconnect.com/",
                         imageUrl: "https://avatars.githubusercontent.com/u/37784886?s=200&v=4",
                         order: 1,
                         mobileLink: "walletapp://"
                     )
                ]
            ) { error in
                
                print(error)
            }
            
            Web3Modal.instance.socketConnectionStatusPublisher.receive(on: DispatchQueue.main).sink { [unowned self] status in
                print("Socket connection status: \(status)")
                socketConnectionManager.socketConnected = (status == .connected)

            }.store(in: &disposeBag)
            Web3Modal.instance.logger.setLogging(level: .debug)
            
            let hostingController = UIHostingController(rootView: ContentView()
                .environmentObject(userData)
                .environmentObject(socketConnectionManager) // Передача окружения
                .onOpenURL { url in
                    Web3Modal.instance.handleDeeplink(url)
                }
                .onReceive(Web3Modal.instance.sessionResponsePublisher, perform: { response in
                    switch response.result {
                    case let .response(value):
                        print("Session response: \(value.stringRepresentation)")
                    case let .error(error):
                        print("Session error: \(error)")
                    }
                })
                    
            )
            view?.present(hostingController)
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
        } else {
            print("Error during avatar generation")
        }
    }
}

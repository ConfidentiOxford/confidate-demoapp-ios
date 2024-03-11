//
//  InitialViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import WalletConnectSign
import Web3Modal

final class InitialViewModel {
    weak var view: InitialViewController?
    
    @objc func logInTapped() {
        print("[InitialViewModel] SignIn tapped")
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
            }))
        view?.translate(to: hostingController)
    }
    
    
    @objc func signUpTapped() {
        print("[InitialViewModel] SignUp tapped")
        let signupVC = MVVMBuilder.setupVC
        view?.translate(to: signupVC)
    }
}

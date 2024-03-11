//
//  MainApp.swift
//  Confidate
//
//  Created by Artem Grigor on 09/03/2024.
//

import Combine
import SwiftUI
import UIKit
import WalletConnectSign
import Web3Modal


class SocketConnectionManager: ObservableObject {
    @Published var socketConnected: Bool = false
}

// MARK: MAIN APP

//@main
class ExampleApp: App {
    private var disposeBag = Set<AnyCancellable>()
    private var socketConnectionManager = SocketConnectionManager()


    @State var alertMessage: String = "Hurray!"

    required init() {

        let projectId = "a8c9ba3d40503f0e4f97518fdd1b2b71"
        
        
        
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
        setup()

    }

    func setup() {
        Web3Modal.instance.socketConnectionStatusPublisher.receive(on: DispatchQueue.main).sink { [unowned self] status in
            print("Socket connection status: \(status)")
            self.socketConnectionManager.socketConnected = (status == .connected)

        }.store(in: &disposeBag)
        Web3Modal.instance.logger.setLogging(level: .debug)
    }

    var body: some Scene {
        WindowGroup { [unowned self] in
            ContentView()
                .environmentObject(socketConnectionManager)
                .onOpenURL { url in
                    Web3Modal.instance.handleDeeplink(url)
                }
                .onReceive(Web3Modal.instance.sessionResponsePublisher, perform: { response in
                    switch response.result {
                    case let .response(value):
                        self.alertMessage = "Session response: \(value.stringRepresentation)"
                    case let .error(error):
                        self.alertMessage = "Session error: \(error)"
                    }
                })
        }
    }
}

// MARK: ContentView


import SwiftUI
import Web3Modal
import Web3
import Web3ContractABI
import Web3ModalBackport
import Web3PromiseKit


struct ContentView: View {
    @State var showUIComponents: Bool = false
    @EnvironmentObject var socketConnectionManager: SocketConnectionManager
    @EnvironmentObject var user: UserData
    @State private var showAlert = false


    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Web3ModalButton()
                
                Web3ModalNetworkButton()
                
                Spacer()
                
                
                Button("Mint Your Privatar NFT") {
                                    
                    let _embedding = generateEmbeddingArray()
                    let (_pA, _pB, _pC, _pubSignals) = generateProofData()
                    let _avatarUrl = "some_url"

                                
                    sendMintTx(_embedding: _embedding, _avatarUrl: _avatarUrl, _pA: _pA, _pB: _pB, _pC: _pC, _pubSignals: _pubSignals)
                    
                    
                    self.showAlert = true
                    
                }                    
                .buttonStyle(W3MButtonStyle())
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Congratulations!"),
                        message: Text("Congratulations on Your New Private NFT!"),
                        dismissButton: .default(Text("OK"))
                    )
                }

            }
            .overlay(
                HStack {
                    Circle()
                        .fill(socketConnectionManager.socketConnected ? Color.Success100 : Color.Error100)
                        .frame(width: 10, height: 10)

                    Text("Socket \(socketConnectionManager.socketConnected ? "Connected" : "Disconnected")")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(socketConnectionManager.socketConnected ? Color.Success100 : Color.Error100)
                },
                alignment: .top
            )
        }
    }
    
    func requestPersonalSign() {
        Task {
            do {
                guard let address = Web3Modal.instance.getAddress() else { return }
                
                guard let currentChainId = Web3Modal.instance.getSelectedChain() else {
                    fatalError("Chain not connected")
                }
                
                try await Web3Modal.instance.request(.personal_sign(address: address, message: "Hey!"))
                
            } catch {
                print(error)
            }
        }
    }
    
    
}

// MARK: Component Lib

import SwiftUI
import Web3Modal


struct ComponentLibraryView: View {
    var body: some View {
        listView
            .navigationTitle("Components")
    }

    var listView: some View {
        Group {
#if DEBUG
            List {
                NavigationLink(destination: AccountButtonPreviewView()) {
                    Text("AccountButton")
                }
                NavigationLink(destination: NetworkButtonPreviewView()) {
                    Text("NetworkButton")
                }
                NavigationLink(destination: W3MButtonStylePreviewView()) {
                    Text("W3MButton")
                }
                NavigationLink(destination: W3MCardSelectStylePreviewView()) {
                    Text("W3MCardSelect")
                }
                NavigationLink(destination: W3MTagPreviewView()) {
                    Text("W3MTag")
                }
                NavigationLink(destination: W3MListSelectStylePreviewView()) {
                    Text("W3MListSelect")
                }
                NavigationLink(destination: W3MActionEntryStylePreviewView()) {
                    Text("W3MActionEntry")
                }
                NavigationLink(destination: QRCodeViewPreviewView()) {
                    Text("QRCode")
                }
                NavigationLink(destination: W3MChipButtonStylePreviewView()) {
                    Text("W3MChipButtonStyle")
                }
                NavigationLink(destination: W3MListItemButtonStylePreviewView()) {
                    Text("W3MListItemButtonStyle")
                }
                NavigationLink(destination: ToastViewPreviewView()) {
                    Text("ToastView")
                }
            }
            .listStyle(.plain)
#endif
        }
    }
}

// MARK: Socket


import Foundation
import WalletConnectRelay
import Starscream

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        let socket = WebSocket(url: url)
        let queue = DispatchQueue(label: "com.walletconnect.sdk.sockets", attributes: .concurrent)
        socket.callbackQueue = queue
        return socket
    }
}

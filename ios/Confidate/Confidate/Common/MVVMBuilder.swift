//
//  MVVMBuilder.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation

final class MVVMBuilder {
    static let shared = MVVMBuilder()
    private init() {}
    /// Create Initial View Controller
    static var initialVC: InitialViewController {
        let viewModel = InitialViewModel()
        let vc = InitialViewController(viewModel: viewModel)
        viewModel.view = vc
        return vc
    }
    /// Create Set up View Controller
    static var setupVC: SetUpViewController {
        let viewModel = SetUpViewModel()
        let vc = SetUpViewController(viewModel: viewModel)
        viewModel.view = vc
        return vc
    }
    // Create Avatar ViewController
    static func privatarVC(userInfo: UserInfo) -> PrivatarViewController {
        let viewModel = PrivatarViewModel(userInfo: userInfo)
        let vc = PrivatarViewController(viewModel: viewModel)
        viewModel.view = vc
        return vc
    }
    /// Create WalletConnect View Controller
    static var walletConnectVC: WalletConnectViewController {
        let viewModel = WalletConnectViewModel()
        let vc = WalletConnectViewController(viewModel: viewModel)
        viewModel.view = vc
        return vc
    }
    static func setUpWalletConnectVC(user: User) -> WalletConnectViewController {
        let viewModel = WalletConnectViewModel(user: user)
        let vc = WalletConnectViewController(viewModel: viewModel)
        viewModel.view = vc
        return vc
    }
}

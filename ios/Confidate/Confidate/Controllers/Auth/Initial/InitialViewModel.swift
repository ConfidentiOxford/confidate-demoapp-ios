//
//  InitialViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation

final class InitialViewModel {
    weak var view: InitialViewController?
    
    @objc func logInTapped() {
        print("[InitialViewModel] SignIn tapped")
        let walletVC = MVVMBuilder.walletConnectVC
        view?.translate(to: walletVC)
    }
    
    @objc func signUpTapped() {
        print("[InitialViewModel] SignUp tapped")
        let signupVC = MVVMBuilder.setupVC
        view?.translate(to: signupVC)
    }
}

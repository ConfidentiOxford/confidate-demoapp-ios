//
//  InitialViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation

import Foundation

final class InitialViewModel {
    weak var view: InitialViewController?
    
    @objc func logInTapped() {
        print("[InitialViewModel] SignIn tapped")
    }
    
    @objc func signUpTapped() {
        print("[InitialViewModel] SignUp tapped")
    }
}

//
//  PrivatarViewModel.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import Foundation

final class PrivatarViewModel {
    weak var view: PrivatarViewController?
    var userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}

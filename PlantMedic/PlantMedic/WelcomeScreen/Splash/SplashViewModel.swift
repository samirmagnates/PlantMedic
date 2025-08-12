//
//  SplashViewModel.swift
//  PlantMedic
//
//  Created by Magnatesage  on 01/08/25.
//

import Combine
import Foundation

class SplashViewModel: ObservableObject {
    @Published var showLogin = false
    @Published var showSignup = false

    func navigateToLogin() {
        showLogin = true
    }

    func navigateToSignup() {
        showSignup = true
    }
}

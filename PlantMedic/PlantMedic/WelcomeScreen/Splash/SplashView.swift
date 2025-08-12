//
//  SplashView.swift
//  PlantMedic
//
//  Created by Magnatesage  on 01/08/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Image("splash_image") // Use your image asset name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                VStack(spacing: 16) {
                    Button("Login") {
                        viewModel.navigateToLogin()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Sign Up") {
                        viewModel.navigateToSignup()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $viewModel.showSignup) {
                SignupView()
            }
        }
    }
}

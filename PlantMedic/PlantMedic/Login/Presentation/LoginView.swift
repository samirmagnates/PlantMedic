//
//  LoginView.swift
//  PlantMedic
//
//  Created by Magnatesage  on 24/07/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel(
        loginUseCase: LoginUseCase(repository: AuthRepository())
    )

    @State private var navigateToSignup = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image("splash_image")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top)

                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                if let error = viewModel.emailError {
                    Text(error).foregroundColor(.red).font(.footnote)
                }

                HStack {
                    if viewModel.isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button(action: { viewModel.togglePasswordVisibility() }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                if let error = viewModel.passwordError {
                    Text(error).foregroundColor(.red).font(.footnote)
                }

                Button("Forgot Password?") {
                    // Future action
                }
                .font(.footnote)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .trailing)

                Button("Login") {
                    Task {
                        await viewModel.login()
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                HStack {
                    Text("New here?")
                    Button("Register") {
                        navigateToSignup = true
                    }
                    .foregroundColor(.blue)
                }
                .font(.footnote)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
            }
        }
    }
}

// struct LoginView1: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//
//    @ObservedObject var presenter: LoginPresenter
//    let interactor: LoginInteractorProtocol
//    let router = LoginRouter()
//
//    var body: some View {
//        VStack(spacing: 24) {
//            // Header
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Welcome back! Glad to see you, Again!")
//                    .font(.system(size: 28, weight: .bold))
//                    .foregroundColor(.black)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.top, 32)
//
//            // Email and Password fields
//            VStack(spacing: 16) {
//                AppTextField(
//                    placeholder: "Enter your email",
//                    text: $email,
//                    keyboardType: .emailAddress
//                )
//
//                AppTextField(
//                    placeholder: "Enter your password",
//                    text: $password,
//                    isSecure: true
//                )
//            }
//
//            // Forgot Password Row
//            HStack {
//                Spacer()
//                Button(action: {
//                    presenter.showForgotPassword()
//                }) {
//                    Text("Forgot Password?")
//                        .foregroundColor(Color(.gray))
//                        .font(.system(size: 14, weight: .regular))
//                }
//            }
//
//            // Login Button
//            AppButton(
//                title: "Login",
//                action: {
//                    interactor.login(email: email, password: password)
//                },
//                backgroundColor: .black,
//                foregroundColor: .white,
//                cornerRadius: 12,
//                height: 50
//            )
//            .disabled(email.isEmpty || password.isEmpty)
//            .padding(.top, 8)
//
//            // Spacer with "Or"
//            orDivider
//
//            // Social Login Buttons
//            HStack(spacing: 16) {
//                socialButton(iconName: "facebook", action: { /* Facebook logic */ })
//                socialButton(iconName: "google", action: { /* Google logic */ })
//                socialButton(iconName: "applelogo", isSF: true, action: { /* Apple logic */ })
//            }
//            .padding(.top, 8)
//
//            Spacer()
//
//            // Register prompt
//            HStack {
//                Text("Don't have an account?")
//                    .foregroundColor(.gray)
//                AppButton(title: "Register Now", action: {
//                    presenter.showForgotPassword()
//                }, backgroundColor: .white, foregroundColor: .blue, borderColor: .white, borderWidth: 1)
//
//            }
//            .padding(.bottom, 16)
//        }
//        .padding(.horizontal, 24)
//        .background(Color.white)
//        .navigationBarBackButtonHidden(false)
//        // Navigation for routes (like Forgot Password/Register)
//        .background(
//            NavigationLink(
//                destination: router.destination(for: presenter.route),
//                isActive: Binding(
//                    get: { presenter.route != .none },
//                    set: { if !$0 { presenter.route = .none } }
//                )
//            ) {
//                EmptyView()
//            }
//        )
//        // Optional: present error/success messages
//        .overlay(
//            Group {
//                if let errorMsg = presenter.errorMessage {
//                    Text(errorMsg)
//                        .foregroundColor(.red)
//                        .padding()
//                        .background(Color.white.shadow(radius: 3))
//                        .cornerRadius(8)
//                        .padding(.top, 16)
//                }
//            }, alignment: .top
//        )
//    }
//
//    var orDivider: some View {
//        HStack {
//            Rectangle()
//                .fill(Color(.secondarySystemFill))
//                .frame(height: 1)
//            Text("Or Login with")
//                .foregroundColor(.gray)
//                .font(.system(size: 14))
//            Rectangle()
//                .fill(Color(.secondarySystemFill))
//                .frame(height: 1)
//        }
//        .padding(.vertical, 12)
//    }
//
//    func socialButton(iconName: String, isSF: Bool = false, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Group {
//                if isSF {
//                    Image(systemName: iconName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22, height: 22)
//                        .foregroundColor(.black)
//                } else {
//                    Image(iconName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22, height: 22)
//                }
//            }
//            .padding()
//            .frame(width: 56, height: 56)
//            .background(Color(.secondarySystemBackground))
//            .cornerRadius(12)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
// }
//
//
// struct LoginView1_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create instances for preview
//        let worker = LoginWorker()
//        let interactor = LoginInteractor(worker: worker)
//        let presenter = LoginPresenter()
//        interactor.presenter = presenter
//
//        // Inject dependencies into LoginView
//        return LoginView1(presenter: presenter, interactor: interactor)
//    }
// }

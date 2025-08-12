//
//  LoginModels.swift
//  PlantMedic
//
//  Created by Magnatesage  on 24/07/25.
//

import Foundation

struct LoginRequest {
    let email: String
    let password: String
}

enum LoginError: Error, LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        }
    }
}

enum ValidationError: LocalizedError {
    case invalidEmail
    case invalidPassword

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPassword:
            return "Password must be at least 6 characters, and include 1 uppercase, 1 lowercase, and 1 special character."
        }
    }
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false

    @Published var emailError: String?
    @Published var passwordError: String?

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    func login() async {
        emailError = nil
        passwordError = nil

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            emailError = "Email is required."
            return
        }

        guard isValidEmail(email) else {
            emailError = "Invalid email format."
            return
        }

        guard !password.isEmpty else {
            passwordError = "Password is required."
            return
        }

        guard password.count >= 7 else {
            passwordError = "Password must be at least 7 characters."
            return
        }

        do {
            let message = try await loginUseCase.execute(email: email, password: password)
            print("✅ Login Success: \(message)")
        } catch {
            passwordError = error.localizedDescription
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

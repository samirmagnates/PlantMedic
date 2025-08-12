//
//  AuthAPIService.swift
//  PlantMedic
//
//  Created by Magnatesage  on 01/08/25.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> String
}

class AuthRepository: AuthRepositoryProtocol {
    private let api = AuthAPIService()

    func login(email: String, password: String) async throws -> String {
        return try await api.performLogin(email: email, password: password)
    }
}

//
//  AuthRepository.swift
//  PlantMedic
//
//  Created by Magnatesage  on 01/08/25.
//

import Foundation

@MainActor
class AuthAPIService {
    func performLogin(email: String, password: String) async throws -> String {
        guard let url = URL(string: "https://yourapi.com/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200 ..< 300 ~= httpResponse.statusCode
        else {
            throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials."])
        }

        // Parse response if needed
        let message = String(data: data, encoding: .utf8) ?? "Login success"
        return message
    }
}

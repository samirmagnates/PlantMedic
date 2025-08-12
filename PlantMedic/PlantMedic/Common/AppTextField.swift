//
//  AppTextField.swift
//  PlantMedic
//
//  Created by Magnatesage  on 24/07/25.
//

import SwiftUI

struct AppTextField: View {
    // Placeholder text shown when the field is empty
    let placeholder: String
    // Bound text value
    @Binding var text: String
    // Keyboard type e.g., .emailAddress, .default, .numberPad etc.
    var keyboardType: UIKeyboardType = .default
    // Determines if the field should obscure text (useful for passwords)
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .textContentType(keyboardType == .emailAddress ? .emailAddress : .none)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .font(.system(size: 16))
        .disableAutocorrection(true)
    }
}

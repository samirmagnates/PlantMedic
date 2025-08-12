//
//  AppStyle.swift
//  PlantMedic
//
//  Created by Magnatesage  on 24/07/25.
// this is testing

import SwiftUI

enum AppColors {
    static let background = Color("BackgroundColor") // define in Assets.xcassets
    static let textPrimary = Color("TextPrimary") // define in Assets.xcassets
    static let textSecondary = Color("TextSecondary") // define in Assets.xcassets

    // Or define using RGB directly if you don't want asset colors:
    // static let background = Color(red: 0.95, green: 0.95, blue: 0.97)
    // static let textPrimary = Color.black
    // static let textSecondary = Color.gray
}

enum AppFonts {
    static func primaryFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.system(size: size, weight: weight)
    }

    // Add custom font loader if you have custom fonts:
    // static func customFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
    //     Font.custom("YourFontName", size: size).weight(weight)
    // }
}

enum AppFontSizes {
    static let small: CGFloat = 12
    static let normal: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}

struct AppButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = .black
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 12
    var height: CGFloat = 48
    var borderColor: Color? // Optional border color
    var borderWidth: CGFloat = 1

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.primaryFont(size: AppFontSizes.normal, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: height)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    // Add this overlay only if borderColor is set
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor ?? Color.clear, lineWidth: borderWidth)
                )
        }
    }
}

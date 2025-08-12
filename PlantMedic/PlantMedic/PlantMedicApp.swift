//
//  PlantMedicApp.swift
//  PlantMedic
//
//  Created by Magnatesage  on 24/07/25.
//

import SwiftUI

@main
struct PlantMedicApp: App {
    var body: some Scene {
            WindowGroup {
//                let worker = LoginWorker()
//                let interactor = LoginInteractor(worker: worker)
//                let presenter = LoginPresenter()
//                interactor.presenter = presenter
//                // Explicitly return the view with `return`
//                return LoginView(presenter: presenter, interactor: interactor)

//                let interactor = WelcomeInteractor()
//                let presenter = WelcomePresenter()
//                interactor.presenter = presenter
//                return WelcomeView(presenter: presenter, interactor: interactor)
                return SplashView()

            }

    }
}

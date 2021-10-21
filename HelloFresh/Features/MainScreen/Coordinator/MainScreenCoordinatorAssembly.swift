//
//  MainScreenCoordinatorAssembly.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation
import Swinject

final class MainScreenCoordinatorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MainScreenCoordinator.self) { (_, navigationController: UINavigationController) in
            
            return MainScreenCoordinator(navigationController: navigationController)
        }
    }
}

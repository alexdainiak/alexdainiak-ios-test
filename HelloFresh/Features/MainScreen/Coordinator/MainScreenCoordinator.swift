//
//  MainScreenCoordinator.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

/// Coordinator, serving for routing to feature "MainScreen" and between other screens in this feature
class MainScreenCoordinator: AssemblyCoordinator<Void> {
    
    var navigationController: UINavigationController!

    public override func assemblies() -> [Assembly] {
        [
            MainScreenAssembly(),
            MainScreenDataAssembly()
        ]
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public override func start() {
        let viewController = resolver.resolve(MainScreenViewController.self)!
        navigationController.pushViewController(viewController, animated: true)
    }
}


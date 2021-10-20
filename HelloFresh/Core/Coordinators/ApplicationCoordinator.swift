//
//  ApplicationCoordinator.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Swinject

/// First coordinator, from which starts routing in app
public class ApplicationCoordinator: AssemblyCoordinator<Void> {
    
    var mainScreenCoordinator: MainScreenCoordinator!
    
    /// Helps to initialize required assemblies
    /// - Returns: array of all initialized assemblies
    public override func assemblies() -> [Assembly] {
        [
            MainScreenCoordinatorAssembly()
        ]
    }
    
    public init(assembler: Assembler) {
        super.init()
        
        self.assembler = assembler
        assembler.apply(assemblies: assemblies())
        
    }
    
    /// Starting MainscreenCoordinator, routing to the feature "Mainscreen"
    public override func start() {
        coordinate(to: mainScreenCoordinator)
    }
}

//
//  BaseCoordinator.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation

open class BaseCoordinator<ResultType> {
    
    // MARK: - Public properties
    
    public var onComplete: ((ResultType) -> Void)?
    
    // MARK: - Initialized properties
    
    private let identifier: UUID = UUID()
    
    private var childCoordinators: [UUID: Any] = [:]
    
    public init() {}
    
    // MARK: - Public methods
    
    open func coordinate<T>(to coordinator: BaseCoordinator<T>) {
        
        store(coordinator: coordinator)
        let completion = coordinator.onComplete
        coordinator.onComplete = { [weak self, weak coordinator] value in
            completion?(value)
            
            if let coordinator = coordinator {
                self?.free(coordinator: coordinator)
            }
            
        }
        
        coordinator.start()
        
    }
    
    open func start() {
        fatalError("⛔️ необходимо перегрузить данный метод в наследнике")
    }
    
    // MARK: - Private methods
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        
        childCoordinators[coordinator.identifier] = coordinator
        
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        
        childCoordinators.removeValue(forKey: coordinator.identifier)
        
    }
}

//
//  Recipe.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

protocol Recipe {
    var id: String { get }
    var name: String { get }
    var headline: String { get }
    var image: String { get }
    var preparationMinutes: Int { get }
}

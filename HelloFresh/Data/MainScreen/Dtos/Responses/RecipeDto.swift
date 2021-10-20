//
//  RecipeDto.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

struct RecipeDto: Codable {
    
    let id: String
    let name: String
    let headline: String
    let image: String
    let preparationMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, headline, image
        case preparationMinutes = "preparation_minutes"
    }
}

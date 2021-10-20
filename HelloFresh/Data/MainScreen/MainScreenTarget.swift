//
//  MainScreenTarget.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

enum MainScreenTarget: BaseTarget {
    case getRecipes
    
    var scheme: String {
        switch self {
        case .getRecipes:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .getRecipes:
            return "hf-mobile-app.s3-eu-west-1.amazonaws.com"
        }
    }
    
    var path: String {
        switch self {
        case .getRecipes:
            return "recipes_v3.json"
        }
    }
    
    var method: String {
        switch self {
        case .getRecipes:
            return "GET"
        }
    }
}


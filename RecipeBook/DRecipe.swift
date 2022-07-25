//
//  DRecipe.swift
//  FetchRewards
//
//  Created by Neethu Kuruvilla on 5/24/22.
//

import Foundation


struct DRecipe: Codable {
    let meals: [meal]
}

struct meal: Codable {
    let strMeal: String?
    let strMealThumb: String?
    let idMeal: String?
}

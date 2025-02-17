//
//  MockRecipeService.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/17/25.
//

import Foundation

class MockRecipeService: RecipeServiceProtocol {
    var error: Error?
    var jsonString: String?

    func fetchRecipes() async throws -> [RecipeData] {
        if let error = error {
            throw error
        }
        
        if let jsonString = jsonString {
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let mockRecipeData = try decoder.decode(RecipeModel.self, from: data)
            return mockRecipeData.recipes
        }
        
        return []
    }
}

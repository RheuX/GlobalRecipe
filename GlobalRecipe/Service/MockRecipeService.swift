//
//  MockRecipeService.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/17/25.
//

import Foundation

class MockRecipeService: RecipeServiceProtocol {
    var mockRecipeData: [RecipeData]?
    var error: Error?

    func fetchRecipes() async throws -> [RecipeData] {
        if let error = error {
            throw error
        }

        return mockRecipeData ?? []
    }
}

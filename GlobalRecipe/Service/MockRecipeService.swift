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
    
    //assumed this Int is the hashed value stored in the UserDefaults
    var storedHashed: Int?
    
    //assume this is from NSCache, if there was data on it
    var storedRecipe: [RecipeData] = []
    
    //boolean value to check if its toggled
    var useCached: Bool = false

    func fetchRecipes() async throws -> [RecipeData] {
        useCached = false
        if let error = error {
            throw error
        }
        
        if let jsonString = jsonString {
            let data = jsonString.data(using: .utf8)!
            
            if compareRecipes(data) {
                useCached = true
                return storedRecipe
            }
            
            let mockRecipeData = try JSONDecoder().decode(RecipeModel.self, from: data)
            
            storedHashed = hashedValue(data)
            storedRecipe = mockRecipeData.recipes
            
            return mockRecipeData.recipes
        }
        
        return []
    }
    
    func hashedValue(_ data: Data) -> Int {
        var hasher = Hasher()
        hasher.combine(data)
        return hasher.finalize()
    }
    
    func compareRecipes(_ newRecipes: Data) -> Bool {
        return hashedValue(newRecipes) == storedHashed
    }
}

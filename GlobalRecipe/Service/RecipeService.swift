//
//  RecipeService.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/17/25.
//

import Foundation

class RecipeService: RecipeServiceProtocol {
    
    //for testing URL
    let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let recipeURLMalformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let recipeURLNoData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    let cache = NSCache<NSString, RecipeWrapper>()
    
    func fetchRecipes() async throws -> [RecipeData] {
        guard let url = URL(string: recipeURL) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if compareRecipes(data), let cachedData = cache.object(forKey: "cachedRecipe") {
            print("Finished Fetching Cached Recipe")
            return cachedData.model
        }
        
        let decodedData = try JSONDecoder().decode(RecipeModel.self, from: data)
        
        storeData(hashedValue(data))
        print("Finished Fetching New Recipe")
        self.cache.setObject(RecipeWrapper(model: decodedData.recipes), forKey: "cachedRecipe")
        return decodedData.recipes
    }
    
    func compareRecipes(_ newRecipes: Data) -> Bool {
        return hashedValue(newRecipes) == getStoredData()
    }
    
    func hashedValue(_ data: Data) -> Int {
        var hasher = Hasher()
        hasher.combine(data)
        return hasher.finalize()
    }
    
    func storeData(_ hashedData: Int) {
        UserDefaults.standard.set(hashedData, forKey: "cachedData")
    }

    func getStoredData() -> Int? {
        return UserDefaults.standard.integer(forKey: "cachedData")
    }
}

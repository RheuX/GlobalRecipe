//
//  RecipeViewModel.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeData] = []
    //@Published var errorMessage: String = ""
    
    let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    func fetchRecipes() async throws {
        do {
            guard let url = URL(string: recipeURL) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedData = try JSONDecoder().decode(RecipeModel.self, from: data)
            DispatchQueue.main.async() {
                self.recipes = decodedData.recipes
            }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
}

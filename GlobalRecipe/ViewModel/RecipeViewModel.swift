//
//  RecipeViewModel.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeData] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = true
    
    //for testing URL
    let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let recipeURLMalformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let recipeURLNoData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    func fetchRecipes() async throws {
        updateLoadingState(true)
        do {
            guard let url = URL(string: recipeURLNoData) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedData = try JSONDecoder().decode(RecipeModel.self, from: data)
            DispatchQueue.main.async() {
                self.recipes = decodedData.recipes
            }
        } catch URLError.badURL {
            updateErrorMessage("Invalid URL. Please check API Endpoint!")
            print("Invalid URL. Please check API Endpoint!")
        }
        catch let DecodingError.dataCorrupted(context) {
            updateErrorMessage("Data corrupted!")
            print("Data corrupted: \(context)")
        }
        catch let DecodingError.keyNotFound(key, context) {
            updateErrorMessage("API response is missing required fields!")
            print("Key '\(key)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath)
        }
        catch let DecodingError.valueNotFound(value, context) {
            updateErrorMessage("API response is missing required fields!")
            print("Value '\(value)' not found:", context.debugDescription)
            print("Coding Path:", context.codingPath)
        } catch {
            updateErrorMessage("API failed to fetch recipes! Please try again!")
            print("Failed to fetch recipes: \(error.localizedDescription)")
        }
        
        updateLoadingState(false)
    }
    
    func updateErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
    
    func updateLoadingState(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
}

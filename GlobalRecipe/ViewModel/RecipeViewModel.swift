//
//  RecipeViewModel.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [RecipeData]
}

class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeData] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = true
    
    private let service: RecipeServiceProtocol
    
    init(service: RecipeServiceProtocol = RecipeService()) {
        self.service = service
    }
    
    func fetchRecipes() async throws {
        updateLoadingState(true)
        do {
            let fetchedRecipes = try await service.fetchRecipes()
            updateRecipe(fetchedRecipes)
            
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
    
    func updateRecipe(_ recipes: [RecipeData]) {
        DispatchQueue.main.async() {
            self.recipes = recipes
        }
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

//
//  RecipeViewModel.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(from url: URL) async throws -> [RecipeData]
}

class RecipeViewModel: ObservableObject {
    @Published var recipes: [RecipeData] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = true
    
    let cache = NSCache<NSString, RecipeWrapper>()
    
    //for testing URL
    let recipeURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let recipeURLMalformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let recipeURLNoData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
//    private let service: RecipeServiceProtocol
//    
//    init(service: RecipeServiceProtocol) {
//        self.service = service
//    }
    
    func fetchRecipes() async throws {
        updateLoadingState(true)
        do {
            guard let url = URL(string: recipeURL) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //if the same, then just reuse the cache data, and then return
            if compareRecipes(data), let cachedWrapper = cache.object(forKey: "cachedRecipe") {
                updateRecipe(cachedWrapper.model)
                updateLoadingState(false)
                return
            }
            
            let decodedData = try JSONDecoder().decode(RecipeModel.self, from: data)
            updateRecipe(decodedData.recipes)
            storeData(hashedValue(data))
            print("Finished Fetching")
            
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
            self.cache.setObject(RecipeWrapper(model: recipes), forKey: "cachedRecipe")
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

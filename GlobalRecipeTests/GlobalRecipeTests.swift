//
//  GlobalRecipeTests.swift
//  GlobalRecipeTests
//
//  Created by Axel Lorens on 2/16/25.
//

import XCTest
@testable import GlobalRecipe

final class GlobalRecipeTests: XCTestCase {
    
    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService!

    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        viewModel = RecipeViewModel(service: mockService)
    }

    override func tearDown() {
        super.tearDown()
        mockService = nil
        viewModel = nil
    }

    func testFetchRecipes_Success() async throws {
        mockService.mockRecipeData = [
            RecipeData(cuisine: "Malaysian",
                       name: "Apam Balik",
                       image_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                       image_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                       source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                       uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                       youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
            RecipeData(cuisine: "British",
                       name: "Apple and Blackberry Crumble",
                       image_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                       image_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                       source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                       uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                       youtube_url: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
        ]
        try await viewModel.fetchRecipes()
        print(viewModel.recipes)
        XCTAssertEqual(viewModel.recipes.count, 2, "Recipes should include 2 dishes")
    }

}

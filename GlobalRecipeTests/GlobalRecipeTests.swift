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
    
    func mockFetch() async {
        let expectation = XCTestExpectation(description: "Fetch recipes")
        
        Task {
            try await viewModel.fetchRecipes()
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }

    func testFetchRecipes_Success() async throws {
        mockService.jsonString = """
        {
            "recipes": [
                    {
                        "cuisine": "Malaysian",
                        "name": "Apam Balik",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                    },
                    {
                        "cuisine": "British",
                        "name": "Apple and Blackberry Crumble",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                        "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                        "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                    },
            ]
        }
        """
        
        await mockFetch()
        
        XCTAssertEqual(viewModel.recipes.count, 2, "Recipes should include 2 dishes")
        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "First dish should be Apam Balik")
        XCTAssertTrue(viewModel.errorMessage.isEmpty, "Error message should be empty")
    }

    func testFetchRecipes_Empty() async {
        mockService.jsonString = """
        {
            "recipes": []
        }
        """
        
        await mockFetch()
        
        XCTAssertEqual(viewModel.recipes.count, 0, "Recipes should be empty")
        XCTAssertTrue(viewModel.errorMessage.isEmpty, "Error message should be empty")
    }
    
    func testFetchRecipes_Malformed() async {
        mockService.jsonString = """
        {
            "recipes": [
                    {
                        "cuisine": "Malaysian",
                        "name": "Apam Balik",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                    },
                    {
                        "cuisine": "British",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                        "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                        "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                    },
            ]
        }
        """
        
        await mockFetch()
        
        XCTAssertEqual(viewModel.recipes.count, 0, "Recipes should be empty")
        XCTAssertEqual(viewModel.errorMessage, "API response is missing required keys!", "Error message should be equal for `key not found`")
    }
    
    func testFetchRecipes_Caching_Success() async throws {
        mockService.jsonString = """
        {
            "recipes": [
                    {
                        "cuisine": "Malaysian",
                        "name": "Apam Balik",
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    },
                    {
                        "cuisine": "British",
                        "name": "Apple and Blackberry Crumble",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    },
            ]
        }
        """
        
        await mockFetch()
        
        XCTAssertEqual(viewModel.recipes.count, 2, "Recipes should include 2 dishes")
        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "First dish should be Apam Balik")
        XCTAssertTrue(viewModel.errorMessage.isEmpty, "Error message should be empty")
        XCTAssertFalse(mockService.useCached, "Should be false, since we never used a cached, we decode from JSON")
        
        //assuming we fetch with the same information
        await mockFetch()
        
        XCTAssertTrue(mockService.useCached, "Should be true, since we used a cached, we decode from JSON")
        XCTAssertEqual(viewModel.recipes.count, 2, "Recipes should include 2 dishes")
    }
    
    func testFetchRecipes_2_Fetch() async throws {
        mockService.jsonString = """
        {
            "recipes": [
                    {
                        "cuisine": "Malaysian",
                        "name": "Apam Balik",
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    },
                    {
                        "cuisine": "British",
                        "name": "Apple and Blackberry Crumble",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    },
            ]
        }
        """
        
        await mockFetch()
        
        XCTAssertEqual(viewModel.recipes.count, 2, "Recipes should include 2 dishes")
        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "First dish should be Apam Balik")
        XCTAssertTrue(viewModel.errorMessage.isEmpty, "Error message should be empty")
        XCTAssertFalse(mockService.useCached, "Should be false, since we never used a cached, we decode from JSON")
        
        mockService.jsonString = """
        {
            "recipes": [
                    {
                        "cuisine": "Malaysian",
                        "name": "Apam Balik",
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    },
                    {
                        "cuisine": "Canadian",
                        "name": "BeaverTails",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    },
                    {
                        "cuisine": "British",
                        "name": "Bakewell Tart",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    },
            ]
        }
        """
        
        //assuming we fetch with the different information
        await mockFetch()
        
        XCTAssertFalse(mockService.useCached, "Should be false, since hashed should be difference due to different of informatino")
        XCTAssertEqual(viewModel.recipes.last?.name, "Bakewell Tart", "Last dish should be Bakewell Tart")
        XCTAssertEqual(viewModel.recipes.count, 3, "Recipes should include 3 dishes")
    }
}



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
        viewModel = RecipeViewModel()
    }

    override func tearDown() {
        super.tearDown()
        mockService = nil
        viewModel = nil
    }

    func testExample() throws {
        
    }

}

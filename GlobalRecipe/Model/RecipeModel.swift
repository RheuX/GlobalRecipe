//
//  RecipeModel.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import Foundation

struct RecipeModel: Decodable {
    let recipes: [RecipeData]
}

struct RecipeData: Decodable {
    let cuisine: String
    let name: String
    let image_large: String?
    let image_small: String?
    let source_url: String?
    let uuid: String
    let youtube_url: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine, name, source_url, uuid, youtube_url
        case image_large = "photo_url_large"
        case image_small = "photo_url_small"
    }
}

class RecipeWrapper: NSObject {
    let model: [RecipeData]
    
    init(model: [RecipeData]) {
        self.model = model
    }
}

//
//  RecipeDetailView.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/17/25.
//
import SwiftUI

struct RecipeDetailView: View {
    @State var recipe: RecipeData?
    
    var body: some View {
        VStack(spacing: 16) {
            if let recipe = recipe {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if let imageUrl = recipe.image_large, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(maxWidth: 300, maxHeight: 300)
                        }
                    }
                }

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                VStack(spacing: 8) {
                    if let source = recipe.source_url, let sourceURL = URL(string: source) {
                        Link(destination: sourceURL) {
                            Label("Quick link to Recipe", systemImage: "link")
                        }
                        .font(.body)
                        .foregroundColor(.blue)
                    }

                    if let youtubeURL = recipe.youtube_url, let youtubeLink = URL(string: youtubeURL) {
                        Link(destination: youtubeLink) {
                            Label("Watch How To Make It", systemImage: "play.rectangle")
                        }
                        .font(.body)
                        .foregroundColor(.red)
                    }
                }
                .padding(.top)
            } else {
                Text("Recipe not available")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

}

//
//  RecipeView.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel = RecipeViewModel()
    
    var body: some View {
        VStack {
            if viewModel.recipes.isEmpty {
                ProgressView()
                Text("Loading Recipes...")
            } else {
                RecipeList(recipeList: viewModel.recipes)
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchRecipes()
            }
        }
    }
}

struct RecipeList: View {
    @State var recipeList: [RecipeData]
    
    var body: some View {
        List {
            ForEach(recipeList, id: \.uuid) { recipe in
                HStack(spacing: 8) {
                    //Async Image
                    AsyncImageView(imageURL: recipe.image_small)
                    VStack(alignment: .leading) {
                        //Title
                        Text("\(recipe.name)")
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        //Dish Coutry of Origin
                        Text("\(recipe.cuisine)")
                            .font(.body)
                            .fontWeight(.light)
                            .italic()
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Spacer() //Pushing SourceView into the right side
                            SourceView(sourceURL: recipe.source_url, youtubeURL: recipe.youtube_url)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct AsyncImageView: View {
    @State var imageURL: String = ""
    
    var body: some View {
        if let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 75, height: 75)
            .padding(2)
        } else {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

struct SourceView: View {
    @State var sourceURL: String?
    @State var youtubeURL: String?
    
    let imageSize: CGFloat = 20
    
    var body: some View {
        HStack(spacing: 12) {
            if let sourceURL = sourceURL, let url = URL(string: sourceURL) {
                Link(destination: url) {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                }
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .opacity(0.5)
            }
            if let youtubeURL = youtubeURL, let url = URL(string: youtubeURL) {
                Link(destination: url) {
                    Image(systemName: "play.rectangle.fill")
                        .resizable()
                        .frame(width: imageSize, height: imageSize-4)
                }
            } else {
                Image(systemName: "play.rectangle.fill")
                    .resizable()
                    .frame(width: imageSize+8, height: imageSize-4)
                    .opacity(0.5)
            }
        }
    }
}

#Preview {
    RecipeView()
}

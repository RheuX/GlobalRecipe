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
        VStack {
            List {
                ForEach(recipeList, id: \.uuid) { recipe in
                    HStack {
                        AsyncImageView(imageURL: recipe.image_small)
                        VStack(alignment: .leading) {
                            //Title
                            Text("\(recipe.name)")
                            //Coutry of Origin
                            Text("\(recipe.cuisine)")
                            
                            HStack {
                                Spacer()
                                SourceView()
                            }
                        }
                    }
                }
            }
        }
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
    
    var body: some View {
        Image(systemName: "globe")
        Image(systemName: "play.rectangle.fill")
    }
}

#Preview {
    RecipeView()
}

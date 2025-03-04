//
//  ContentView.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/16/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                RecipeView()
            }
            .navigationTitle("Recipe Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}

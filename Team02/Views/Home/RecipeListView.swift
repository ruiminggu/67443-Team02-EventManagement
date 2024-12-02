//
//  RecipeListView.swift
//  Team02
//
//  Created by 顾芮名 on 12/3/24.
//

import SwiftUI

struct RecipeListView: View {
    let category: String
    let userID: String // Pass the userID from HomeView
    @StateObject private var viewModel = RecipeSearchViewModel()

    var body: some View {
        VStack {
            Text("\(category) Recommendations")
                .font(.largeTitle)
                .padding()

            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.recipes.isEmpty {
                Text("No recipes found for \(category).")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.recipes, id: \.id) { recipe in
                            HomeRecipeSearchCard(recipe: recipe, userID: userID) // Use HomeRecipeSearchCard
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.searchText = category // Set the search query
            Task {
                await viewModel.searchRecipes() // Fetch recipes for the category
            }
        }
    }
}

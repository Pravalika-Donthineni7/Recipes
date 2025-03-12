import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published var searchText = ""
    
    var filteredRecipes: [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @MainActor
    func fetchRecipes(from endpoint: RecipeEndpoint = .normal) async {
        self.isLoading = true
        self.error = nil
        
        do {
            self.recipes = try await NetworkManager.shared.fetchRecipes(from: endpoint)
        } catch NetworkError.malformedData {
            self.error = "Unable to process recipe data. Please try again later."
            self.recipes = []
        } catch NetworkError.decodingError {
            self.error = "Unable to load recipes. Please try again later."
            self.recipes = []
        } catch NetworkError.serverError(let code) {
            self.error = "Server error (\(code)). Please try again later."
            self.recipes = []
        } catch NetworkError.invalidURL {
            self.error = "Invalid configuration. Please contact support."
            self.recipes = []
        } catch NetworkError.invalidResponse {
            self.error = "Invalid server response. Please try again later."
            self.recipes = []
        } catch {
            self.error = "An unexpected error occurred. Please try again."
            self.recipes = []
        }
        
        self.isLoading = false
    }
    
    func loadImage(from urlString: String?) async -> UIImage? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            return try await ImageCache.shared.loadImage(from: url)
        } catch {
            return nil
        }
    }
} 
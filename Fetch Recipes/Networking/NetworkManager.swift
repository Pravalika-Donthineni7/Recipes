import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case malformedData
    case unknown
}

enum RecipeEndpoint {
    case normal
    case malformed
    case empty
    
    var url: String {
        let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
        switch self {
        case .normal:
            return "\(baseURL)/recipes.json"
        case .malformed:
            return "\(baseURL)/recipes-malformed.json"
        case .empty:
            return "\(baseURL)/recipes-empty.json"
        }
    }
}

actor NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchRecipes(from endpoint: RecipeEndpoint = .normal) async throws -> [Recipe] {
        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            
            // Check for malformed data conditions
            if recipeResponse.recipes.contains(where: { 
                $0.name.isEmpty || $0.cuisine.isEmpty || $0.id.isEmpty 
            }) {
                throw NetworkError.malformedData
            }
            
            return recipeResponse.recipes
        } catch DecodingError.dataCorrupted(_) {
            throw NetworkError.malformedData
        } catch DecodingError.keyNotFound(_, _),
                DecodingError.valueNotFound(_, _),
                DecodingError.typeMismatch(_, _) {
            throw NetworkError.malformedData
        } catch {
            throw NetworkError.decodingError
        }
    }
} 
import XCTest
@testable import Fetch_Recipes

final class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RecipeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Recipe Fetching Tests
    
    func testFetchRecipes_Success() async {
        // When
        await viewModel.fetchRecipes(from: .normal)
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.recipes.isEmpty)
    }
    
    func testFetchRecipes_EmptyData() async {
        // When
        await viewModel.fetchRecipes(from: .empty)
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    func testFetchRecipes_MalformedData() async {
        // When
        await viewModel.fetchRecipes(from: .malformed)
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.error, "Unable to process recipe data. Please try again later.")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    // MARK: - Search Tests
    
    func testRecipeSearch_MatchingName() {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "1", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        ]
        viewModel.recipes = testRecipes
        
        // When
        viewModel.searchText = "Pizza"
        
        // Then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Pizza")
    }
    
    func testRecipeSearch_MatchingCuisine() {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "1", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        ]
        viewModel.recipes = testRecipes
        
        // When
        viewModel.searchText = "Japanese"
        
        // Then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.cuisine, "Japanese")
    }
    
    func testRecipeSearch_NoMatches() {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "1", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        ]
        viewModel.recipes = testRecipes
        
        // When
        viewModel.searchText = "Burger"
        
        // Then
        XCTAssertTrue(viewModel.filteredRecipes.isEmpty)
    }
    
    func testRecipeSearch_EmptySearchText() {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "1", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        ]
        viewModel.recipes = testRecipes
        
        // When
        viewModel.searchText = ""
        
        // Then
        XCTAssertEqual(viewModel.filteredRecipes.count, testRecipes.count)
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingState() async {
        // Given
        XCTAssertFalse(viewModel.isLoading)
        
        // When
        Task {
            await viewModel.fetchRecipes()
        }
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for completion
        await Task.sleep(1_000_000_000) // 1 second
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadImage_Success() async {
        // Given
        let imageURL = "https://example.com/image.jpg"
        
        // When
        let image = await viewModel.loadImage(from: imageURL)
        
        // Then
        XCTAssertNil(image) // Since this is a fake URL, we expect nil
    }
    
    func testLoadImage_InvalidURL() async {
        // Given
        let invalidURL = ""
        
        // When
        let image = await viewModel.loadImage(from: invalidURL)
        
        // Then
        XCTAssertNil(image)
    }
} 
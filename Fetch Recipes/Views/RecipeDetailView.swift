import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Recipe Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(recipe.cuisine)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                // Large Image
                AsyncImageView(url: recipe.photoUrlLarge, contentMode: .fill)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Action Buttons
                VStack(spacing: 16) {
                    if let sourceUrl = recipe.sourceUrl,
                       let url = URL(string: sourceUrl) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 18))
                                Text("View Original Recipe")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue)
                            )
                            .foregroundColor(.white)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    
                    if let youtubeUrl = recipe.youtubeUrl,
                       let url = URL(string: youtubeUrl) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                    .font(.system(size: 18))
                                Text("Watch on YouTube")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red)
                            )
                            .foregroundColor(.white)
                            .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 
import SwiftUI

struct AsyncImageView: View {
    let url: String?
    let contentMode: ContentMode
    @StateObject private var viewModel = RecipeViewModel()
    @State private var image: UIImage?
    @State private var isLoading = true
    
    init(url: String?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .task {
            isLoading = true
            image = await viewModel.loadImage(from: url)
            isLoading = false
        }
    }
} 
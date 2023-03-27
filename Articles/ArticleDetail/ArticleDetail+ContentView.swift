import ComposableArchitecture
import ComposableNavigation
import Foundation
import SwiftUI
import UIKit

extension ArticleDetail {
    static func makeView(
        store: StoreOf<ArticleDetail>
    ) -> UIViewController {
        UIHostingController(
            rootView: ContentView(store: store)
        )
    }
    
    struct ContentView: View, Presentable {
        let store: StoreOf<ArticleDetail>
        
        var body: some View {
            WithViewStore(store) { viewStore in
                ScrollView {
                    VStack {
                        ImageView(url: viewStore.article.imageUrl)
                        HStack {
                            Text(viewStore.article.title ?? "N/A")
                                .padding(.leading)
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(5)
                        HStack {
                            Spacer()
                            Text(viewStore.article.formattedReleaseDate)
                                .padding(.trailing)
                        }
                        .padding(5)
                        Text (viewStore.article.articleDescription ?? "N/A")
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Text("Author:")
                                .padding(.leading)
                                .fontWeight(.bold)
                            Text(viewStore.article.author ?? "N/A")
                            Spacer()
                        }
                        .padding(5)
                        Spacer()
                    }
                }
                .ignoresSafeArea()
            }
        }
        
        @ViewBuilder
        func failedImageView() -> some View {
            Text("😢")
                .font(.system(size: 50))
                .frame(height: 200)
                .aspectRatio(contentMode: .fit)
                .aspectRatio(contentMode: .fit)
        }
        
        @ViewBuilder
        func ImageView(url: URL?) -> some View {
            if url == nil {
                failedImageView()
            } else {
                CacheAsyncImage(url: url!) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(height: 200)
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        failedImageView()
                    case .empty:
                        Rectangle()
                            .frame(height: 200)
                            .tint(.green)
                            .overlay {
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                            }
                    default:
                        failedImageView()
                    }
                }
            }
        }
    }
}

struct ArticleDetail_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var article = MockArticle(id: 1)
        article.releaseDate = "5/21/2019"
        article.image = "http://dummyimage.com/507x696.bmp/dddddd/000000"
        article.author = "rfowden2@jigsy.com"
        article.title = "Sharable maximized analyzer"
        article.articleDescription = "ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris"
        return ArticleDetail.ContentView(store:
                .init(
                    initialState:
                            .init(article:
                                    article
                                 ),
                    reducer: ArticleDetail()))
    }
}

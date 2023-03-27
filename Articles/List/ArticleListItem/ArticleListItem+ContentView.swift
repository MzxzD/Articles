import SwiftUI
import CoreData
import ComposableArchitecture
import ComposableNavigation


extension ArticleListItem {
    struct ContentView: View, Presentable {
        let store: StoreOf<ArticleListItem>
        
        var body: some View {
            WithViewStore(store) { viewStore in
                Button(
                    action: {
                        viewStore.send(.select)
                    },
                    label: {
                        HStack {
                            ImageView(url: viewStore.article.imageUrl)
                            VStack {
                                HStack {
                                    Text(viewStore.article.title ?? "N/A")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .tint(.black)
                                        .lineLimit(1)
                                        .padding(.trailing, 8)
                                    Spacer()
                                }.padding(.bottom, 8)
                                HStack {
                                    Text(viewStore.article.articleDescription ?? "N/A")
                                        .tint(.black)
                                        .font(.system(size: 15))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing, 8)
                                    Spacer()
                                }.padding(.bottom, 8)
                            }
                        }
                        
                        .padding(
                            EdgeInsets(
                                top: 8,
                                leading: 8,
                                bottom: 8,
                                trailing: 8)
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 100,
                            alignment: .leading
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                                .shadow(color: Color(UIColor.lightGray), radius: 4)
                        )
                        .padding(7)
                    }
                )
            }
        }
        
        @ViewBuilder
        func failedImageView() -> some View {
            Text("😢")
                .font(.system(size: 50))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
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
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                        
                    case .failure(_):
                        failedImageView()
                    case .empty:
                        Circle()
                            .frame(width: 50, height: 50)
                            .tint(.green)
                            .overlay {
                                ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            }
                    default:
                        EmptyView()
                    }
                }.padding(.trailing, 8)
            }
        }
    }
}

struct ArticleListItem_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        var article = MockArticle(id: 1)
        article.title = "Versatile 6th generation definition"
        article.articleDescription = "a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in"
        article.author = "d"
        article.releaseDate = "d"
        article.image = "https://dummyimage.com/366x582.png/5fa2dd/ffffff"
        
        return ArticleListItem.ContentView(store: .init(
            initialState: .init(article:
                                    article),
            reducer: ArticleListItem())
        )
    }
}

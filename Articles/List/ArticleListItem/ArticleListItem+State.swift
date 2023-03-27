import ComposableArchitecture
import Foundation

extension ArticleListItem {
    public struct State: Equatable {
        public static func == (lhs: ArticleListItem.State, rhs: ArticleListItem.State) -> Bool {
            lhs.id == rhs.id && lhs.article.id == rhs.article.id
        }
        
        var article: any ArticlePresentible
    }
}

extension ArticleListItem.State: Identifiable {
    public var id: Int64 {
        article.id
    }
}

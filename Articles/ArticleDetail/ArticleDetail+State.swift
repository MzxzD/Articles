import ComposableArchitecture
import Foundation

extension ArticleDetail {
    public struct State: Equatable {
        public static func == (lhs: ArticleDetail.State, rhs: ArticleDetail.State) -> Bool {
            lhs.id == rhs.id && lhs.article.id == rhs.article.id
        }
        var article: any ArticlePresentible

    }
}

extension ArticleDetail.State: Identifiable {
    public var id: Int64 {
        article.id
    }
}

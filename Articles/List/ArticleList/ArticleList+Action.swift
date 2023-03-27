import Foundation

import ComposableArchitecture
import ComposableNavigation
import Foundation

extension ArticleList {
    public enum Action: Equatable {
        case stackNavigation(StackNavigation<NavigationItem>.Action)
        case listItem(id: ArticleListItem.State.ID, action: ArticleListItem.Action)
        case detail(ArticleDetail.Action)
        case loadNewArticles(fetched: [any ArticlePresentible], stored: [any ArticlePresentible])
        case setup
        case reload
        case receivedNewArticles([any ArticlePresentible])
    }
}

extension ArticleList.Action {
    public static func == (lhs: ArticleList.Action, rhs: ArticleList.Action) -> Bool {
        switch (lhs, rhs) {
            
        case (.receivedNewArticles(let lhs), .receivedNewArticles(let rhs)):
            
            return lhs.count == rhs.count
        default:
            return lhs == rhs
        }
    }
}

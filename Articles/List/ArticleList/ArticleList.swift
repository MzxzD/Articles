import Combine
import ComposableArchitecture
import UIKit
import ComposableNavigation
import Foundation
import CoreData

public struct ArticleList {
    let fetchArticles: () async -> [any ArticlePresentible]
    let fetchStoredArticles: () async -> [any ArticlePresentible]

    
    init(fetchArticles: @escaping () async -> [any ArticlePresentible], fetchStoredArticles: @escaping () async -> [any ArticlePresentible]) {
        self.fetchArticles = fetchArticles
        self.fetchStoredArticles = fetchStoredArticles
    }
}

extension ArticleList {
    public enum NavigationItem: Hashable {
        case list
        case detail(id: ArticleDetail.State.ID)
    }
    
    struct ViewProvider: ViewProviding {
        let store: StoreOf<ArticleList>
        
        func makePresentable(for navigationItem: NavigationItem) -> Presentable {
            switch navigationItem {
            case .list:
                return ArticleList.ContentView(store: store)
            case .detail:
                return store
                    .scope(
                        state: \.detail,
                        action: ArticleList.Action.detail
                    )
                    .compactMap(ArticleDetail.makeView(store:)) ?? UIViewController()
            }
        }
    }
}

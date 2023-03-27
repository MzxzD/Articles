import ComposableArchitecture
import ComposableNavigation
import Foundation

extension ArticleList {
    public struct State: Equatable {
        var listItems = IdentifiedArrayOf<ArticleListItem.State>()
        var isLoading = false
        
        var selectedArticle: ArticleDetail.State.ID?

        var detail: ArticleDetail.State? {
            get {
                guard let selectedArticle, let listItem = listItems[id: selectedArticle] else {
                    return nil
                }
                return .init(listItem: listItem)
            }
            set {
                guard let selectedArticle, let newValue else {
                    selectedArticle = nil
                    return
                }
                listItems[id: selectedArticle] = .init(detail: newValue)
            }
        }
        
        var stackNavigation: StackNavigation<NavigationItem>.State {
            get {
                if let detail {
                    return .init(items: [.list, .detail(id: detail.id)])
                } else {
                    return .init(items: [.list])
                }
            }
            set {
                let detailId: ArticleDetail.State.ID? = newValue.items.articleDetailId
                selectedArticle = detailId
            }
        }
    }
}

extension ArticleDetail.State {
    init(listItem: ArticleListItem.State) {
        self.article = listItem.article
    }
}

extension ArticleListItem.State {
    init(detail: ArticleDetail.State) {
        self.article = detail.article
    }
}

extension Array where Element == ArticleList.NavigationItem {
    var articleDetailId: ArticleDetail.State.ID? {
        self
            .lazy
            .compactMap {
                switch $0 {
                case let .detail(id):
                    return id
                default:
                    return nil
                }
            }
            .first
    }
}

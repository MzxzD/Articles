import ComposableArchitecture
import ComposableNavigation
import Foundation

extension ArticleList: ReducerProtocol {
    private func privateReduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .listItem(id: let id, .select):
            return .task { .stackNavigation(.pushItem(.detail(id: id))) }
        case .setup, .reload:
            state.isLoading = true
            return .run { send in
                await send(.loadNewArticles(fetched: fetchArticles(), stored: fetchStoredArticles()))
            }
        case .loadNewArticles(fetched: let fetchedData, stored: let storedData):
            var articlesToStore: [any ArticlePresentible] = []
            
            let diff = fetchedData.difference(from: storedData, by: { $0.id == $1.id })
            
            for change in diff {
                switch change {
                case let .insert(_, newElement, _):
                    articlesToStore.append(newElement)
                default:
                    continue
                }
            }
            
            for article in articlesToStore {
                let context = CoreDataHelper.shared.persistentContainer.viewContext
                let newArticle = Article(context: context)
                newArticle.id = article.id
                newArticle.title = article.title
                newArticle.articleDescription = article.articleDescription
                newArticle.author = article.author
                newArticle.releaseDate = article.releaseDate
                newArticle.image = article.image
                
                CoreDataHelper.shared.saveContext()
            }
            
            ///  could've used (storedData.first! as! Article).managedObjectContext!.hasChanges
            ///  but too much forceUnwrapping
            let storedDataHasChanges: Bool = articlesToStore.count > 0
            
            if storedDataHasChanges {
                return .run { send in
                    await send(.receivedNewArticles(fetchStoredArticles()))
                }
            }
            return .run { send in
                await send(.receivedNewArticles(storedData))
            }
            
        case .receivedNewArticles(let newData):
            state.isLoading = false
            
            state.listItems = .init(
                uncheckedUniqueElements: newData.map(ArticleListItem.State.init(article:))
            )
            return .none
            
        default:
            return .none
        }
    }
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.stackNavigation, action: /Action.stackNavigation) {
            StackNavigation<NavigationItem>()
        }
        Reduce(privateReduce)
            .forEach(\.listItems, action: /ArticleList.Action.listItem) {
                ArticleListItem()
            }
            .ifLet(\.detail, action: /ArticleList.Action.detail) {
                ArticleDetail()
            }
    }
}

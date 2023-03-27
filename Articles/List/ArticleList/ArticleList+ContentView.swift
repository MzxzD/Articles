import ComposableArchitecture
import ComposableNavigation
import Foundation
import SwiftUI

extension ArticleList {
    static func makeView(
        store: StoreOf<ArticleList>
    ) -> UIViewController {
        let view = StackNavigationViewController(
            store: store.scope(state: \.stackNavigation, action: Action.stackNavigation),
            viewProvider: ViewProvider(store: store)
        )
        ViewStore(store).send(.setup)
        return view
    }
    
    struct ContentView: View, Presentable {
        let store: StoreOf<ArticleList>
        
        var body: some View {
            WithViewStore(store) { viewStore in
                LoadingView(isShowing: viewStore.isLoading) {
                    ScrollView {
                        ForEachStore(
                            store.scope(state: \.listItems, action: ArticleList.Action.listItem)
                        ) { listItemStore in
                            ArticleListItem.ContentView(store: listItemStore)
                        }
                    }.refreshable {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            viewStore.send(.reload)
                        })
                    }
                }
                .navigationTitle("Articles")
            }
        }
    }
}

//
//  SceneDelegate.swift
//  Articles
//
//  Created by Work Mode on 25.03.2023..
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = makeViewController()
        self.window = window
        window.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    fileprivate func makeViewController() -> UIViewController {
        ArticleList.makeView(
            store: .init(
                initialState:
                    ArticleList.State(
                        listItems: [] // Pull from  persistance?
                    ),
                reducer:
                    ArticleList(
                        fetchArticles: {
                            await self.getMockArticles()
                        },
                        fetchStoredArticles: {
                            await self.getStoredArticles()
                        }
                    )
            )
        )
    }
    

    fileprivate func getMockArticles() async -> [any ArticlePresentible] {
        let lol = URL(string: "https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8")!
        do {
            let result = try await APIClient().fetchData(from: lol)
            return result
        } catch {
            print(error)
            return []
        }
    }
    
    fileprivate func getStoredArticles() async -> [Article] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainContext = appDelegate.persistentContainer.viewContext
        
        do {
            return try await CoreDataHelper.shared.fetch(Article.self) ?? []
        } catch {
            print(error)
            return []
        }
    }
    
}


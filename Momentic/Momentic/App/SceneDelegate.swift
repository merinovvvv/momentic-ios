//
//  SceneDelegate.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 25.09.25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator = CoordinatorFactory().createAppCoordinator(navigationController: UINavigationController())


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            LoggingService.shared.error("Failed to create window scene", category: "AppLifecycle")
            return
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appCoordinator.navigationController
        self.window = window
        
        appCoordinator.navigationController.setNavigationBarHidden(true, animated: false)
        
        LoggingService.shared.info("Scene will connect, starting app coordinator", category: "AppLifecycle")
        appCoordinator.start()
        
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        LoggingService.shared.info("Scene disconnected", category: "AppLifecycle")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        LoggingService.shared.info("Scene became active", category: "AppLifecycle")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        LoggingService.shared.info("Scene will resign active", category: "AppLifecycle")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        LoggingService.shared.info("Scene will enter foreground", category: "AppLifecycle")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        LoggingService.shared.info("Scene did enter background", category: "AppLifecycle")
    }


}


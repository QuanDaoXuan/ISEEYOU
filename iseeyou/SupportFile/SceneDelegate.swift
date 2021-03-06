//
//  SceneDelegate.swift
//  iseeyou
//
//  Created by resopt on 7/24/1399 AP.
//  Copyright © 1399 truc. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let notificationCenter = NotificationCenter.default

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        notificationCenter.addObserver(self, selector: #selector(setRootViewController), name: NSNotification.Name(rawValue: Constant.needStartCameraSession), object: nil)
        let window = UIWindow(windowScene: windowScene)
        if !SaveDataDefaults().getIsLogin() {
            let vc = R.storyboard.main.loginNavigation()!
            window.rootViewController = vc
        } else {
            let vc = R.storyboard.main.tabbarcontrollerViewController()!
            window.rootViewController = vc
        }
        self.window = window
        window.makeKeyAndVisible()
    }

    @objc func setRootViewController() {
        window?.rootViewController?.navigationController?.popToRootViewController(animated: true)
        if !SaveDataDefaults().getIsLogin() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let vc = R.storyboard.main.loginNavigation()!
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController?.parent?.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.window?.rootViewController?.navigationController?.viewControllers = []
                let vc = R.storyboard.main.tabbarcontrollerViewController()!
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController?.parent?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }
}

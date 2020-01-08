//
//  SceneDelegate.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let userLoginData = UserDataController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let userLogin = userLoginData.getUserData() { // есть данные смотрим их верность в другом окне
            
            if userLogin.typeUser == "1" {
                showUser(windowScene: windowScene)
            }
            if userLogin.typeUser == "0" {
                showUserTeacher(windowScene: windowScene)
            }
            
        } else {
            showLogin(windowScene: windowScene)
        }
    }
    //MARK: - отобразить окно студента
    private func showUser(windowScene: UIWindowScene) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "studUser")
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = vc
    }
    
    //MARK: - отобразить окно препода
    private func showUserTeacher(windowScene: UIWindowScene) {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "studUser")
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = vc
    }
    
    //MARK: - отобразить окно логина
    private func showLogin(windowScene: UIWindowScene) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "login")
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        self.window?.rootViewController = vc
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


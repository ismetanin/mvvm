//
//  MainRouter.swift
//  mvvm
//
//  Created by Ivan Smetanin on 07/04/2019.
//  Copyright © 2019 Ivan Smetanin. All rights reserved.
//

import UIKit

final class MainRouter: Router {

    // MARK: - Properties

    private var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    private var navigationController: UINavigationController? {
        if let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            return tabBar.selectedViewController as? UINavigationController
        }
        return UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    }

    private var tabBarController: UITabBarController? {
        return UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
    }

    private var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }

    // MARK: - Router

    func present(_ module: Presentable?) {
        self.present(module, animated: true, completion: nil)
    }

    func present(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent() else {
            return
        }
        topViewController?.present(controller, animated: animated, completion: completion)
    }

    func push(_ module: Presentable?) {
        self.push(module, animated: true)
    }

    func push(_ module: Presentable?, animated: Bool) {
        if let controller = module?.toPresent() {
            self.topViewController?.navigationController?.pushViewController(controller, animated: animated)
        }
    }

    func push(_ module: Presentable?, animated: Bool, hideTabBar: Bool = false) {
        module?.toPresent()?.hidesBottomBarWhenPushed = hideTabBar
        push(module, animated: animated)
    }

    func popModule() {
        self.popModule(animated: true)
    }

    func popModule(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func dismissModule() {
        self.dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        topViewController?.dismiss(animated: animated, completion: completion)
    }

    func setNavigationControllerRootModule(_ module: Presentable?,
                                           animated: Bool = false,
                                           hideBar: Bool = false) {
        if let controller = module?.toPresent() {
            navigationController?.isNavigationBarHidden = hideBar
            navigationController?.setViewControllers([controller], animated: false)
        }
    }

    func setRootModule(_ module: Presentable?) {
        window?.rootViewController = module?.toPresent()
        window?.makeKeyAndVisible()
    }

    func setTab(_ index: Int) {
        tabBarController?.selectedIndex = index
    }

}

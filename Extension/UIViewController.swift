//
//  UIViewController.swift
//  Extension
//
//  Created by 金瑞 on 2023/1/1.
//

import UIKit

public extension UIViewController {
  /// 当前给定的 ViewController 最上层显示的 ViewController
  /// - parameters:
  ///   - viewController: 给定的控制器，默认是根控制器
  ///   - ignoreModalViewController: 是否忽略 模态 ViewController
  /// - returns: 最上层 ViewController
  class func topLevelViewController(
    in viewController: UIViewController? = UIWindow.keyWindow?.rootViewController,
    ignoreModalViewController: Bool = true
  ) -> UIViewController? {
    if let navigationController = viewController as? UINavigationController {
      if ignoreModalViewController {
        if let topViewController = navigationController.topViewController {
          return topLevelViewController(in: topViewController)
        }
        return nil
      } else {
        if let visibleViewController = navigationController.visibleViewController {
          return topLevelViewController(in: visibleViewController)
        }
        return nil
      }
    }
    if let tabBarController = viewController as? UITabBarController,
        let selectedViewController = tabBarController.selectedViewController {
      return topLevelViewController(in: selectedViewController)
    }
    if ignoreModalViewController == false, let presentedViewController = viewController?.presentedViewController {
      return topLevelViewController(in: presentedViewController)
    }
    return viewController
  }
}


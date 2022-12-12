//
//  UIViewController+Current.swift
//  ViewControllerManager
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit

extension UIViewController {
  /// 当前window最上层viewController
  /// - parameters:
  ///       - controller 可选
  ///       - isFilterModalView 是否过滤掉 模态vc
  /// - returns: 最上层viewController
  public class func topMoastViewController(
    controller: UIViewController? = UIWindow.keyWindow?.rootViewController,
    filterModalView: Bool = true
  ) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      if filterModalView {
        if let topVC = navigationController.topViewController {
          return topMoastViewController(controller: topVC)
        }
        return nil
      } else {
        if let visibleVC = navigationController.visibleViewController {
          return topMoastViewController(controller: visibleVC)
        }
        return nil
      }
    }
    if let tabController = controller as? UITabBarController {
      if let selectedVC = tabController.selectedViewController {
        return topMoastViewController(controller: selectedVC)
      }
    }
    if filterModalView == false, let presented = controller?.presentedViewController {
      return topMoastViewController(controller: presented)
    }
    return controller
  }
}


//
//  ViewControllerManager.swift
//  ViewControllerManager
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit

public class ViewControllerManager {
//  public class func pushToInjectedViewController<T: UIViewController>(
//    type: T.Type,
//    args: [String: Any]? = nil,
//    hidesBottomBarWhenPushed _: Bool = true,
//    title: String = "",
//    animation: CATransition? = nil
//  ) {
//    guard let newVC = Resolver.optional(type, args: args) else {
//      return
//    }
//    newVC.hidesBottomBarWhenPushed = true
//    newVC.title = title
//    pushToViewCotntroller(toVC: newVC, animation: animation)
//  }
//
//  public class func pushToWebViewController(
//    url: String,
//    args: [String: Any]? = nil,
//    hidesBottomBarWhenPushed _: Bool = true,
//    animation: CATransition? = nil
//  ) {
//    guard let webVC = Resolver.optional(WebViewController.self, args: args) else {
//      return
//    }
//    webVC.loadUrlString(url)
//    webVC.hidesBottomBarWhenPushed = true
//    pushToViewCotntroller(toVC: webVC, animation: animation)
//  }

  public class func pushToViewCotntroller(toVC: UIViewController, animation: CATransition? = nil) {
    let topVC = UIViewController.topMoastViewController(controller: Utils.keyWindow()?.rootViewController)
    if let transition = animation, animation != nil {
      topVC?.navigationController?.view.layer.add(transition, forKey: nil)
      topVC?.navigationController?.pushViewController(toVC, animated: false)
    } else {
      topVC?.navigationController?.pushViewController(toVC, animated: true)
    }
  }
}

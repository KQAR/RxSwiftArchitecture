//
//  ViewControllerManager.swift
//  ViewControllerManager
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import Extension

public class ViewControllerManager {
  public class func pushToViewCotntroller(toVC: UIViewController, animation: CATransition? = nil) {
    let topVC = UIViewController.topLevelViewController()
    if let transition = animation, animation != nil {
      topVC?.navigationController?.view.layer.add(transition, forKey: nil)
      topVC?.navigationController?.pushViewController(toVC, animated: false)
    } else {
      topVC?.navigationController?.pushViewController(toVC, animated: true)
    }
  }
}

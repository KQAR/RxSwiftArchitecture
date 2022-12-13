//
//  ViewControllerPresentable.swift
//  Popups
//
//  Created by 金瑞 on 2022/12/12.
//

import UIKit

public protocol ViewControllerPresentable {
  var makeContentSize: CGSize { get }
  func popup(in vc: UIViewController, animated: Bool)
}

public extension ViewControllerPresentable where Self: UIViewController {
  func popup(in vc: UIViewController, animated: Bool) {
    let presented = CustomPresentationController(configuration: PopupsGen.instance.defaultConfiguration, presentedViewController: self)
    transitioningDelegate = presented
    preferredContentSize = makeContentSize
    vc.present(self, animated: animated)
  }
}

//
//  NavigationController.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/11.
//

import UIKit

public final class NavigationController: UINavigationController {
  
  enum Metrics {
    static let titleColor = UIColor.darkText
    static let titleFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
  }
  
  var backAction: (() -> Void)?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    navigationBar.isTranslucent = false
    setNavigationBarHidden(true, animated: false)
    setupNavigationBarAppearance()
  }
  
  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    /// 当push页面时隐藏底部TabBar
    if self.viewControllers.count > 0 {
      viewController.hidesBottomBarWhenPushed = true
      
      //设置导航栏按钮
      let image = UIImage(named: "nav_back")?.withRenderingMode(.alwaysOriginal)
      viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
    }
    super.pushViewController(viewController, animated: true)
  }
}

extension NavigationController {
  @objc func back() {
    if let action = backAction {
      action()
    } else {
      popViewController(animated: true)
    }
  }
  
  func setupNavigationBarAppearance() {
    var textDic = Dictionary<NSAttributedString.Key, Any>()
    textDic[NSAttributedString.Key.font] = Metrics.titleFont
    textDic[NSAttributedString.Key.foregroundColor] = Metrics.titleColor
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.titleTextAttributes = textDic
      appearance.backgroundColor = .white
      appearance.backgroundImage = UIImage(color: .white)
      appearance.backgroundEffect = nil
      appearance.shadowColor = .white
      navigationBar.standardAppearance = appearance
      navigationBar.scrollEdgeAppearance = appearance
    } else {
      navigationBar.titleTextAttributes = textDic
      navigationBar.shadowImage = UIImage()
    }
  }
  
}

extension UINavigationController {
  func pushTo(_ viewController: UIViewController, compeltion: @escaping () -> Void) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(compeltion)
    pushViewController(viewController, animated: true)
    CATransaction.commit()
  }
}

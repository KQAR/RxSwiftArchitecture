//
//  TabBarController.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/11.
//

import UIKit
import ESTabBarController_swift
import Extension

public class TabBarController: ESTabBarController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.isTranslucent = false
    tabBar.backgroundColor = .white
    
    // 修改tabbar黑线
    if #available(iOS 13.0, *) {
      let standardAppearance = tabBar.standardAppearance.copy()
      standardAppearance.shadowColor = UIColor.white
      standardAppearance.backgroundColor = .white
      tabBar.standardAppearance = standardAppearance
    } else {
      let resizedImage = UIImage(color: .white)
      self.tabBar.shadowImage = resizedImage
      self.tabBar.backgroundColor = .white
    }
  }
  
  public func set(itemsAssembly: TabBarItemsAssembly) {
    let vcs = itemsAssembly.viewControllers
    viewControllers = vcs
    let additionInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBar.bounds.size.height, right: 0)
    for vc in vcs {
      if let nav = vc as? UINavigationController {
        nav.viewControllers.last?.additionalSafeAreaInsets = additionInsets
      } else {
        vc.additionalSafeAreaInsets = additionInsets
      }
    }
  }
}

public class TabBarItemContentView: ESTabBarItemContentView {
  
  enum Color {
    static let textColor = UIColor.lightGray
    static let badgeColor = UIColor.red
    static let highlightTextColor = UIColor.darkText
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    itemContentMode = .alwaysOriginal
    renderingMode = .alwaysOriginal
    titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
    textColor = Color.textColor
    badgeColor = Color.badgeColor
    highlightTextColor = Color.highlightTextColor
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setBadge(unreadNum: Int) {
    guard unreadNum != 0 else {
      badgeValue = nil
      return
    }
    badgeValue = unreadNum > 99 ? "99+" : String(unreadNum)
  }
}

//
//  TabBarItems.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/11.
//

import UIKit
import ESTabBarController_swift
import BaseView

enum TabBarItem: Int, CaseIterable {
  case home
  case profile
  
  var title: String {
    switch self {
    case .home:
      return "Home"
    case .profile:
      return "Profile"
    }
  }
  
  var image: UIImage? {
    return selectedImage?.withTintColor(.lightGray)
  }
  
  var selectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house")
    case .profile:
      return UIImage(systemName: "person.crop.circle")
    }
  }
  
  var viewController: UIViewController {
    var vc: UIViewController
    switch self {
    case .home:
      vc = Assembly.homeViewController
    case .profile:
      vc = Assembly.profileViewController
    }
    return vc
  }
}

public struct TabBarItems: TabBarItemsAssembly {
  
  public var viewControllers: [UIViewController] {
    return TabBarItem.allCases.map { item in
      let itemContentView = TabBarItemContentView()
      let vc = item.viewController
      vc.tabBarItem = ESTabBarItem(
        itemContentView,
        title: item.title,
        image: item.image,
        selectedImage: item.selectedImage,
        tag: item.rawValue
      )
      return vc
    }
  }
}

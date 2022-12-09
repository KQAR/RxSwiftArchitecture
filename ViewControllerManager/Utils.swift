//
//  Utils.swift
//  ViewControllerManager
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import Foundation

enum Utils {
  
  /// 仅适用于单`Scene`应用程序
  /// - Returns: keyWindow
  public static func keyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
      guard let scene = UIApplication.shared.connectedScenes.first,
            let windowScene = (scene as? UIWindowScene) else { return nil }
      return windowScene.windows.first
    } else {
      return UIApplication.shared.keyWindow
    }
  }
}

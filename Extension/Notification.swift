//
//  Notification.swift
//  Extension
//
//  Created by Jarvis on 2022/12/20.
//

import UIKit
import Foundation

extension Notification {
  
  func keyBoardHeight() -> CGFloat {
    if let userInfo = self.userInfo {
      if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let size = value.cgRectValue.size
        return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
      }
    }
    return 0
  }
  
  /// 类型安全的 UserInfo 字典键
  struct UserInfoKey<ValueType>: Hashable {
    let key: String
  }
  
  /// 使用 UserInfoKey 获取确定类型的数据值
  func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
    return userInfo![key] as! T
  }
}

extension NotificationCenter {
  
  /// 类型安全的 `userInfo` 的通知广播方法
  /// - Parameters:
  ///   - aName: 通知名
  ///   - anObject: 对象
  ///   - aUserInfo: 通知的数据字典
  func post<T>(
    name aName: NSNotification.Name,
    object anObject: Any?,
    typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil
  ) {
    post(name: aName, object: anObject, userInfo: aUserInfo)
  }
}

// 通知名定义
extension Notification.Name {
  /// 消息角标（作为传值的示例）
  static let chatMessageBadgeNotification = Notification.Name(rawValue: "com.Jarvis.VIPER.chatMessageBadgeNotification")
}

// UserInfoKey 键与对应类型定义
extension Notification.UserInfoKey {
  static var chatMessageBadgeValueKey: Notification.UserInfoKey<Int> {
    return Notification.UserInfoKey(key: "com.Jarvis.VIPER.chatMessageBadgeValueKey.badgeNum")
  }
}

//
//  Wireframe.swift
//  Popups
//
//  Created by 金瑞 on 2023/1/1.
//

import RxSwift
import Extension

public protocol Wireframe {
  func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

public enum DefaultWireframeAction: CustomStringConvertible {
  case cancel
  case ensure
  
  public var description: String {
    switch self {
    case .cancel:
      return "取消"
    case .ensure:
      return "确认"
    }
  }
  
  public var confirm: Bool {
    switch self {
    case .cancel:
      return false
    case .ensure:
      return true
    }
  }
}

public class DefaultWireframe: Wireframe {
  
  public static let shared = DefaultWireframe()
  
  private var rootViewController: UIViewController?
  
  public init(_ rootViewController: UIViewController? = UIWindow.keyWindow?.rootViewController) {
    self.rootViewController = rootViewController
  }
  
  public func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action : CustomStringConvertible {
    return Observable.create { observer in
      let alertView = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
        observer.on(.next(cancelAction))
      })
      
      for action in actions {
        alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
          observer.on(.next(action))
        })
      }
      
      if let rootViewController = self.rootViewController {
        rootViewController.present(alertView, animated: true, completion: nil)
      }
      
      return Disposables.create {
        alertView.dismiss(animated:false, completion: nil)
      }
    }
  }
}

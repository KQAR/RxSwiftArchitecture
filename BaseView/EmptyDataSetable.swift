//
//  EmptyDataSetable.swift
//  BaseView
//
//  Created by Jarvis on 2023/9/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxExtension
import EmptyDataSet_Swift

public extension DataStatus {
  var emptyDataState: EmptyDataState {
    switch self {
    case .normal:
      return .normal
    case .empty:
      return .empty
    case .error(_):
      return .empty
    }
  }
}

public enum EmptyDataState {
  case normal
  case empty
  case error
  
  var title: String {
    switch self {
    case .normal:
      return ""
    case .empty:
      return "还没有数据哦~"
    case .error:
      return "请求出错了..."
    }
  }
  
  var description: String {
    return "当前没有数据展示"
  }
  
  var image: UIImage? {
    switch self {
    case .normal:
      return nil
    case .empty:
      return UIImage(named: "empty_state_witdraw")
    case .error:
      return UIImage(named: "network_error")
    }
  }
  
  var imageTintColor: UIColor? {
    return nil
  }
  
  var buttonTitle: String? {
    return nil
  }
  
  var backgroundColor: UIColor? {
    return .clear
  }
  
  var emptyViewShouldDisplay: Bool {
    return self != .normal
  }
  
  var emptyViewShouldAllowScroll: Bool {
    return true
  }
}

public protocol EmptyDataSetable: EmptyDataSetSource, EmptyDataSetDelegate {
  var emptyDataSetButtonTap: PublishRelay<Void> { get }
  var emptyDataSetStatus: EmptyDataState { get set }
}

// MARK: - EmptyDataSet Source

extension EmptyDataSetable {
  public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetStatus.title, attributes: [
      .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
      .foregroundColor: UIColor.gray
    ])
  }
  
  public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetStatus.description)
  }
  
  public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return emptyDataSetStatus.image
  }
  
  public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return emptyDataSetStatus.imageTintColor
  }
  
  public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return emptyDataSetStatus.backgroundColor
  }
}

// MARK: - EmptyDataSet Delegate

extension EmptyDataSetable {
  public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    return emptyDataSetStatus.emptyViewShouldDisplay
  }
  
  public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
    return emptyDataSetStatus.emptyViewShouldAllowScroll
  }
  
  public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
    emptyDataSetButtonTap.accept(())
  }
}

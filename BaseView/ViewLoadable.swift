//
//  ViewLoadable.swift
//  BaseView
//
//  Created by Jarvis on 2023/9/21.
//

import UIKit
import Foundation
import Lottie
import RxSwift
import RxCocoa
import Toast_Swift

public protocol AnimatableView: UIView {
  var isAnimationPlaying: Bool { get }
  func play(completion: ((Bool) -> Void)?)
  func stop()
}

extension LottieAnimationView: AnimatableView {}

public protocol ViewAnimateLoadable: UIViewController {
  var isLoading: Bool { get }
  var animationLoadingView: AnimatableView { get }
}

extension ViewAnimateLoadable {
  public var isLoading: Bool {
    get { animationLoadingView.isAnimationPlaying }
    set {
      if newValue == true {
        showLoadingToast()
      } else {
        hideLoadingToast()
      }
    }
  }
  
  func showLoadingToast() {
    view.showToast(animationLoadingView, duration: TimeInterval.infinity, position: .center)
    animationLoadingView.play(completion: nil)
  }
  
  func hideLoadingToast() {
    animationLoadingView.stop()
    view.hideToast(animationLoadingView)
  }
}

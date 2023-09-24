//
//  DataSetViewController.swift
//  BaseView
//
//  Created by Jarvis on 2023/9/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Lottie
import Log

open class DataSetViewController: UIViewController, EmptyDataSetable {
  
  var navigationTitle = "" {
    didSet {
      navigationItem.title = navigationTitle
    }
  }
  
  let isAppeared = BehaviorRelay(value: false)
  
  public let emptyDataSetButtonTap = PublishRelay<Void>()
  public var emptyDataSetStatus: EmptyDataState = .normal
  
  private var lottieLoadingView: LottieAnimationView = {
    let animationView = LottieAnimationView()
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.backgroundBehavior = .pauseAndRestore
    animationView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    animationView.layer.cornerRadius = 10
    animationView.layer.masksToBounds = true
    animationView.frame = CGRect(origin: .zero, size: CGSize(width: 150, height: 80))
    if let animation = LottieAnimation.named("text_loading", bundle: Bundle.current!) {
      animationView.animation = animation
    }
    return animationView
  }()
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    extendedLayoutIncludesOpaqueBars = true
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    
    configureUI()
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isAppeared.accept(true)
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    isAppeared.accept(false)
  }
  
  open func configureUI() {
    
  }
  
  open func updateUI() {
    
  }
  
  deinit {
    printLog("###- \(Self.self) deinit -###")
  }
}

// MARK: - UIGestureRecognizerDelegate

extension DataSetViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // 处理当navigationController的rootViewContoller响应左滑返回手势时，再push下一个页面会导致下一个页面无法显示
    if gestureRecognizer == navigationController?.interactivePopGestureRecognizer &&
        navigationController?.visibleViewController == navigationController?.viewControllers.first {
      return false
    }
    return true
  }
}

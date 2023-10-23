//
//  ViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Lottie
import Toast_Swift
import Factory
import EmptyDataSet_Swift
import Bindable
import NetworkManager
import Log

open class ViewController: UIViewController, EmptyDataSetable, ViewAnimateLoadable {
  
  public var disposeBag = DisposeBag()
  
  let isAppeared = BehaviorRelay(value: false)
  
  var navigationTitle = "" {
    didSet {
      navigationItem.title = navigationTitle
    }
  }
  
  public let emptyDataSetButtonTap = PublishRelay<Void>()
  public var emptyDataSetStatus: EmptyDataState = .normal
  
  public var animationLoadingView: AnimatableView = {
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
  
//  open func bindViewModel() {
//    viewModel.loading.asObservable().bind(to: rx.isLoading).disposed(by: disposeBag)
//    
//    // Empty Data Status
//    viewModel.dataStaus.asObservable()
//      .map{ dataStatus -> EmptyDataState in
//        switch dataStatus {
//        case .normal:
//          return .normal
//        case .empty:
//          return .empty
//        case .error(_):
//          return .empty
//        }
//      }.bind(to: rx.emptyDataSetStatus)
//      .disposed(by: disposeBag)
//  }
  
  deinit {
    printLog("###- \(Self.self) deinit -###")
  }
}

// MARK: - UIGestureRecognizerDelegate

extension ViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    // 处理当navigationController的rootViewContoller响应左滑返回手势时，再push下一个页面会导致下一个页面无法显示
    if gestureRecognizer == navigationController?.interactivePopGestureRecognizer &&
        navigationController?.visibleViewController == navigationController?.viewControllers.first {
      return false
    }
    return true
  }
}

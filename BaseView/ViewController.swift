//
//  ViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import Toast_Swift
import Factory
import EmptyDataSet_Swift
import Bindable
import NetworkManager
import Log

open class ViewController: UIViewController, BindableType, EmptyDataSetable {
  
  open var viewModel: ViewModel!
  
  public let disposeBag = DisposeBag()
  
  public let refreshTrigger = PublishRelay<Void>()
  
  let error = PublishRelay<ApiError>()
  let isLoading = BehaviorRelay(value: false)
  let isAppeared = BehaviorRelay(value: false)
  
  var navigationTitle = "" {
    didSet {
      navigationItem.title = navigationTitle
    }
  }
  
  public let emptyDataSetButtonTap = PublishRelay<Void>()
  public let emptyDataSetStatus = BehaviorRelay<EmptyDataState>(value: .normal)
  
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
  
  open func bindViewModel() {
    viewModel.loading.asObservable().bind(to: isLoading).disposed(by: disposeBag)
    viewModel.parsedError.asObservable().bind(to: error).disposed(by: disposeBag)
    
    // Empty Data Status
    viewModel.dataStaus.asObservable()
      .withUnretained(self)
      .subscribe(onNext: { owner, dataStatus in
        switch dataStatus {
        case .normal:
          owner.emptyDataSetStatus.accept(.normal)
        case .empty:
          owner.emptyDataSetStatus.accept(.empty)
        case .error(_):
          owner.emptyDataSetStatus.accept(.error)
        }
      }).disposed(by: disposeBag)
    
    // Network Activity
    Observable.combineLatest(isLoading, isAppeared) { $0 && $1 }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { owner, shouldLoading in
        // Provide a custom network activity UI in your app if desired.
        if shouldLoading {
          owner.showLoadingToast()
        } else {
          owner.hideLoadingToast()
        }
      }).disposed(by: disposeBag)
    
    // error capture
    error
      .withUnretained(self)
      .subscribe(onNext: { owner, error in
        // do something show error
      }).disposed(by: disposeBag)
  }
  
  public func showLoadingToast() {
    view.showToast(lottieLoadingView, duration: TimeInterval.infinity, position: .center)
    lottieLoadingView.play()
  }
  
  public func hideLoadingToast() {
    lottieLoadingView.stop()
    view.hideToast(lottieLoadingView)
  }
  
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

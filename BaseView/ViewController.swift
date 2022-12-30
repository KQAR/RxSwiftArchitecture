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

enum EmptyDataState {
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

open class ViewController: UIViewController, BindableType {
  
  open var viewModel: ViewModel!
  
  public let disposeBag = DisposeBag()
  
  public let refreshTrigger = PublishSubject<Void>()
  
  let error = PublishSubject<ApiError>()
  let isLoading = BehaviorRelay(value: false)
  let isAppeared = BehaviorRelay(value: false)
  
  var navigationTitle = "" {
    didSet {
      navigationItem.title = navigationTitle
    }
  }
  
  let emptyDataSetButtonTap = PublishSubject<Void>()
  let emptyDataSetStatus = BehaviorRelay<EmptyDataState>(value: .normal)
  
  private var lottieLoadingView: LottieAnimationView = {
    let animationView = LottieAnimationView()
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.backgroundBehavior = .pauseAndRestore
    animationView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    animationView.layer.cornerRadius = 10
    animationView.layer.masksToBounds = true
    animationView.frame = CGRect(origin: .zero, size: CGSize(width: 160, height: 80))
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

// MARK: - EmptyDataSet Source

extension ViewController: EmptyDataSetSource {
  public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetStatus.value.title, attributes: [
      .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
      .foregroundColor: UIColor.gray
    ])
  }
  
  public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetStatus.value.description)
  }
  
  public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return emptyDataSetStatus.value.image
  }
  
  public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return emptyDataSetStatus.value.imageTintColor
  }
  
  public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return emptyDataSetStatus.value.backgroundColor
  }
}

// MARK: - EmptyDataSet Delegate

extension ViewController: EmptyDataSetDelegate {
  public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    return emptyDataSetStatus.value.emptyViewShouldDisplay
  }
  
  public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
    return emptyDataSetStatus.value.emptyViewShouldAllowScroll
  }
  
  public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
    emptyDataSetButtonTap.onNext(())
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

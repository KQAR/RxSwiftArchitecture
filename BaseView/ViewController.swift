//
//  ViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import Factory
import EmptyDataSet_Swift
import Bindable
import NetworkManager
import Log

open class ViewController: UIViewController, BindableType {
  
  open var viewModel: ViewModel!
  
  public let disposeBag = DisposeBag()
  
  let refreshTrigger = PublishSubject<Void>()
  
  let error = PublishSubject<ApiError>()
  let isLoading = BehaviorRelay(value: false)
  
  var navigationTitle = "" {
    didSet {
      navigationItem.title = navigationTitle
    }
  }
  
  let emptyDataSetButtonTap = PublishSubject<Void>()
  var emptyDataSetTitle = "还没有数据哦~"
  var emptyDataSetDescription = ""
  var emptyDataSetImage = UIImage(named: "empty_state_witdraw")
  var emptyDataSetImageTintColor = BehaviorRelay<UIColor?>(value: nil)
  
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
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  open func configureUI() {
    
  }
  
  open func updateUI() {
    
  }
  
  open func bindViewModel() {
    viewModel?.loading.asObservable().bind(to: isLoading).disposed(by: disposeBag)
    viewModel?.parsedError.asObservable().bind(to: error).disposed(by: disposeBag)
    
    // Network Activity
    isLoading
      .subscribe(onNext: { isLoading in
        // Provide a custom network activity UI in your app if desired.
      }).disposed(by: disposeBag)
    
    // error capture
    error
      .withUnretained(self)
      .subscribe(onNext: { owner, error in
        // do something show error
      }).disposed(by: disposeBag)
  }
  
  deinit {
    printLog("###- \(Self.self) deinit -###")
  }
}

// MARK: - EmptyDataSet Source

extension ViewController: EmptyDataSetSource {
  public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetTitle, attributes: [
      .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
      .foregroundColor: UIColor.gray
    ])
  }
  
  public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: emptyDataSetDescription)
  }
  
  public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return emptyDataSetImage
  }
  
  public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return emptyDataSetImageTintColor.value
  }
  
  public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    return .clear
  }
}

// MARK: - EmptyDataSet Delegate

extension ViewController: EmptyDataSetDelegate {
  public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    return !isLoading.value
  }
  
  public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
    return true
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

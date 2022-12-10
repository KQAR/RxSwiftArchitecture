//
//  TableViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

open class TableViewController: ViewController {
  
  public let headerRefreshTrigger = PublishSubject<Void>()
  public let footerRefreshTrigger = PublishSubject<Void>()
  
  public let isHeaderLoading = BehaviorRelay(value: false)
  public let isFooterLoading = BehaviorRelay(value: false)
  public let isNomoreData = BehaviorRelay(value: false)
  
  public lazy var tableView: TableView = {
    let view = TableView(frame: .zero, style: .plain)
    view.estimatedRowHeight = UITableView.automaticDimension
    view.emptyDataSetSource = self
    view.emptyDataSetDelegate = self
    return view
  }()
  
  open override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  open override func configureUI() {
    super.configureUI()
    
    // KafkaRefresh
//    tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
//      self?.headerRefreshTrigger.onNext(())
//    })
//    tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
//      self?.footerRefreshTrigger.onNext(())
//    })
//    tableView.footRefreshControl.setAlertBackgroundColor(.white)
//    tableView.footRefreshControl.autoRefreshOnFoot = true
//    isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
//    isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)
//    isNomoreData.bind(to: tableView.footRefreshControl.rx.isNomoreData).disposed(by: disposeBag)
    
    // MJRefresh
    tableView.mj_header = RefreshHeaderControl(refreshingBlock: {
      self.headerRefreshTrigger.onNext(())
    })
    tableView.mj_footer = RefreshFooterControl(refreshingBlock: {
      self.footerRefreshTrigger.onNext(())
    })
    isHeaderLoading.bind(to: tableView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    isFooterLoading.bind(to: tableView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    
    error.subscribe(onNext: { [weak self] (error) in
      //            self?.tableView.makeToast(error.description, title: error.title, image: R.image.icon_toast_warning())
    }).disposed(by: disposeBag)
  }
  
  open override func bindViewModel() {
    super.bindViewModel()
    
    viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: disposeBag)
    viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: disposeBag)
    viewModel.pagingIndicator.asObservable().bind(to: isNomoreData).disposed(by: disposeBag)
    
    let updateEmptyDataSet = Observable.of(
      isLoading.filter({ $0 == false }).map { _ in }.asObservable(),
      emptyDataSetImageTintColor.map { _ in }
    ).merge()
    updateEmptyDataSet
      .subscribe(onNext: { [weak self] () in
        self?.tableView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

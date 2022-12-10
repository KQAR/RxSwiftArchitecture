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
    
    // MJRefresh
    tableView.mj_header = RefreshHeaderControl(refreshingBlock: { [weak self] in
      self?.headerRefreshTrigger.onNext(())
    })
    tableView.mj_footer = RefreshFooterControl(refreshingBlock: { [weak self] in
      self?.footerRefreshTrigger.onNext(())
    })
    isHeaderLoading.bind(to: tableView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    isFooterLoading.bind(to: tableView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    isNomoreData.bind(to: tableView.mj_footer!.rx.noMoreData).disposed(by: disposeBag)
    
    // error capture
    error
      .withUnretained(self)
      .subscribe(onNext: { owner, error in
        // do something show error
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
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.tableView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

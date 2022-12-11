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
  }
  
  open override func bindViewModel() {
    super.bindViewModel()
    
    viewModel.headerLoading.asObservable().bind(to: tableView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    viewModel.footerLoading.asObservable().bind(to: tableView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    viewModel.pagingIndicator.asObservable().bind(to: tableView.mj_footer!.rx.noMoreData).disposed(by: disposeBag)
    
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

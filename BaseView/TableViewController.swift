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
  
  public let headerRefreshTrigger = PublishRelay<Void>()
  public let footerRefreshTrigger = PublishRelay<Void>()
  
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
    setupRefreshControl()
  }
  
  /// 如果要使用其他自定义刷新控件，请在子类重写该方法
  open func setupRefreshControl() {
    // MJRefresh
    tableView.mj_header = RefreshHeaderControl(refreshingBlock: { [weak self] in
      self?.headerRefreshTrigger.accept(())
    })
    tableView.mj_footer = RefreshFooterControl(refreshingBlock: { [weak self] in
      self?.footerRefreshTrigger.accept(())
    })
  }
  
  open override func bindViewModel() {
    super.bindViewModel()
    
    viewModel.headerLoading.asObservable().bind(to: tableView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    viewModel.footerLoading.asObservable().bind(to: tableView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    viewModel.pagingIndicator.asObservable().bind(to: tableView.mj_footer!.rx.noMoreData).disposed(by: disposeBag)
    
    viewModel.headerLoading.asObservable()
      .skip(1)
      .filter { !$0 }
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.tableView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

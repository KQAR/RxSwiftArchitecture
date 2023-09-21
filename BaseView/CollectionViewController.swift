//
//  CollectionViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import Log

open class CollectionViewController: ViewController, ViewRefreshable {
  
  public let headerRefreshTrigger = PublishRelay<Void>()
  public let footerRefreshTrigger = PublishRelay<Void>()
  
  public lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = false
    collectionView.alwaysBounceVertical = true
    collectionView.isPrefetchingEnabled = true
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    return collectionView
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
    collectionView.mj_header = refreshHeader
    collectionView.mj_footer = refreshFooter
  }
  
  open override func bindViewModel() {
    super.bindViewModel()
    
    viewModel.headerLoading.asObservable()
      .bind(to: collectionView.mj_header!.rx.isAnimating)
      .disposed(by: disposeBag)
    viewModel.footerLoading.asObservable()
      .bind(to: collectionView.mj_footer!.rx.isAnimating)
      .disposed(by: disposeBag)
    viewModel.pagingIndicator.asObservable()
      .bind(to: collectionView.mj_footer!.rx.noMoreData)
      .disposed(by: disposeBag)
    
    viewModel.headerLoading.asObservable()
      .skip(1)
      .filter { !$0 }
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.collectionView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

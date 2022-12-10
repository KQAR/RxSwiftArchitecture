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

open class CollectionViewController: ViewController {
  
  public let headerRefreshTrigger = PublishSubject<Void>()
  public let footerRefreshTrigger = PublishSubject<Void>()
  
  public let isHeaderLoading = BehaviorRelay(value: false)
  public let isFooterLoading = BehaviorRelay(value: false)
  public let isNomoreData = BehaviorRelay(value: false)
  
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
    
    collectionView.mj_header = RefreshHeaderControl(refreshingBlock: { [weak self] in
      self?.headerRefreshTrigger.onNext(())
    })
    collectionView.mj_footer = RefreshFooterControl(refreshingBlock: { [weak self] in
      self?.footerRefreshTrigger.onNext(())
    })
    isHeaderLoading.bind(to: collectionView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    isFooterLoading.bind(to: collectionView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    isNomoreData.bind(to: collectionView.mj_footer!.rx.noMoreData).disposed(by: disposeBag)
    
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
        owner.collectionView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

//
//  CollectionViewController.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh
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
    
    collectionView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
      self?.headerRefreshTrigger.onNext(())
    })
    collectionView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
      self?.footerRefreshTrigger.onNext(())
    })
    collectionView.footRefreshControl.setAlertBackgroundColor(.white)
    collectionView.footRefreshControl.autoRefreshOnFoot = true
    
    isHeaderLoading.bind(to: collectionView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
    isFooterLoading.bind(to: collectionView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)
    isNomoreData.bind(to: collectionView.footRefreshControl.rx.isNomoreData).disposed(by: disposeBag)
    
    error
      .subscribe(onNext: { [weak self] (error) in
        //      self?.tableView.makeToast(error.description, title: error.title, image: R.image.icon_toast_warning())
        printLog("==> error: \(error)")
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
        self?.collectionView.reloadEmptyDataSet()
      }).disposed(by: disposeBag)
  }
}

extension Reactive where Base: KafkaFootRefreshControl {
    public var isNomoreData: Binder<Bool> {
        return Binder(self.base) { refreshControl, nomoreData in
            if nomoreData {
                refreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
            } else if refreshControl.isShouldNoLongerRefresh {
                refreshControl.resumeRefreshAvailable()
            }
        }
    }
}

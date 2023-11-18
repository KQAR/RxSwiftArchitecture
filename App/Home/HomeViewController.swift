//
//  HomeViewController.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import Factory
import RxSwift
import RxCocoa
import RxDataSources
import Mediator
import BaseView
import Log
import ReactorKit

public final class HomeViewController: CollectionViewController, View {
  
  enum Metrics {
    static let minimumLineSpacing: CGFloat = 10
    static let itemSize = CGSize(width: UIScreen.main.bounds.size.width - 30, height: 120)
    static let sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.RGBA(r: 231, g: 231, b: 231, a: 1.0)
    navigationController?.delegate = self
  }
  
  public override func configureUI() {
    super.configureUI()
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = Metrics.itemSize
    flowLayout.minimumLineSpacing = Metrics.minimumLineSpacing
    flowLayout.headerReferenceSize = CGSize(width: Metrics.itemSize.width, height: Metrics.minimumLineSpacing)
    collectionView.backgroundColor = view.backgroundColor
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
    collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  public func bind(reactor: HomeReactor) {
    // action (View -> Reactor)
    let refresh = Observable.of(Observable.just(()), headerRefreshTrigger.asObservable()).merge()
    refresh.map { Reactor.Action.headerRefresh }.bind(to: reactor.action).disposed(by: disposeBag)
    footerRefreshTrigger.map { Reactor.Action.footerRefresh }.bind(to: reactor.action).disposed(by: disposeBag)
    // state (Reactor -> View)
    reactor.state.map(\.headerLoading).bind(to: collectionView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    reactor.state.map(\.footerLoading).bind(to: collectionView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    reactor.state.map(\.dataStatus.emptyDataState).bind(to: rx.emptyDataSetStatus).disposed(by: disposeBag)
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<HomeSectionReactor>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.reuseIdentifier, for: indexPath) as! HomeCollectionCell
        cell.bind(reactor: item)
        return cell
      })
    reactor.state.map(\.items).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
  }
}

extension HomeViewController: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    let isHiddenBarPage = viewController.isKind(of: HomeViewController.self)
    navigationController.setNavigationBarHidden(isHiddenBarPage, animated: true)
  }
}

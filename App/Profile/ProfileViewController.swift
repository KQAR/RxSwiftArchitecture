//
//  ProfileViewController.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import RxSwift
import RxDataSources
import BaseView
import SnapKit
import ReactorKit

public final class ProfileViewController: TableViewController, ReactorKit.View {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.RGBA(r: 231, g: 231, b: 231, a: 1.0)
  }
  
  public override func configureUI() {
    super.configureUI()
    tableView.separatorColor = .gray
    tableView.backgroundColor = view.backgroundColor
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  public func bind(reactor: ProfileViewReactor) {
    // action (View -> Reactor)
    let refresh = Observable.of(Observable.just(()), headerRefreshTrigger.asObservable()).merge()
    refresh.map { Reactor.Action.headerRefresh }.bind(to: reactor.action).disposed(by: disposeBag)
    footerRefreshTrigger.map { Reactor.Action.footerRefresh }.bind(to: reactor.action).disposed(by: disposeBag)
    // state (Reactor -> View)
    reactor.state.map(\.headerLoading).bind(to: tableView.mj_header!.rx.isAnimating).disposed(by: disposeBag)
    reactor.state.map(\.footerLoading).bind(to: tableView.mj_footer!.rx.isAnimating).disposed(by: disposeBag)
    reactor.state.map(\.dataStatus.emptyDataState).bind(to: rx.emptyDataSetStatus).disposed(by: disposeBag)
  }
  
//  public override func bindViewModel() {
//    super.bindViewModel()
//    guard let viewModel = viewModel as? ProfileViewModel else { return }
//    let refresh = Observable.of(Observable.just(()), headerRefreshTrigger.asObservable()).merge()
//    let input = ProfileViewModel.Input(
//      headerRefresh: refresh.asSignal(onErrorJustReturn: ()),
//      footerRefresh: footerRefreshTrigger.asSignal()
//    )
//    let output = viewModel.transform(input: input)
//    
//    output.items
//      .drive(tableView.rx.items(
//        cellIdentifier: ProfileTableViewCell.reuseIdentifier,
//        cellType: ProfileTableViewCell.self)
//      ) { row, viewModel, cell in
//        cell.bind(to: viewModel)
//      }.disposed(by: disposeBag)
//  }
}

//
//  DetailViewController.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import BaseView
import Popups

final class DetailViewController: UIViewController, ReactorKit.View {
  
  private var detailView: DetailView!
  internal var disposeBag = DisposeBag()
  
  override func loadView() {
    detailView = DetailView()
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  func bind(reactor: DetailReactor) {
    Observable.just(())
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    detailView.collect.asSignal(onErrorJustReturn: ())
      .map { Reactor.Action.collect }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.detail?.title)
      .bind(to: navigationItem.rx.title, detailView.title)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.detail?.coverURL)
      .bind(to: detailView.cover)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.detail?.content)
      .bind(to: detailView.content)
      .disposed(by: disposeBag)
    
    reactor.state.compactMap(\.isCollect)
      .bind(to: detailView.collectButtonIsSelected)
      .disposed(by: disposeBag)
  }
}

//final class DetailViewController: ViewController {
//
//  private var detailView: DetailView!
//
//  override func loadView() {
//    detailView = DetailView()
//    view = detailView
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.backgroundColor = .white
//  }
//
//  override func bindViewModel() {
//    super.bindViewModel()
//    guard let viewModel = viewModel as? DetailViewModel else { return }
//
//    let refresh = Observable.of(Observable.just(()), refreshTrigger.asObservable()).merge()
//    let input = DetailViewModel.Input(
//      refresh: refresh.asSignal(onErrorJustReturn: ()),
//      collect: detailView.collect.asSignal(onErrorJustReturn: ()),
//      wireframe: DefaultWireframe()
//    )
//    let output = viewModel.transform(input: input)
//
//    output.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
//    output.title.drive(detailView.title).disposed(by: disposeBag)
//    output.cover.drive(detailView.cover).disposed(by: disposeBag)
//    output.content.drive(detailView.content).disposed(by: disposeBag)
//    output.isCollected.drive(detailView.collectButtonIsSelected).disposed(by: disposeBag)
//    output.isCollectHidden.drive(detailView.collectButtonHidden).disposed(by: disposeBag)
//    output.tips
//      .emit(with: self, onNext: { owner, tips in
//        owner.view?.makeToast(tips)
//      }).disposed(by: disposeBag)
//  }
//}

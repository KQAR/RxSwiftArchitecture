//
//  DetailViewController.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa
import BaseView
import Popups

final class DetailViewController: ViewController {
  
  private var detailView: DetailView!
  
  override func loadView() {
    detailView = DetailView()
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? DetailViewModel else { return }
    
    let refresh = Observable.of(Observable.just(()), refreshTrigger.asObservable()).merge()
    let input = DetailViewModel.Input(
      refresh: refresh,
      collect: detailView.collect,
      wireframe: DefaultWireframe()
    )
    let output = viewModel.transform(input: input)
    
    output.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
    output.title.drive(detailView.title).disposed(by: disposeBag)
    output.cover.drive(detailView.cover).disposed(by: disposeBag)
    output.content.drive(detailView.content).disposed(by: disposeBag)
    output.isCollected.drive(detailView.collectButtonIsSelected).disposed(by: disposeBag)
    output.isCollectHidden.drive(detailView.collectButtonHidden).disposed(by: disposeBag)
    output.tips
      .withUnretained(self)
      .subscribe(onNext: { owner, tips in
        owner.view?.makeToast(tips)
      }).disposed(by: disposeBag)
  }
}

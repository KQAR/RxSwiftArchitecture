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
    
    let refresh = Observable.of(Observable.just(()), refreshTrigger).merge()
    let input = DetailViewModel.Input(refresh: refresh)
    let output = viewModel.transform(input: input)
    
    output.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
    output.title.drive(detailView.title).disposed(by: disposeBag)
    output.cover.drive(detailView.cover).disposed(by: disposeBag)
    output.content.drive(detailView.content).disposed(by: disposeBag)
  }
}

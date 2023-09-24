//
//  PaymentViewController.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import Factory
import RxSwift
import RxCocoa
import BaseView
import Popups
import Log

public class PaymentViewController: ViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .purple
    
    let button = UIButton()
    button.setTitle("Go", for: .normal)
//    button.rx.tap
//      .withUnretained(self)
//      .flatMap { owner, _ in
//        return AdDialog.popupAction(in: owner, animated: true)
//      }.subscribe(onNext: { action in
//        printLog("\(action.description) tap ~ ")
//      }).disposed(by: disposeBag)
    view.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(200)
      make.size.equalTo(CGSize(width: 60, height: 44))
      make.centerX.equalToSuperview()
    }
  }
  
  private func goNext() {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .brown
    navigationController?.pushViewController(viewController, animated: true)
  }
  
//  public override func bindViewModel() {
//    
//  }
}


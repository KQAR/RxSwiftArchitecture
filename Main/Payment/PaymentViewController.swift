//
//  PaymentViewController.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import Factory
import BaseView
import Popups

public class PaymentViewController: ViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .purple
    
    let button = UIButton()
    button.setTitle("Go", for: .normal)
    button.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        let dialog = AdDialog()
        dialog.popup(in: owner, animated: true)
      }).disposed(by: disposeBag)
    view.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalTo(200)
      make.size.equalTo(CGSize(width: 60, height: 44))
      make.centerX.equalToSuperview()
    }
  }
  
  public override func bindViewModel() {
    
  }
}


//
//  PaymentViewController.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import Factory
import BaseView

public class PaymentViewController: ViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .purple
  }
  
  public override func bindViewModel() {
    guard let viewModel = viewModel as? PaymentViewModel else { return }
  }
}


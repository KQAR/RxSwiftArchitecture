//
//  AdDialog.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/12.
//

import UIKit
import Popups

class AdDialog: UIViewController, ViewControllerPresentable {
  
  var makeContentSize: CGSize {
    return CGSize(width: 200, height: 200)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
  }
}

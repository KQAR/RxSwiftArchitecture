//
//  UIView.swift
//  Extension
//
//  Created by Jarvis on 2022/12/29.
//

import UIKit

public extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}

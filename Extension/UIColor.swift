//
//  UIColor.swift
//  Extension
//
//  Created by 金瑞 on 2022/12/11.
//

import UIKit

public extension UIColor {
  
  /// Color的RGBA简写
  class func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
  }
  
  /// 十六进制颜色
  class func hex(with color: String) -> UIColor {
    let scanner = Scanner(string: color)
    var valueRGB: UInt64 = 0
    if scanner.scanHexInt64(&valueRGB) == false {
      return self.init(red: 0, green: 0, blue: 0, alpha: 0)
    } else {
      return self.init(
        red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
      )
    }
  }
  
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    self.init(
      red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
      blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
      alpha: alpha
    )
  }
}

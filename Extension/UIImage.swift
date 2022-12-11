//
//  UIImage.swift
//  Extension
//
//  Created by 金瑞 on 2022/12/11.
//

import UIKit

public extension UIImage {
  
  /// 生成纯色图片
  convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image!.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
  
  /// 生成渐变色图片
  class func gradient(
    colors: [UIColor],
    size: CGSize = CGSize(width: 1, height: 1),
    locations: [NSNumber] = [0, 1],
    startPoint: CGPoint = CGPoint(x: 0, y: 0),
    endPoint: CGPoint = CGPoint(x: 1, y: 0)
  ) -> UIImage? {
    guard colors.count != 0 else { return nil }
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect(origin: .zero, size: size)
    gradientLayer.locations = locations
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.colors = colors.map { $0.cgColor }
    
    UIGraphicsBeginImageContextWithOptions(size, gradientLayer.isOpaque, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    gradientLayer.render(in: context)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage
  }
  
  /// 图片拉伸
  func resized() -> UIImage {
    return stretchableImage(withLeftCapWidth: Int(size.width * 0.5), topCapHeight: Int(size.height * 0.5))
  }
}

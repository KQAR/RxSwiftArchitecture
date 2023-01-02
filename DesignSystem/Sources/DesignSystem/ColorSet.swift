//
//  ColorSet.swift
//  
//
//  Created by 金瑞 on 2023/1/2.
//

import UIKit

public protocol ColorSet {
  var tintColor: UIColor { get set }
  var labelColor: UIColor { get set }
  var primaryBackgroundColor: UIColor { get set }
  var secondaryBackgroundColor: UIColor { get set }
}

public struct DarkSet: ColorSet {
  public var tintColor = UIColor(red: 187/255, green: 59/255, blue: 226/255, alpha: 1.0)
  public var labelColor = UIColor.white
  public var primaryBackgroundColor =  UIColor(red: 16/255, green: 21/255, blue: 35/255, alpha: 1.0)
  public var secondaryBackgroundColor = UIColor(red: 30/255, green: 35/255, blue: 62/255, alpha: 1.0)
  
  public init() {}
}

public struct LightSet: ColorSet {
  public var tintColor = UIColor(red: 187/255, green: 59/255, blue: 226/255, alpha: 1.0)
  public var labelColor = UIColor.black
  public var primaryBackgroundColor = UIColor.white
  public var secondaryBackgroundColor = UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1.0)
  
  public init() {}
}


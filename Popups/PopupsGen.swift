//
//  PopupsGen.swift
//  Popups
//
//  Created by Jarvis on 2022/12/13.
//

import UIKit
import Foundation

public class PopupsGen {
  
  public enum PopupStyle {
    case top(extent: CGFloat?)
    case bottom(extent: CGFloat?)
    case center
    
    var extent: CGFloat? {
      switch self {
      case .top(let extent), .bottom(let extent):
        return extent
      case .center:
        return nil
      }
    }
  }
  
  public enum Layout {
    case top(inset: CGFloat)
    case bottom(inset: CGFloat)
    case center(offset: CGFloat)
  }
  
  public enum DimModel {
    case none
    case gray
    case blur
  }
  
  public struct Config {
    init() {}
    
    public var popupStyle = PopupStyle.bottom(extent: 50)
    
    public var layout = Layout.bottom(inset: 100)
    
    public var dimModel = DimModel.none
    
    public var cornerRadius: CGFloat = 8.0
    
    public var duration: TimeInterval = 0.6
  }
  
  static let instance = PopupsGen()
  private init() {}
  
  public var defaultConfiguration = Config()
  
  func show(view: UIView, with: Config, in viewController: UIViewController) {
    
  }
  
}

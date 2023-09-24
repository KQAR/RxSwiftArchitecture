//
//  ViewRefreshable.swift
//  BaseView
//
//  Created by Jarvis on 2023/9/21.
//

import Foundation
import RxRelay

public protocol ViewRefreshable: AnyObject {
  var headerRefreshTrigger: PublishRelay<Void> { get }
  var footerRefreshTrigger: PublishRelay<Void> { get }
}

extension ViewRefreshable {
  // MJRefresh
  var refreshHeader: RefreshHeaderControl {
    RefreshHeaderControl(refreshingBlock: { [weak self] in
      self?.headerRefreshTrigger.accept(())
    })
  }
  
  var refreshFooter: RefreshFooterControl {
    RefreshFooterControl(refreshingBlock: { [weak self] in
      self?.footerRefreshTrigger.accept(())
    })
  }
  
  var lottieRefreshHeader: LottieRefreshHeaderControl {
    LottieRefreshHeaderControl(refreshingBlock: { [weak self] in
      self?.headerRefreshTrigger.accept(())
    })
  }
  
  var lottieRefreshFooter: LottieRefreshFooterControl {
    LottieRefreshFooterControl(refreshingBlock: { [weak self] in
      self?.footerRefreshTrigger.accept(())
    })
  }
}

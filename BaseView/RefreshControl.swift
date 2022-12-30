//
//  RefreshControl.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import MJRefresh
import Lottie

let currentBundle = Bundle(identifier: "com.person.BaseView")
// MARK: - RefreshHeaderControl

/// 下拉自动刷新控件
public class RefreshHeaderControl: MJRefreshNormalHeader {

}

/// Lottie动画下拉刷新控件
public class LottieRefreshHeaderControl: MJRefreshHeader {
  
  enum Metrics {
    static let animationName = "down_arrows"
  }
  
  private var lottieAnim: LottieAnimationView = {
    let animationView = LottieAnimationView()
    animationView.contentMode = .scaleAspectFill
    animationView.loopMode = .loop
    
    if let animation = LottieAnimation.named(Metrics.animationName, bundle: currentBundle!) {
      animationView.animation = animation
    } else {
      DotLottieFile.named(Metrics.animationName, bundle: currentBundle!) { result in
        guard case Result.success(let lottie) = result else { return }
        animationView.loadAnimation(from: lottie)
      }
    }

    return animationView
  }()
  
  public override func prepare() {
    super.prepare()
    addSubview(lottieAnim)
    lottieAnim.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lottieAnim.heightAnchor.constraint(equalTo: heightAnchor),
      lottieAnim.widthAnchor.constraint(equalTo: heightAnchor),
      lottieAnim.centerXAnchor.constraint(equalTo: centerXAnchor),
      lottieAnim.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  public override var state: MJRefreshState {
    didSet {
      switch state {
      case .idle:
        guard lottieAnim.isAnimationPlaying else { return }
        lottieAnim.stop()
      case .refreshing:
        guard lottieAnim.animation != nil && !lottieAnim.isAnimationPlaying else { return }
        lottieAnim.play()
      default:
        break
      }
    }
  }
  
  public override var pullingPercent: CGFloat {
    didSet {
      guard lottieAnim.animation != nil && !lottieAnim.isAnimationPlaying else { return }
      lottieAnim.currentProgress = pullingPercent
    }
  }
}

// MARK: - FooterRefreshControl

/// 上拉自动加载控件
/// 隐藏了菊花和文字，上拉到控件全部显示时自动加载更多
public class RefreshFooterControl: MJRefreshAutoNormalFooter {
  public override var state: MJRefreshState {
    didSet {
      switch state {
      case .idle:
        stateLabel?.isHidden = true
      case .refreshing:
        isHidden = false
        stateLabel?.isHidden = false
      case .noMoreData:
        isHidden = true
      default:
        break
      }
    }
  }
}

/// 上拉加载 Lottie 动画样式
public class LottieRefreshFooterControl: MJRefreshAutoFooter {
  
  enum Metrics {
    static let animationName = "seconds-loader-beeboard"
  }
  
  private var lottieAnim: LottieAnimationView = {
    let animationView = LottieAnimationView()
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 2.0
    
    if let animation = LottieAnimation.named(Metrics.animationName, bundle: currentBundle!) {
      animationView.animation = animation
    } else {
      DotLottieFile.named(Metrics.animationName, bundle: currentBundle!) { result in
        guard case Result.success(let lottie) = result else { return }
        animationView.loadAnimation(from: lottie)
      }
    }

    return animationView
  }()
  
  public override func prepare() {
    super.prepare()
    
    addSubview(lottieAnim)
    lottieAnim.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lottieAnim.heightAnchor.constraint(equalTo: heightAnchor),
      lottieAnim.widthAnchor.constraint(equalTo: widthAnchor),
      lottieAnim.centerXAnchor.constraint(equalTo: centerXAnchor),
      lottieAnim.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  public override var state: MJRefreshState {
    didSet {
      switch state {
      case .idle:
        lottieAnim.isHidden = true
        guard lottieAnim.isAnimationPlaying else { return }
        lottieAnim.stop()
      case .refreshing:
        isHidden = false
        guard lottieAnim.animation != nil && !lottieAnim.isAnimationPlaying else { return }
        lottieAnim.isHidden = false
        lottieAnim.play()
      case .noMoreData:
        isHidden = true
      default:
        break
      }
    }
  }
  
  public override var pullingPercent: CGFloat {
    didSet {
      guard lottieAnim.animation != nil && !lottieAnim.isAnimationPlaying else { return }
      lottieAnim.currentProgress = pullingPercent
    }
  }
}

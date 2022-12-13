//
//  CustomPresentationController.swift
//  Popups
//
//  Created by 金瑞 on 2022/12/12.
//

import UIKit

class CustomPresentationController: UIPresentationController {
  
  private let configuration: PopupsGen.Config
  private var dimmingView: UIView?
  private var presentationWrappingView: UIView!
  
  override var presentedView: UIView {
    return presentationWrappingView
  }
  
  init(
    configuration: PopupsGen.Config,
    presentedViewController: UIViewController,
    presenting presentingViewController: UIViewController? = nil
  ) {
    self.configuration = configuration
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    presentedViewController.modalPresentationStyle = .custom
  }
  
  override func presentationTransitionWillBegin() {
    guard let presentedViewControllerView = super.presentedView else { return }
    
    // Wrap the presented view controller's view in an intermediate hierarchy
    // that applies a shadow and rounded corners to the top-left and top-right
    // edges.  The final effect is built using three intermediate views.
    //
    // presentationWrapperView              <- shadow
    //   |- presentationRoundedCornerView   <- rounded corners (masksToBounds)
    //        |- presentedViewControllerWrapperView
    //             |- presentedViewControllerView (presentedViewController.view)
    //
    
    let presentationWrapperView = UIView(frame: frameOfPresentedViewInContainerView)
    presentationWrapperView.layer.shadowOpacity = 0.1
    presentationWrapperView.layer.shadowRadius = 3
    presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -3)
    self.presentationWrappingView = presentationWrapperView
    
    // presentationRoundedCornerView is CORNER_RADIUS points taller than the
    // height of the presented view controller's view.  This is because
    // the cornerRadius is applied to all corners of the view.  Since the
    // effect calls for only the top two corners to be rounded we size
    // the view such that the bottom CORNER_RADIUS points lie below
    // the bottom edge of the screen.
    let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds)
    presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    presentationRoundedCornerView.layer.cornerRadius = configuration.cornerRadius
    presentationRoundedCornerView.layer.masksToBounds = true
    
    // To undo the extra height added to presentationRoundedCornerView,
    // presentedViewControllerWrapperView is inset by CORNER_RADIUS points.
    // This also matches the size of presentedViewControllerWrapperView's
    // bounds to the size of -frameOfPresentedViewInContainerView.
    let presentedViewControllerWrapperView = UIView(frame: presentationRoundedCornerView.bounds)
    presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // Add presentedViewControllerView -> presentedViewControllerWrapperView.
    presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
    presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
    
    // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
    presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
    
    // Add presentationRoundedCornerView -> presentationWrapperView.
    presentationWrapperView.addSubview(presentationRoundedCornerView)
    
    // Add a dimming view behind presentationWrapperView.  self.presentedView
    // is added later (by the animator) so any views added here will be
    // appear behind the -presentedView.
    guard let containerView = containerView else { return }
    let dimmingView = UIView(frame: containerView.bounds)
    dimmingView.backgroundColor = .black
    dimmingView.isOpaque = false
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(sender:))))
    self.dimmingView = dimmingView
    self.containerView?.addSubview(dimmingView)
    
    let transitionCoordinator = presentingViewController.transitionCoordinator
    
    self.dimmingView?.alpha = 0
    transitionCoordinator?.animate(alongsideTransition: { context in
      self.dimmingView?.alpha = 0.4
    }, completion: nil)
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool) {
    if completed == false {
      self.presentationWrappingView = nil
      self.dimmingView = nil
    }
  }
  
  override func dismissalTransitionWillBegin() {
    let transitionCoordinator = presentingViewController.transitionCoordinator
    transitionCoordinator?.animate(alongsideTransition: { context in
      self.dimmingView?.alpha = 0
    }, completion: nil)
  }
  
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed == true {
      self.presentationWrappingView = nil
      self.dimmingView = nil
    }
  }
  
  // MARK: - Layout
  
  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    super.preferredContentSizeDidChange(forChildContentContainer: container)
    if container === presentedViewController {
      containerView?.setNeedsLayout()
    }
  }
  
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    if container === presentedViewController {
      return (container as! UIViewController).preferredContentSize
    } else {
      return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerViewBounds = containerView?.bounds else { return .zero }
    let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    
//    var presentedViewControllerFrame = containerViewBounds
//    presentedViewControllerFrame.size.height = presentedViewContentSize.height
//    presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
    
    var presentedViewControllerFrame = CGRect(origin: .zero, size: presentedViewContentSize)
    let x = (containerViewBounds.maxX - presentedViewContentSize.width) / 2
    var y: CGFloat = 0
    switch configuration.layout {
    case .top(let inset):
      y = inset
    case .bottom(let inset):
      y = containerViewBounds.maxY - presentedViewContentSize.height - inset
    case .center(let offset):
      y = (containerViewBounds.maxY - presentedViewContentSize.height) / 2 + offset
    }
    presentedViewControllerFrame.origin = CGPoint(x: x, y: y)
    return presentedViewControllerFrame
  }
  
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    dimmingView?.frame = containerView?.bounds ?? .zero
    presentationWrappingView.frame = frameOfPresentedViewInContainerView
  }
  
  // MARK: - Tap Gesture Recognizer
  
  @objc func dimmingViewTapped(sender: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CustomPresentationController: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    guard let isAnimated = transitionContext?.isAnimated else { return 0 }
    return isAnimated ? configuration.duration : 0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
    
    let containerView = transitionContext.containerView
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    let toView = transitionContext.view(forKey: .to)
    // If NO is returned from -shouldRemovePresentersView, the view associated
    // with UITransitionContextFromViewKey is nil during presentation.  This
    // intended to be a hint that your animator should NOT be manipulating the
    // presenting view controller's view.  For a dismissal, the -presentedView
    // is returned.
    //
    // Why not allow the animator manipulate the presenting view controller's
    // view at all times?  First of all, if the presenting view controller's
    // view is going to stay visible after the animation finishes during the
    // whole presentation life cycle there is no need to animate it at all — it
    // just stays where it is.  Second, if the ownership for that view
    // controller is transferred to the presentation controller, the
    // presentation controller will most likely not know how to layout that
    // view controller's view when needed, for example when the orientation
    // changes, but the original owner of the presenting view controller does.
    let fromView = transitionContext.view(forKey: .from)
    
    let isPresenting = fromViewController == presentingViewController
    
    // This will be the current frame of fromViewController.view.
    let fromViewInitialFrame = transitionContext.initialFrame(for: fromViewController)
    // For a presentation which removes the presenter's view, this will be
    // CGRectZero.  Otherwise, the current frame of fromViewController.view.
    var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
    // This will be CGRectZero.
    var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
    // For a presentation, this will be the value returned from the
    // presentation controller's -frameOfPresentedViewInContainerView method.
    let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation (will have no effect on dismissal because the
    // presenting view controller's view was not removed).
    if let toView = toView {
      containerView.addSubview(toView)
    }
    
    if isPresenting {
      // animation start position
//      toViewInitialFrame.origin = CGPoint(x: containerView.bounds.minX, y: containerView.bounds.maxY)
      
      var toViewInitialOrigin = CGPoint.zero
      let originX = toViewFinalFrame.origin.x
      switch configuration.popupStyle {
      case .top(let extent):
        var y = -toViewFinalFrame.size.height
        if let extent {
          y = toViewFinalFrame.origin.y - extent
        }
        toViewInitialOrigin = CGPoint(x: originX, y: y)
      case .bottom(let extent):
        var y = containerView.bounds.maxY
        if let extent {
          y = toViewFinalFrame.origin.y + extent
        }
        toViewInitialOrigin = CGPoint(x: originX, y: y)
      case .center:
        toViewInitialOrigin = CGPoint(x: originX, y: toViewFinalFrame.origin.y)
      }
      toViewInitialFrame.origin = toViewInitialOrigin
      toViewInitialFrame.size = toViewFinalFrame.size
      toView?.frame = toViewInitialFrame
    } else {
      // Because our presentation wraps the presented view controller's view
      // in an intermediate view hierarchy, it is more accurate to rely
      // on the current frame of fromView than fromViewInitialFrame as the
      // initial frame (though in this example they will be the same).
      var offsetY: CGFloat = 0
      switch configuration.popupStyle {
      case .top(let extent):
        offsetY = (extent != nil) ? -extent! : -(fromViewInitialFrame.origin.y + fromViewInitialFrame.size.height)
      case .bottom(let extent):
        offsetY = (extent != nil) ? extent! : (containerView.bounds.maxY - fromViewInitialFrame.origin.y)
      case .center:
        offsetY = 0
      }
      fromViewFinalFrame = (fromView?.frame ?? .zero).offsetBy(dx: 0, dy: offsetY)
    }
    
    let transitionDuration = transitionDuration(using: transitionContext)
    
    toView?.alpha = 0.0
    UIView.animate(
      withDuration: transitionDuration,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: .curveEaseOut
    ) {
      if isPresenting {
        toView?.alpha = 1.0
        toView?.frame = toViewFinalFrame
      } else {
        fromView?.alpha = 0.0
        fromView?.frame = fromViewFinalFrame
      }
    } completion: { finished in
      let wasCancelled = transitionContext.transitionWasCancelled
      transitionContext.completeTransition(!wasCancelled)
    }
  }
  
}

// MARK: - UIViewControllerTransitionDelegate

extension CustomPresentationController: UIViewControllerTransitioningDelegate {
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    assert(presentedViewController == presented, "You didn't initialize \(self) with the correct presentedViewController.  Expected \(presented), got \(presentedViewController).")
    return self
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
  
}

//
//  RoundedButton.swift
//  CompanyManager
//
//  Created by Bartek on 08.04.2017.
//  Copyright © 2017 zabicki. All rights reserved.
//

import UIKit

/**
 Creates rounded button with animatable borders and marks in the middle of it.
 It draw failure and success marks.
 - Designable
 - Inspectable
 */
@IBDesignable public class RoundedButton: UIButton {
  
  // MARK: - Enums
  
  public enum Response {
    case success
    case failure
  }
  
  // MARK: - Properties
  
  
  override public var borderWidth: CGFloat {
    get {
      return 1
    } set {}
  }
  ///The color inside button
  @IBInspectable public var innerBackgroundColor: UIColor = .white
  @IBInspectable public var successColor: UIColor = #colorLiteral(red: 0.2899999917, green: 0.949000001, blue: 0.6309999824, alpha: 1)
  @IBInspectable public var failureColor: UIColor = #colorLiteral(red: 1, green: 0.200000003, blue: 0.4709999859, alpha: 1)
  @IBInspectable public var shouldLoadAfterSelected: Bool = true
  override public var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  private var _borderColor: UIColor? = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)
  override public var borderColor: UIColor? {
    get {
      return _borderColor
    } set {
      maskLayer.strokeColor = newValue?.cgColor
      setTitleColor(newValue, for: .normal)
      _borderColor = newValue
    }
  }
  
  override public var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.1) {
        self.backgroundColor = self.isHighlighted ? self.borderColor : self.innerBackgroundColor
      }
    }
  }
  
  override public var intrinsicContentSize: CGSize {
    return CGSize(width: 120, height: 40)
  }
  
  private var activityIndicator: UIActivityIndicatorView!
  private let kRotationAnimationKey = "rotationAnimation"
  private let kSpinningAnimationKey = "spinningAnimation"
  private var borderLayer: CAShapeLayer?
  private lazy var animatedCircleLayer: CAShapeLayer = {
    var layer = CAShapeLayer()
    layer.strokeColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)
    layer.fillColor = nil
    layer.lineWidth = 1
    return layer
  }()
  private lazy var staticArcLayer: CAShapeLayer = {
    var layer = CAShapeLayer()
    layer.strokeColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)
    layer.fillColor = nil
    layer.lineWidth = 1
    return layer
  }()
  private lazy var markLayer: CAShapeLayer = {
    var layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.fillColor = nil
    return layer
  }()
  private lazy var maskLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = borderColor?.cgColor
    layer.fillColor = nil
    layer.lineWidth = 1.0
    layer.lineJoin = .bevel
    return layer
  }()
  private var arcRadius: CGFloat {
    return bounds.width < bounds.height ? bounds.width/2 : bounds.height/2
  }
  private var arcCenter: CGPoint {
    return CGPoint(x: bounds.width/2, y: bounds.height/2)
  }
  private var response: Response?
  private var responseCompletion: (() -> Void)?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override public func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  // MARK: - Actions
  
  @objc private func touchUpInside(sender: RoundedButton) {
    guard shouldLoadAfterSelected else {
      return
    }
    animate()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    animatedCircleLayer.frame = bounds
    staticArcLayer.frame = bounds
    markLayer.frame = bounds
    reloadBorderLayerPath()
  }
  
  // MARK: - Public function
  
  ///Handle response and draw mark in the middle
  public func handleResponse(with response: Response, completion: (() -> Void)? = nil) {
    guard !isEnabled else {
      self.response = response
      responseCompletion = completion
      return
    }
    animatedCircleLayer.strokeColor = response == .success ? successColor.cgColor : failureColor.cgColor
    staticArcLayer.strokeColor = response == .success ? successColor.cgColor : failureColor.cgColor
    staticArcLayer.removeAllAnimations()
    staticArcLayer.removeFromSuperlayer()
    
    animatedCircleLayer.removeAllAnimations()
    
    let finalPathAnimation = basicAnimation(withKeyPath: "strokeEnd", delay: 0, duration: 0.4,
                                        startValue: 0, endValue: 1)
    animatedCircleLayer.add(finalPathAnimation, forKey: "circleAnimation")
    
    markLayer.path = response == .success ? succesMarkPath() : failureMarkPath()
    markLayer.strokeColor = response == .success ? successColor.cgColor : failureColor.cgColor
    
    animatedCircleLayer.fillColor = response == .success ?
      successColor.withAlphaComponent(0.05).cgColor : failureColor.withAlphaComponent(0.05).cgColor
    
    layer.addSublayer(markLayer)
    
    let pathAnimation = basicAnimation(withKeyPath: "strokeEnd", delay: 0, duration: 0.3,
                                       startValue: 0, endValue: 1)
    markLayer.add(pathAnimation, forKey: "markAnimation")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
      completion?() ?? self.responseCompletion?()
      self.restoreStartState()
    })
  }
  
  /// Starts animation, hides the title
  public func animate() {
    isEnabled = false
    animateBorder()
  }
  
  public func restoreStartState() {
    animatedCircleLayer.removeFromSuperlayer()
    staticArcLayer.removeFromSuperlayer()
    markLayer.removeFromSuperlayer()
    animatedCircleLayer.fillColor = nil
    staticArcLayer.strokeColor = borderColor?.cgColor
    
    UIView.animate(withDuration: 0.7, delay: 0, options: .allowAnimatedContent, animations: {
      self.borderLayer?.strokeColor = self.borderLayer?.strokeColor?.copy(alpha: 0)
    }, completion: { _ in
      self.borderLayer?.removeFromSuperlayer()
      self.isEnabled = true
    })
  }
  
  // MARK: - Private Functions
  
  private func setup() {
    cornerRadius = frame.height/2
    tintColor = .clear
    setTitleColor(.white, for: .highlighted)
    setTitleColor(borderColor, for: .normal)
    setTitleColor(.clear, for: .disabled)
    #if !TARGET_INTERFACE_BUILDER
    addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    #endif
    addBorderLayer()
  }
  
  ///Simple skeleton to the animation
  private func basicAnimation(withKeyPath keyPath: String, delay: Double, duration: Double,
                              startValue: Double, endValue: Double,
                              timing: CAMediaTimingFunction =
    CAMediaTimingFunction(name: .easeInEaseOut)) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: keyPath)
    animation.beginTime = delay
    animation.duration = duration
    animation.fromValue = startValue
    animation.toValue = endValue
    animation.timingFunction = timing
    return animation
  }
  
  ///Add border around the button with the color, which depends on that if button is highlighted or not
  private func addBorderLayer() {
    reloadBorderLayerPath()
    layer.addSublayer(maskLayer)
  }
  
  private func reloadBorderLayerPath() {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners,
                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    maskLayer.frame = bounds
    maskLayer.path = path.cgPath
  }
  
  private func createPath(withOrigin origin: CGPoint, size: CGSize, cornerRadius: CGFloat) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: origin)
    path.addLine(to: CGPoint(x: size.width - cornerRadius, y: 0))
    path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: cornerRadius),
                radius: cornerRadius, startAngle: 270.asRadian(), endAngle: 0.asRadian(), clockwise: true)
    path.addLine(to: CGPoint(x: size.width, y: cornerRadius))
    path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius),
                radius: cornerRadius, startAngle: 0.asRadian(), endAngle: 90.asRadian(), clockwise: true)
    path.addLine(to: CGPoint(x: cornerRadius, y: size.height))
    path.addArc(withCenter: CGPoint(x: cornerRadius, y: size.height - cornerRadius),
                radius: cornerRadius, startAngle: 90.asRadian(), endAngle: 180.asRadian(), clockwise: true)
    path.addLine(to: CGPoint(x: 0, y: cornerRadius))
    path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                radius: cornerRadius, startAngle: 180.asRadian(), endAngle: 270.asRadian(), clockwise: true)
    path.addLine(to: origin)
    return path
  }
  
  /**
   Draw another border around the button with the background color, so
   there is illusion of the hiding border
   */
  private func animateBorder() {
    let path = createPath(withOrigin: CGPoint(x: bounds.width/2, y: 0),
                          size: CGSize(width: bounds.width, height: bounds.height), cornerRadius: cornerRadius)
    
    borderLayer = CAShapeLayer()
    guard let borderLayer = borderLayer else {
      return
    }
    borderLayer.frame = bounds
    borderLayer.path = path.cgPath
    borderLayer.strokeColor = innerBackgroundColor.cgColor
    borderLayer.fillColor = nil
    borderLayer.lineWidth = 3
    borderLayer.lineJoin = .bevel
    layer.addSublayer(borderLayer)
    
    CATransaction.begin()
    let pathAnimation = basicAnimation(withKeyPath: "strokeEnd", delay: 0, duration: 1, startValue: 0, endValue: 1)
    CATransaction.setCompletionBlock {
      self.drawCircle(withDuration: 1.5)
    }
    borderLayer.add(pathAnimation, forKey: "buttonBorderAnimation")
    CATransaction.commit()
  }
  
  private func drawCircle(withDuration duration: Double) {
    
    let path = UIBezierPath()
    let arcAngles = [270, 0, 90, 180, 270]
    for index in 0...3 {
      path.addArc(withCenter: arcCenter, radius: arcRadius, startAngle: arcAngles[index].asRadian(),
                  endAngle: arcAngles[index + 1].asRadian(), clockwise: true)
    }
    
    animatedCircleLayer.frame = bounds
    animatedCircleLayer.path = path.cgPath
    animatedCircleLayer.fillColor = nil
    animatedCircleLayer.strokeColor = borderColor?.cgColor
    
    //Static arc of 30 angle create illusion of not ending circle
    let staticArcPath = UIBezierPath()
    staticArcPath.addArc(withCenter: arcCenter, radius: arcRadius,
                         startAngle: 255.asRadian(), endAngle: 275.asRadian(), clockwise: true)
    
    staticArcLayer.frame = bounds
    staticArcLayer.path = staticArcPath.cgPath
    
    layer.addSublayer(staticArcLayer)
    layer.addSublayer(animatedCircleLayer)
    
    addSpinningCircleAnimation(withDuration: duration)
  }
  
}

extension RoundedButton {
  
  private func addSpinningCircleAnimation(withDuration duration: Double) {
    let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    let headAnimation = basicAnimation(withKeyPath: "strokeStart", delay: 0,
                                       duration: duration / 1.5, startValue: 0, endValue: 0.25)
    let tailAnimation = basicAnimation(withKeyPath: "strokeEnd", delay: 0,
                                       duration: duration / 1.5, startValue: 0, endValue: 1)
    let endHeadAnimation = basicAnimation(withKeyPath: "strokeStart", delay: duration / 1.5,
                                          duration: duration / 3, startValue: 0.25, endValue: 1)
    let endTailAnimation = basicAnimation(withKeyPath: "strokeEnd", delay: duration / 1.5,
                                          duration: duration / 3, startValue: 1, endValue: 1)
    
    let spinningAnimation = CAAnimationGroup()
    spinningAnimation.duration = duration
    spinningAnimation.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
    spinningAnimation.repeatCount = Float.infinity
    spinningAnimation.isRemovedOnCompletion = false
    spinningAnimation.fillMode = .forwards
    animatedCircleLayer.add(spinningAnimation, forKey: kSpinningAnimationKey)
    
    let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    
    rotationAnimation.keyTimes = [0, 0.5, 1]
    rotationAnimation.values = [0, CGFloat.pi, 2 * CGFloat.pi]
    rotationAnimation.duration = duration
    rotationAnimation.timingFunctions = [timingFunction]
    rotationAnimation.isRemovedOnCompletion = false
    rotationAnimation.repeatCount = Float.infinity
    staticArcLayer.add(rotationAnimation, forKey: kRotationAnimationKey)
  }
  
  private func succesMarkPath() -> CGPath {
    UIGraphicsBeginImageContext(frame.size)
    UIGraphicsGetCurrentContext()
    var center = arcCenter
    center.y += arcRadius/4
    center.x -= arcRadius/9
    
    let line = UIBezierPath()
    line.move(to: CGPoint(x: center.x  + arcRadius/3 * cos(225.asRadian()),
                          y: center.y + arcRadius/3 * sin(225.asRadian())))
    line.addLine(to: center)
    line.addLine(to: CGPoint(x: center.x  + arcRadius/3*2 * cos(310.asRadian()),
                             y: center.y + arcRadius/3*2 * sin(310.asRadian())))
    line.stroke()
    line.fill()
    UIGraphicsEndImageContext()
    return line.cgPath
  }
  
  private func failureMarkPath() -> CGPath {
    UIGraphicsBeginImageContext(frame.size)
    UIGraphicsGetCurrentContext()
    let line = UIBezierPath()
    line.move(to: CGPoint(x: arcCenter.x  + arcRadius/3 * cos(225.asRadian()),
                          y: arcCenter.y + arcRadius/3 * sin(225.asRadian())))
    line.addLine(to: CGPoint(x: arcCenter.x  + arcRadius/3 * cos(45.asRadian()),
                             y: arcCenter.y + arcRadius/3 * sin(45.asRadian())))
    line.move(to: CGPoint(x: arcCenter.x  + arcRadius/3 * cos(315.asRadian()),
                          y: arcCenter.y + arcRadius/3 * sin(315.asRadian())))
    line.addLine(to: CGPoint(x: arcCenter.x  + arcRadius/3 * cos(135.asRadian()),
                             y: arcCenter.y + arcRadius/3 * sin(135.asRadian())))
    line.stroke()
    line.fill()
    UIGraphicsEndImageContext()
    return line.cgPath
  }
  
}

//
//  FloatTextField.swift
//  CompanyManager
//
//  Created by Bartek on 28.04.2017.
//  Copyright © 2017 zabicki. All rights reserved.
//

import UIKit

/**
 Textfield which can handle correct or bad input and then display message do the
 user below.
 - Designable
 - Inspectable
 */
@IBDesignable public class FloatTextField: UITextField {
  
  // MARK: - Properties
  
  @IBInspectable var maxCharactersCount: Int = 0
  @IBInspectable var isDeleteMarkEnabled: Bool = true
  @IBInspectable var titleColor: UIColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)
  @IBInspectable var errorColor: UIColor = #colorLiteral(red: 1, green: 0.200000003, blue: 0.4709999859, alpha: 1)
  @IBInspectable var successColor: UIColor = #colorLiteral(red: 0.2899999917, green: 0.949000001, blue: 0.6309999824, alpha: 1)
  @IBInspectable var underlineColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5) {
    didSet {
      bottomBorderView?.backgroundColor = underlineColor
    }
  }
  
  private var bottomBorderView: UIView?
  private var titleLabel: UILabel?
  private var titleFontSize: CGFloat = 12
  private var errorLabel: UILabel?
  private let kFadeDuration = 0.2
  private let kDrawDuration = 0.1
  private var deleteMark: UIButton?
  private var markLayer: CAShapeLayer?
  var errorMessage: String? {
    return errorLabel?.text
  }
  
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
  
  // MARK: - Overrides
  
  override public func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsets(top: UIFont.systemFont(ofSize: titleFontSize).lineHeight + 4, left: 0,
                                              bottom: UIFont.systemFont(ofSize: titleFontSize).lineHeight + 3,
                                              right: isDeleteMarkEnabled ? 20 : 0))
  }
  
  override public func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds,
                                 UIEdgeInsets(top: UIFont.systemFont(ofSize: titleFontSize).lineHeight + 4, left: 0,
                                              bottom: UIFont.systemFont(ofSize: titleFontSize).lineHeight + 3,
                                              right: isDeleteMarkEnabled ? 20 : 0))
  }
  
  // MARK: - Actions
  
  @objc private func didChangeText() {
    guard let text = text else {
      hideTitle()
      return
    }
    text.isEmpty ? hideTitle() : showTitle()
    guard maxCharactersCount != 0, text.composedCharacterCount > maxCharactersCount else {
      return
    }
    let endIndex = text.index(before: text.endIndex)
    self.text = String(text[..<endIndex])
  }
  
  @objc func clearText() {
    text = nil
    didChangeText()
  }
  
  // MARK: - Functions
  
  public func success() {
    bottomBorderView?.backgroundColor = successColor.withAlphaComponent(0.5)
    hideErrorLabel()
  }
  
  public func failure(error: String) {
    bottomBorderView?.backgroundColor = errorColor.withAlphaComponent(0.5)
    showErrorLabel(with: error)
  }
  
  // MARK: - Private Functions
  
  private func setup() {
    borderStyle = .none
    bottomBorderView = UIView()
    bottomBorderView!.backgroundColor = underlineColor
    addSubview(bottomBorderView!)
    bottomBorderView?.translatesAutoresizingMaskIntoConstraints = false
    bottomBorderView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    bottomBorderView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    bottomBorderView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant:
      -UIFont.systemFont(ofSize: titleFontSize).lineHeight).isActive = true
    bottomBorderView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
    createDeleteMark()
    createTitle()
    createErrorLabel()
    addObservers()
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(didChangeText),
                                           name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
  }
  
  private func showTitle() {
    guard let title = titleLabel else {
      createTitle()
      return
    }
    guard title.alpha == 0 else { return }
    showDeleteMark()
    UIView.animate(withDuration: kFadeDuration) {
      title.alpha = 1
    }
  }
  
  private func hideTitle() {
    guard let title = titleLabel else {
      createTitle()
      return
    }
    guard title.alpha == 1 else { return }
    hideDeleteMark()
    if (text ?? "").isEmpty {
      bottomBorderView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    UIView.animate(withDuration: kFadeDuration) {
      title.alpha = 0
    }
  }
  
  private func createTitle() {
    guard titleLabel == nil else {
      titleLabel?.frame.size.width = frame.width
      return
    }
    titleLabel = UILabel()
    titleLabel?.text = placeholder
    titleLabel?.font = titleLabel?.font.withSize(titleFontSize)
    titleLabel?.textColor = titleColor
    titleLabel?.alpha = 0
    titleLabel?.sizeToFit()
    titleLabel?.frame.size.width = frame.width
    addSubview(titleLabel!)
    titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    titleLabel?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel?.topAnchor.constraint(equalTo: topAnchor).isActive = true
    if !(text ?? "").isEmpty {
      showTitle()
    }
  }
  
  private func createErrorLabel() {
    guard errorLabel == nil else {
      errorLabel?.frame.size.width = frame.width
      return
    }
    errorLabel = UILabel()
    errorLabel?.font = errorLabel?.font.withSize(titleFontSize)
    errorLabel?.textColor = errorColor
    errorLabel?.alpha = 0
    errorLabel?.sizeToFit()
    errorLabel?.frame.size.width = frame.width
    errorLabel?.frame.origin.y = frame.height - errorLabel!.font.lineHeight
    addSubview(errorLabel!)
    errorLabel?.translatesAutoresizingMaskIntoConstraints = false
    errorLabel?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    errorLabel?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    errorLabel?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  private func showErrorLabel(with error: String) {
    guard let errorLabel = errorLabel else {
      createErrorLabel()
      return
    }
    errorLabel.text = error
    errorLabel.sizeToFit()
    UIView.animate(withDuration: kFadeDuration) {
      errorLabel.alpha = 1
    }
  }
  
  private func hideErrorLabel() {
    guard let errorLabel = errorLabel else {
      createErrorLabel()
      return
    }
    UIView.animate(withDuration: kFadeDuration, animations: {
      errorLabel.alpha = 0
    }, completion: { _ in
      errorLabel.text = ""
    })
  }
  
  private func createDeleteMark() {
    deleteMark = UIButton()
    guard let deleteMark = deleteMark else { return }
    deleteMark.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    addSubview(deleteMark)
    deleteMark.translatesAutoresizingMaskIntoConstraints = false
    deleteMark.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    deleteMark.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    deleteMark.heightAnchor.constraint(equalToConstant: 20).isActive = true
    deleteMark.widthAnchor.constraint(equalToConstant: 20).isActive = true
    layoutIfNeeded()
    
    markLayer = CAShapeLayer()
    markLayer?.path = deleteMarkPath()
    markLayer?.strokeColor = titleColor.cgColor
    markLayer?.lineWidth = 1
    markLayer?.frame = deleteMark.bounds
    markLayer?.frame.origin = CGPoint.zero
    hideDeleteMark()
    deleteMark.layer.addSublayer(markLayer!)
  }
  
}

// MARK: - Delete Mark Animations

extension FloatTextField {
  
  private func showDeleteMark() {
    guard isDeleteMarkEnabled else { return }
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = kDrawDuration
    animation.fromValue = markLayer!.presentation()?.strokeEnd
    animation.toValue = 1
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    markLayer?.strokeEnd = 1
    markLayer?.removeAllAnimations()
    markLayer?.add(animation, forKey: "showMarkAnimation")
  }
  
  private func hideDeleteMark() {
    guard isDeleteMarkEnabled else { return }
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = kDrawDuration
    animation.fromValue = markLayer!.presentation()?.strokeEnd
    animation.toValue = 0
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    markLayer?.strokeEnd = 0
    markLayer?.removeAllAnimations()
    markLayer?.add(animation, forKey: "hideMarkAnimation")
  }
  
  private func deleteMarkPath() -> CGPath? {
    guard let deleteMark = deleteMark else { return nil }
    let center = CGPoint(x: deleteMark.frame.width/2, y: deleteMark.frame.height/2)
    let radius = deleteMark.frame.width/4
    UIGraphicsBeginImageContext(deleteMark.frame.size)
    UIGraphicsGetCurrentContext()
    let line = UIBezierPath()
    line.move(to: CGPoint(x: center.x  + radius * cos(315.asRadian()), y: center.y + radius * sin(315.asRadian())))
    line.addLine(to: CGPoint(x: center.x  + radius * cos(135.asRadian()),
                             y: center.y + radius * sin(135.asRadian())))
    line.move(to: CGPoint(x: center.x  + radius * cos(45.asRadian()), y: center.y + radius * sin(45.asRadian())))
    line.addLine(to: CGPoint(x: center.x  + radius * cos(225.asRadian()),
                             y: center.y + radius * sin(225.asRadian())))
    line.stroke()
    line.fill()
    UIGraphicsEndImageContext()
    return line.cgPath
  }
  
}

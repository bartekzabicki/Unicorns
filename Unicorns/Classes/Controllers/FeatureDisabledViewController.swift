//
//  FeatureDisabledViewController.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//

import UIKit

/// A controller with message that this feature is not yet available

class FeatureDisabledViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    let label = UILabel()
    label.font = UIFont(name: "Avenir-Medium", size: 16)
    label.text = "feature_not_yet_available".localized
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    view.addSubview(label)
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
}

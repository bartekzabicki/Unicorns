//
//  UITableViewExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 06.08.2018.
//

import Foundation

extension UITableView {
    
    public func register<T:ReuseIdentifying>(reuseIdentifying: T.Type) {
        let nibName = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nibName, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
}

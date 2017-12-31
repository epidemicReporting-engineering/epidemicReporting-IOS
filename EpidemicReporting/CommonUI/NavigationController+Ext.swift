//
//  ERNavigationController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func setStyledNavigationBar() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.init(hexString: themeBlue)
        }
        
        navigationBar.barTintColor = UIColor.init(hexString: themeBlue)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationBar.tintColor = UIColor.white
        navigationBar.backItem?.title = ""
    }
    
    func setBackItem() {
        
    }
}

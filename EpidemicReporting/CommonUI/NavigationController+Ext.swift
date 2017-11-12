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
        navigationBar.barTintColor = UIColor.init(hexString: themeBlue)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}

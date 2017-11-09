//
//  LoginViewProtocol.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/9.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewProtocol: class {
    
    //Presenter->View
    func showLoading()
    
    func hideLoading()
    
    func showError()
}

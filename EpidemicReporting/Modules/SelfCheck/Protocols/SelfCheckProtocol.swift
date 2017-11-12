//
//  SelfCheckProtocol.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation

protocol SelfCheckViewProtcol: class {
    
    //Presenter->View
    func showCheckSuccess()
    
    func showCheckError()
}



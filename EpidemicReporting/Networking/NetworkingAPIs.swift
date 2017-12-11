//
//  NetworkingAPIs.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Networking {
    
    func userLogin(_ username: String?, password: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.UserLogin.rawValue, httpMethod: .post, httpHeaders: initialHeaders(), params: ["username": username,"password": password],handler: handler)
    }
}

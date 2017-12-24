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
        _ = syncWithAppServer(WebServiceAPIMapping.UserLogin.rawValue, httpMethod: .post, httpHeaders: loginHeaders(), params: ["username": username,"password": password],handler: handler)
    }
    
    func getProfile(_ username: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetProfile.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["username": username], params: nil,  handler: handler)
    }
    
    func changePassword(_ username: String?, oldPassword: String?, newPassword: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.PasswordChange.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["username": username,"oldPassword": oldPassword,"newPassword": newPassword], handler: handler)
    }
    
    func reportMessage(_ reporter: String?, location: String?, latitude: String?, longitude: String?, description: String?, multimedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyReport.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["reporter": reporter,"location": location,"latitude": latitude,"longitude": longitude, "description": description, "multimedia": multimedia], handler: handler)
    }

}

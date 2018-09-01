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
    
    func checkIn(_ username: String?, latitude: String?, longitude: String?, location: String?, isAbsence: Bool?, isAvailable: Bool?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.CheckIn.rawValue, httpMethod: .post, httpHeaders: getHeaders(), urlParams: nil, params: ["username": username,"latitude": latitude,"longitude": longitude,"location": location,"isAbsence": isAbsence,"isAvailable": isAvailable],  handler: handler)
    }
    
    func getMyCheckIn(handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetCheckedNum.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, params: nil,  handler: handler)
    }
    
    func changePassword(_ username: String?, oldPassword: String?, newPassword: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.PasswordChange.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["username": username,"oldPassword": oldPassword,"newPassword": newPassword], handler: handler)
    }
    
    func reportMessage(_ reporter: String?, location: String?, latitude: String?, longitude: String?, description: String?, multimedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyReport.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["reporter": reporter,"location": location,"latitude": latitude,"longitude": longitude, "description": description, "multimedia": multimedia], handler: handler)
    }
    
    func reportAssign(_ dutyId: String?, dutyOwner: String?, dutyDescription: String?, dutyStatus: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyAssign.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"dutyOwner": dutyOwner,"dutyDescription": dutyDescription,"dutyStatus": dutyStatus], handler: handler)
    }
    
    func reportProcess(_ dutyId: String?, dutyOwner: String?, dutyDescription: String?, dutyStatus: String?, dutyMultiMedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyProcess.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"dutyOwner": dutyOwner,"dutyDescription": dutyDescription,"dutyStatus": dutyStatus, "dutyMultiMedia": dutyMultiMedia], handler: handler)
    }
    
    func reportConfirm(_ dutyId: String?, dutyOwner: String?, dutyDescription: String?, dutyStatus: String?, dutyMultiMedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyConfirm.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"dutyOwner": dutyOwner,"dutyDescription": dutyDescription,"dutyStatus": dutyStatus, "dutyMultiMedia": dutyMultiMedia], handler: handler)
    }
    
    func getReportAllStatus(_ dutyId: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyAllStatus.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["id": dutyId], handler: handler)
    }
    
    func getAllReports(_ action: String?, filter: String?, param: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyAllReports.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["action": action, "filter": filter, "param": param], handler: handler)
    }
    
    func getStuff(handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.GetStuff.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, handler: handler)
    }
}

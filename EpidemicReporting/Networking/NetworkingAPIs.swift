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
        _ = syncWithAppServer(WebServiceAPIMapping.CheckIn.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, params: nil,  handler: handler)
    }
    
    func getMyCheckInMoth(month: String, year: String, user: String,handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.CheckIn.rawValue, pathTail: "/\(user)", httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["year": year, "month": month], params: nil,  handler: handler)
    }
    
    func changePassword(_ username: String?, oldPassword: String?, newPassword: String?, handler:@escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.PasswordChange.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["username": username,"oldPassword": oldPassword,"newPassword": newPassword], handler: handler)
    }
    
    func reportMessage(_ reporter: String?, location: String?, latitude: String?, longitude: String?, description: String?, multimedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyReport.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["reporter": reporter,"location": location,"latitude": latitude,"longitude": longitude, "description": description, "multimedia": multimedia], handler: handler)
    }
    
    func reportDuty(data: DutyReportDataModel, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        var patients = [[String: Any]]()
        for patient in data.pataints {
            patients.append([
                "name": patient.name,
                "sex": patient.sex,
                "age": patient.age,
                "career": patient.career,
                "symptom": patient.symptom,
                "fabing": patient.fabing,
                "treatment": patient.treatment
                ])
        }
        
        let params: [String: Any] = [
            "location": data.location,
            "latitude": data.latitude,
            "longitude": data.longitude,
            "multiMedia": data.multiMedia,
            "description": data.description,
            "happenTime": data.happenTime,
            "company": data.company,
            "department": data.department,
            "reportTime": Int64(data.reportTime) ?? 0,
            "patients": patients
        ]
        
        _ = syncWithAppServer(WebServiceAPIMapping.DutyReport.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: params, handler: handler)
    }
    
    func reportAssign(_ dutyId: String?, dutyOwner: String?, dutyDescription: String?, dutyStatus: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyAssign.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"dutyOwner": dutyOwner,"dutyDescription": dutyDescription,"dutyStatus": dutyStatus], handler: handler)
    }
    
    func reportProcess(_ dutyId: String?, dutyDescription: String?, dutyStatus: String?, dutyMultiMedia: [String]?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyProcess.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"dutyDescription": dutyDescription,"dutyStatus": dutyStatus, "dutyMultiMedia": dutyMultiMedia], handler: handler)
    }
    
    func reportConfirm(_ dutyId: String?, leaderPoint: String?, leaderComment: String?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyConfirm.rawValue, httpMethod: .post, httpHeaders: getHeaders(), params: ["dutyId": dutyId,"leaderPoint": leaderPoint, "leaderComment": leaderComment], handler: handler)
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
    func getAvailableStuff(handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.getAvailableStuff.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: nil, handler: handler)
    }
    
    func dutyQuery(_ reporter: String?, userName: String? = nil, state: String? = nil, page: String? = nil, size: String? = nil, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) {
        _ = syncWithAppServer(WebServiceAPIMapping.DutyQuery.rawValue, httpMethod: .get, httpHeaders: getHeaders(), urlParams: ["reporter": reporter, "username": userName, "state": state, "page": page, "size": size], handler: handler)
    }
    
}

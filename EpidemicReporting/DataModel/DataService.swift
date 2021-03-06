//
//  OPDataService.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import CoreData
import Sync
import SwiftyJSON

class DataService: NSObject {
    
    static var sharedInstance: DataService {
        
        struct Static {
            static let instance: DataService = DataService()
        }
        return Static.instance
    }
    
    func userLogin(_ username: String?, pwd: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userLogin(username, password: pwd) { [weak self] (success, json, error) in
            if success {
                guard let token = json?["token"].string, let refreshToken = json?["refreshToken"].string else { handler(false, nil)
                    return }
                if token != "" {
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.synchronize()
                    
                    self?.getProfile(username, access: token, refresh: refreshToken,  handler: {(success, error) in
                        if success {
                            handler(true,nil)
                        } else {
                            handler(false, error)
                        }
                    })
                } else {
                    handler(false, nil)
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func getMyCheckIn(handler: @escaping ((_ success:Bool, _ error:NSError?, _ data: JSON?)->())) {
        let clander = Calendar(identifier: .gregorian)
        let comps = clander.dateComponents([.year, .month], from: Date())
        guard let username = appDelegate.currentUser?.username, let month = comps.month, let year = comps.year else {
            handler(false, nil, nil)
            return
        }
        
        Networking.shareInstance.getMyCheckInMoth(month: "\(month)", year: "\(year)", user: username) { (success, json, error) in
            handler(success, error, success ? json : nil)
        }
        
//        Networking.shareInstance.getMyCheckIn { (success, json, error) in
//            if success {
//                guard let data = json?["data"].arrayObject as? [[String : Any]] else { handler(false, nil)
//                    return }
//                Sync.changes(data, inEntityNamed: "Check", dataStack: appDelegate.dataStack, operations: [.insert, .update,.delete], completion: { (error) in
//                    if error == nil {
//                        handler(true, nil)
//                    } else {
//                        handler(false, error)
//                    }
//                })
//                handler(true, nil)
//            } else {
//                handler(false, error)
//            }
//        }
    }
    
    func getDayChekInNumberJSON(handler: @escaping ((_ success:Bool, _ json: JSON?, _ error:NSError?)->())) {
        Networking.shareInstance.getMyCheckIn { (success, json, error) in
            print(json)
            if success {
                handler(true, json, nil)
            } else {
                handler(false, nil, error)
            }
        }
    }
    
    func getDayCheckInNumber(handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getMyCheckIn() { (success, json, error) in
            Networking.shareInstance.getMyCheckIn { (success, json, error) in
                if success {
                    guard let data = json?["data"].arrayObject as? [[String : Any]] else { handler(false, nil)
                        return }
                    Sync.changes(data, inEntityNamed: "Check", dataStack: appDelegate.dataStack, operations: [.insert, .update,.delete], completion: { (error) in
                        if error == nil {
                            handler(true, nil)
                        } else {
                            handler(false, error)
                        }
                    })
                    handler(true, nil)
                } else {
                    handler(false, error)
                }
            }
        }
    }
    
//    func getMyCheckIn(user)
    
    func getProfile(_ username: String?, access: String?, refresh: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getProfile(username) { (success, json, error) in
            if success {
                guard let data = json?["data"] else { handler(false, nil)
                    return }
                
                var jsonData:JSON? = JSON()
                jsonData = data
                jsonData?.dictionaryObject?["accessToken"] = access
                jsonData?.dictionaryObject?["refreshToken"] = refresh
                
                guard let storedata = jsonData?.dictionaryObject else { return }
                Sync.changes([storedata], inEntityNamed: "User", dataStack: appDelegate.dataStack, operations: [.insert,.update], completion: { (error) in
                    if error == nil {
                        handler(true, nil)
                    } else {
                        handler(false, error)
                    }
                })
            } else {
                handler(false, error)
            }
        }
    }
    
    func checkIn(_ username: String?, latitude: String?, longitude: String?, location: String?, isAbsence: Bool?, isAvailable: Bool?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.checkIn(username, latitude: latitude, longitude: longitude, location: location, isAbsence: isAbsence, isAvailable: isAvailable) { (success, json, error) in
            if success {
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    

    
    func changePassword(_ username: String?, oldPassword: String?, newPassword: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.changePassword(username, oldPassword: oldPassword, newPassword: newPassword) { (success, json, error) in
            if success {
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func uploadImageToServer(_ uuid: String, uploadImage: UIImage?, handler:@escaping ((_ success:Bool, _ imageUrl: String?, _ error:NSError?, _ uuid: String)->()), progressHandler:@escaping ((_ uuid: String, _ progress: Progress?)->())) {
        Networking.shareInstance.uploadImageToServer(uuid, uploadImage: uploadImage, handler: { (success, json, error) in
            guard let data = json?["data"].dictionaryObject else {
                handler(false, nil, error, uuid)
                return
            }
            if let relative = data["relativePath"] as? String {
                let url = relative
                handler(success, url, nil, uuid)
                return
            }
            handler(false, nil, error, uuid)
        }) { (process) in
            progressHandler(uuid, process)
        }
    }
    
    func uploadVideoToServer(_ uuid: String, _ url: URL?, handler:@escaping ((_ success:Bool, _ videoUrl: String?, _ error:NSError?, _ uuid: String)->()), progressHandler:@escaping ((_ uuid: String, _ progress: Progress?)->())) {
        Networking.shareInstance.uploadVideoToServer(uuid, url, handler: { (success, json, error) in
            guard let data = json?["data"].dictionaryObject else {
                handler(false, nil, error, uuid)
                return
            }
            if let relative = data["relativePath"] as? String {
                let url = relative
                handler(success, url, nil, uuid)
                return
            }
        }) { (process) in
            progressHandler(uuid, process)
        }
    }
    
    func reportMessage(_ reporter: String?, location: String?, latitude: String?, longitude: String?, description: String?, multimedia: [String]?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportMessage(reporter, location: location, latitude: latitude, longitude: longitude, description: description, multimedia: multimedia) { (success, json, error) in
            if success {
                guard let data = json?["data"].dictionaryObject else { handler(false, nil)
                    return }
                Sync.changes([data], inEntityNamed: "DutyReport", dataStack: appDelegate.dataStack, operations: [.insert, .update,], completion: { (error) in
                    if error == nil {
                        handler(true, nil)
                    } else {
                        handler(false, error)
                    }
                })
            } else {
                handler(false, error)
            }
        }
    }
    
    func reportDuty(data: DutyReportDataModel, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportDuty(data: data) { (success, json, error) in
            if success {
                guard let data = json?["data"].dictionaryObject else { handler(false, nil)
                    return }
                Sync.changes([data], inEntityNamed: "DutyReport", dataStack: appDelegate.dataStack, operations: [.insert, .update,], completion: { (error) in
                    if error == nil {
                        handler(true, nil)
                    } else {
                        handler(false, error)
                    }
                })
            } else {
                handler(false, error)
            }
        }
    }
    
    func reportAssign(_ dutyId: String?, dutyOwner: String?, dutyDescription: String?, dutyStatus: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportAssign(dutyId, dutyOwner: dutyOwner, dutyDescription: dutyDescription, dutyStatus: dutyStatus) { (success, json, error) in
            print(json)
            if success {
                //TODO: store the data into DB, data example
                /*
                 {
                 "code" : 0,
                 "data" : {
                 "id" : 100019,
                 "description" : "333",
                 "dutyOwner" : "user001",
                 "leaderPoint" : null,
                 "leaderComment" : null,
                 "dutyDescription" : "注意给病人隔离",
                 "dutyStatus" : "0",
                 "longitude" : "222",
                 "dutyMultiMedia" : null,
                 "latitude" : "111",
                 "reportTime" : 1514182714000,
                 "location" : "Ning Bo",
                 "reporter" : "user001",
                 "dutyOwnerName" : "张三",
                 "processTime" : 1514184160000,
                 "reporterName" : "张三",
                 "multiMedia" : [
                 "111",
                 "222"
                 ]
                 }
                 */
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func reportProcess(_ dutyId: String?, dutyDescription: String?, dutyStatus: String?, dutyMultiMedia: [String]?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportProcess(dutyId, dutyDescription: dutyDescription, dutyStatus: dutyStatus, dutyMultiMedia: dutyMultiMedia) { (success, json, error) in
            if success {
                //TODO: store the data into DB, data example
                /*
                 {
                 "code" : 0,
                 "data" : {
                 "id" : 100019,
                 "description" : "333",
                 "dutyOwner" : "user001",
                 "leaderPoint" : null,
                 "leaderComment" : null,
                 "dutyDescription" : "我要开始处理疫情",
                 "dutyStatus" : "1",
                 "longitude" : "222",
                 "dutyMultiMedia" : null,
                 "latitude" : "111",
                 "reportTime" : 1514182714000,
                 "location" : "Ning Bo",
                 "reporter" : "user001",
                 "dutyOwnerName" : "张三",
                 "processTime" : 1514187434000,
                 "reporterName" : "张三",
                 "multiMedia" : [
                 "111",
                 "222"
                 ]
                 }
                 }
                 
                 //data example: send finish status, get the response
                 {
                 "code" : 0,
                 "data" : {
                 "id" : 100019,
                 "description" : "333",
                 "dutyOwner" : "user001",
                 "leaderPoint" : null,
                 "leaderComment" : null,
                 "dutyDescription" : "结束处理",
                 "dutyStatus" : "3",
                 "longitude" : "222",
                 "dutyMultiMedia" : [
                 "picture 1",
                 "picture 2"
                 ],
                 "latitude" : "111",
                 "reportTime" : 1514182714000,
                 "location" : "Ning Bo",
                 "reporter" : "user001",
                 "dutyOwnerName" : "张三",
                 "processTime" : 1514187954000,
                 "reporterName" : "张三",
                 "multiMedia" : [
                 "111",
                 "222"
                 ]
                 }
                 }
                 
                 */
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func reportConfirm(_ dutyId: String?, leaderPoint: String?, leaderComment: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportConfirm(dutyId, leaderPoint: leaderPoint, leaderComment: leaderComment) { (success, json, error) in
            if success {
                //TODO: store the data into DB, data example
                /*
                 {
                 "code" : 0,
                 "data" : {
                 "id" : 100019,
                 "description" : "333",
                 "dutyOwner" : "user001",
                 "leaderPoint" : null,
                 "leaderComment" : null,
                 "dutyDescription" : "非常好，感谢",
                 "dutyStatus" : "4",
                 "longitude" : "222",
                 "dutyMultiMedia" : [
                 "picture 3",
                 "picture 5"
                 ],
                 "latitude" : "111",
                 "reportTime" : 1514182714000,
                 "location" : "Ning Bo",
                 "reporter" : "user001",
                 "dutyOwnerName" : "张三",
                 "processTime" : 1514188502000,
                 "reporterName" : "张三",
                 "multiMedia" : [
                 "111",
                 "222"
                 ]
                 }
                 }
                 
                 */
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func getReportAllStatus(_ dutyId: String?, handler: @escaping ((_ success:Bool, _ model: [DutyStatusModel]?, _ json: JSON?, _ error:NSError?)->())) {
        Networking.shareInstance.getReportAllStatus(dutyId) { (success, jsonData, error) in
            if success {
                if let data = jsonData?["data"] {
                    let models = DutyStatusDataSource(statusData: data).getDutyStatus()
                    handler(true, models, jsonData, nil)
                } else {
                    handler(false, nil, jsonData, nil)
                }
            } else {
                handler(false, nil, jsonData, error)
            }
        }
    }
    
    func getAllReportsJSON(reporter: String, handler: @escaping ((_ success:Bool, _ json: JSON?, _ error:NSError?)->())) {
        Networking.shareInstance.dutyQuery(reporter) { (success, json, error) in
            if success {
                handler(true, json, error)
            } else {
                handler(false, nil, error)
            }
        }
    }
    
    func getAllReportsJSONByUserName(userName: String, handler: @escaping ((_ success:Bool, _ json: JSON?, _ error:NSError?)->())) {
        Networking.shareInstance.dutyQuery(nil, userName: userName) { (success, json, error) in
            if success {
                handler(true, json, error)
            } else {
                handler(false, nil, error)
            }
        }
    }
    
    func getAllStatusReportsJSON(handler: @escaping ((_ success:Bool, _ json: JSON?, _ error:NSError?)->())) {
        Networking.shareInstance.dutyQuery(nil, userName: nil) { (success, json, error) in
            if success {
                handler(true, json, error)
            } else {
                handler(false, nil, error)
            }
        }
    }
    
    //_ action: String?, filter: String?, param: String?
    func getAllReports(userName: String, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.dutyQuery(userName) { (success, json, error) in
            
            if success {
                guard let data = json?["data"]["list"].arrayObject as? [[String: Any]] else {
                    handler(false, nil)
                    return
                }
                var newData = [[String : Any]]()
                for d in data {
                    var newDic = d
                    var urls = ""
                    if let mediaArray = newDic["multiMedia"] as? [String] {
                        for media in mediaArray {
                            print(media)

                            urls += "\(media),"
                        }
                    }
                    if urls.count > 0 {
                        urls.removeLast()
                    }
                    newDic["medias"] = urls
                    newDic["reportDateString"] = d["reportTime"]
                    newData.append(newDic)
                }

                Sync.changes(newData, inEntityNamed: "DutyReport", dataStack: appDelegate.dataStack, operations: [.insert, .update,.delete], completion: { (error) in
                    if error == nil {
                        handler(true, nil)
                    } else {
                        handler(false, error)
                    }
                })
                handler(true, error)
            } else {
                handler(false, error)
            }
        }
        
    }
    
    func getStuff(handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getAvailableStuff { (success, json, error) in
            if success {
                guard let data = json?["data"].arrayObject as? [[String : Any]] else { handler(false, nil)
                    return }
                Sync.changes(data, inEntityNamed: "Processor", dataStack: appDelegate.dataStack, operations: [.insert, .update,.delete], completion: { (error) in
                    if error == nil {
                        handler(true, nil)
                    } else {
                        handler(false, error)
                    }
                })
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func fetchAvailableProcessorsBy(_ name: String?) -> [Processor]? {
        var processors: [Processor]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Processor")
        request.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        if name != nil {
            guard let username = name else { return nil }
            request.predicate = NSPredicate(format: "username == %@", username)
        }
        processors = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [Processor])
        return processors
    }
    
    func checkNumber(handler: @escaping ((_ isChecked:Bool, _ number: Int)->())) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Check")
        request.predicate = NSPredicate(format: "createTime != nil")
        if let number = (((try! appDelegate.dataStack.mainContext.fetch(request)) as? [Check]))?.count {
            guard let username = appDelegate.currentUser?.username else {
                handler(false,number)
                return
            }
            request.predicate = NSPredicate(format: "username == %@",username)
            let myCheck = (((try! appDelegate.dataStack.mainContext.fetch(request)) as? [Check]))?.count
            if myCheck == 1 {
                handler(true, number)
            } else {
                handler(false, number)
            }
        }
    }
}

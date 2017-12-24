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

class DataService: NSObject {
    
    static var sharedInstance: DataService {
        
        struct Static {
            static let instance: DataService = DataService()
        }
        return Static.instance
    }
    
    func userLogin(_ username: String?, pwd: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.userLogin(username, password: pwd) { (success, json, error) in
            if success {
                guard let token = json?["token"].string else { handler(false, nil)
                    return }
                if token != "" {
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.synchronize()
                    handler(true, nil)
                } else {
                    handler(false, nil)
                }
            } else {
                handler(false, error)
            }
        }
    }
    
    func getProfile(_ username: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.getProfile(username) { (success, json, error) in
            //TODO:process the data
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
    
    func uploadImageToServer(_ name: String?, desc: String?, uploadImage: UIImage?, handler:@escaping ((_ success:Bool, _ imageUrl: String?, _ error:NSError?)->()), progressHandler:@escaping ((_ progress: Progress?)->())) {
        Networking.shareInstance.uploadImageToServer(name, desc: desc, uploadImage: uploadImage, handler: { (success, json, error) in
            guard let data = json?.dictionaryObject else {
                handler(false, nil, error)
                return
            }
            handler(success, data["img"] as? String, nil)
        }) { (process) in
            progressHandler(process)
        }
    }
    
    func reportMessage(_ reporter: String?, location: String?, latitude: String?, longitude: String?, description: String?, multimedia: [String]?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        Networking.shareInstance.reportMessage(reporter, location: location, latitude: latitude, longitude: longitude, description: description, multimedia: multimedia) { (success, json, error) in
            if success {
                //TODO: store the data into DB
                handler(true, nil)
            } else {
                handler(false, error)
            }
        }
    }
    
    func userRegistration(_ username: String?, pwd: String?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
//        Networking.shareInstance.userRegister(username, password: pwd) { (success, json, error) in
//            if success {
//                handler(true, nil)
//            } else {
//                handler(false, error)
//            }
//        }
    }
    
    func getComments(_ commentType: String, _ farmId: Int16?, handler: @escaping ((_ success:Bool, _ error:NSError?)->())) {
        
//        Networking.shareInstance.getComments(commentType, farmId) { (success, json, error) in
//            guard let data = json?["data"].arrayObject as? [[String : Any]] else {
//                handler(false, error)
//                return
//            }
//            Sync.changes(data, inEntityNamed: "Comment", dataStack: appDelegate.dataStack, operations: [.Insert, .Update], completion: { (error) in
//                if error != nil {
//                    handler(false, error)
//                } else {
//                    handler(true, nil)
//                }
//            })
//        }
    }
}

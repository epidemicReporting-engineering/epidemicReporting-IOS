//
//  Networking.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/9.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//
import Alamofire
import SwiftyJSON

enum RequestType: Int {
    case requestTypeGet
    case requestTypePost
}

import Foundation

class Networking {
    
    static var sharreInstance: Networking {
        struct Static {
            static let instance: Networking = Networking()
        }
        return Static.instance
    }
    
    var baseURL: String! {
        get {
            return "http://127.0.0.1:8000"
        }
    }
}

extension Networking {
    
    //POST request
    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: Any] {
                    success(value)
                    let json = JSON(value)
                    print(json)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //GET request
    func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: .get, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    failture(error)
                    print("error:\(error)")
                }
        }
    }
    
    func downloadFileRequest(_ fileURL: String, finalPath: URL?,
                             completeHandler:((_ localPath: URL?, _ error: NSError?)->())? = nil,
                             progressHandler:((_ bytesRead: Int64?, _ totalBytesRead: Int64?, _ totalBytesExpectedToRead: Int64?)->())? = nil) {
        
        var localPath: URL? = finalPath
        let url = baseURL + fileURL
        
        Alamofire.download(url, method: HTTPMethod.get) { (temporaryURL, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            if let path = localPath {
                return (path, [.removePreviousFile, .createIntermediateDirectories])
            } else {
                let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let pathComponent = response.suggestedFilename
                localPath = directoryURL.appendingPathComponent(pathComponent!)
                return (localPath!, [.removePreviousFile, .createIntermediateDirectories])
            }
            }.responseData { (downloadResponse) in
                if let error = downloadResponse.error as NSError? {
                    completeHandler?(localPath, error)
                } else {
                    completeHandler?(localPath, nil)
                }
        }
    }
    
    fileprivate func syncWithAppServer(_ apiMapping: String, httpMethod: HTTPMethod ,httpHeaders: HTTPHeaders? = nil, urlParams:[String: Any?]? = nil, params:[String: Any?]? = nil, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) -> DataRequest? {
        let url = baseURL! + apiMapping
        let request = Alamofire.request(url, method: httpMethod, parameters: params, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (data) in
            //TODO: waiting for the status code
            let response = data.response
            
            if response?.statusCode == 200 || response?.statusCode == 201 || response?.statusCode == 204 {
                if let value = data.result.value {
                    let json = JSON(value)
                    handler(true, json, nil)
                } else {
                    handler(false, nil, data.result.error as NSError?)
                }
            } else {
                handler(false, nil, data.result.error as NSError?)
            }
        }
        return request
    }
}

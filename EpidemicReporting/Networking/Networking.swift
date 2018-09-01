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
    
    static var shareInstance: Networking {
        struct Static {
            static let instance: Networking = Networking()
        }
        return Static.instance
    }
    
    lazy var token: String? = {
        let token = UserDefaults.standard.value(forKey: "token") as? String
        return token
    }()
    
    var baseURL: String! {
        get {
            return "http://api.warmgoal.com"
        }
    }
    
    var apiBaseURL: String! {
        get {
            return "http://api.warmgoal.com/xsgov"
        }
    }
    
    func initialHeaders() -> [String : String]? {
        let headers = [
            "Allow": "POST,OPTIONS",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    func loginHeaders() -> [String : String]? {
        let headers = [
            "X-Requested-With": "XMLHttpRequest",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    func getHeaders() -> [String : String]? {
        guard let unwrapToken = token else { return nil }
        let headers = [
            "X-Authorization": "Bearer \(unwrapToken)"
        ]
        return headers
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
        let url = apiBaseURL + fileURL
        
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
    
    func syncWithAppServer(_ apiMapping: String, httpMethod: HTTPMethod ,httpHeaders: HTTPHeaders? = nil, urlParams:[String: Any?]? = nil, params:[String: Any?]? = nil, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->())) -> DataRequest? {
        var url = apiBaseURL! + apiMapping
        
        if let parameters = urlParams {
            var urlParam = "?"
            for (key, value) in parameters {
                if let parameterValue = value {
                    urlParam += "\(key)=\(parameterValue)&"
                }
            }
            let index = urlParam.index(urlParam.endIndex, offsetBy: -1)
            urlParam = urlParam.substring(to: index)
            url += urlParam
        }
        
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
    
    //upload video
    func uploadVideoToServer(_ uuid: String, _ uploadVideo: URL?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->()), progessHandler: @escaping (_ progress: Progress?)->()) {
        let url  = apiBaseURL! + "\(WebServiceAPIMapping.UploadMedia.rawValue)"
        
        var params: Parameters = [String: Any]()
        if let name = appDelegate.currentUser?.username {
            params = [
                "user": name,
            ]
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let videoUrl = uploadVideo {
                multipartFormData.append(videoUrl, withName: "file", fileName: "swift_file.mp4", mimeType: "video/mp4")
            }
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }, usingThreshold: UInt64.init(), to: url, method: HTTPMethod.post, headers: getHeaders(), encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    progessHandler(Progress)
                })
                
                upload.responseJSON { data in
                    let response = data.response
                    
                    if response?.statusCode == 200 {
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
            case .failure(let encodingError):
                handler(false, nil, encodingError as NSError?)
            }
        })
    }
    
    //upload image to server
    func uploadImageToServer(_ uuid: String, uploadImage: UIImage?, handler: @escaping ((_ success:Bool, _ json:JSON?, _ error:NSError?)->()), progessHandler: @escaping ((_ progress:Progress?)->())) {
        let url  = apiBaseURL! + "\(WebServiceAPIMapping.UploadMedia.rawValue)"
        
        var params: Parameters = [String: Any]()
        if let name = appDelegate.currentUser?.username {
            params = [
                "user": name,
            ]
        }
    
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let image = uploadImage, let imageData = UIImageJPEGRepresentation(image,1){
                multipartFormData.append(imageData, withName: "file", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: HTTPMethod.post, headers: getHeaders(), encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    progessHandler(Progress)
                })
                
                upload.responseJSON { data in
                    let response = data.response
                    
                    if response?.statusCode == 200 {
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
            case .failure(let encodingError):
                handler(false, nil, encodingError as NSError?)
            }
        })
    }
}

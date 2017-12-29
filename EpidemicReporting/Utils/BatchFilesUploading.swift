//
//  BatchFileUploading.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/27.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//


import Foundation
import Photos

class BatchFilesUploading: NSObject {
    
    fileprivate var assets:[PHAsset]?
    fileprivate var uploadProgress = [String: Progress]()
    fileprivate var successUploading = [String]()
    fileprivate var isUploading: Bool = false
    fileprivate var isCalculating: Bool = false
    
    static var sharedInstance: BatchFilesUploading {
        
        struct Static {
            static let instance: BatchFilesUploading = BatchFilesUploading()
        }
        return Static.instance
    }
    
    func getCurrentProgress() -> Float {
        var percentage: Double = 0.0
        guard let currentAssets = assets else { return 0 }
        if isCalculating == false &&  uploadProgress.count == currentAssets.count {
            isCalculating = true
            for ( _, progress) in uploadProgress {
                percentage += progress.fractionCompleted
            }
            percentage = percentage / Double(uploadProgress.count)
            isCalculating = false
        }
        return Float(percentage)
    }
    
    func uploadFiles(_ assetsInput: [PHAsset]?, handler: @escaping ((_ success:Bool, _ successUploading: [String]?, _ error:NSError?)->()), progessHandler: @escaping ((_ progress: Float)->())) {
        if isUploading {
            let error = NSError.init(domain: "FILEUPLOAD", code: FileUploadErrorCode.UPLOADING.rawValue, userInfo: nil)
            handler(false, nil, error)
            return
        }
        cleanData()// clean the data first
        assets = assetsInput
        guard let assets = assets else { return }
        for uploadAsset in assets {
            if uploadAsset.mediaType == .image {
                Utils.getUIImageFromAsset(uploadAsset, handler: { (image) in
                    //start to upload the image
                    let uuid = UUID().uuidString
                    DataService.sharedInstance.uploadImageToServer(uuid, uploadImage: image, handler: { [weak self] (success, url, error, uuidCallback) in
                        self?.processCallback(success, url: url, uuidCallback: uuid, handler: handler)
                        }, progressHandler: { [weak self](backuuid, progress) in
                            self?.uploadProgress[backuuid] = progress
                            guard let percentage = self?.getCurrentProgress() else { return }
                            progessHandler(percentage)
                    })
                })
                
            } else if uploadAsset.mediaType == .video {
                
                Utils.getVideoFromAsset(uploadAsset, handler: { [weak self](success, url) in
                    //start to upload the video
                    if success {
                        let uuid = UUID().uuidString
                        DataService.sharedInstance.uploadVideoToServer(uuid, url, handler: { [weak self] (success, url, error, uuidCallback) in
                            self?.processCallback(success, url: url, uuidCallback: uuid, handler: handler)
                            }, progressHandler: { [weak self](backuuid, progress) in
                                self?.uploadProgress[backuuid] = progress
                                guard let percentage = self?.getCurrentProgress() else { return }
                                progessHandler(percentage)
                        })
                    }
                })
            }
        }
    }
    
    fileprivate func processCallback(_ success: Bool, url: String?, uuidCallback: String, handler: @escaping ((_ success:Bool, _ successUploading: [String]?, _ error:NSError?)->())) {
        let error = NSError.init(domain: "FILEUPLOAD", code: FileUploadErrorCode.UPLOADFAILED.rawValue, userInfo: nil)
        if success {
            if uploadProgress[uuidCallback] != nil {
                guard let mediaURL = url else {
                    handler(false, nil, error)
                    return
                }
                successUploading.append(mediaURL)//save the url
                if uploadProgress.count == successUploading.count {
                    uploadProgress.removeAll()
                    isUploading = false
                    handler(true, successUploading, nil)
                }
            }
        } else {
            // in case one task fails, all other task should be canceld also
            for (uuid, progress) in uploadProgress {
                progress.cancel()
                uploadProgress.removeValue(forKey: uuid)
            }
            handler(false, nil, error)
        }
    }
    
    fileprivate func cleanData() {
        if  assets?.count != 0{
            assets?.removeAll()
        }
        uploadProgress.removeAll()
        successUploading.removeAll()
    }
}

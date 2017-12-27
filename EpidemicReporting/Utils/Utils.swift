//
//  Utils.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import Photos

class Utils {
    
    class func getUIImageFromAsset(_ asset: PHAsset, handler: @escaping ((_ image: UIImage?)->())) {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
                handler(img)
            }
        }
    }
    
    class func getVideoFromAsset(_ asset: PHAsset, handler: @escaping ((_ success: Bool, _ url: URL?)->())) {
        var url: URL?
        let manager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .mediumQualityFormat
        manager.requestAVAsset(forVideo: asset, options: options) { (assetVideo, _, _) in
        url = (assetVideo as? AVURLAsset)?.url
        //handler(url)
        let outputPath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
        guard let videoUrl = url?.absoluteString else { return }
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: videoUrl), options: nil)
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
        let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
        let existBool = FileManager.default.fileExists(atPath: outputPath)
        if existBool {
            //TODO: need to fix the issue
           //do nothing
        }
        exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true;
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
                case .failed:
                    handler(false, nil)
                    break
                case .cancelled:
                    handler(false, nil)
                    break;
                case .completed:
                    let mp4Path = URL.init(fileURLWithPath: outputPath)
                    handler(true, mp4Path)
                    break;
                default:
                    break;
                    }
                })
            }
        }
    }
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func getScreenHeigh() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func getCurrentTimeStamp(_ time: Int64) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        return dateformatter.string(from: date as Date)
    }
    
    class func getDutyStatus(_ status: String) -> String {
        switch status {
        case "0":
            return "未分配"
        case "1":
            return "已分配"
        case "2":
            return "已开始"
        case "3":
            return "有障碍"
        case "4":
            return "已完成"
        case "5":
            return "已评阅"
        case "6":
            return "不能做"
        default:
            return "未分配"
        }
    }
}


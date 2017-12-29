//
//  AssetsViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/10.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class AssetsViewController: UIViewController {
    
    var assets: [PHAsset]?
    var uploadURLs: [String]?
    fileprivate var locationManager: AMapLocationManager?
    fileprivate var search: AMapSearchAPI?
    fileprivate var location: String?
    fileprivate var latitude: String?
    fileprivate var longitude: String?
    fileprivate var reportDescription: String?
    fileprivate var multimedia: [String]?
    
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var imageList: UIImageView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    fileprivate var uploadingComplete = false
    fileprivate var alertController: UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = AMapLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.locationTimeout = 2
        locationManager?.reGeocodeTimeout = 2
        
        search = AMapSearchAPI()
        search?.delegate = self
        
        navigationController?.setStyledNavigationBar()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelWasPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .done, target: self, action: #selector(sendReport))
        
        initUI()
        uploadAssets(assets)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initUI() {
    
        numberView.layer.cornerRadius = numberView.frame.width / 2
        numberView.layer.masksToBounds = true
        numberView.backgroundColor = UIColor.green
        guard let count = assets?.count, count > 0, let asset = assets?.first else { return }
        number.text = count.description
        Utils.getUIImageFromAsset(asset) { [weak self] (image) in
            self?.imageList.image = image
        }
        commentsView.delegate = self
        commentsView.becomeFirstResponder()
        progress.setProgress(0.0, animated: true)
        progress.progressTintColor = UIColor.init(hexString: themeBlue)
        getCurrentLocation()
        
    }
    
    @objc func cancelWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendReport() {
        guard let description = reportDescription else {
            //TODO: toast, the content should not be empty
            return
        }

        if (uploadingComplete == true) {
            guard let userid = appDelegate.currentUser?.userid else { return }
            DataService.sharedInstance.reportMessage(userid, location: location ?? "无法获取地理位置信息", latitude: latitude, longitude: longitude, description: description, multimedia: uploadURLs) { [weak self](success, error) in
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    //TODO: Toast, error message
                }
            }
        }
    }
    
    fileprivate func showAlterViewController() {
        alertController = UIAlertController(title: "上传错误", message: "文件上传错误，您是否需要重新上传？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {[weak self] (action) in
            self?.alertController?.dismiss(animated: true, completion: nil)
        })
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {[weak self] (action) in

            self?.uploadAssets(self?.assets)
        })
        alertController?.addAction(cancelAction)
        alertController?.addAction(okAction)
        guard let alertVC = alertController else { return }
        present(alertVC, animated: true, completion: nil)
    }
    
    private func uploadAssets(_ assetsIn: [PHAsset]?) {
        BatchFilesUploading.sharedInstance.uploadFiles(assetsIn, handler: { [weak self] (success, result, error) in
            if success {
                self?.uploadingComplete = true
                self?.uploadURLs = result
            } else {
                guard let code = error?.code else { return }
                switch(code) {
                case FileUploadErrorCode.UPLOADFAILED.rawValue:
                    self?.progress.setProgress(0.0, animated: true)
                    self?.showAlterViewController()
                default:
                    break
                }
            }
        }) { [weak self](percentage) in
            self?.progress.setProgress(percentage, animated: true)
        }
    }
    
    func getCurrentLocation() {
        locationManager?.requestLocation(withReGeocode: false, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            if let location = location {
                NSLog("location:%@", location)
                self?.latitude = location.coordinate.latitude.description
                self?.longitude = location.coordinate.longitude.description
                let request = AMapReGeocodeSearchRequest()
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
                request.requireExtension = true
                self?.search?.aMapReGoecodeSearch(request)
            }
            
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
            }
        })
    }
}

extension AssetsViewController: AMapSearchDelegate {
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        currentLocation.text = response?.regeocode?.formattedAddress
        location = response?.regeocode?.formattedAddress
    }
}

extension AssetsViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            placeHolder.isHidden = true
        } else {
            placeHolder.isHidden = false
        }
        reportDescription = textView.text
    }
}

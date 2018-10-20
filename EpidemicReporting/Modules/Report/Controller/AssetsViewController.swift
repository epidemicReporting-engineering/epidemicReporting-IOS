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
    var type: DutyStatus = .UNASSIGN
    var dutyID: Int64? = 0
    var reportData: DutyReportDataModel?
    
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
    
    var finishedAction: (()->Void)?
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initUI() {
    
        numberView.layer.cornerRadius = numberView.frame.width / 2
        numberView.layer.masksToBounds = true
        numberView.backgroundColor = UIColor.green
        commentsView.delegate = self
        commentsView.becomeFirstResponder()
        progress.setProgress(0.0, animated: true)
        progress.progressTintColor = UIColor.init(hexString: themeBlue)
        guard let count = assets?.count, count > 0, let asset = assets?.first else {
            progress.setProgress(0, animated: true)
            imageList.isHidden = true
            numberView.isHidden = true
            return
        }
        number.text = count.description
        uploadAssets(assets)
        Utils.getUIImageFromAsset(asset) { [weak self] (image) in
            self?.imageList.image = image
        }
    }
    
    @objc func cancelWasPressed() {
        dismiss(animated: true, completion: nil)
        finishedAction?()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initUI()
        getCurrentLocation()
        
        switch type.rawValue {
        case DutyStatus.BLOCK.rawValue:
            placeHolder.text = "说说遇到的困难..."
        case DutyStatus.CANTDO.rawValue:
            placeHolder.text = "说说不能做的原因..."
        case DutyStatus.FINISH.rawValue:
            placeHolder.text = "总结下本次疫情处理心得..."
        case DutyStatus.SUCCESS.rawValue:
            placeHolder.text = "对本地疫情处理进行评价..."
        default:
            break
        }
    }
    
    func refeshDataAll(){
        guard let userName = appDelegate.currentUser?.username else { return }
        DataService.sharedInstance.getAllReports(userName: userName) { (success, error) in
            print("refresh the data")
        }
    }
    
    @objc func sendReport() {
        guard let count = assets?.count else { return }
        if (uploadingComplete == false && count > 0) {
            OPLoadingHUD.show(UIImage.init(named: "block"), title: "图片还在上传", animated: false, delay: 2.0)
            return
        }
        guard let description = reportDescription else {
            OPLoadingHUD.show(UIImage.init(named: "block"), title: "内容不能为空", animated: false, delay: 2.0)
            return
        }

        if count == 0 {
            uploadingComplete = true
        }
        
        if (uploadingComplete == true) {
            guard let userid = appDelegate.currentUser?.username else { return }
            if type == .UNASSIGN, var reportData = reportData {
                reportData.location = location ?? "无法获取地理位置信息"
                reportData.latitude = latitude ?? "0.0"
                reportData.longitude = longitude ?? "0.0"
                reportData.description = description
                reportData.multiMedia = uploadURLs ?? []
                DataService.sharedInstance.reportDuty(data: reportData) { [weak self] (success, error) in
                    if success {
                        self?.dismiss(animated: true, completion: { [weak self] in
                            self?.refeshDataAll()
                            self?.finishedAction?()
                        })
                    } else {
                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "疫情发送失败", animated: false, delay: 2.0)
                    }
                }
//                DataService.sharedInstance.reportMessage(userid, location: location ?? "无法获取地理位置信息", latitude: latitude, longitude: longitude, description: description, multimedia: uploadURLs) { [weak self](success, error) in
//                    if success {
//                        self?.dismiss(animated: true, completion: { [weak self] in
//                            self?.refeshDataAll()
//                        })
//                    } else {
//                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "疫情发送失败", animated: false, delay: 2.0)
//                    }
//                }
            } else if type == .SUCCESS {
                guard let id = dutyID, id != 0 else { return }
//                reportData
                DataService.sharedInstance.reportConfirm(id.description, leaderPoint: "10", leaderComment: "") { [weak self](success, error) in
                    if success {
                        self?.dismiss(animated: true, completion: {[weak self]  in
                            self?.refeshDataAll()
                            self?.finishedAction?()
                        })
                    } else {
                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "信息发送失败", animated: false, delay: 2.0)
                    }
                }
            } else {
                guard let id = dutyID, id != 0 else { return }
                DataService.sharedInstance.reportProcess(id.description, dutyDescription: description, dutyStatus: type.rawValue, dutyMultiMedia: uploadURLs) { [weak self](success, error) in
                    if success {
                        self?.dismiss(animated: true, completion: {[weak self]  in
                            self?.refeshDataAll()
                            self?.finishedAction?()
                        })
                    } else {
                        OPLoadingHUD.show(UIImage.init(named: "block"), title: "信息发送失败", animated: false, delay: 2.0)
                    }
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
        GetCurrentLocationUtils.sharedInstance.getCurrentLocation { [weak self](location, success, error) in
            if success {
                let request = AMapReGeocodeSearchRequest()
                guard let lat = location?.coordinate.latitude, let longt = location?.coordinate.longitude else { return }
                self?.latitude = lat.description
                self?.longitude = longt.description
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(lat), longitude: CGFloat(longt))
                request.requireExtension = true
                self?.search?.aMapReGoecodeSearch(request)
            }
        }
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

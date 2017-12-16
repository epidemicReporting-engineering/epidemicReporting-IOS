//
//  AssetsViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/10.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import Photos

class AssetsViewController: UIViewController {
    
    var assets: [PHAsset]?
    fileprivate var locationManager: AMapLocationManager?
    fileprivate var search: AMapSearchAPI?
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var imageList: UIImageView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .done, target: self, action: #selector(cancelWasPressed))
        
        initUI()
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
        let image = getUIImageFromAsset(asset)
        imageList.image = image
        commentsView.delegate = self
        commentsView.becomeFirstResponder()
        
        getCurrentLocation()
    }
    
    @objc func cancelWasPressed() {
        dismiss(animated: true, completion: nil)
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
    }
}

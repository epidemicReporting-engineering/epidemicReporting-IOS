//
//  File.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/11.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class SelfCheckViewController: UIViewController, MAMapViewDelegate {
    
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var calendarContainer: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var checkBut: UIImageView!
    @IBOutlet weak var checkMessage: UILabel!
    
    
    fileprivate var mapView: MAMapView?
    fileprivate var search: AMapSearchAPI?
    fileprivate var currentLocation: String?
    fileprivate var latitude: String?
    fileprivate var longitude: String?
    
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        initSearch()
        initCalendar()
        
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "我的足迹"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.isShowsUserLocation = true
        mapView?.setZoomLevel(14.2, animated: false)
        mapView?.showsScale = false
        mapView?.userTrackingMode = MAUserTrackingMode.follow
    }
    
    @IBAction func checkinAction(_ sender: UITapGestureRecognizer) {
        checkBut.addScaleAnimation()
        if (latitude == nil || longitude == nil) {
            OPLoadingHUD.show(UIImage(named: "block"), title: "无法获取地理位置", animated: false, delay: 2)
        } else {
            DataService.sharedInstance.checkIn(appDelegate.currentUser?.username, latitude: latitude, longitude: longitude, location: currentLocation, isAbsence: false, isAvailable: true, handler: { [weak self](success, error) in
                if success {
                    self?.checkMessage.text = "今日您已签到"
                } else {
                    OPLoadingHUD.show(UIImage(named: "block"), title: "签到失败", animated: false, delay: 2)
                }
            })
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initMapView() {
        mapView = MAMapView(frame: mapViewContainer.bounds)
        mapView?.delegate = self
        if let map = mapView {
            mapViewContainer.addSubview(map)
        }
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
    func initCalendar() {
        calendar.dataSource = self
        calendarContainer.layer.borderWidth = 3.0
        calendarContainer.layer.borderColor = UIColor.init(hexString: themeBlue).cgColor
        calendarContainer.layer.cornerRadius = 10
    }
}

extension SelfCheckViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [11,10].contains(day) ? UIImage(named: "history") : nil
    }
}

extension SelfCheckViewController: AMapSearchDelegate {
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        currentLocation = response?.regeocode?.formattedAddress
    }
}

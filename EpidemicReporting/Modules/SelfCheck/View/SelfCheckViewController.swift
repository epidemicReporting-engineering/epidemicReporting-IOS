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
    @IBOutlet weak var totalNum: UILabel!
    
    
    fileprivate var mapView: MAMapView?
    fileprivate var search: AMapSearchAPI?
    fileprivate var currentLocation: String?
    fileprivate var latitude: String?
    fileprivate var longitude: String?
    fileprivate var current: MAUserLocation?
    
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
//    fileprivate var checkinTypeSelectionView: SelectionAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        let rightFilterItemblank = UIBarButtonItem.createBarButtonItemWithText("", CGRect(x: 0, y: 0, width: 4, height: 24), self, #selector(profilePress), UIColor.white, 12)
        guard let profileImage = UIImage(named: "profile") else { return }
        let rightProfileItem = UIBarButtonItem.createBarButtonItemWithImage(profileImage, CGRect(x: 0, y: 0, width: 24, height: 24), self, #selector(profilePress))
        navigationItem.rightBarButtonItems = [rightFilterItemblank,rightProfileItem]
        
        
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "我的足迹"
        
        refreshCheckNumber()
    }
    
    func refreshCheckNumber(){
//        DataService.sharedInstance.getMyCheckIn { (success, error) in
//
//            DataService.sharedInstance.checkNumber { [weak self](checked, number) in
//                if checked {
//                    self?.checkMessage.text = "今日您已签到"
//                } else {
//                    self?.checkMessage.text = "点击签到"
//                }
//                self?.totalNum.text = "今日签到人数：" + number.description
//                self?.getCurrentLocation()
//            }
//        }
        DataService.sharedInstance.getMyCheckIn { (success, error) in
            print("finish")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("coming")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func profilePress() {
        let stroryboard = UIStoryboard.init(name: "Profile", bundle: nil)
        if let profileNav = stroryboard.instantiateInitialViewController() as? UINavigationController {
            present(profileNav, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkinAction(_ sender: UITapGestureRecognizer) {
        checkBut.addScaleAnimation()
        let alert = UIAlertController(title: nil, message: "请选择签到方式", preferredStyle: .actionSheet)
        let checkinAction = UIAlertAction(title: "签到 可工作状态", style: .default) { [weak self] (action) in
            self?.checkIn(isAbsence: false, isAvaliable: true)
        }
        let checkinUnavaliableAction = UIAlertAction(title: "签到 不可工作状态", style: .default) { [weak self] (action) in
            self?.checkIn(isAbsence: false, isAvaliable: false)
        }
        let missAction = UIAlertAction(title: "缺勤", style: .default) { [weak self] (action) in
            self?.checkIn(isAbsence: true, isAvaliable: false)
        }
        let acCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(checkinAction)
        alert.addAction(checkinUnavaliableAction)
        alert.addAction(missAction)

        alert.addAction(acCancel)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func checkIn(isAbsence: Bool, isAvaliable: Bool) {
        if (current == nil) {
            OPLoadingHUD.show(UIImage(named: "block"), title: "无法获取地理位置", animated: false, delay: 2)
        } else {
            guard let lat = current?.coordinate.latitude.description, let long = current?.coordinate.longitude.description, let location = currentLocation else { return }
            DataService.sharedInstance.checkIn(appDelegate.currentUser?.username, latitude: lat, longitude: long, location: location, isAbsence: isAbsence, isAvailable: isAvaliable, handler: { [weak self](success, error) in
                if success {
                    self?.checkMessage.text = "今日您已签到"
                    self?.refreshCheckNumber()
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
        mapView?.setUserTrackingMode(.follow, animated: true)
        mapView?.isShowsUserLocation = true
        mapView?.setZoomLevel(10.2, animated: false)
        mapView?.showsScale = false
        mapView?.delegate = self
        
        if let map = mapView {
            mapViewContainer.addSubview(map)
        }
        current = mapView?.userLocation
    }
    
    private func initSearch() {
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
    private func initCalendar() {
        calendar.dataSource = self
        calendarContainer.layer.borderWidth = 3.0
        calendarContainer.layer.borderColor = UIColor.init(hexString: themeBlue).cgColor
        calendarContainer.layer.cornerRadius = 10
    }
    
    func initUI() {
        initMapView()
        initSearch()
        initCalendar()
        
//        let config = SelectionConfiguration()
//        config.selections = [(title: "在位签到", tag: 0) ,(title: "缺勤签到", tag: 1)]
//        checkinTypeSelectionView = SelectionAlertView(configuration: config) { [weak self] (tag) in
//
//        }
//        view.addSubview(checkinTypeSelectionView ?? UIView())
//        checkinTypeSelectionView?.snp.makeConstraints { (maker) in
//            maker.centerX.equalToSuperview()
//            maker.centerY.equalToSuperview().offset(-30)
//            maker.width.equalToSuperview().multipliedBy(0.65)
//        }
    }
    
    func getCurrentLocation() {
        let request = AMapReGeocodeSearchRequest()
        guard let lat = current?.coordinate.latitude, let longt = current?.coordinate.longitude else { return }
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(lat), longitude: CGFloat(longt))
        request.requireExtension = true
        search?.aMapReGoecodeSearch(request)
    }
    
//    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
//        print(userLocation.coordinate)
//    }
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

//
//  AvailableLocationsViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 31/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import UIKit

class AvailableLocationsViewController: UIViewController, MAMapViewDelegate {
    
    @IBOutlet weak var mapView: MAMapView!
    
    fileprivate var customCalloutView: CustomCalloutView?
    fileprivate var annotations: [MAAnnotation] = [MAAnnotation]()
    fileprivate var processors: [Processor]?
    var duty: DutyReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStyledNavigationBar()
        
        mapView.setUserTrackingMode(.follow, animated: true)
        //mapView.isShowsUserLocation = true
        mapView.showsScale = false
        customCalloutView = CustomCalloutView()
        mapView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DataService.sharedInstance.getStuff { [weak self](success, error) in
            self?.processors = DataService.sharedInstance.fetchAvailableProcessorsBy(nil)
            if let availableProcssor = self?.processors {
                for procssor in availableProcssor {
                    let pointAnnotation = MAPointAnnotation()
                    if let latitude = (procssor.latitude as? NSString)?.doubleValue, let longitude = (procssor.longitude as? NSString)?.doubleValue {
                        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        pointAnnotation.title = procssor.username //work arount to math the username
                        self?.mapView.addAnnotation(pointAnnotation)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? CustomAnnotationView
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            if let availableprocessors = processors {
                for processor in availableprocessors {
                    if processor.username == annotation.title {
                        annotationView?.processor = processor
                        annotationView?.processorHandler = { [weak self] (processor)in
                            self?.showAlertVC(processor)
                        }
                    }
                }
            }
            //annotationView!.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.image = UIImage.init(named: "location_map")
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -18)
            annotationView!.canShowCallout = false
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("didselect")
    }
    
    func showAlertVC(_ process: Processor?) {
        guard let available = process, let name = available.username else { return }
        let alertController = UIAlertController(title: "任务分配",
                                                message: "您是否确定要把该任务分配给\(name)?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {[weak self]
            action in
            DataService.sharedInstance.reportAssign(self?.duty?.id.description, dutyOwner: process?.username, dutyDescription: "请立即开始处理", dutyStatus: DutyStatus.ASSIGNED.rawValue, handler: {[weak self](success, error) in
                if !success {
                    OPLoadingHUD.show(UIImage.init(named: "block"), title: "分配失败", animated: false, delay: 2)
                } else {
                    //self?.navigationController?.dismiss(animated: true, completion: nil)
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

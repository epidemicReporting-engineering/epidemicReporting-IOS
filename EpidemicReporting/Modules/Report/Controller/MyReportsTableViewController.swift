//
//  MyReportsTableViewController.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData
import TZImagePickerController
import Gallery

class MyReportsTableViewController: CoreDataTableViewController {
    
    fileprivate var imagePickerVc: TZImagePickerController?
    fileprivate var gallyPickerVc: GalleryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initTableView()
    }
    
    fileprivate func initUI() {
        navigationController?.setStyledNavigationBar()
        navigationItem.title = "上报疫情"
        
        //inti circle
        let buttonView = UIView.init(frame: CGRect.init(x: Utils.getScreenWidth() - 100, y: Utils.getScreenHeigh() - 160, width: 64, height: 64))
        buttonView.backgroundColor = UIColor.init(hexString: themeBlue)
        buttonView.layer.cornerRadius = buttonView.frame.width / 2
        buttonView.layer.masksToBounds = true
        
        //init plus
        let plusView = UIImageView.init(frame: CGRect.zero)
        plusView.image = UIImage.init(named: "plus")
        buttonView.addSubview(plusView)
        plusView.translatesAutoresizingMaskIntoConstraints = false
        plusView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
        plusView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
        plusView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        plusView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        //add action
        plusView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewPicker))
        plusView.addGestureRecognizer(tapGesture)
        navigationController?.view.addSubview(buttonView)
    }
    
    func initTableView() {
        let footView = UIView()
        tableView.tableFooterView = footView
        
        let nib = UINib(nibName: "ReportTableViewCell",bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReportTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        _ = setup
    }
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let userid = appDelegate.currentUser?.userid else { return }
        request.predicate = NSPredicate(format: "reporter == %@", userid)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func imageViewPicker() {
        gallyPickerVc = GalleryController()
        gallyPickerVc?.delegate = self
        if let presentVc = gallyPickerVc {
            present(presentVc, animated: true, completion: nil)
        }
    }
}

extension MyReportsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        guard let report = fetchedResultsController?.object(at: indexPath) as? DutyReport else { return cell }
        cell.updateDataSource(report)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let parent = fetchedResultsController?.object(at: indexPath) as? Comment
//        if parent?.user?.username == appDelegate.currentUser?.username {
//            guard let alterVC = showReplyAlertController(parentComment?.id, showDelete: true, commentId: parent?.id) else { return }
//            present(alterVC, animated: true, completion: nil)
//        } else {
//            guard let alterVC = showReplyAlertController(parent?.id) else { return }
//            present(alterVC, animated: true, completion: nil)
//        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MyReportsTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]){
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video){
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//extension MyReportsTableViewController: TZImagePickerControllerDelegate {
//
//    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
//        //
//        print("selected")
//    }
//
//    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
//        //
//        print("selected")
//    }
//
//    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: Any!) {
//        //
//        print("selected")
//    }
//
//    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
//        //
//        print("selected")
//    }
//
//    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
//        //
//        print("selected")
//    }
//}


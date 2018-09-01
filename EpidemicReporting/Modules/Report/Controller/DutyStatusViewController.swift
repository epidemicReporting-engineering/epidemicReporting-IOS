//
//  DutyStatusViewController.swift
//  EpidemicReporting
//
//  Created by IBM on 04/01/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit

class DutyStatusViewController: UIViewController {
    
    @IBOutlet weak var dutyOwner: UILabel!
    @IBOutlet weak var processTime: UILabel!
    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var contentDescription: UILabel!
    @IBOutlet weak var connectionView: UICollectionView!
    
    fileprivate let mediaArray:[String] = ["http://api.warmgoal.com/media/2017-12-28/df958d33-ff48-4325-a2bc-9f80184d56e9.jpeg","http://api.warmgoal.com/media/2017-12-28/579ca994-4c1d-412b-887a-ac92ed577637.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionView.delegate = self
        connectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DutyStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DutyStatusImageCollectionViewCell", for: indexPath) as?
            DutyStatusImageCollectionViewCell else { return UICollectionViewCell() }
        cell.updateDataSource(mediaArray[indexPath.item])
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
}

extension DutyStatusViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 20, bottom: 0, right: 20)
    }
}

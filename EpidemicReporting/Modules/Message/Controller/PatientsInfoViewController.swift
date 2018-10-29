//
//  PatientsInfoViewController.swift
//  EpidemicReporting
//
//  Created by Jianyu Wang on 29/10/2018.
//  Copyright © 2018 epidemicreporting.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class PatiantsInfoCell: UITableViewCell {
    
    static let reusedId = "PatiantsInfoCell"
    
    lazy var infoLabel = UILabel()
//    lazy var careerLabel = UILabel()
    lazy var symptomLabel = UILabel()
//    lazy var fabingLabel = UILabel()
//    lazy var tratmentLabel = UILabel()
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addsubviews()
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(_ json: JSON) {
        infoLabel.text = "\(json["name"].string ?? "") \(json["sex"].string ?? "男") \(json["age"].int ?? 0)岁 \(json["career"].string ?? "")"
//        careerLabel.text = json["career"].string ?? ""
        symptomLabel.text = "\(json["symptom"].string ?? "") \(json["fabing"].string ?? "") \(json["treatment"].string ?? "")"
//        fabingLabel.text = json["fabing"].string ?? ""
//        tratmentLabel.text = json["treatment"].string ?? ""
    }
    
    func addsubviews() {
        var last: UIView?
        [infoLabel, symptomLabel].forEach { (label) in
            addSubview(label)
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.lightGray
            label.snp.makeConstraints { (maker) in
                if let last = last {
                    maker.top.equalTo(last.snp.bottom).offset(5)
                } else {
                    maker.top.equalTo(5)
                }
                maker.left.equalTo(15)
            }
            last = label
        }
        
    }
    
}

class PatientsInfoViewController: UIViewController {

    fileprivate let companyLabel = UILabel()
    fileprivate let departmentLabel = UILabel()
    fileprivate let tableView = UITableView()
    
    var data: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

}

extension PatientsInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func initUI() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(companyLabel)
        companyLabel.textColor = UIColor.lightGray
        companyLabel.text = "单位： \(data?["company"].string ?? "信息缺失")"
        companyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(10)
        }

        view.addSubview(departmentLabel)
        departmentLabel.textColor = UIColor.lightGray
        departmentLabel.text = "部门： \(data?["department"].string ?? "信息缺失")"
        departmentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(companyLabel.snp.bottom).offset(10)
        }
        
        let widthOfPic = (view.bounds.width / 3) - 15 * 4
        let heightOfPic = widthOfPic * 2
        var last: UIView?
        
        if let multiMedia = data?["multiMedia"].array {
            if multiMedia.count > 0, let first = multiMedia.first?.string {
//                cover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "defaultIcon"))
                let img0 = UIImageView()
                view.addSubview(img0)
                img0.snp.makeConstraints { (maker) in
                    maker.top.equalTo(departmentLabel.snp.bottom).offset(10)
                    maker.left.equalTo(15)
                    maker.width.equalTo(widthOfPic)
                    maker.height.equalTo(heightOfPic)
                }
                last = img0
                img0.sd_setImage(with: URL(string: first), placeholderImage: UIImage(named: "defaultIcon"))
                if multiMedia.count > 1, let second = multiMedia[1].string {
                    let img1 = UIImageView()
                    view.addSubview(img1)
                    img1.snp.makeConstraints { (maker) in
                        maker.top.equalTo(departmentLabel.snp.bottom).offset(10)
                        maker.left.equalTo(img0.snp.right).offset(15)
                        maker.width.equalTo(widthOfPic)
                        maker.height.equalTo(heightOfPic)
                    }
                    img1.sd_setImage(with: URL(string: second), placeholderImage: UIImage(named: "defaultIcon"))

                    if multiMedia.count > 2, let third = multiMedia[2].string {
                        let img2 = UIImageView()
                        view.addSubview(img2)
                        img2.snp.makeConstraints { (maker) in
                            maker.top.equalTo(departmentLabel.snp.bottom).offset(10)
                            maker.left.equalTo(img1.snp.right).offset(15)
                            maker.width.equalTo(widthOfPic)
                            maker.height.equalTo(heightOfPic)
                        }
                        img1.sd_setImage(with: URL(string: third), placeholderImage: UIImage(named: "defaultIcon"))
                    }
                }
            }
        }
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            if let last = last {
                maker.top.equalTo(last.snp.bottom).offset(15)
            } else {
                maker.top.equalTo(departmentLabel.snp.bottom).offset(15)
            }
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-10)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(PatiantsInfoCell.self, forCellReuseIdentifier: PatiantsInfoCell.reusedId)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?["patients"].array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PatiantsInfoCell.reusedId, for: indexPath) as? PatiantsInfoCell else { return UITableViewCell() }
        guard let jsondata = data?["patients"].array?[indexPath.row] else { return cell }
        cell.prepare(jsondata)
        return cell
    }
    
}











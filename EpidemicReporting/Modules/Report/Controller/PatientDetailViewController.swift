//
//  PatientDetailViewController.swift
//  EpidemicReporting
//
//  Created by WangJianyu on 2018/9/24.
//  Copyright © 2018年 epidemicreporting.com. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PatientDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
//    lazy fileprivate var nameTF = UnderlineTextfield()
    lazy fileprivate var companyTF = UnderlineTextfield()
    lazy fileprivate var departmentTF = UnderlineTextfield()
    lazy fileprivate var datePicker = UIDatePicker()
    lazy fileprivate var paitentsLabel = UILabel()
    
    var reportData = DutyReportDataModel()
    
    var finishedAction: ((DutyReportDataModel) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().enable = true
        title = "患者详情"
        prepareUI()
    }


}

extension PatientDetailViewController {
    
    fileprivate func prepareUI() {
        navigationController?.setStyledNavigationBar()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(completionAction))

        let textWidth = view.bounds.width - 64
        
        var last: UIView?
        
        
        [("单位/公司/学校", companyTF), ("部门/班级", departmentTF)].forEach { (placeholder, underline) in
            scrollView.addSubview(underline)
            underline.placeholder = placeholder
            underline.borderStyle = .none
            underline.snp.makeConstraints { (maker) in
                if let last = last {
                    maker.top.equalTo(last.snp.bottom).offset(32)
                } else {
                    maker.top.equalTo(32)
                }
                maker.left.equalTo(32)
                maker.width.equalTo(textWidth)
                
//                maker.bottom.lessThanOrEqualTo(-32)
            }
            
            last = underline
        }

        let label = UILabel()
        label.text = "发现时间: "
        label.textColor = UIColor.lightGray
        scrollView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.top.equalTo(last!.snp.bottom).offset(32)
            maker.left.equalTo(32)
        }
        
        datePicker.datePickerMode = .date
        scrollView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.height.equalTo(160)
            maker.top.equalTo(label.snp.bottom).offset(5)
//            maker.bottom.lessThanOrEqualTo(-32)
        }
        
        let morePatains = UILabel()
        morePatains.text = "至少添加一名病人详细信息: "
        morePatains.textColor = UIColor.lightGray
        scrollView.addSubview(morePatains)
        morePatains.snp.makeConstraints { (maker) in
            maker.top.equalTo(datePicker.snp.bottom).offset(26)
            maker.left.equalTo(32)
//            maker.bottom.lessThanOrEqualTo(-32)
        }
        
        let moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        moreButton.backgroundColor = UIColor(hexString: "#0084C0")
        scrollView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(morePatains.snp.right).offset(12)
            maker.centerY.equalTo(morePatains)
            maker.size.equalTo(CGSize(width: 28, height: 28))
        }
        moreButton.layer.cornerRadius = 14
        moreButton.layer.masksToBounds = true
        moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        
        scrollView.addSubview(paitentsLabel)
        paitentsLabel.textColor = UIColor.gray
        paitentsLabel.numberOfLines = 0
        paitentsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(morePatains)
            maker.top.equalTo(morePatains.snp.bottom).offset(16)
            maker.right.equalTo(departmentTF)
            maker.bottom.lessThanOrEqualTo(-32)
        }
//        paitentsLabel.text = "张三,张三,张三,张三,张三,张三,张三,张三，张三,张三,张三,张三,张三,张三,张三,张三，张三,张三,张三,张三,张三,张三,张三,张三，张三,张三,张三,张三,张三,张三,张三,张三"
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moreAction() {
        let addVC = AddPatientViewController()
        addVC.finishedAddAction = { [weak self] (data) in
            guard let strong = self else { return }
            strong.reportData.pataints.append(data)
            var text = strong.reportData.pataints.first?.name ?? ""
            for index in 1..<strong.reportData.pataints.count {
                let pa = strong.reportData.pataints[index]
                text += ",\(pa.name)"
            }
            strong.paitentsLabel.text = text
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc func completionAction() {
        self.dismiss(animated: true) { [weak self] in
            guard let reportData = self?.reportData else { return }
            self?.finishedAction?(reportData)
        }
    }
    
}


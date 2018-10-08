//
//  AddPatientViewController.swift
//  EpidemicReporting
//
//  Created by WangJianyu on 2018/9/24.
//  Copyright © 2018年 epidemicreporting.com. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

struct DutyReportDataModel {
    var location = ""
    var latitude = ""
    var longitude = ""
    var multiMedia = [String]()
    var description = ""
    var happenTime = ""
    var company = ""
    var department = ""
    var pataints = [DutyReportPataintDataModel]()
}

struct DutyReportPataintDataModel {
    var name = ""
    var sex = "男"
    var age = -1
    var career = ""
    var symptom = ""
    var fabing = ""
    var treatment = ""
}

class AddPatientViewController: UIViewController {
    
    lazy fileprivate var scrollView = UIScrollView()
    lazy fileprivate var nameTF = UnderlineTextfield()
    lazy fileprivate var genderCheckBoxGroup = SingleSelectionCheckBoxGroup(titles: ["男", "女"])
    lazy fileprivate var careerTF = UnderlineTextfield()
    lazy fileprivate var ageTF = UnderlineTextfield()
    lazy fileprivate var symptomCheckBoxArray = [CheckBox(title: "头疼"), CheckBox(title: "发热"), CheckBox(title: "呕吐"), CheckBox(title: "腹泻"), CheckBox(title: "休克"), CheckBox(title: "呼吸难"), CheckBox(title: "其他")]
    lazy fileprivate var fabingCheckBoxGroup = SingleSelectionCheckBoxGroup(titles: ["轻度", "中等", "严重"])
    lazy fileprivate var treatmentTF = UnderlineTextfield()
    
    var finishedAddAction: ((DutyReportPataintDataModel) -> Void)?
    var data = DutyReportPataintDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        IQKeyboardManager.sharedManager().enable = true
        title = "添加患者"
        prepareUI()
    }


}

extension AddPatientViewController {
    
    fileprivate func prepareUI() {
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addAction))]

        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
        }
        
        let textWidth = view.bounds.width - 64
        let symCheckWidth = ( textWidth / 3 )

        scrollView.addSubview(nameTF)
        nameTF.placeholder = "患者姓名"
        nameTF.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(32)
            maker.width.equalTo(textWidth)
        }
        
        let genderLabel = UILabel()
        genderLabel.textColor = UIColor.lightGray
        genderLabel.text = "性别: "
        scrollView.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameTF.snp.bottom).offset(26)
            maker.left.equalTo(nameTF)
        }
        
        for index in 0..<genderCheckBoxGroup.checkBoxArray.count {
            let checkbox = genderCheckBoxGroup.checkBoxArray[index]
            scrollView.addSubview(checkbox)
            checkbox.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(genderLabel)
                if index == 0 {
                    checkbox.checkBoxStatus = .selected
                    maker.left.equalTo(genderLabel.snp.right).offset(12)
                } else {
                    maker.left.equalTo(genderCheckBoxGroup.checkBoxArray[index-1].snp.right).offset(12)
                }
                maker.height.equalTo(28)
            })
        }
        
        scrollView.addSubview(careerTF)
        careerTF.placeholder = "职位"
        careerTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(genderLabel)
            maker.top.equalTo(genderLabel.snp.bottom).offset(26)
//            maker.bottom.lessThanOrEqualTo(-32)
            maker.width.equalTo(textWidth * 0.4)
        }
        
        scrollView.addSubview(ageTF)
        ageTF.placeholder = "年龄"
        ageTF.keyboardType = .numberPad
        ageTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(careerTF.snp.right).offset(18)
            maker.centerY.equalTo(careerTF)
            maker.width.equalTo(textWidth * 0.2)
        }
        
        let symptomLabel = UILabel()
        symptomLabel.textColor = UIColor.lightGray
        symptomLabel.text = "选择至少一项病情: "
        scrollView.addSubview(symptomLabel)
        symptomLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(careerTF.snp.bottom).offset(26)
            maker.left.equalTo(careerTF)
            //            maker.bottom.lessThanOrEqualTo(-32)
        }
        
        var lastSymBox: UIView?
        for index in 0..<symptomCheckBoxArray.count {
            let box = symptomCheckBoxArray[index]
            scrollView.addSubview(box)
            box.snp.makeConstraints { (maker) in
                maker.height.equalTo(28)
                maker.width.equalTo(symCheckWidth)
                
                if index % 3 == 0 {
                    if let lastSymBox = lastSymBox {
                        maker.top.equalTo(lastSymBox.snp.bottom).offset(12)
                    } else {
                        maker.top.equalTo(symptomLabel.snp.bottom).offset(18)
                    }
                    maker.left.equalTo(symptomLabel)
                } else {
                    if let lastSymBox = lastSymBox {
                        maker.top.equalTo(lastSymBox)//.offset(12)
                        maker.left.equalTo(lastSymBox.snp.right)//.offset(8)
                    }
                }
            }
            lastSymBox = box
        }
        
        let fabingLabel = UILabel()
        fabingLabel.textColor = UIColor.lightGray
        fabingLabel.text = "发病程度: "
        scrollView.addSubview(fabingLabel)
        fabingLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(lastSymBox!.snp.bottom).offset(26)
            maker.left.equalTo(symptomLabel)
        }
        
        for index in 0..<fabingCheckBoxGroup.checkBoxArray.count {
            let box = fabingCheckBoxGroup.checkBoxArray[index]
            scrollView.addSubview(box)
            box.snp.makeConstraints { (maker) in
                if index == 0 {
                    box.checkBoxStatus = .selected
                    maker.left.equalTo(fabingLabel)
                } else {
                    maker.left.equalTo(fabingCheckBoxGroup.checkBoxArray[index-1].snp.right).offset(18)
                }
                maker.height.equalTo(28)
                maker.top.equalTo(fabingLabel.snp.bottom).offset(18)
            }
        }
        
        scrollView.addSubview(treatmentTF)
        treatmentTF.placeholder = "治疗方式"
        treatmentTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(fabingLabel)
            maker.top.equalTo(fabingCheckBoxGroup.checkBoxArray[0].snp.bottom).offset(26)
            maker.width.equalTo(textWidth)
            maker.bottom.lessThanOrEqualTo(-32)
        }
        
    }
    
    @objc func addAction() {
        // check empty
        if let name = nameTF.text {
            data.name = name
        }
        if let gender = genderCheckBoxGroup.selectedTitle {
            data.sex = gender
        }
        if let career = careerTF.text {
            data.career = career
        }
        if let age = ageTF.text, let ageInt = Int(age) {
            data.age = ageInt
        }
        for box in symptomCheckBoxArray {
            if box.checkBoxStatus == .selected {
                data.symptom += data.symptom.count > 0 ? " \((box.titleLable.text ?? ""))" : (box.titleLable.text ?? "")
            }
        }
        if let fabing = fabingCheckBoxGroup.selectedTitle {
            data.fabing = fabing
        }
        if let treat = treatmentTF.text {
            data.treatment = treat
        }
        finishedAddAction?(data)
        navigationController?.popViewController(animated: true)
    }
    
}

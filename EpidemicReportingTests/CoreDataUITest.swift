//
//  CoreDataUITest.swift
//  EpidemicReportingTests
//
//  Created by eleven on 2017/12/26.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import XCTest
@testable import EpidemicReporting
import SwiftyJSON
import Sync

class CoreDataUITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_0_save_report() {
        var waitingForBlock = true
        
        let stringjson = "{\"id\":100026,\"reportDescription\":\"执行职务的医护人员和检疫人员、疾病预防控制人员、乡村医生、个体开业医生均为责任疫情报告人，各级各类医疗卫生机构和疾病预防控制机构为责任报告单位。对甲类传染病、传染性非典型肺炎和乙类传染病中艾滋病、肺炭疽、脊髓灰质炎的病人、病原携带者和疑似病人，城镇于2小时内、农村于6小时内报告；对其他乙类传染病人、疑似病人、伤寒、副伤寒、痢疾、梅毒、淋病、乙肝、白喉、疟疾的病原携带者，城镇于6小时、农村于12小时内报告，对丙类传染病和其他传染病，在24小时内报告。\",\"dutyOwner\":\"user001\",\"leaderPoint\":null, \"leaderComment\":null,\"dutyDescription\":\"又要马上开始\",\"dutyStatus\":\"0\",\"longitude\":\"222\",\"dutyMultiMedia\":null,\"latitude\":\"333\",\"reportTime\":1514191435000,\"location\":\"Ning Bo\",\"reporter\":\"user001\",\"dutyOwnerName\":\"张三\",\"processTime\":1514191491000,\"reporterName\":\"张三\",\"multiMedia\":[\"111\",\"222\"]}";
        let jsonData = stringjson.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
        
        let jsonReal = JSON(json as Any)
        guard let data = jsonReal.dictionaryObject else { return }
        Sync.changes([data], inEntityNamed: "DutyReport", dataStack: appDelegate.dataStack, operations: [.insert, .update,], completion: { (error) in
            waitingForBlock = false
        })
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_1_query_report() {
        let id = 100026
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DutyReport")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.predicate = NSPredicate(format: "id == %lld", id)
        let users = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [DutyReport])
        print("users")
    }
    
    func test_2_save_user() {
        var waitingForBlock = true
        
        let stringjson = "{\"userid\":\"user001\",\"accessToken\":\"aaaaa\",\"refreshToken\":\"bbb\"}";
        let jsonData = stringjson.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
        
        let jsonReal = JSON(json as Any)
        guard let data = jsonReal.dictionaryObject else { return }
        Sync.changes([data], inEntityNamed: "User", dataStack: appDelegate.dataStack, operations: [.insert, .update,], completion: { (error) in
            waitingForBlock = false
        })
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_3_query_user() {
        let id = "user001"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(key: "userid", ascending: true)]
        request.predicate = NSPredicate(format: "userid == %@", id)
        let _ = ((try! appDelegate.dataStack.mainContext.fetch(request)) as? [User])
    }
    
}

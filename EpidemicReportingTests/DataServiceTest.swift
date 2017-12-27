//
//  DataServiceTest.swift
//  EpidemicReportingTests
//
//  Created by IBM on 16/12/2017.
//  Copyright © 2017 epidemicreporting.com. All rights reserved.
//

import XCTest
@testable import EpidemicReporting

class DataServiceTest: XCTestCase {
    
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
    
    func test_0_do_login() {
        var waitingForBlock = true
        DataService.sharedInstance.userLogin("user001", pwd: "123456", handler: { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        })
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_1_duty_report() {
        var waitingForBlock = true
        //report
        DataService.sharedInstance.reportMessage("user001", location: "Ning Bo", latitude: "333", longitude: "222", description: "mockup cannotdo", multimedia: ["111","222"]) { (success, error) in
                waitingForBlock = false
                XCTAssert(success, "Login result")
        
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "start-assign-bolck-candnot  task mock",
         "dutyOwner" : null,
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : null,
         "dutyStatus" : null,
         "longitude" : "222",
         "dutyMultiMedia" : null,
         "latitude" : "333",
         "reportTime" : 1514190673000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : null,
         "processTime" : null,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_2_duty_assign() {
        var waitingForBlock = true
        //1. assign
        DataService.sharedInstance.reportAssign("100026", dutyOwner: "user001", dutyDescription: "又要马上开始", dutyStatus: DutyStatus.ASSIGNED.rawValue) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "refrsh the task mockup",
         "dutyOwner" : "user001",
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : "又要马上开始",
         "dutyStatus" : "1",
         "longitude" : "222",
         "dutyMultiMedia" : null,
         "latitude" : "333",
         "reportTime" : 1514191435000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : "张三",
         "processTime" : 1514191491000,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_2_duty_start() {
        var waitingForBlock = true
        //1. start
        DataService.sharedInstance.reportProcess("100026", dutyOwner: "user001", dutyDescription: "我要开始处理疫情", dutyStatus: DutyStatus.START.rawValue, dutyMultiMedia: nil) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "block task mock",
         "dutyOwner" : "user001",
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : "我要开始处理疫情",
         "dutyStatus" : "1",
         "longitude" : "222",
         "dutyMultiMedia" : null,
         "latitude" : "333",
         "reportTime" : 1514189596000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : "张三",
         "processTime" : 1514190097000,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_3_duty_block() {
        var waitingForBlock = true
        //block
        DataService.sharedInstance.reportProcess("100026", dutyOwner: "user001", dutyDescription: "搞不定", dutyStatus: DutyStatus.BLOCK.rawValue, dutyMultiMedia: ["picture 11","picture 12"]) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "block task mock",
         "dutyOwner" : "user001",
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : "搞不定",
         "dutyStatus" : "2",
         "longitude" : "222",
         "dutyMultiMedia" : [
         "picture 11",
         "picture 12"
         ],
         "latitude" : "333",
         "reportTime" : 1514189596000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : "张三",
         "processTime" : 1514190331000,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_4_duty_finish() {
        var waitingForBlock = true
        //finish
        DataService.sharedInstance.reportProcess("100026", dutyOwner: "user001", dutyDescription: "结束处理", dutyStatus: DutyStatus.FINISH.rawValue, dutyMultiMedia: ["picture 4","picture 10"]) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "block task mock",
         "dutyOwner" : "user001",
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : "结束处理",
         "dutyStatus" : "3",
         "longitude" : "222",
         "dutyMultiMedia" : [
         "picture 4",
         "picture 10"
         ],
         "latitude" : "333",
         "reportTime" : 1514189596000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : "张三",
         "processTime" : 1514190549000,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_5_duty_confirm() {
        var waitingForBlock = true
        //confirm
        DataService.sharedInstance.reportConfirm("100025", dutyOwner: "user001", dutyDescription: "非常好，感谢", dutyStatus: DutyStatus.SUCCESS.rawValue, dutyMultiMedia: ["picture 3","picture 5"]) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "Login result")
        }
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
        /*
         {
         "code" : 0,
         "data" : {
         "id" : 100025,
         "description" : "refrsh the task mockup",
         "dutyOwner" : "user001",
         "leaderPoint" : null,
         "leaderComment" : null,
         "dutyDescription" : "非常好，感谢",
         "dutyStatus" : "5",
         "longitude" : "222",
         "dutyMultiMedia" : [
         "picture 3",
         "picture 5"
         ],
         "latitude" : "333",
         "reportTime" : 1514191435000,
         "location" : "Ning Bo",
         "reporter" : "user001",
         "dutyOwnerName" : "张三",
         "processTime" : 1514192119000,
         "reporterName" : "张三",
         "multiMedia" : [
         "111",
         "222"
         ]
         }
         }
         */
    }
    
    func test_6_duty_list_load() {
        var waitingForBlock = true
        DataService.sharedInstance.getAllReports(PullDataType.LOAD.rawValue, filter: nil, param: nil) { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "duty_list")
        }
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_6_duty_status() {
        var waitingForBlock = true
        //
        DataService.sharedInstance.getAllReports(PullDataType.LOAD.rawValue, filter: nil, param: "1514191491000") { (success, error) in
            //
            waitingForBlock = false
            XCTAssert(success, "duty_list")
        }
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_7_upload_image() {
        var waitingForBlock = true
        let image = UIImage.init(named: "loginbg")
        let uuid = UUID().uuidString
        DataService.sharedInstance.uploadImageToServer(uuid, uploadImage: image, handler: { (success, json, error,uuid) in
            print(success)
            waitingForBlock = false
            }, progressHandler: { (uuid,progress) in
                print(progress?.fractionCompleted)
                guard let value = progress?.fractionCompleted else { return }
                if value == 1.0 {
                    print("the uploading complete")
                }
        })
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
}



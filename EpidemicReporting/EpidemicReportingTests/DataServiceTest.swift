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
        DataService.sharedInstance.reportAssign("100007", dutyOwner: "user001", dutyDescription: "给user001新派发一个任务", dutyStatus: DutyStatus.ASSIGNED.rawValue) { (success, error) in
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
        DataService.sharedInstance.reportProcess("100003", dutyOwner: "user001", dutyDescription: "之前说的问题，其他同事已经帮我解决，非常感谢，我又要开始处理", dutyStatus: DutyStatus.START.rawValue, dutyMultiMedia: nil) { (success, error) in
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
        DataService.sharedInstance.reportProcess("100003", dutyOwner: "user001", dutyDescription: "我这里遇到了点情况，需要前线支援", dutyStatus: DutyStatus.BLOCK.rawValue, dutyMultiMedia: ["picture 11","picture 12"]) { (success, error) in
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
        DataService.sharedInstance.reportProcess("100004", dutyOwner: "user001", dutyDescription: "经过努力，终于把这些事情给处理了，我发了一些图片，请确认，如果没有问题，请批准关闭这个case", dutyStatus: DutyStatus.FINISH.rawValue, dutyMultiMedia: ["picture 4","picture 10"]) { (success, error) in
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
        DataService.sharedInstance.reportConfirm("100004", dutyOwner: "user001", dutyDescription: "非常好，感谢，这个情况处理的非常及时", dutyStatus: DutyStatus.SUCCESS.rawValue, dutyMultiMedia: ["picture 3","picture 5"]) { (success, error) in
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
    
    func test_6_duty_Allstatus() {
        var waitingForBlock = true
        //
        DataService.sharedInstance.getReportAllStatus("100004") { (success, json, error) in
            waitingForBlock = false
            XCTAssert(success, "duty_list")
        }
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_7_admin_stuff() {
        var waitingForBlock = true
        //
        DataService.sharedInstance.getStuff() { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "duty_list")
        }
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
    func test_7_get_checkin() {
        var waitingForBlock = true
        //
        DataService.sharedInstance.getMyCheckIn { (success, error) in
            waitingForBlock = false
            XCTAssert(success, "duty_list")
        }
        
        while waitingForBlock {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
        }
    }
    
}



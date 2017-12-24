////
////  DataServiceTest.swift
////  EpidemicReportingTests
////
////  Created by IBM on 16/12/2017.
////  Copyright © 2017 epidemicreporting.com. All rights reserved.
////
//
//import XCTest
//@testable import EpidemicReporting
//
//class DataServiceTest: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//    func test_0_do_login() {
//        var waitingForBlock = true
//        DataService.sharedInstance.userLogin("user001", pwd: "123456", handler: { (success, error) in
//            waitingForBlock = false
//            XCTAssert(success, "Login result")
//        })
//        
//        while waitingForBlock {
//            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
//        }
//    }
//}


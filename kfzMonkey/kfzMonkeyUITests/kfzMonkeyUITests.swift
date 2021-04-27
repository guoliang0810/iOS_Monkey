//
//  kfzMonkeyUITests.swift
//  kfzMonkeyUITests
//
//  Created by 刘国亮 on 2020/9/23.
//  Copyright © 2020 kongfz. All rights reserved.
//

import XCTest
import SwiftMonkey

class kfzMonkeyUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMonkey() {
//        let application = XCUIApplication()
        let application = XCUIApplication.init(bundleIdentifier: "com.kongfz.Kongfz")
        application.launch()
        application.activate()
        print(try!application.snapshot().dictionaryRepresentation)

        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        let monkey = Monkey(frame: application.frame)
//        monkey.addDefaultXCTestPrivateActions()
//        monkey.addXCTestTapAlertAction(interval: 100, application: application)
        NSLog("孔夫子旧书网啦啦啦addXCTestTapAction")
        monkey.addXCTestTapAction(weight: 100)
        
        // Run the monkey test indefinitely
        for index in 0 ..< 100000 {
            print("自动化测试报错次数", index)
            do{
                try monkey.monkeyAround(iterations: 1000)
            } catch {
                print(index)
            }
        }

        // Use recording to get started writing UI tests.

        // Use XCTAssert and related functions to verify your tests produce the correct results.

    }

}

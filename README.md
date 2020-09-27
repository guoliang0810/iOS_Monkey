# iOS_Monkey
 
# 孔网iosmonkey是基于swiftmonkey框架的二次开发

## 1、SwiftMonkey简介

swiftmonkey是国外友人基于 XCUITesting 框架开发的 monkey 工具，是用swift语言写的，SwiftMonkey 把 XCTesting 的私有 API 拿出来用了，直接通过 XCEventGenerator 来模拟事件。源码的GitHub的地址：https://github.com/zalando/SwiftMonkey



## 二次开发思路***

源码Swiftmonkey需要在源码打桩，如果不想改变源码，我们换个思路，可以先借助一个“假”app，在“假”app上建立XCUITesting类，XCUITesting 框架可以调用另一个app。基于这个思路，我们开始go起来。

啦啦啦啦啦啦***

## 2、SwiftMonkey配置

（1）新建一个app，在新app上新建一个target。点击Xcode的file->New->Target，按默认勾选的iOS UI Testing Bundle即可，然后直接next就好了(注意名字要与pod配置target名一致)

（2）打开appNew->Build Phases->TARGETS->appNew-> Target Dependencies，将新建的target关联到项目

（3）在项目中添加SwiftMonkey依赖。进入路径/worksplace/monkeyTest/kfz-ios/src/Kongfz，找到Podfile文件，然后把下列代码粘贴上去。

target "kongfz" do    

    pod "SwiftMonkeyPaws"

end



target "kfzUITests" do

    pod "SwiftMonkey", "~> 2.1.1"

    #    pod 'SwiftMonkey', :git => 'https://github.com/zalando/SwiftMonkey.git'

end



（4）更新项目依赖。进入改文件下，运行pod install，注： 如果出现以下错误就执行‘pod repo update’或者‘pod install --repo-update’



（5）打开新建target下的kfzUITest.swift文件(重要：文件名和pod target名相同)，替换如下代码;

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

        monkey.addXCTestTapAction(weight: 100)

        

        // Run the monkey test indefinitely.

        monkey.monkeyAround(iterations: 1000)

        NSLog("dddd33333333")



        // Use recording to get started writing UI tests.



        // Use XCTAssert and related functions to verify your tests produce the correct results.



    }



}

（6）打开appNew->build settings，把build options的“always embed swift standard libraries”设置为yes（一般默认是yes）



## 三. 更改MonkeyXCTestPrivate.swift中的addXCTestTapAction函数替换私有函数

### 原代码注释掉

//            let semaphore = DispatchSemaphore(value: 0)

//            self!.sharedXCEventGenerator.tapAtTouchLocations(locations, numberOfTaps: numberOfTaps, orientation: orientationValue) {

//                semaphore.signal()

//            }

//            semaphore.wait()

            

### 新增代码

            if #available(iOS 9.0, *) {

                let app = XCUIApplication(bundleIdentifier: "com.kongfz.Kongfz")

                let coordinate = app.coordinate(withNormalizedOffset: CGVector(dx: locations[0].x/(app.frame.maxX/2), dy: locations[0].y/(app.frame.maxY/2)))

                coordinate.tap()



            } else{

                // Fallback on earlier versions

            }

## 四、检查咱孔网代码的运行环境。打开Kongfz>util>netreq>NetReq.h文件，查看是否注释了图片表注的代码，不注释为测试环境，注释了为线上环境。（注释符号//）



## 五、运行测试代码。选择已经连接的设备或模拟器，然后点击Product>Test开始测试，如图所示



# 注意：iOS monkey测试期间，出现崩溃，app会停留在当前页面，不会继续执行测试，建议白天跑，发现崩溃后，重新执行测试。

### 查看日志：
运行结束后，可以到崩溃统计平台上查看日志。友盟的收集有延时，结束后需要等半小时左右。开发看到崩溃日志后，进行修复；修复后可以重复运行命令查看相同的崩溃是否复现。
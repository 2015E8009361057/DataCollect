//
//  ViewController.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/4.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import SQLite


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var motionManager = CMMotionManager()
    var locationManager = CLLocationManager()
    
    // Outlets
    @IBOutlet var accX: UILabel!
    @IBOutlet var accY: UILabel!
    @IBOutlet var accZ: UILabel!
    
    @IBOutlet var rotX: UILabel!
    @IBOutlet var rotY: UILabel!
    @IBOutlet var rotZ: UILabel!
    
    @IBOutlet var magX: UILabel!
    @IBOutlet var magY: UILabel!
    @IBOutlet var magZ: UILabel!
    
    @IBOutlet var longitude: UILabel!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var height: UILabel!
    @IBOutlet var speed: UILabel!
    @IBOutlet var direction: UILabel!
    
    
    func timeStampToDate(timeStampInterval timeStamp: TimeInterval) -> String{
        let timeInterval: TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.string(from: date)
    }
    
    func getUpdateMotionData() {
        // 设置传感器信息更新频率
        print("打印传感器信息")
        let updateInterval = 1.0 / 20
        // 获取 去掉影响因素后的 加速计 和 陀螺仪 信息
        if (motionManager.isDeviceMotionAvailable) {
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
                if let deviceData = data {
                    // 显示加速计信息
                    self.accX.text = String(deviceData.userAcceleration.x)
                    self.accY.text = String(deviceData.userAcceleration.y)
                    self.accZ.text = String(deviceData.userAcceleration.z)
                    
                    // 显示陀螺仪信息
                    self.rotX.text = String(deviceData.rotationRate.x)
                    self.rotY.text = String(deviceData.rotationRate.y)
                    self.rotZ.text = String(deviceData.rotationRate.z)
                    let timeStampInterval = Date().timeIntervalSince1970
                    print("device " + self.timeStampToDate(timeStampInterval: timeStampInterval))
                }
            })
        }
        // 获取磁力计信息
        if (motionManager.isMagnetometerAvailable) {
            motionManager.magnetometerUpdateInterval = updateInterval
            motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
                if let magData = data {
                    // 显示磁力计信息
                    self.magX.text = String(magData.magneticField.x)
                    self.magY.text = String(magData.magneticField.y)
                    self.magZ.text = String(magData.magneticField.z)
                    let timeStampInterval = Date().timeIntervalSince1970
                    print("mag " + self.timeStampToDate(timeStampInterval: timeStampInterval))
                }
            })
        }
    }
    
    func getUpdateLocationData() {
        // Send Authorization Request
        locationManager.requestWhenInUseAuthorization()
        
        // Authorized
        if (CLLocationManager.locationServicesEnabled()) {
            // Set Location Service Agent
            locationManager.delegate = self
            
            // Set Location Accuracy
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            // Set Location Update Interval
            locationManager.distanceFilter = 1
            
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 获取设备传感器信息
        getUpdateMotionData()
        // 获取GPS信息
        getUpdateLocationData()
    }
    
    // 定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("打印GPS信息")
        // 获取最新的坐标
        let currentLocation = locations.last!
        // 获取经度
        longitude.text = String(currentLocation.coordinate.longitude)
        // 获取纬度
        latitude.text = String(currentLocation.coordinate.latitude)
        // 获取高度
        height.text = String(currentLocation.altitude)
        // 获取速度
        speed.text = String(currentLocation.speed)
        print(currentLocation.timestamp)
    }
    
    //方向改变执行
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // 获取方向
        direction.text = String(newHeading.trueHeading)
        print(newHeading.timestamp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        if (CLLocationManager.authorizationStatus() != .denied) {
            print("应用成功拥有定位权限")
        }
        else {
            let alert = UIAlertController(title: "打开定位开关", message: "定位服务未开启，请进入系统设置>隐私>定位服务中打开开关，并允许DataCollect使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) {
                (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) {
                (action) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if (UIApplication.shared.canOpenURL(url! as URL)) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            alert.addAction(tempAction)
            alert.addAction(callAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
 
    */
}


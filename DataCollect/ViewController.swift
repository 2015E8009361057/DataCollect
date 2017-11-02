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
    
    @IBOutlet var switchButton: UISwitch!
    
    @IBAction func recordingDataAccordingSwitchButtonValue(_ sender: UISwitch) {
        if (sender.isOn) {
            // 获取设备传感器信息
            startGetUpdateMotionData()
            // 获取GPS信息
            startGetUpdateLocationData()
        }
        else {
            stopGetUpdateMotionData()
            stopGetUpdateLocationData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        switchButton.setOn(false, animated: true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postJsonObjectToServer(uri URi: String, parameter parameters: Dictionary<String, String>) {
        
        guard let url = URL(string: "http://192.168.1.126:8080/DataServer/" + URi) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("response")
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("json")
                    print(json)
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func timeStampToDate(timeStampInterval timeStamp: TimeInterval) -> String{
        let timeInterval: TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.string(from: date)
    }
    
    // 开始获取加速计、陀螺仪、磁力计信息
    func startGetUpdateMotionData() {
        // 设置传感器信息更新频率
        let updateInterval = 1.0 / 20
        // 获取 去掉影响因素后的 加速计 和 陀螺仪 信息
        if (motionManager.isDeviceMotionAvailable) {
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
                if let deviceData = data {
                    // 获取当前时间
                    let timeStampInterval = Date().timeIntervalSince1970
                    let date = self.timeStampToDate(timeStampInterval: timeStampInterval)
                    
                    let aX = String(deviceData.userAcceleration.x)
                    let aY = String(deviceData.userAcceleration.y)
                    let aZ = String(deviceData.userAcceleration.z)
                    
                    let rX = String(deviceData.rotationRate.x)
                    let rY = String(deviceData.rotationRate.y)
                    let rZ = String(deviceData.rotationRate.z)
                    
                    // 显示加速计信息
                    self.accX.text = aX
                    self.accY.text = aY
                    self.accZ.text = aZ
                    
                    // 显示陀螺仪信息
                    self.rotX.text = rX
                    self.rotY.text = rY
                    self.rotZ.text = rZ
                    
                    let rotationMatrix = deviceData.attitude.rotationMatrix
                    
                    let rotaMatrixM11 = String(rotationMatrix.m11)
                    let rotaMatrixM12 = String(rotationMatrix.m12)
                    let rotaMatrixM13 = String(rotationMatrix.m13)
                    let rotaMatrixM21 = String(rotationMatrix.m21)
                    let rotaMatrixM22 = String(rotationMatrix.m22)
                    let rotaMatrixM23 = String(rotationMatrix.m23)
                    let rotaMatrixM31 = String(rotationMatrix.m31)
                    let rotaMatrixM32 = String(rotationMatrix.m32)
                    let rotaMatrixM33 = String(rotationMatrix.m33)
                    
                    // 插入到数据库 tblDeviceMotion 表中
                    let insertId = DeviceMotionEntity.shared.insert(timeStamp: timeStampInterval, date: date, accelerometerX: deviceData.userAcceleration.x, accelerometerY: deviceData.userAcceleration.y, accelerometerZ: deviceData.userAcceleration.z, gyroscopeX: deviceData.rotationRate.x, gyroscopeY: deviceData.rotationRate.y, gyroscopeZ: deviceData.rotationRate.z, rotationMatrixM11: rotationMatrix.m11, rotationMatrixM12: rotationMatrix.m12, rotationMatrixM13: rotationMatrix.m13, rotationMatrixM21: rotationMatrix.m21, rotationMatrixM22: rotationMatrix.m22, rotationMatrixM23: rotationMatrix.m23, rotationMatrixM31: rotationMatrix.m31, rotationMatrixM32: rotationMatrix.m32, rotationMatrixM33: rotationMatrix.m33)
                    if (insertId != nil) {
                        print("Insert a record to tblDeviceMotion Successfully!")
                    }
                    else {
                        print("Insert a record to tblDeviceMotion failed.")
                    }
                    // 组装要发送的内容
                    let parameters = ["timeStamp" : String(timeStampInterval), "date" : date, "accelerometerX": aX, "accelerometerY" : aY, "accelerometerZ" : aZ, "gyroscopeX" : rX, "gyroscopeY" : rY, "gyroscopeZ" : rZ, "rotationMatrixM11" : rotaMatrixM11, "rotationMatrixM12" : rotaMatrixM12, "rotationMatrixM13" : rotaMatrixM13, "rotationMatrixM21" : rotaMatrixM21, "rotationMatrixM22" : rotaMatrixM22, "rotationMatrixM23" : rotaMatrixM23, "rotationMatrixM31" : rotaMatrixM31, "rotationMatrixM32" : rotaMatrixM32, "rotationMatrixM33" : rotaMatrixM33]
                    
                    // 将数据发送至服务器
                    let URi = "HandleDeviceMotionData"
                    self.postJsonObjectToServer(uri: URi, parameter: parameters)
                }
            })
        }
        // 获取磁力计信息
        if (motionManager.isMagnetometerAvailable) {
            motionManager.magnetometerUpdateInterval = updateInterval
            motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
                if let magData = data {
                    // 获取当前时间
                    let timeStampInterval = Date().timeIntervalSince1970
                    let date = self.timeStampToDate(timeStampInterval: timeStampInterval)
                    
                    let mgX = String(magData.magneticField.x)
                    let mgY = String(magData.magneticField.y)
                    let mgZ = String(magData.magneticField.z)
                    // 显示磁力计信息
                    self.magX.text = mgX
                    self.magY.text = mgY
                    self.magZ.text = mgZ
                    
                    // 插入到数据库 tblMagnetometer 表中
                    let insertId = MagnetometerEntity.shared.insert(timeStamp: timeStampInterval, date: date, magnetometerX: magData.magneticField.x, magnetometerY: magData.magneticField.y, magnetometerZ: magData.magneticField.z)
                    if (insertId != nil) {
                        print("Insert a record to tblMagnetometer Successfully!")
                    }
                    else {
                        print("Insert a record to tblMagnetometer failed.")
                    }
                    // 组装要发送的数据
                    let parameters = ["timeStamp" : String(timeStampInterval), "date" : date, "magnetometerX" : mgX, "magnetometerY" : mgY, "magnetometerZ" : mgZ]
                    // 将数据发送至服务器
                    let URi = "HandleMagnetometerData"
                    self.postJsonObjectToServer(uri: URi, parameter: parameters)
                }
            })
        }
    }
    
    // 停止获取并存储加速计、陀螺仪、磁力计信息
    func stopGetUpdateMotionData() {
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopMagnetometerUpdates()
    }
    
    // 开始获取并存储位置信息
    func startGetUpdateLocationData() {
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
            
            // 调用位置更新函数
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    // 停止获取位置信息
    func stopGetUpdateLocationData() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    // 定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 获取最新的坐标
        let currentLocation = locations.last!
        
        // 获取当前时间
        let timeStampInterval = Date().timeIntervalSince1970
        let date = self.timeStampToDate(timeStampInterval: timeStampInterval)
        
        let log = String(currentLocation.coordinate.longitude)
        let lat = String(currentLocation.coordinate.latitude)
        let hei = String(currentLocation.altitude)
        let spd = String(currentLocation.speed)
        let hoc = String(currentLocation.horizontalAccuracy)
        let vec = String(currentLocation.verticalAccuracy)
        // 获取经度
        longitude.text = log
        // 获取纬度
        latitude.text = lat
        // 获取高度
        height.text = hei
        // 获取速度
        speed.text = spd
        
        // 插入到数据库 tblLocation 表中
        let insertId = LocationEntity.shared.insert(timeStamp: timeStampInterval, date: date, longitude: currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude, height: currentLocation.altitude, speed: currentLocation.speed, horizontalAccuracy: currentLocation.horizontalAccuracy, verticalAccuracy: currentLocation.verticalAccuracy)
        if (insertId != nil) {
            print("Insert a record to tblLocation Successfully!")
        }
        else {
            print("Insert a record to tblLocation failed.")
        }
        // 组装要发送的数据
        let parameters = ["timeStamp" : String(timeStampInterval), "date" : date, "longitude" : log, "latitude" : lat, "height" : hei, "speed" : spd, "horizontalAccuracy" : hoc, "verticalAccuracy" : vec]
        // 将数据发送至服务器
        let URi = "HandleLocationData"
        self.postJsonObjectToServer(uri: URi, parameter: parameters)
    }
    
    //方向改变执行
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // 获取当前时间
        let timeStampInterval = Date().timeIntervalSince1970
        let date = self.timeStampToDate(timeStampInterval: timeStampInterval)
        let trh = String(newHeading.trueHeading)
        let trhA = String(newHeading.headingAccuracy)
        // 获取方向
        direction.text = trh
        
        // 插入到数据库 tblLocationHeading 表中
        let insertId = LocationHeadingEntity.shared.insert(timeStamp: timeStampInterval, date: date, actualDirection: newHeading.trueHeading, directionAccuracy: newHeading.headingAccuracy)
        if (insertId != nil) {
            print("Insert a record to tblLocationHeading Successfully!")
        }
        else {
            print("Insert a record to tblLocationHeading failed.")
        }
        
        // 组装要发送的数据
        let parameters = ["timeStamp" : String(timeStampInterval), "date" : date, "actualDirection" : trh, "directionAccuracy" : trhA]
        // 将数据发送至服务器
        let URi = "HandleLocationHeadingData"
        self.postJsonObjectToServer(uri: URi, parameter: parameters)
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


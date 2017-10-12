//
//  DeviceMotionEntity.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/12.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import Foundation
import SQLite

// Store data of accelerometer and gyroscope
class DeviceMotionEntity {
    static let shared = DeviceMotionEntity()
    
    private let tblDeviceMotion = Table("tblDeviceMotion")
    
    private let id = Expression<Int64>("id");
    
    // Store data of accelermeter
    private let accelerometerX = Expression<Double>("accelerometerX")
    private let accelerometerY = Expression<Double>("accelerometerY")
    private let accelerometerZ = Expression<Double>("accelerometerZ")
    
    // Store data of gyroscope
    private let gyroscopeX = Expression<Double>("gyroscopeX")
    private let gyroscopeY = Expression<Double>("gyroscopeY")
    private let gyroscopeZ = Expression<Double>("gyroscopeZ")
    
    // Store time when get device motion's data
    private let timeStamp = Expression<Double>("timeStamp")
    private let date = Expression<String>("date")
    
    private init() {
        // Create table if not exists
        do {
            if let connection = Database.shared.connection {
                try connection.run(tblDeviceMotion.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(self.id, primaryKey: true)
                    table.column(self.accelerometerX)
                    table.column(self.accelerometerY)
                    table.column(self.accelerometerZ)
                    table.column(self.gyroscopeX)
                    table.column(self.gyroscopeY)
                    table.column(self.gyroscopeZ)
                    table.column(self.timeStamp)
                    table.column(self.date)
                }))
                print("Create table tblDeviceMotion successfully!")
            }
            else {
                print("Create table tblDeviceMotion failed.")
            }
        }
        catch {
            let nserror = error as NSError
            print("Create table tblDeviceMotion failed. Error is: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func toString(deviceMotion: Row) {
        print("""
                Device Motion Details: \n
                Accelerometer Info: \n
                Accelerometer X = \(deviceMotion[self.accelerometerX]) \n
                Accelerometer Y = \(deviceMotion[self.accelerometerY]) \n
                Accelerometer Z = \(deviceMotion[self.accelerometerZ]) \n
                Gyroscope Info: \n
                Gyroscope X = \(deviceMotion[self.gyroscopeX]) \n
                Gyroscope Y = \(deviceMotion[self.gyroscopeY]) \n
                Gyroscope Z = \(deviceMotion[self.gyroscopeZ]) \n
                Date: \n
                TimeStamp = \(deviceMotion[self.timeStamp]) \n
                Date = \(deviceMotion[self.date])
            """)
    }
}










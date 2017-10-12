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
    
    // Store time when get device motion's data
    private let timeStamp = Expression<Double>("timeStamp")
    private let date = Expression<String>("date")
    
    // Store data of accelermeter
    private let accelerometerX = Expression<Double>("accelerometerX")
    private let accelerometerY = Expression<Double>("accelerometerY")
    private let accelerometerZ = Expression<Double>("accelerometerZ")
    
    // Store data of gyroscope
    private let gyroscopeX = Expression<Double>("gyroscopeX")
    private let gyroscopeY = Expression<Double>("gyroscopeY")
    private let gyroscopeZ = Expression<Double>("gyroscopeZ")
    
    // Store data of rotationMatrix
    private let rotationMatrixM11 = Expression<Double>("rotationMatrixM11")
    private let rotationMatrixM12 = Expression<Double>("rotationMatrixM12")
    private let rotationMatrixM13 = Expression<Double>("rotationMatrixM13")
    private let rotationMatrixM21 = Expression<Double>("rotationMatrixM21")
    private let rotationMatrixM22 = Expression<Double>("rotationMatrixM22")
    private let rotationMatrixM23 = Expression<Double>("rotationMatrixM23")
    private let rotationMatrixM31 = Expression<Double>("rotationMatrixM31")
    private let rotationMatrixM32 = Expression<Double>("rotationMatrixM32")
    private let rotationMatrixM33 = Expression<Double>("rotationMatrixM33")
    
    private init() {
        // Create table if not exists
        do {
            if let connection = Database.shared.connection {
                try connection.run(tblDeviceMotion.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(self.id, primaryKey: true)
                    table.column(self.timeStamp)
                    table.column(self.date)
                    table.column(self.accelerometerX)
                    table.column(self.accelerometerY)
                    table.column(self.accelerometerZ)
                    table.column(self.gyroscopeX)
                    table.column(self.gyroscopeY)
                    table.column(self.gyroscopeZ)
                    table.column(self.rotationMatrixM11)
                    table.column(self.rotationMatrixM12)
                    table.column(self.rotationMatrixM13)
                    table.column(self.rotationMatrixM21)
                    table.column(self.rotationMatrixM22)
                    table.column(self.rotationMatrixM23)
                    table.column(self.rotationMatrixM31)
                    table.column(self.rotationMatrixM32)
                    table.column(self.rotationMatrixM33)
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
    
    // Insert a record to tblDeviceMotion
    func insert(timeStamp: Double, date: String, accelerometerX: Double, accelerometerY: Double, accelerometerZ: Double, gyroscopeX: Double, gyroscopeY: Double, gyroscopeZ: Double, rotationMatrixM11: Double, rotationMatrixM12: Double, rotationMatrixM13: Double, rotationMatrixM21: Double, rotationMatrixM22: Double, rotationMatrixM23: Double, rotationMatrixM31: Double, rotationMatrixM32: Double, rotationMatrixM33: Double) -> Int64? {
        do {
            let insert = tblDeviceMotion.insert(self.timeStamp <- timeStamp,
                                                self.date <- date,
                                                self.accelerometerX <- accelerometerX,
                                                self.accelerometerY <- accelerometerY,
                                                self.accelerometerZ <- accelerometerZ,
                                                self.gyroscopeX <- gyroscopeX,
                                                self.gyroscopeY <- gyroscopeY,
                                                self.gyroscopeZ <- gyroscopeZ,
                                                self.rotationMatrixM11 <- rotationMatrixM11,
                                                self.rotationMatrixM12 <- rotationMatrixM12,
                                                self.rotationMatrixM13 <- rotationMatrixM13,
                                                self.rotationMatrixM21 <- rotationMatrixM21,
                                                self.rotationMatrixM22 <- rotationMatrixM22,
                                                self.rotationMatrixM23 <- rotationMatrixM23,
                                                self.rotationMatrixM31 <- rotationMatrixM31,
                                                self.rotationMatrixM32 <- rotationMatrixM32,
                                                self.rotationMatrixM33 <- rotationMatrixM33)
            let insertId = try Database.shared.connection!.run(insert)
            return insertId
        }
        catch {
            let nserror = error as NSError
            print("Cannot insert new DeviceMotion. Error is: \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    // Query (find) all records in tblDeviceMotion
    func queryAll() -> AnySequence<Row>? {
        do {
            return try Database.shared.connection?.prepare(self.tblDeviceMotion)
        }
        catch {
            let nserror = error as NSError
            print("Cannot query(list) all tblDeviceMotion. Error is: \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func toString(deviceMotion: Row) {
        print("""
                Device Motion Details: \n
                TimeStamp = \(deviceMotion[self.timeStamp]) \n
                Date = \(deviceMotion[self.date]) \n
                Accelerometer Info: \n
                Accelerometer X = \(deviceMotion[self.accelerometerX]) \n
                Accelerometer Y = \(deviceMotion[self.accelerometerY]) \n
                Accelerometer Z = \(deviceMotion[self.accelerometerZ]) \n
                Gyroscope Info: \n
                Gyroscope X = \(deviceMotion[self.gyroscopeX]) \n
                Gyroscope Y = \(deviceMotion[self.gyroscopeY]) \n
                Gyroscope Z = \(deviceMotion[self.gyroscopeZ]) \n
                Rotation Matrix M11 = \(deviceMotion[self.rotationMatrixM11]) \n
                Rotation Matrix M12 = \(deviceMotion[self.rotationMatrixM12]) \n
                Rotation Matrix M13 = \(deviceMotion[self.rotationMatrixM13]) \n
                Rotation Matrix M21 = \(deviceMotion[self.rotationMatrixM21]) \n
                Rotation Matrix M22 = \(deviceMotion[self.rotationMatrixM22]) \n
                Rotation Matrix M23 = \(deviceMotion[self.rotationMatrixM23]) \n
                Rotation Matrix M31 = \(deviceMotion[self.rotationMatrixM31]) \n
                Rotation Matrix M32 = \(deviceMotion[self.rotationMatrixM32]) \n
                Rotation Matrix M33 = \(deviceMotion[self.rotationMatrixM33])
            """)
    }
}










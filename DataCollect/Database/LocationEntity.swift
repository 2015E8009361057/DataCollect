//
//  LocationEntity.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/12.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import Foundation
import SQLite

class LocationEntity {
    static let shared = LocationEntity()
    
    private let tblLocation = Table("tblLocation")
    
    private let id = Expression<Int64>("id")
    // 时间戳
    private let timeStamp = Expression<Double>("timeStamp")
    // 时间（精确到秒）
    private let date = Expression<String>("date")
    // 经度
    private let longitude = Expression<Double>("longitude")
    // 纬度
    private let latitude = Expression<Double>("latitude")
    // 高度（海拔）
    private let height = Expression<Double>("height")
    // 速度
    private let speed = Expression<Double>("speed")
    // 水平精度
    private let horizontalAccuracy = Expression<Double>("horizontalAccuracy")
    // 垂直精度
    private let verticalAccuracy = Expression<Double>("verticalAccuracy")
    
    private init() {
        // Create table if not exists
        do {
            if let connection = Database.shared.connection {
                try connection.run(tblLocation.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(table) in
                    table.column(self.id, primaryKey: true)
                    table.column(self.timeStamp)
                    table.column(self.date)
                    table.column(self.longitude)
                    table.column(self.latitude)
                    table.column(self.height)
                    table.column(self.speed)
                    table.column(self.horizontalAccuracy)
                    table.column(self.verticalAccuracy)
                }))
                print("Create table tblLocation successfully!")
            }
            else {
                print("Create table tblLocation failed.")
            }
        }
        catch {
            let nserror = error as NSError
            print("Create table tblLocation failed. Error is: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func toString(location: Row) {
        print("""
            Location Info: \n
            TimeStamp = \(location[self.timeStamp]) \n
            Date = \(location[self.date]) \n
            Longitude = \(location[self.longitude]) \n
            Latitude = \(location[self.latitude]) \n
            Height = \(location[self.height]) \n
            Speed = \(location[self.speed]) \n
            Horizontal Accuracy = \(location[self.horizontalAccuracy]) \n
            Vertical Accuracy = \(location[self.verticalAccuracy])
            """)
    }
}

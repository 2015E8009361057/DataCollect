//
//  LocationHeadingEntity.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/12.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import Foundation
import SQLite

class LocationHeadingEntity {
    static let shared = LocationHeadingEntity()
    
    private let tblLocationHeading = Table("tblLocationHeading")
    
    private let id = Expression<Int64>("id")
    
    // 时间戳
    private let timeStamp = Expression<Double>("timeStamp")
    // 时间（精确到秒）
    private let date = Expression<String>("date")
    // 真实方向
    private let actualDirection = Expression<Double>("actualDirection")
    // 方向精度
    private let directionAccuracy = Expression<Double>("directionAccuracy")
    
    private init() {
        // Create table if not exists
        do {
            if let connection = Database.shared.connection {
                try connection.run(tblLocationHeading.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {(table) in
                    table.column(self.id, primaryKey: true)
                    table.column(self.timeStamp)
                    table.column(self.date)
                    table.column(self.actualDirection)
                    table.column(self.directionAccuracy)
                }))
                print("Create table tblLocationHeading successfully!")
            }
            else {
                print("Create table tblLocationHeading failed.")
            }
        }
        catch {
            let nserror = error as NSError
            print("Create table tblLocationHeading failed. Error is: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func toString(locationHeading: Row) {
        print("""
            Location Heading Info: \n
            TimeStamp = \(locationHeading[self.timeStamp]) \n
            Date = \(locationHeading[self.date]) \n
            Actual Direction = \(locationHeading[self.actualDirection]) \n
            Direction Accuracy = \(locationHeading[self.directionAccuracy])
            """)
    }
}

//
//  MagnetometerEntity.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/12.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import Foundation
import SQLite

class MagnetometerEntity {
    static let shared = MagnetometerEntity()
    
    private let tblMagnetometer = Table("tblMagnetometer")
    
    private let id = Expression<Int64>("id");
    
    // Store time when get magnetometer's data
    private let timeStamp = Expression<Double>("timeStamp")
    private let date = Expression<String>("date")
    
    // Store data of magnetometer
    private let magnetometerX = Expression<Double>("magnetometerX")
    private let magnetometerY = Expression<Double>("magnetometerY")
    private let magnetometerZ = Expression<Double>("magnetometerZ")
    
    private init() {
        // Create table if not exists
        do {
            if let connection = Database.shared.connection {
                try connection.run(tblMagnetometer.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {
                    (table) in
                    table.column(self.id, primaryKey: true)
                    table.column(self.magnetometerX)
                    table.column(self.magnetometerY)
                    table.column(self.magnetometerZ)
                    table.column(self.timeStamp)
                    table.column(self.date)
                }))
                print("Create table tblMagnetometer successfully!")
            }
            else {
                print("Create table tblMagnetometer failed.")
            }
        }
        catch {
            let nserror = error as NSError
            print("Create table tblMagnetometer failed. Error is: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func toString(magnetometer: Row) {
        print("""
            Magnetometer Info: \n
            TimeStamp = \(magnetometer[self.timeStamp]) \n
            Date = \(magnetometer[self.date]) \n
            Magnetometer X = \(magnetometer[self.magnetometerX]) \n
            Magnetometer Y = \(magnetometer[self.magnetometerY]) \n
            Magnetometer Z = \(magnetometer[self.magnetometerZ])
            """)
    }
}

//
//  Database.swift
//  DataCollect
//
//  Created by 曾庆玺 on 2017/10/12.
//  Copyright © 2017年 曾庆玺. All rights reserved.
//

import Foundation
import SQLite

class Database {
    static let shared = Database()
    public let connection: Connection?
    public let databaseFileName = "SensorDatabase.sqlite3"
    private init() {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        do {
            connection = try Connection("\(dbPath!)/(databaseFileName)")
        }
        catch {
            connection = nil
            let nserror = error as NSError
            print("Cannot connect to Database. Error is \(nserror), \(nserror.userInfo)")
        }
    }
}

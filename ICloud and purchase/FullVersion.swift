//
//  FullVersion.swift
//  PetMaster
//
//  Created by Fedor Sychev on 20.08.2021.
//

import Foundation

class AppVersion {
    static var isFullVersion = false
    
    static func CheckFullVersion() {
        CloudHelper.GetFullVersionFromCloud()
    }
}

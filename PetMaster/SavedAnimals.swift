//
//  SavedAnimals.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import Foundation
import UIKit

enum DefaultKeys{
    static let savedData = "SavedData"
    static let savedSettings = "SavedSettings"
    static let savedExpenditures = "SavedExpenditures"
    static let savedVersion = "SavedVersion"
}

enum StatusSort: String, Decodable, Encodable {
    case up = "up"
    case down = "down"
}

struct SavedAnimals: Codable {
    var animals: [Animal]
}

struct Settings: Codable {
    var sort: StatusSort
    var dateFormat: String
    var backgroundImage: String
    var headerColor_red: Float
    var headerColor_green: Float
    var headerColor_blut: Float
    var cellBackground_red: Float
    var cellBackground_green: Float
    var cellBackground_blue: Float
    var isShared: Bool
}

struct Money: Codable {
    var allExpenditures: [Expenditure]
}

struct FullVersion: Codable {
    var isFullVersion: Bool
}

class Saved {
    static var shared = Saved()
    
    private var baseSave = SavedAnimals(animals: [])
    
    private var baseSettings = Settings(sort: .down, dateFormat: "dd/MM/YYYY", backgroundImage: "Background1", headerColor_red: 255, headerColor_green: 171, headerColor_blut: 74, cellBackground_red: 233, cellBackground_green: 92, cellBackground_blue: 19, isShared: false)
    
    private var baseExpenditures = Money(allExpenditures: [])
    
    var currentSettings: Settings{
        get{
            if let data = UserDefaults.standard.object(forKey: DefaultKeys.savedSettings) as? Data{
                do{
                    return try PropertyListDecoder().decode(Settings.self, from: data)
                }
                catch{
                    self.reserSettings()
                }
            } else {
                return baseSettings
            }
            return baseSettings
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: DefaultKeys.savedSettings)
            }
        }
    }
    
    var currentSaves: SavedAnimals{
        get{
            if let data = UserDefaults.standard.object(forKey: DefaultKeys.savedData) as? Data{
                do{
                    return try PropertyListDecoder().decode(SavedAnimals.self, from: data)
                }
                catch {
                    self.resetSaves()
                }
                }
            else{
                return baseSave
            }
            return baseSave
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: DefaultKeys.savedData)
            }
        }
    }
    
    var currentExpenditures: Money {
        get {
            if let data = UserDefaults.standard.object(forKey: DefaultKeys.savedExpenditures) as? Data{
                do{
                    return try PropertyListDecoder().decode(Money.self, from: data)
                }
                catch {
                    self.resetExpenditures()
                }
                }
            else{
                return baseExpenditures
            }
            return baseExpenditures
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: DefaultKeys.savedExpenditures)
            }
        }
    }
    
    var currentVersion: FullVersion {
        get {
            if let data = UserDefaults.standard.object(forKey: DefaultKeys.savedVersion) as? Data{
                do{
                    
                    let result = try PropertyListDecoder().decode(FullVersion.self, from: data)
                    if result.isFullVersion == true {
                        return result
                    } else {
                        if AppVersion.isFullVersion {
                            return FullVersion.init(isFullVersion: true)
                        } else {
                            return FullVersion.init(isFullVersion: false)
                        }
                    }
                }
                catch {
                    //try to get data from icloud
                    if AppVersion.isFullVersion {
                        return FullVersion.init(isFullVersion: true)
                    } else {
                        return FullVersion.init(isFullVersion: false)
                    }
                }
                }
            else{
                //try to get data from icloud
                //AppVersion.CheckFullVersion()
                if AppVersion.isFullVersion {
                    return FullVersion.init(isFullVersion: true)
                } else {
                    return FullVersion.init(isFullVersion: false)
                }
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: DefaultKeys.savedVersion)
            }
        }
    }
    
    private func resetSaves() {
        Saved.shared.currentSaves = baseSave
    }
    
    func reserSettings() {
        if Saved.shared.currentSettings.isShared {
            Saved.shared.currentSettings = baseSettings
            Saved.shared.currentSettings.isShared = true
        } else {
            Saved.shared.currentSettings = baseSettings
        }
    }
    
    func resetExpenditures() {
        Saved.shared.currentExpenditures = baseExpenditures
    }
}

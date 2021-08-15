//
//  SavedAnimals.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import Foundation

enum DefaultKeys{
    static let savedData = "SavedData"
    static let savedSettings = "SavedSettings"
    static let savedExpenditures = "SavedExpenditures"
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
}

struct Money: Codable {
    var allExpenditures: [Expenditure]
}

class Saved {
    static var shared = Saved()
    
    private var baseSave = SavedAnimals(animals: [])
    
    private var baseSettings = Settings(sort: .down, dateFormat: "dd/MM/YYYY")
    
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
    
    private func resetSaves() {
        Saved.shared.currentSaves = baseSave
    }
    
    func reserSettings() {
        Saved.shared.currentSettings = baseSettings
    }
    
    func resetExpenditures() {
        Saved.shared.currentExpenditures = baseExpenditures
    }
}

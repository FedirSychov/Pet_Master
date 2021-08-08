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
}

enum StatusSort: String, Decodable, Encodable{
    case up = "up"
    case down = "down"
    case nilsort = "nilsort"
}

struct SavedAnimals: Codable{
    var animals: [Animal]
}

struct Settings: Codable{
    var sort: StatusSort
}

class Saved{
    static var shared = Saved()
    
    private var baseSave = SavedAnimals(animals: [])
    
    private var baseSettings = Settings(sort: .down)
    
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
    
    private func resetSaves(){
        Saved.shared.currentSaves = baseSave
    }
    
    private func reserSettings(){
        
    }
}

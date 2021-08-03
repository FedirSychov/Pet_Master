//
//  SavedAnimals.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import Foundation

enum DefaultKeys{
    static let savedData = "SavedData"
}

struct SavedAnimals: Codable{
    var animals: [Animal]
}

class Saved{
    static var shared = Saved()
    
    private var baseSave = SavedAnimals(animals: [])
    
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
}

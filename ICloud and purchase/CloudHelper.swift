//
//  CloudHelper.swift
//  PetMaster
//
//  Created by Fedor Sychev on 19.08.2021.
//

import Foundation
import CloudKit

class CloudHelper {
    
    struct CloudKeys {
        static let recordType = "MainSettings"
        static let recordKey = "Settings"
        static let recordKeyVersion = "FullVersion"
        static let AnimalsRecordID = CKRecord.ID(recordName: "CurrentAnimalList")
        static let SettingsReCordID = CKRecord.ID(recordName: "CurrentSettings")
        static let ExpendituresRecordID = CKRecord.ID(recordName: "CurrentExpenditures")
        static let FullVersionRecordID = CKRecord.ID(recordName: "FullVersion")
    }
    
    static let dataBase = CKContainer(identifier: "iCloud.petmasterstorage").privateCloudDatabase
    
    static func SaveToCloud(animal: [Animal]) {
        let newAnimal = CKRecord(recordType: CloudKeys.recordType, recordID: CloudKeys.AnimalsRecordID)
        if let data = try? PropertyListEncoder().encode(animal) {
            newAnimal.setValue(data, forKey: CloudKeys.recordKey)
        }
        
        dataBase.save(newAnimal) { record, error in
            print("record id: \(String(describing: record?.recordID))")
            print(error ?? "No errors")
            guard record != nil else { return }
        }
    }
    
    static func SaveFullVersionToCloud(fullVersion: Bool) {
        let FullVersion = CKRecord(recordType: CloudKeys.recordType, recordID: CloudKeys.FullVersionRecordID)
        
            FullVersion.setValue(fullVersion, forKey: CloudKeys.recordKeyVersion)
        
        dataBase.save(FullVersion) { record, error in
            print("record id: \(String(describing: record?.recordID))")
            print(error ?? "No errors")
            guard record != nil else { return }
        }
    }
    
    static func GetFullVersionFromCloud() {
        let recordid = CloudKeys.FullVersionRecordID
        
        let refs = CKRecord.Reference(recordID: recordid, action: .none)
        let pred1 = NSPredicate(format: "recordID = %@", refs)
        let query = CKQuery(recordType: CloudKeys.recordType, predicate: pred1)
        dataBase.perform(query, inZoneWith: nil) { records, error in
            guard let record = records else { return }
            if record.count > 0 {
                if record[0].value(forKey: CloudKeys.recordKeyVersion) as! Int == 1 {
                    AppVersion.isFullVersion = true
                }
            } else {
                AppVersion.isFullVersion = false
            }
        }
    }
    
    static func SaveAllToCloud(animal: [Animal], exps: [Expenditure], settings: Settings) {
        let newAnimal = CKRecord(recordType: CloudKeys.recordType, recordID: CloudKeys.AnimalsRecordID)
        
        if let data = try? PropertyListEncoder().encode(animal) {
            newAnimal.setValue(data, forKey: CloudKeys.recordKey)
        }
        
        
        let newExp = CKRecord(recordType: CloudKeys.recordType, recordID: CloudKeys.ExpendituresRecordID)
        
        if let data_exp = try? PropertyListEncoder().encode(exps) {
            newExp.setValue(data_exp, forKey: CloudKeys.recordKey)
        }
        
        
        let newSettings = CKRecord(recordType: CloudKeys.recordType, recordID: CloudKeys.SettingsReCordID)
        
        if let data_settings = try? PropertyListEncoder().encode(settings) {
            newSettings.setValue(data_settings, forKey: CloudKeys.recordKey)
        }
        
        
        dataBase.save(newAnimal) { record, error in
            print("record id: \(String(describing: record?.recordID))")
            print(error ?? "No errors")
            guard record != nil else { return }
        }
        
        dataBase.save(newExp) { record, error in
            print("record id: \(String(describing: record?.recordID))")
            print(error ?? "no errors")
            guard record != nil else { return }
        }
        
        dataBase.save(newSettings) { record, error in
            print("record id: \(String(describing: record?.recordID))")
            print(error ?? "no errors")
            guard record != nil else { return }
        }
    }
    
    static func delete(recordID: CKRecord.ID) {
        dataBase.delete(withRecordID: recordID) { recordid, error in
            if let err = error {
                print(err)
                return
            }
            guard recordid != nil else {
                return
            }
        }
    }
    
    static func QueryAnimalsDataBase() {
        let recordid = CloudKeys.AnimalsRecordID
        
        let refs = CKRecord.Reference(recordID: recordid, action: .none)
        let pred1 = NSPredicate(format: "recordID = %@", refs)
        
        let query = CKQuery(recordType: CloudKeys.recordType, predicate: pred1)
        dataBase.perform(query, inZoneWith: nil) { records, error in
            guard let record = records else { return }
            if record.count > 0 {
                let temp: [Animal] = try! PropertyListDecoder().decode([Animal].self, from: record[0].value(forKey: CloudKeys.recordKey) as! Data)
                Saved.shared.currentSaves.animals = temp
            }
        }
    }
    
    static func QueryExpendituresDataBase() {
        let recordid = CloudKeys.ExpendituresRecordID
        
        let refs = CKRecord.Reference(recordID: recordid, action: .none)
        let pred1 = NSPredicate(format: "recordID = %@", refs)
        
        
        let query = CKQuery(recordType: CloudKeys.recordType, predicate: pred1)
        dataBase.perform(query, inZoneWith: nil) { records, error in
            guard let record = records else { return }
            
            if record.count > 0 {
                let temp: [Expenditure] = try! PropertyListDecoder().decode([Expenditure].self, from: record[0].value(forKey: CloudKeys.recordKey) as! Data)
                
                Saved.shared.currentExpenditures.allExpenditures = temp
            }
        }
    }
    
    static func QuerySettingsDataBase() {
        let recordid = CloudKeys.SettingsReCordID
        
        let refs = CKRecord.Reference(recordID: recordid, action: .none)
        let pred1 = NSPredicate(format: "recordID = %@", refs)
        
        
        let query = CKQuery(recordType: CloudKeys.recordType, predicate: pred1)
        dataBase.perform(query, inZoneWith: nil) { records, error in
            guard let record = records else { return }
            
            if record.count > 0 {
                let temp = try! PropertyListDecoder().decode(Settings.self, from: record[0].value(forKey: CloudKeys.recordKey) as! Data)
                
                Saved.shared.currentSettings = temp
            }
        }
    }
    
    static func ModifyAnimals(recordid: CKRecord.ID, animals: [Animal]) {
        CloudHelper.delete(recordID: recordid)
        CloudHelper.SaveToCloud(animal: animals)
    }
    
    static func ModifyAll(animals: [Animal], exps: [Expenditure], settings: Settings) {
        CloudHelper.delete(recordID: CloudKeys.AnimalsRecordID)
        CloudHelper.delete(recordID: CloudKeys.ExpendituresRecordID)
        CloudHelper.delete(recordID: CloudKeys.SettingsReCordID)
        sleep(1)
        SaveAllToCloud(animal: animals, exps: exps, settings: settings)
    }
}

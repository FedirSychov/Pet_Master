//
//  ExportAnimalInfo.swift
//  PetMaster
//
//  Created by Fedor Sychev on 27.08.2021.
//

import Foundation

class ExportAnimals {
    
    static func ExportInfo(currentAnimal: Animal) -> String {
        var result: String = ""
        result += "\(NSLocalizedString("animal_name", comment: ""))\(currentAnimal.name)\n"
        result += "\(NSLocalizedString("animal_type", comment: ""))\(currentAnimal.animal_breed!)\n"
        result += "\(NSLocalizedString("animal_age", comment: ""))\(currentAnimal.animal_full_age!)\n\n"
        result += "\(NSLocalizedString("vaccinations_button", comment: "")):\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Saved.shared.currentSettings.dateFormat
        
        for vacc in currentAnimal.vaccinations_list {
            result += "- \(vacc.name):\n"
            result += "    \(NSLocalizedString("date", comment: "")): \(dateFormatter.string(from: vacc.date))\n"
        }
        result += "\n"
        
        result += "\(NSLocalizedString("diseases", comment: "")):\n"
        for disease in currentAnimal.disease_list {
            result += "- \(disease.name):\n"
            result += "    \(NSLocalizedString("date", comment: "")): \(dateFormatter.string(from: disease.data_of_disease))\n"
            result += "    \(NSLocalizedString("days_last", comment: ""))\(disease.days_of_disease)\n"
            result += "    \(NSLocalizedString("medicines", comment: ""))\(disease.medicines)\n"
        }
        return result
    }
}

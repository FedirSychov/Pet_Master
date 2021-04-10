//
//  Animals.swift
//  TestConsole
//
//  Created by Fedor Sychev on 08.03.2021.
//

import Foundation

//класс болезни
class Disease {
    var name: String
    var description: String?
    var data_of_disease: Date
    var medicines: String?
//    Базовый конструктор
    init(name: String, data_d: String?, description: String?, meds: String?) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let my_date = data_f.date(from: data_d!) else {
            fatalError()
        }
        self.name = name
        if data_d == nil {
            self.data_of_disease = Date()
        }
        else {
            self.data_of_disease = my_date
        }
    }
//    вывод информации о болезни
    func showDiseaseInfo () -> String {
        return "Болезнь: \(self.name), дата: \(self.data_of_disease))"
    }
}
//класс прививок
class Vaccination {
    var name: String
    var description: String?
    var date: Date
    
    init(name: String, descrpit: String?, date: String?) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let my_date = data_f.date(from: date!) else {
            fatalError()
        }
        if date == nil {
            self.date = Date()
        } else {
            self.date = my_date
        }
        self.name = name
        self.description = descrpit
    }
    //вывод информации о прививке
    func showVaccinationInfo() -> String {
        if (self.description != nil) {
            return "Прививка: \(self.name), описание: \(self.description!), дата: \(self.date)"
        } else {
            return "Прививка: \(self.name), дата: \(self.date)"
        }
    }
}
//класс события в жизни питомца
class Event {
    var name: String
    var date: Date
    var description: String?
    //конструктор
    init(name: String, date: String, descr: String?) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let my_date = data_f.date(from: date) else {
            fatalError()
        }
        self.name = name
        self.date = my_date
        self.description = descr
    }
}
//класс домашнего животного
class Animal {
    var name: String
    var date_of_birth: Date
    var animal_age: Int
    var animal_type: String
    var animal_breed: String?
    var food: String?
    var additional_info: String?
    var vaccinations_list = [Vaccination]()
    var disease_list = [Disease]()
    var events_list = [Event]()
//    конструктор для 3 элементов
    init(name: String, birthday: String, type: String) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let my_date = data_f.date(from: birthday) else {
            fatalError()
        }
        self.date_of_birth = my_date
        self.name = name
        let ageComponents = Calendar.current.dateComponents([.year], from: date_of_birth, to: Date())
        self.animal_age = ageComponents.year!
        self.animal_type = type
    }
//    конструктор для 4 элементов
    init(name: String, birthday: String, type: String, breed: String) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let my_date = data_f.date(from: birthday) else {
            fatalError()
        }
        self.date_of_birth = my_date
        self.name = name
        let ageComponents = Calendar.current.dateComponents([.year], from: date_of_birth, to: Date())
        self.animal_age = ageComponents.year!
        self.animal_type = type
        self.animal_breed = breed
    }
//    вывод общей информации
    func showInfo() -> String {
        var all_info: String
        if self.animal_breed == nil {
            all_info = "\(self.name), \(self.animal_age) years old, \(self.animal_type), status: "
        }
        else {
        all_info = "\(self.name), \(self.animal_age) years old, \(self.animal_breed!), \(self.animal_type), status: "
        }
//        Перевод на человеческие годы, если это собака
        if self.animal_type == "dog" {
            all_info.append(", возраст на человеческие годы: \(String(Int(log(Double(self.animal_age))*16 + 31)))")
        }
        return all_info
    }
//    метод добавления болезни в список болезней
    func add_disease(disease_name: String, disease_date: String?, description: String?, meds: String?) {
        let new_disease = Disease(name: disease_name, data_d: disease_date, description: description, meds: meds)
        self.disease_list.insert(new_disease, at: 0)
    }
//    метод добавления прививки в список
    func add_vaccination(vacc_name: String, vac_date: String?, description: String?) {
        let new_vaccination = Vaccination(name: vacc_name, descrpit: description, date: vac_date)
        self.vaccinations_list.insert(new_vaccination, at: 0)
    }
//    метод добавления события в список
    func add_event(event_name: String, event_date: String, event_descrtiption: String?) {
        let new_event = Event(name: event_name, date: event_date, descr: event_descrtiption)
        self.events_list.insert(new_event, at: 0)
    }
}

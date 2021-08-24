//
//  Animals.swift
//  TestConsole
//
//  Created by Fedor Sychev on 08.03.2021.
//

import Foundation

//другие нужные функции
class OtherFunctions{
    static func getRandomString(length: Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

//MARK: - Disease class
class Disease: Codable, Equatable {
    static func == (lhs: Disease, rhs: Disease) -> Bool {
        return lhs.name == rhs.name && lhs.data_of_disease == rhs.data_of_disease && lhs.date_of_end == rhs.date_of_end && lhs.description == rhs.description && lhs.medicines == rhs.medicines
    }
    
    var name: String
    var description: String
    var data_of_disease: Date
    var date_of_end: Date?
    var medicines: String
    var days_of_disease: Int
//    Базовый конструктор
    init(name: String, data_d: String, date_end: String?, description: String, meds: String) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let my_date = data_f.date(from: data_d)
        let my_end_date: Date? = data_f.date(from: date_end!)
        self.name = name
        self.description = description
        self.data_of_disease = my_date!
        self.date_of_end = my_end_date ?? nil
        self.medicines = meds
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: my_date!), to: calendar.startOfDay(for: my_end_date!))
        self.days_of_disease = components.day!
    }
    init(name: String, data_d: String, description: String, meds: String) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let my_date = data_f.date(from: data_d)
        self.name = name
        self.description = description
        self.data_of_disease = my_date!
        self.date_of_end = nil
        self.medicines = meds
        self.days_of_disease = 0
    }
    func reloadDays(){
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let my_date = self.data_of_disease
        let my_end_date = self.date_of_end
        let calendar = NSCalendar.current
        if self.date_of_end != nil{
            let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: my_date), to: calendar.startOfDay(for: my_end_date!))
            self.days_of_disease = components.day!
        } else {
            let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: my_date), to: calendar.startOfDay(for: Date()))
            self.days_of_disease = components.day!
        }
    }
//    вывод информации о болезни
    func showDiseaseInfo () -> String {
        return "Болезнь: \(self.name), дата: \(self.data_of_disease))"
    }
}

//MARK: - Vaccination class
class Vaccination: Codable, Equatable {
    static func == (lhs: Vaccination, rhs: Vaccination) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date && lhs.description == rhs.description
    }
    
    var name: String
    var description: String?
    var date: Date
    
    init(name: String, descrpit: String?, date: String?) {
        let data_f = DateFormatter()
        data_f.dateFormat = "dd-MM-yyyy"
        data_f.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let my_date = data_f.date(from: date!)
        if date == nil {
            self.date = Date()
        } else {
            self.date = my_date!
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

//MARK: - event class
class Event: Codable, Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date && lhs.description == rhs.description
    }
    
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

//MARK: - animal class
class Animal: Codable, Equatable {
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.name == rhs.name && lhs.animal_type == rhs.animal_type && lhs.date_of_birth == rhs.date_of_birth
    }
    
    var name: String
    var date_of_birth: Date
    var animal_age: Int
    var animal_full_age: String?
    var animal_type: String
    var animal_breed: String?
    var food: String?
    var additional_info: String?
    var vaccinations_list = [Vaccination]()
    var disease_list = [Disease]()
    var events_list = [Event]()
    var animal_image: String?
    var date_of_death: Date?
    var deathComment: String?
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
            all_info = "\(self.name), \(self.animal_type)"
        }
        else {
        all_info = "\(self.name), \(self.animal_breed!), \(self.animal_type)"
        }
//        Перевод на человеческие годы, если это собака
        if self.animal_type == "dog" {
            all_info.append(", возраст на человеческие годы: \(String(Int(log(Double(self.animal_age))*16 + 31)))")
        }
        return all_info
    }
//    метод обновления полного возраста
    func UpdateAge() -> Bool{
        var ageComponents = Calendar.current.dateComponents([.year, .month, .day], from: date_of_birth, to: Date())
        if self.date_of_death == nil {
            ageComponents = Calendar.current.dateComponents([.year, .month, .day], from: date_of_birth, to: Date())
        } else {
            ageComponents = Calendar.current.dateComponents([.year, .month, .day], from: date_of_birth, to: self.date_of_death!)
        }
        var new_full_age: String

        new_full_age = "\(ageComponents.year!)\(NSLocalizedString("years", comment: "")), \(ageComponents.month!)\(NSLocalizedString("monthes", comment: "")), \(ageComponents.day!)\(NSLocalizedString("days", comment: ""))"
        
        if ageComponents.year! <= 4 && ageComponents.year! > 0 {
            if new_full_age.contains("лет") {
                if ageComponents.year! == 1{
                    new_full_age = new_full_age.replacingOccurrences(of: "лет", with: "год")
                } else {
                    new_full_age = new_full_age.replacingOccurrences(of: "лет", with: "года")
                }
            }
            if new_full_age.contains("years") && ageComponents.year == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "years", with: "year")
            }
            if new_full_age.contains("Jahre") && ageComponents.year == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "Jahre", with: "Jahr")
            }
            if new_full_age.contains("років") {
                if ageComponents.year! == 1{
                    new_full_age = new_full_age.replacingOccurrences(of: "років", with: "рік")
                } else {
                    new_full_age = new_full_age.replacingOccurrences(of: "років", with: "роки")
                }
            }
        }
        if ageComponents.month! <= 4 && ageComponents.month! > 0 {
            if new_full_age.contains("месяцев") && ageComponents.month! == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "месяцев", with: "месяц")
            }
            if new_full_age.contains("месяцев") && ageComponents.month! >= 2 && ageComponents.month! <= 4 {
                new_full_age = new_full_age.replacingOccurrences(of: "месяцев", with: "месяца")
            }
            if new_full_age.contains("monthes") && ageComponents.month == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "monthes", with: "month")
            }
            if new_full_age.contains("Monate") && ageComponents.month == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "Monate", with: "Monat")
            }
            if new_full_age.contains("місяців") {
                if ageComponents.month! == 1{
                    new_full_age = new_full_age.replacingOccurrences(of: "місяців", with: "місяць")
                } else {
                    new_full_age = new_full_age.replacingOccurrences(of: "місяців", with: "місяця")
                }
            }
        }
        if ageComponents.day! <= 4 && ageComponents.day! > 0 {
            if new_full_age.contains("дней") && ageComponents.day! == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "дней", with: "день")
            }
            if new_full_age.contains("дней") && ageComponents.day! >= 2 && ageComponents.day! <= 4 {
                new_full_age = new_full_age.replacingOccurrences(of: "дней", with: "дня")
            }
            if new_full_age.contains("days") && ageComponents.day! == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "days", with: "day")
            }
            if new_full_age.contains("Tage") && ageComponents.day! == 1 {
                new_full_age = new_full_age.replacingOccurrences(of: "Tage", with: "Tag")
            }
            if new_full_age.contains("днів") {
                if ageComponents.day! == 1{
                    new_full_age = new_full_age.replacingOccurrences(of: "днів", with: "день")
                } else {
                    new_full_age = new_full_age.replacingOccurrences(of: "днів", with: "дні")
                }
            }
        }
        self.animal_full_age = new_full_age
        self.animal_age = ageComponents.year!
        if ageComponents.month! == 0 && ageComponents.day! == 0 {
            return true
        } else {
            return false
        }
    }
//    метод добавления болезни в список болезней
    func add_disease(disease_name: String, disease_date: String, disease_end: String?, description: String, meds: String) {
        let new_disease = Disease(name: disease_name, data_d: disease_date, date_end: disease_end ?? nil, description: description, meds: meds)
        self.disease_list.insert(new_disease, at: 0)
    }
    func add_disease_no_end(disease_name: String, disease_date: String, description: String, meds: String) {
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

enum moneyFor: String, Codable {
    case entertainment = "entertainment"
    case food = "food"
    case vet = "vet"
    case other = "other"
}

//MARK: - expendinture
class Expenditure: Codable {
    var animal: String?
    var name: String
    var summ: Double
    var date: Date
    var moneyFor: moneyFor
    
    init(name: String, animal: String?, summ: Double, forM: moneyFor) {
        self.animal = animal
        self.summ = summ
        self.date = Date()
        self.moneyFor = forM
        self.name = name
    }
}

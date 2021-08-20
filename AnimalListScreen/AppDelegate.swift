//
//  AppDelegate.swift
//  PetMaster
//
//  Created by Fedor Sychev on 20.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // main notification center
    let notificationCenter = UNUserNotificationCenter.current()
    // set orientations that will be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        checkAllBirthdays()

        AppVersion.CheckFullVersion()
        
        sleep(1)
        // cheking for full version of an app
        let isFullVersion: Bool = Saved.shared.currentVersion.isFullVersion
        
        if isFullVersion {
            AppVersion.isFullVersion = true
            CloudHelper.SaveFullVersionToCloud(fullVersion: true)
        } else {
            if AppVersion.isFullVersion {
                Saved.shared.currentVersion.isFullVersion = true
            }
        }
        
        if AppVersion.isFullVersion {
            //recovering data from icloud or saving
            if Saved.shared.currentSaves.animals.count == 0 {
                CloudHelper.QueryAnimalsDataBase()
                CloudHelper.QuerySettingsDataBase()
                CloudHelper.QueryExpendituresDataBase()
            } else {
                CloudHelper.ModifyAll(animals: Saved.shared.currentSaves.animals, exps: Saved.shared.currentExpenditures.allExpenditures, settings: Saved.shared.currentSettings)
            }
        }


        print(Saved.shared.currentVersion.isFullVersion)
        print("Version: \(AppVersion.isFullVersion)")
        
        if findAllPlans() != ""{
            AllowNotifications()
            SendNotification(identifier: "plans", title: "You have plans!", body: findAllPlans(), timeW8: 3)
        }
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
//MARK: - Checking birthdays
    private func checkAllBirthdays() {
        var tempAnimals: [Animal]
        tempAnimals = Saved.shared.currentSaves.animals
        var bodyText: String = ""
        //updating age and finding birthdays
        for animal in tempAnimals {
            //updating disease duration
            for disease in animal.disease_list{
                disease.reloadDays()
            }
            if animal.UpdateAge() && animal.date_of_death == nil {
                if bodyText == "" {
                    bodyText += animal.name
                } else {
                    bodyText += ", \(animal.name)"
                }
            }
        }
        if bodyText != "" {
            if bodyText.contains(",") {
                SendNotification(identifier: "birthday", title: "\(NSLocalizedString("birthday", comment: ""))!", body: "\(bodyText)\(NSLocalizedString("have_a_birthday", comment: ""))", timeW8: 10)
            } else {
                SendNotification(identifier: "birthday", title: "\(NSLocalizedString("birthday", comment: ""))!", body: "\(bodyText)\(NSLocalizedString("has_a_birthday", comment: ""))", timeW8: 10)
            }
        }
        Saved.shared.currentSaves.animals = tempAnimals
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
//MARK: - Finding plans
    func findAllPlans() -> String{
        var text: String = ""
        for animal in Saved.shared.currentSaves.animals{
            for plan in animal.events_list{
                if plan.date > Date(){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/YYYY"
                    text += "\(plan.name) - \(dateFormatter.string(from: plan.date))"
                    if text != ""{
                        text += ", "
                    }
                }
            }
        }
        return text
    }
    
//MARK: - Notifications
    func AllowNotifications(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .alert]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return}
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func SendNotification(identifier: String, title: String, body: String, timeW8: Int) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeW8), repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}

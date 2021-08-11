//
//  AppDelegate.swift
//  PetMaster
//
//  Created by Fedor Sychev on 20.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Saved.shared.currentSaves.animals[0].vaccinations_list.count)
        if findAllPlans() != ""{
            AllowNotifications()
            SendNotification(identifier: "plans", title: "You have plans!", body: findAllPlans())
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
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
    
    func AllowNotifications(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .alert]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                print(settings)
                guard settings.authorizationStatus == .authorized else { return}
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func SendNotification(identifier: String, title: String, body: String) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
        print(#function)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }
}

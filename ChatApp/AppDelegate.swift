//
//  AppDelegate.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 28/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let userDefaultsManager:UserDefaultsManager = UserDefaultsManager()
    let jsonDecoder = JSONDecoder()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForPushNotifications()
        let notificationOption = launchOptions?[.remoteNotification]
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func registerForPushNotifications() -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {(granted:Bool,error:Error?) -> Void in
            print("Permission Granted: \(granted)")
            guard granted else {return}
            //Acciones personalizadas
            let firstAction = UNNotificationAction(identifier: "FIXED_MESSAGE1_ACTION", title: "Estoy ocupado, luego hablamos", options: [.foreground])
            let secondAction = UNNotificationAction(identifier: "FIXED_MESSAGE2_ACTION", title: "Hola, que tal?", options: [.foreground])
            //Tipo de notificaciones
            let notifCategory = UNNotificationCategory(identifier: "TEST_PUSH", actions: [firstAction,secondAction], intentIdentifiers: [], options: .customDismissAction)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.setNotificationCategories([notifCategory])
            
            self.getNotificationSettings()
            UNUserNotificationCenter.current().delegate = self
        })
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {settings in
            print("Configuracion Push: \(settings)")
            guard settings.authorizationStatus == .authorized else {return}
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    //Completed registering to APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

           let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }

           let token = tokenParts.joined()

           print("Device Token: \(token)")

       }
    //Error while registering to APNS
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fallo al registrar: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo as Dictionary, options: .prettyPrinted)
            let notification:ApnObject = try jsonDecoder.decode(ApnObject.self, from: jsonData)
            print (notification)
            let user:User = apnObjectToUserObject(apn: notification)
            let message:UserMessage = apnObjectToUserMessageObject(apn: notification)
            
            userDefaultsManager.readChatListFromUserDefaults()
            let isFound = !userDefaultsManager.userList.users.filter({
                return $0.token == user.token
            }).isEmpty
            
            if isFound{
                print("User Found")
                for n in 0...userDefaultsManager.userList.users.count-1{
                    if userDefaultsManager.userList.users[n].token == user.token{
                        userDefaultsManager.userList.users[n].name = user.name
                        userDefaultsManager.storeToChatList()
                        break
                    }
                }
                userDefaultsManager.readChatFromUserDefaults(user: user)
            }else{
                print("User Not Found. Adding it")
                userDefaultsManager.userList.users.append(user)
                userDefaultsManager.storeToChatList()
                userDefaultsManager.messageList = UserMessageList()
            }
            print("Storing Notification")
            userDefaultsManager.messageList.messageList.append(message)
            userDefaultsManager.storeChatMessages(user: user)
            let nc = NotificationCenter.default
            
            var responseMessage:UserMessage?
            switch response.actionIdentifier {
            case "FIXED_MESSAGE1_ACTION":
                responseMessage = UserMessage(author: user.name, message: "Estoy ocupado, hablamos luego")
                sendMessageToServer(userToSend: user, message: responseMessage!)
                break
            case "FIXED_MESSAGE2_ACTION":
                responseMessage = UserMessage(author: user.name, message: "Hola, que tal?")
                sendMessageToServer(userToSend: user, message: responseMessage!)
                break
            default:
               print("Abierta la notificacion sin click")
            }
            guard let res = responseMessage else {return}
            userDefaultsManager.readChatFromUserDefaults(user: user)
            userDefaultsManager.messageList.messageList.append(res)
            userDefaultsManager.storeChatMessages(user: user)
            
        } catch {
            print("Exception Found")
        }
            
            /*
             This works in the simulator
             print(aps)
             */
            
            
    }
}


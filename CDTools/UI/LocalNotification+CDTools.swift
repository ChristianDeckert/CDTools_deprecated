//
//  LocalNotification+CDTools
//  CDTools
//
//  Created by Deckert on 08.05.17.
//  Copyright © 2017 Christian Deckert. All rights reserved.
//

import Foundation

public extension UILocalNotification {
    public static func schedule(text: String, soundName: String = UILocalNotificationDefaultSoundName) {
        let note = UILocalNotification()
        note.alertBody = text
        note.soundName = soundName
        UIApplication.shared.scheduleLocalNotification(note)
    }
}

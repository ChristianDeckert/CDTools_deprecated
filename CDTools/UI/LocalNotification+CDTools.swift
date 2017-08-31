//
//  LocalNotification+CDTools
//  sos
//
//  Created by Deckert on 08.05.17.
//  Copyright © 2017 Christian Deckert. All rights reserved.
//

import Foundation

public func displayNotificationAlert(text: String) {
    let note = UILocalNotification()
    note.alertBody = text
    note.soundName = UILocalNotificationDefaultSoundName
    UIApplication.shared.scheduleLocalNotification(note)
}

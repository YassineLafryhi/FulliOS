//
//  LocalNotificationsView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import SwiftUI
import UserNotifications

struct LocalNotificationsView: View {
    @State private var titleText = ""
    @State private var bodyText = ""
    @State private var triggerDate = Date()
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Schedule Notification")) {
                    TextField("Title", text: $titleText)
                    TextField("Body", text: $bodyText)
                    DatePicker("Trigger Date", selection: $triggerDate, in: Date()...)
                    Button("Schedule Notification") {
                        scheduleNotification()
                    }
                }

                Section(header: Text("Pending Notifications")) {
                    List(pendingNotifications, id: \.identifier) { notification in
                        VStack(alignment: .leading) {
                            Text(notification.content.title)
                                .font(.headline)
                            Text(notification.content.body)
                                .font(.subheadline)
                            if
                                let trigger = notification.trigger as? UNCalendarNotificationTrigger,
                                let nextTriggerDate = trigger.nextTriggerDate() {
                                Text("Scheduled for: \(nextTriggerDate)")
                                    .font(.caption)
                            }
                        }
                        .swipeActions {
                            Button("Delete") {
                                removeNotification(withIdentifier: notification.identifier)
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("Local Notifications")
            .onAppear(perform: requestNotificationPermission)
            .onAppear(perform: loadPendingNotifications)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = titleText
        content.body = bodyText
        content.sound = UNNotificationSound.default

        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Error scheduling notification: \(error.localizedDescription)"
                } else {
                    alertMessage = "Notification scheduled successfully!"
                    titleText = ""
                    bodyText = ""
                    triggerDate = Date()
                    loadPendingNotifications()
                }
                showAlert = true
            }
        }
    }

    func loadPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                pendingNotifications = requests
            }
        }
    }

    func removeNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        loadPendingNotifications()
    }
}

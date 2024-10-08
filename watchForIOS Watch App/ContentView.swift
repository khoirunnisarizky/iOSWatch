//
//  ContentView.swift
//  watchForIOS Watch App
//
//  Created by khoirunnisa' rizky noor fatimah on 02/10/24.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        VStack {
            Text("Watch App")
                .font(.title)
            
            Text(connectivityManager.lastReceivedMessage)
                .padding()
        }
    }
}

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()
    @Published var lastReceivedMessage = ""
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let request = message["request"] as? String, request == "openApp" {
                self.lastReceivedMessage = "Received open request from iPhone"
                // Here you would typically perform any necessary actions to "open" or bring your app to the foreground
                print("Received request to open app")
            }
        }
    }
}


#Preview {
    ContentView()
}


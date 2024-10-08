//
//  ContentView.swift
//  iOSWatch
//
//  Created by khoirunnisa' rizky noor fatimah on 02/10/24.
//
import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        VStack {
            Text("iOS App")
                .font(.title)
            
            Button(action: {
                connectivityManager.sendMessageToWatch()
            }) {
                Text("Open Watch App")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(connectivityManager.isReachable ? "Watch is reachable" : "Watch is not reachable")
                .padding()
        }
    }
}

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    
    static let shared = WatchConnectivityManager()
    @Published var isReachable = false
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    
    func sendMessageToWatch() {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let message = ["request": "openApp"]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

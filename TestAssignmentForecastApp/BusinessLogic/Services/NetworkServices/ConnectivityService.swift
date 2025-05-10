//
//  ConnectivityService.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 09.05.2025.
//

import Network

protocol ConnectivityServiceType {
    func checkInternetConnection() async -> Bool
}

final class ConnectivityService: ConnectivityServiceType {
    func checkInternetConnection() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "ConnectivityMonitor")

            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }

            monitor.start(queue: queue)
        }
    }
}



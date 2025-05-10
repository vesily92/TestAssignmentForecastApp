//
//  IconLoadService.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 08.05.2025.
//

import Foundation

protocol IconServiceType {
    func fetchIconData(for code: String) async throws -> Data
}

final class IconService: IconServiceType {

    private let cache = NSCache<NSString, NSData>()

    func fetchIconData(for code: String) async throws -> Data {
        let key = code as NSString

        if let cached = cache.object(forKey: key) {
            return cached as Data
        }

        guard let url = OpenWeatherEndpoint.icon(code: code).url else {
            throw NetworkError.invalidURLError()
        }

        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse,
              http.url == url,
              (200..<300).contains(http.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NetworkError.badResponseError(statusCode: statusCode)
        }


        guard !data.isEmpty else {
            throw NetworkError.emptyDataError()
        }

        cache.setObject(data as NSData, forKey: key)
        return data
    }
}

//
//  NetworkError.swift
//  TestAssignmentForecastApp
//
//  Created by Vasily Pronin on 10.05.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidCoordinates(function: String, file: String, line: Int)
    case invalidURL(function: String, file: String, line: Int)
    case badResponse(statusCode: Int, function: String, file: String, line: Int)
    case emptyData(function: String, file: String, line: Int)
    case decodingFailure(Error, function: String, file: String, line: Int)

    var errorDescription: String? {
        switch self {
        case .invalidCoordinates(let function, let file, let line):
            return "[\(file):\(line) \(function)] Coordinates out of range."
        case .invalidURL(let function, let file, let line):
            return "[\(file):\(line) \(function)] Bad URL."
        case .badResponse(let code, let function, let file, let line):
            return "[\(file):\(line) \(function)] Server error code \(code)."
        case .emptyData(let function, let file, let line):
            return "[\(file):\(line) \(function)] Empty response data."
        case .decodingFailure(let error, let function, let file, let line):
            return "[\(file):\(line) \(function)] Decoding failed: \(error.localizedDescription)"
        }
    }

    static func invalidCoordinatesError(
        function: String = #function,
        file: String = #fileID,
        line: Int = #line
    ) -> Self {
        .invalidCoordinates(function: function, file: file, line: line)
    }

    static func invalidURLError(
        function: String = #function,
        file: String = #fileID,
        line: Int = #line
    ) -> Self {
        .invalidURL(function: function, file: file, line: line)
    }

    static func badResponseError(
        statusCode: Int,
        function: String = #function,
        file: String = #fileID,
        line: Int = #line
    ) -> Self {
        .badResponse(statusCode: statusCode, function: function, file: file, line: line)
    }

    static func emptyDataError(
        function: String = #function,
        file: String = #fileID,
        line: Int = #line
    ) -> Self {
        .emptyData(function: function, file: file, line: line)
    }

    static func decodingFailureError(
        _ error: Error,
        function: String = #function,
        file: String = #fileID,
        line: Int = #line
    ) -> Self {
        .decodingFailure(error, function: function, file: file, line: line)
    }
}

//
//  APIError.swift

import Foundation

enum APIError: String, Error {
    case jsonDecoding
    case response
    case noInternet
}

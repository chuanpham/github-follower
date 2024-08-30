//
//  ErrorMessages.swift
//  learnuikit
//
//  Created by chuanpham on 20/08/2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please check again!"
    case unableToPerform = "Unable to perform your request"
    case invalidResponse = "Invalid response from server"
    case dataInvalid = "Data invalid"
}

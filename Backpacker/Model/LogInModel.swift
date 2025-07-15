//
//  LogInModel.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import Foundation
//MARK: - LogIn Model
struct LoginResponse: Codable {
    let success: BoolOrInt
    let message: String
    let data: UserData?
    let errors: [FieldError]?
}

struct UserData: Codable {
    let userId: String?
}
struct FieldError: Codable {
    let field: String?
    let message: String?
}
//MARK: - OTP/ResendOtp  Model
struct OtpResponse: Codable {
    let success: Bool?
    let message: String
    let data: OtpData?
    let errors: [FieldError]?
}


struct OtpData : Codable {
    let userId : String?
    let accessToken :String?
    let refreshToken : String
}

struct BoolOrInt: Codable {
    let value: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolVal = try? container.decode(Bool.self) {
            self.value = boolVal
        } else if let intVal = try? container.decode(Int.self) {
            self.value = intVal != 0
        } else {
            throw DecodingError.typeMismatch(Bool.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected Bool or Int"
            ))
        }
    }
}

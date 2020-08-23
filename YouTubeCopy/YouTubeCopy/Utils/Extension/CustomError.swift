//
//  CustomError.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidDecoding
    case other(Error)
    
    static func  mapError(error: Error) -> CustomError  {
        return (error as? CustomError ) ?? other(error)
    }
}

//
//  MediaProtocol.swift
//  Medicare
//
//  Created by sanghv on 4/6/20.
//

import Foundation

protocol MediaProtocol {
    // swiftlint:disable colon
    var id       : Int { get }
    var name     : String { get }
    var imageUrl : URL? { get }
    // swiftlint:enable colon
}

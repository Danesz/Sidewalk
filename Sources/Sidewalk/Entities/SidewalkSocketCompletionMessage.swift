//
//  File.swift
//  File
//
//  Created by Daniel Dallos on 15/02/2022.
//

import Foundation

struct SidewalkSocketCompletionMessage: Decodable {
    let type: String = "completion"
    let connectedId: Int
    let callbackId: String
    let retval: AnyDecodable? // try JSValue?

}

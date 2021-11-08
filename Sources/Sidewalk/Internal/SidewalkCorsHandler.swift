//
//  File.swift
//  
//
//  Created by Daniel Dallos on 13/11/2021.
//

import Foundation
import Telegraph

public class SidewalkCorsHandler: HTTPRequestHandler {
  public func respond(to request: HTTPRequest, nextHandler: HTTPRequest.Handler) throws -> HTTPResponse? {
    
    let response = try nextHandler(request)
    response?.headers.accessControlAllowOrigin = "*"
    //response?.headers.accessControlAllowHeaders = "*"
    //response?.headers.accessControlAllowMethods = "*"

    return response
  }
}

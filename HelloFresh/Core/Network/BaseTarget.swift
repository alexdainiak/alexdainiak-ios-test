//
//  BaseTarget.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation

// Do not use Moya))) (just for fun). Make our own Target
protocol BaseTarget {
    
    /// The target's scheme
    var scheme: String { get }
    
    /// Provides service's host name
    var host: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request. ( String, if required can do enum)
    var method: String { get }
}

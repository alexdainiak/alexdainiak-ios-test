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

    /// The HTTP method used in the request
    var method: Method { get }
    
    /// Using stub or network
    var conectionType: ConectionType { get }
    
    /// The dta of stub sample. Using in case ConectionType.stub
    var sampleData: Data? { get }
}

extension BaseTarget {
    func loadDataInJSONFile(fileName: String, bundleToken: AnyClass) -> Data? {
        let bundle = Bundle(for: bundleToken)
        guard let filePath = bundle.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        return data
    }
}


enum ConectionType {
    case stub
    case network
}

enum Method: String {
    case GET
    case POST
}

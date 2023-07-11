//
//  WreckService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.07.2023.
//

import Foundation

class WreckService {
    
    let httpManager: HTTPManager
    let dataCoder: JSONDataCoder
    
    init(httpManager: HTTPManager, dataCoder: JSONDataCoder) {
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
}

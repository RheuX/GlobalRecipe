//
//  TestCodingKey.swift
//  GlobalRecipe
//
//  Created by Axel Lorens on 2/17/25.
//
import Foundation

struct TestCodingKey: CodingKey {
    var intValue: Int? = nil
    var stringValue: String
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = ""
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}

//
//  ProblemFilter.swift
//  FilterApp
//
//  Created by Angad on 30/11/24.
//

import Foundation

enum DataLoadingError: Error{
    case fileNotFound
    case decodingError
}

protocol DataServicesProtocol {
    func loadLocalData() throws -> HomePageData?
}

struct DataServices: DataServicesProtocol {
    
    func loadLocalData() throws -> HomePageData? {
        
        guard let url = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            print("Error: Could not find the file .json")
            throw DataLoadingError.fileNotFound
        }
        
        do {
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Decode the data into the model object
            let decodedData = try JSONDecoder().decode(HomePageData.self, from: data)
            return decodedData
            
        } catch {
            print("Error decoding JSON: \(error)")
            throw DataLoadingError.decodingError
        }
    }
}

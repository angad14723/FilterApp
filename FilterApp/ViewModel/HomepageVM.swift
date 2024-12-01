//
//  HomepageVM.swift
//  FilterApp
//
//  Created by Angad on 30/11/24.
//

import Foundation

class HomepageVM: ObservableObject {
    
    @Published var selectedItemId: Int = 0
    @Published var filters: [ProblemFilter] = []
    @Published var journeys: [Journey] = []
    @Published var isLoading = false
    @Published var searchText: String = ""
    @Published var errorMessage: String?
  
    
    // Computed property to filter journeys based on search text and selected filter
       var filteredJourneys: [Journey] {
           var results = journeys
           
           // Filter based on selected filter ID
           if let selectedFilterTitle = filters.first(where: { $0.id == selectedItemId })?.title {
               results = results.filter { journey in
                   journey.problems?.contains(selectedFilterTitle) ?? false
               }
           }
           
           // Further filter based on search text
           if !searchText.isEmpty {
               results = results.filter { journey in
                   journey.title?.localizedCaseInsensitiveContains(searchText) == true ||
                   journey.description?.localizedCaseInsensitiveContains(searchText) == true
               }
           }
           
           return results
       }
    
    var service: DataServicesProtocol?
    
    init(service: DataServicesProtocol? = DataServices()) {
        self.service = service
    }
    
    
    func loadData(){
        
        isLoading = true
        
        do{
            let localData = try service?.loadLocalData()
            self.journeys = localData?.data ?? []
            self.filters = localData?.problemFilter ?? []
            self.isLoading = false
            
            print("data :: \(self.journeys.count)")
            print("filters :: \(self.filters.count)")
            
            if self.filters.count > 0{
                self.selectedItemId = self.filters[0].id
            }
            
        }catch{
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
}

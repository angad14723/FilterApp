//
//  HomePageData.swift
//  FilterApp
//
//  Created by Angad on 30/11/24.
//


struct HomePageData: Codable {
    
    let status: Bool?
    let data: [Journey]?
    let premiumStatus: Int?
    let problemFilter: [ProblemFilter]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
        case premiumStatus = "premium_status"
        case problemFilter = "problem_filter"
    }
    
}

struct Journey: Codable, Identifiable {
    
    let id: Int?
    let title: String?
    let juLabel: String?
    let description: String?
    let thumbImage: String?
    let coverImage: String?
    let promo_text: String?
    let problems: [String]?
    let techniques: [String]?
    let days: [Days]?
    let details: String?
    let sessions: String?
    let mins: String?
  
       
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             description,
             problems,
             techniques,
             days,
             details,
             sessions,
             promo_text,
             mins
        case juLabel = "ju_label"
        case thumbImage = "thumb_image"
        case coverImage = "cover_image"
        
    }
}

struct ProblemFilter: Codable, Identifiable {
    let title: String
    let id: Int
}

struct Days: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let numSteps: Int
    let dayCompleted: String
    let completedSteps: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case numSteps = "num_steps"
        case dayCompleted = "day_completed"
        case completedSteps = "completed_steps"
    }
}

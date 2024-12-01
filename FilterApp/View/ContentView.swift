//
//  ContentView.swift
//  FilterApp
//
//  Created by Angad on 30/11/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = HomepageVM()
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 16) {
                
                SearchBarView(searchText:  $viewModel.searchText)
                    .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    // Use the separate ProblemFilterListView
                    ProblemFilterListView(
                        problemFilters: viewModel.filters, selectedItemId: $viewModel.selectedItemId
                    )
                    
                    GridItemView(filteredJourneys: viewModel.filteredJourneys)

                }
                
                Spacer()
                
            }
            .navigationTitle("Discover")
            .toolbar {
                // Toolbar items on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolBarView()
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
}



struct ToolBarView: View {
    var body: some View {
        HStack {
            // Icon 1
            Button(action: {
                print("Icon 1 tapped")
            }) {
                Image(systemName: "heart.fill")
                    .padding(10) // Add padding around the icon
                    .background(Color(.systemGray5)) // Background color
                    .clipShape(Circle()) // Optional: To make the background round
                    .foregroundColor(.white)
            }
            
            // Icon 2
            Button(action: {
                print("Icon 2 tapped")
            }) {
                Image(systemName: "music.note")
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
    }
}

// Custom Search Bar View
struct SearchBarView: View {
    
    @Binding var searchText: String // Bind the search text to parent view
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.primary)
                .font(.body)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = "" // Clear the search text when tapped
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(32)
    }
}


struct ProblemFilterListView: View {
    
    let problemFilters: [ProblemFilter] // List of ProblemFilter items
    @Binding var selectedItemId: Int // Binding to track selected item ID
    
    var body: some View {
        // Horizontal list of items
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(problemFilters) { filter in
                    SelectableItemView(
                        title: filter.title,
                        isSelected: selectedItemId == filter.id,
                        onTap: {
                            selectedItemId = filter.id // Select the new item
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// SelectableItemView
struct SelectableItemView: View {
    let title: String // The text for the item
    let isSelected: Bool // Whether the item is selected
    let onTap: () -> Void // Action when the item is tapped
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue) // Icon when selected
            }
        }
        .padding()
        .background(Color(.systemGray6)) // Background color
        .cornerRadius(32) // Rounded corners
        .onTapGesture {
            onTap() // Trigger the selection action
        }
    }
}

struct GridItemView: View {
    
    var filteredJourneys: [Journey] = []
    // Layout for the grid (two items per row)
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredJourneys) { journey in
                    
                    let footer = (journey.promo_text ?? "") + " . " + (journey.description ?? "")
                    
                    VStack(alignment: .leading, spacing: 8){
                        
                        NetworkImageView(imageURL: journey.thumbImage ?? journey.coverImage ?? "")
                        
                        Text(journey.title ?? "Unknown Journey")
                            .fontWeight(.medium)
                        
                        Text(footer)
                            .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                        
                    }
                }
            }
            .padding()
        }
        
    }
    
}


struct NetworkImageView: View {
    
    var imageURL: String
    
    var body: some View {
        
        WebImage(url: URL(string: imageURL))
            .onSuccess { image, data, cacheType in
                // Handle successful image load
            }
            .onFailure { error in
                // Handle failure
                print(error.localizedDescription)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12)
            .clipped() // Ensures the image doesn't overflow
    }
}

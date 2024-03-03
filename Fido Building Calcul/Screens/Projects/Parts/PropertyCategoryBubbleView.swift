//
//  PropertyCategoryBubbleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

struct PropertyCategoryBubbleView: View {
    
    var propertyCategory: PropertyCategories
    @FetchRequest var fetchedInCategory: FetchedResults<Project>
    @StateObject var viewModel = PropertyCategoryBubbleViewModel()
    
    init(propertyCategory: PropertyCategories) {
        
        self.propertyCategory = propertyCategory
        
        let projectFetchRequest = Project.fetchRequest()
        
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.dateCreated, ascending: false)]
        
        let category = propertyCategory.rawValue as CVarArg
        
        projectFetchRequest.predicate = NSPredicate(format: "category == %@ AND isArchived == NO", category)
        
        _fetchedInCategory = FetchRequest(fetchRequest: projectFetchRequest)
        
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                
                LinearGradient(colors: [Color.brandGray, Color.brandGray.opacity(0.7), Color.brandGray.opacity(0.0)], startPoint: .bottom, endPoint: .top)
                
                HStack(alignment: .firstTextBaseline) {
                    
                    Text(PropertyCategories.readableSymbol(propertyCategory))
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(Color.brandBlack)
                    
                    Spacer()
                    
                    Text("\(fetchedInCategory.count) projects")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                    
                }.padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
            }.frame(height: 110)
            
        }
        .background {
            Image(propertyCategory.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
        }
        .frame(height: 275)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.brandBlack.opacity(0.15), radius: 7)
        
        
    }
    
}

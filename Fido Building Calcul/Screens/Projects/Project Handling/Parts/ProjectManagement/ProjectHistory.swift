//
//  ProjectHistory.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 19/01/2024.
//

import SwiftUI

struct ProjectHistory: View {
    
    @FetchRequest var fetchedEvents: FetchedResults<HistoryEvent>
    
    init(of project: Project) {
        
        let request = HistoryEvent.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HistoryEvent.dateCreated, ascending: false)]
        
        request.predicate = NSPredicate(format: "toProject == %@", project as CVarArg)
        
        _fetchedEvents = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if !fetchedEvents.isEmpty {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("History")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    ForEach(fetchedEvents) { historyEvent in
                        HistoryEventBubble(historyEvent: historyEvent)
                    }
                    
                }
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 3)
                        .frame(width: 10)
                    
                }
                
            }.padding(15)
                .frame(maxWidth: .infinity)
                .background(Color.brandGray)
                .clipShape(.rect(cornerRadius: 24, style: .continuous))
            
        }
        
    }
    
}

fileprivate struct HistoryEventBubble: View {
    
    var historyEvent: HistoryEvent
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            let historyEventType = historyEvent.historyEventType
            
            Image(systemName: "circle.fill")
                .font(.system(size: 10))
                .foregroundStyle(Color.brandBlack)
                .frame(width: 10, alignment: .center)
            
            if historyEventType == .sent {
                Image(systemName: historyEventType.sfSymbol)
                    .font(.system(size: 19))
                    .foregroundStyle(Color.brandBlue, Color.brandBlack)
            } else {
                Image(systemName: historyEventType.sfSymbol)
                    .font(.system(size: 19))
                    .foregroundStyle(Color.brandBlack)
            }
                
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(historyEventType.title)
                    .font(.system(size: 17, weight: .semibold))
                
                if let historyDate = historyEvent.dateCreated {
                    
                    Text(historyDate.formatted(date: .numeric, time: .shortened))
                        .font(.system(size: 13))
                }
                
            }.fixedSize()
                .foregroundStyle(Color.brandBlack)
            
            Spacer()
            
        }

    }
    
}

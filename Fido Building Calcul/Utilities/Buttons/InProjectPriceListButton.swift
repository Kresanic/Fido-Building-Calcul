//
//  InProjectPriceListButton.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct InProjectPricesListButton: View {
    
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    var project: Project
    @Binding var priceListSheet: PriceList?
    
    init(project: Project, priceListSheet: Binding<PriceList?>) {
        
        self._priceListSheet = priceListSheet
        
        self.project = project
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let priceList = fetchedPriceList.last {
            
            VStack(spacing: 8) {
                
                HStack(alignment: .center) {
                    
                    Image(systemName: "eurosign.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.brandBlack)
                    
                    Text("Project price list")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.brandBlack)
                    
                    Spacer()
                    
                }
                
                Button { priceListSheet = priceList } label: {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text("Price list")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.brandBlack)
                            
                            Text("last change: ")
                                .font(.system(size: 13, weight: .semibold))
                            +
                            Text(priceList.dateEdited ?? Date.now, format: .dateTime.day().month().year())
                                .font(.system(size: 13, weight: .semibold))
                            
                        }.foregroundStyle(Color.brandBlack.opacity(0.8))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.brandBlack)
                        
                    }.padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .background(Color.brandGray)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                
            }
            
        }
        
    }
    
    private func localizedDate(from date: Date?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        if let date {
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            let formattedDate = dateFormatter.string(from: Date.now)
            return formattedDate
        }
        
    }
    
}

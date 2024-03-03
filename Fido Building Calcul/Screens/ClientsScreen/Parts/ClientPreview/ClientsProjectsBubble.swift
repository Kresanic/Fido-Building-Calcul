//
//  ClientsProjectsBubble.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ClientsProjectBubble: View {
    
    var project: Project
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var priceCalc: PricingCalculations
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    init(project: Project) {
        
        self.project = project
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                
                Text(project.unwrappedName)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.leading)
                
                Text("\(project.numberOfRooms) miestností")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
            }
            
            Spacer(minLength: 20)
            
            if let priceList = fetchedPriceList.last {
                
                let priceCalc = priceCalc.projectPriceBillCalculations(project: project, priceList: priceList)
                
                if priceCalc.priceWithoutVat > 0 {
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        
                        Text("VAT not included")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.brandBlack)
                        
                        Text(priceCalc.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.brandBlack)
                        
                    }.redrawable()
                    
                }
                
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(Color.brandWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
        
    }
    
    
}

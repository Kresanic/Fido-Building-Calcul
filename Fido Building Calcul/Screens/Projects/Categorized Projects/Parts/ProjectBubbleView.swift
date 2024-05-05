//
//  ProjectBubbleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI

struct ProjectBubbleView: View {
    
    var project: Project
    var isDeleting: Bool
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var priceCalc: PricingCalculations
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @State var paddingVertical: CGFloat = 10
    @State var pressed = false
    
    init(project: Project, isDeleting: Bool) {
        
        self.project = project
        self.isDeleting = isDeleting
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                
                Text(project.projectNumber)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                
                Text(project.unwrappedName)
                    .font(.system(size: 20, weight: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.leading)
                
                if let clientName = project.associatedClientName {
                    Text(clientName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                }
                
            }.frame(height: 50)
            
            Spacer(minLength: 20)
            
            if let priceList = fetchedPriceList.last {
                
                let priceCalc = priceCalc.projectPriceBillCalculations(project: project, priceList: priceList)
                
                if priceCalc.priceWithoutVat > 0 {
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        
                        ProjectStatusBubble(projectStatus: project.statusEnum, deployment: .projectBubble)
                        
                        Text(priceCalc.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.system(size: 20, weight: .semibold))
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.brandBlack)
                        
                        Text("VAT not included")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.brandBlack)
                            .onAppear { withAnimation { paddingVertical = priceCalc.priceWithoutVat > 0 ? 5 : 10 } }
                        
                    }
                    
                }
                
            }
            if !isDeleting {
            Image(systemName: "chevron.right")
                .font(.system(size: 24))
                .foregroundStyle(Color.brandBlack)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, paddingVertical)
        .background(Color.brandGray)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .scaleEffect(pressed ? 0.9 : 1.0)
        .onTapGesture { behavioursVM.projectsPath.append(project) }
        .onLongPressGesture(minimumDuration: 0.6) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.4)) {
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                project.status = project.statusEnum.advanceStatus
                let historyEventObject = behavioursVM.historyEventObjectFromProjectStatus(project.status)
                project.addToToHistoryEvent(historyEventObject)
                try? viewContext.save()
                impactMed.impactOccurred()
            }
        } onPressingChanged: { value in
            if value {
                withAnimation(.linear(duration: 0.6)) {
                    pressed = true
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    pressed = false
                }
            }
        }
        .redrawable()
        
        
    }
    
}

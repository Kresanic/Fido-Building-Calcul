//
//  TotalPriceOfferNewDesign.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 16/01/2024.
//

import SwiftUI

struct TotalPriceOffer: View {
    
    var project: Project
    @State var isShowingPayWall = false
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @EnvironmentObject var priceCalc: PricingCalculations
    @Environment(\.managedObjectContext) var viewContext
    @StateObject var pdfViewModel = ProjectPDF()
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    
    init(project: Project) {
        
        self.project = project
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let priceList = fetchedPriceList.last {
            
            let priceBubble = priceCalc.projectPriceBillCalculations(project: project, priceList: priceList)
            
            if priceBubble.priceWithoutVat > 0 {
                
                VStack(spacing: 8) {
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: "list.bullet.rectangle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Text("Total price offer")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.brandBlack)
                        
                        Spacer()
                        
                    }
                    
                    VStack(spacing: 8) {
                        
                        VStack {
                            
                            HStack(alignment: .firstTextBaseline) {
              
                                Text("without VAT")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                Text(priceBubble.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                          
                                Text("VAT")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                Text(priceBubble.priceWithoutVat*(priceList.othersVatPrice/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                
                                Text("Total price")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                    .minimumScaleFactor(0.4)
                                    .lineLimit(1)
                                    
                                Spacer(minLength: 20)
                                
                                Text(priceBubble.priceWithoutVat*(1 + priceList.othersVatPrice/100), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .minimumScaleFactor(0.4)
                                    .lineLimit(1)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }
                            
                        }
                        
                        RoundedRectangle(cornerRadius: 9)
                            .foregroundStyle(Color.brandWhite)
                            .frame(height: 2)
                        
                        HStack(spacing: 8) {
                            
                            Button {
                                if behavioursVM.isUserPro {
                                    pdfViewModel.isShowingPreview = true
                                } else { isShowingPayWall = true }
                            } label: {
                                PDFPreviewButtonSmall()
                            }
                            
                            Button {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                if behavioursVM.isUserPro {
                                    project.addToToHistoryEvent(ProjectEvents.sent.entityObject)
                                    pdfViewModel.sharePDF(from: project)
                                } else { isShowingPayWall = true }
                            } label: {
                                PDFExportButtonSmall()
                            }
                            
                        }
                        
                    }
                    .padding(15)
                    .background(Color.brandGray)
                    .clipShape(.rect(cornerRadius: 25, style: .continuous))
                    .redrawable()
                    
                }.fullScreenCover(isPresented: $isShowingPayWall) { PayWallScreen() }
                    .sheet(isPresented: $pdfViewModel.isShowingPreview) {
                        PDFPreviewSheet(pdfViewModel: pdfViewModel, pdfProject: project)
                            .onDisappear {
                                if pdfViewModel.shouldSharePDF {
                                    pdfViewModel.sharePDF(from: project)
                                }
                            }
                    }
                    
                
            }
            
        }
        
    }
    
}

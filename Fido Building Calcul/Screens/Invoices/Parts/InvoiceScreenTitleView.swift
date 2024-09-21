//
//  InvoiceScreenTitleView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/07/2024.
//

import SwiftUI
import CoreData
import Algorithms

struct InvoicesScreenTitle: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    @State var isShowingStats: Bool = false
    @State var selectedDetent: PresentationDetent = .large
    @State var isChoosingContractor = false
    @State var isCreatingContractor = false
    @State var shownContractors: [Contractor] = []
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                
                if let contractorName = behaviours.activeContractor?.name {
                    Button {
                        withAnimation(.bouncy) {
                            if isChoosingContractor {
                                isChoosingContractor = false
                            } else {
                                fetchContractors()
                                isChoosingContractor = true
                            }
                        }
                    } label: {
                        HStack {
                            
                            Text(contractorName)
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 27, weight: .medium))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    if !isChoosingContractor && behaviours.activeContractor != nil {
                        Button {
                            isShowingStats = true
                        } label: {
                            Image(systemName: "number.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.brandBlack)
                        }
                    }
                } else {
                    Button {
                        withAnimation(.bouncy) {
                            if isChoosingContractor {
                                isChoosingContractor = false
                            } else {
                                fetchContractors()
                                isChoosingContractor = true
                            }
                        }
                    } label: {
                        HStack {
                            
                            Text("Choose contractor")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 27, weight: .medium))
                                .foregroundColor(Color.brandBlack)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }
                    }
                }
                
            }
            
            if isChoosingContractor {
                
                VStack(spacing: 8) {
                    
                    ForEach(shownContractors) { contractor in
                        
                        Button {
                            withAnimation(.bouncy) {
                                behaviours.activeContractor = contractor
                                isChoosingContractor = false
                            }
                        } label: {
                            ContractorBubble(contractor: contractor, hasChevron: false)
                        }
                        
                    }
                    
                    Button { isCreatingContractor = true } label: {
                        CreateContractorButton()
                    }
                    
                }.padding(.bottom, 15)
                
                
            }
            
        }
        .sheet(isPresented: $isCreatingContractor, content: {
            ContractorEditView(presentationDetents: $selectedDetent)
                .presentationCornerRadius(25)
                .presentationDetents([.height(225), .large], selection: $selectedDetent)
                .interactiveDismissDisabled(true)
                .presentationBackground(.brandWhite)
                .onDisappear { selectedDetent = .large; fetchContractors() }
        })
        .sheet(isPresented: $isShowingStats) {
            if let contractor = behaviours.activeContractor {
                InvoiceStatistics(for: contractor)
                    .presentationBackground(.brandWhite)
                    .presentationDetents([.fraction(0.85)])
                    .presentationCornerRadius(25)
                    .presentationDragIndicator(.visible)
            }
        }
        
    }
    
    func fetchContractors() {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Contractor.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Contractor.dateCreated, ascending: false)]
        
        let fetchedContractors = try? viewContext.fetch(request)
        
        if let fetchedContractors {
            withAnimation {
                shownContractors = fetchedContractors
            }
        }
        
    }
    
}


fileprivate struct InvoiceStatistics: View {
    
    @FetchRequest var invoices: FetchedResults<Invoice>
    @Environment(\.dismiss) var dismiss
    init(for contractor: Contractor) {
        let request = Invoice.fetchRequest()
        
        request.predicate = NSPredicate(format: "toContractor == %@", contractor)
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        _invoices = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        
        ScrollView{
            
            VStack(alignment: .leading, spacing: 15) {
                let chunkedInvoicesByYear = invoices.chunked(by: { $0.dateCreated?.year == $1.dateCreated?.year})
                
                ForEach(0..<chunkedInvoicesByYear.count, id: \.self) { chunkIndex in
                    let chunk = chunkedInvoicesByYear[chunkIndex]
                    
                    InvoiceStatsYearView(chunk: chunk)
                }
                
            }
            .padding(.horizontal, 15)
            .padding(.top, 80)
            
        }
        .overlay(alignment: .top) {
            HStack {
                Text("").frame(width: 40)
                Spacer()
                Text("Statistics")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.brandBlack)
                    .padding(.top, 7)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .frame(width: 40)
                }
            }.padding(.horizontal, 15)
                .frame(height: 60)
                .background(.ultraThinMaterial)
        }
        
//        let sumInvoicesWithoutVat = invoices.reduce(0) { $0 + $1.priceWithoutVat }
//        let sumInvoicesWithVat = invoices.reduce(0) { $0 + ($1.priceWithoutVat + $1.vatAmount )}
        
    }
    
}

struct InvoiceChunk: Identifiable {
    var id: Int // or another unique property
    var invoices: [Invoice]
}


fileprivate struct InvoiceStatsYearView: View {
    
    @Environment(\.locale) var locale
    let chunk: FetchedResults<Invoice>.SubSequence
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(chunk.first?.dateCreated?.year ?? 0, format: .number.grouping(.never))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.brandBlack)
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(calculatePrice(for: chunk), format: .currency(code: locale.currency?.identifier ?? "EUR"))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.brandBlack)
                        .lineLimit(1)
                        .fixedSize()
                 
                    Text("in total, including VAT")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(chunk.count, format: .number)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.brandBlack)
                    
                    Text("invoices")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .minimumScaleFactor(0.6)
                    
                    Spacer()
                    
                }
                
                Capsule()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundStyle(.brandBlack.opacity(0.3))
                    .padding(.vertical, 5)
                
                let paid = chunk.filter{ $0.statusCase == .paid }
                let paidSum = paid.reduce(0.0, {$0 + ($1.priceWithoutVat + $1.vatAmount) })
                let paidCount = paid.count
                
                SubGroupInvoiceStats(title: "Paid", price: paidSum, count: paidCount)
                
                let unpaid = chunk.filter{ $0.statusCase == .unpaid }
                let unpaidSum = unpaid.reduce(0.0, {$0 + ($1.priceWithoutVat + $1.vatAmount) })
                let unpaidCount = unpaid.count
                
                SubGroupInvoiceStats(title: "Unpaid", price: unpaidSum, count: unpaidCount)
                
                let afterMaturity = chunk.filter{ $0.statusCase == .afterMaturity }
                let afterMaturitySum = afterMaturity.reduce(0.0, {$0 + ($1.priceWithoutVat + $1.vatAmount) })
                let afterMaturityCount = afterMaturity.count
                
                SubGroupInvoiceStats(title: "After maturity", price: afterMaturitySum, count: afterMaturityCount)
                
            }.padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.brandWhiteBackground)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 10)
        }
        
    }
    
    func calculatePrice(for invoices: FetchedResults<Invoice>.SubSequence) -> Double {
        return invoices.reduce(0.0, { $0 + ($1.priceWithoutVat + $1.vatAmount) })
    }
    
}

fileprivate struct SubGroupInvoiceStats: View {
    
    @Environment(\.locale) var locale
    var title: LocalizedStringKey
    var price: Double
    var count: Int
    
    var body: some View {
        
        LazyVStack(alignment: .leading, spacing: 2) {
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.brandBlack)
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(price, format: .currency(code: locale.currency?.identifier ?? "EUR"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandBlack)
                        .lineLimit(1)
                        .fixedSize()
                 
                    Text("in total, including VAT")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(count, format: .number)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.brandBlack)
                    
                    Text("invoices in total")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.brandBlack)
                        .minimumScaleFactor(0.6)
                    
                    Spacer()
                    
                }
                
            }.padding(10)
                .frame(maxWidth: .infinity)
                .background(.brandGray)
                .clipShape(.rect(cornerRadius: 15, style: .continuous))
//                .shadow(color: .black.opacity(0.08), radius: 8)
               
        } .padding(.top, 10)
        
    }
    
}

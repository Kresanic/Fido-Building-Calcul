//
//  InvoicesScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 22/03/2024.
//

import SwiftUI

struct InvoicesScreen: View {
    
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FetchRequest var invoices: FetchedResults<Invoice>
    @Environment(\.managedObjectContext) var viewContext
    @State var selectedInvoiceStatus: InvoiceStatus?
    @State var selectedInvoices: [Invoice] = []
    
    init(activeContractor: Contractor?) {
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.number, ascending: false)]
        
        if let activeContractor {
            request.predicate = NSPredicate(format: "toContractor == %@", activeContractor)
        }
        
        _invoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        NavigationStack(path: $behavioursVM.invoicesPath) {
            
            ScrollView {
                
                VStack {
                    
                    InvoicesScreenTitle()
                        .padding(.horizontal, 15)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            
                            Button {
                                selectedInvoiceStatus = nil
                            } label: {
                                Text("All")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(selectedInvoiceStatus == nil ? Color.brandWhite : Color.brandBlack)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .background {
                                        Capsule()
                                            .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                            .background(selectedInvoiceStatus == nil ? Color.brandBlack : Color.brandWhite)
                                            .clipShape(.capsule)
                                    }
                            }
                            
                            ForEach(InvoiceStatus.allCases, id: \.self) { status in
                                
                                Button {
                                    selectedInvoiceStatus = status
                                } label: {
                                    Text(status.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(selectedInvoiceStatus == status ? Color.brandWhite : Color.brandBlack)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 10)
                                        .background {
                                            Capsule()
                                                .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                                .background(selectedInvoiceStatus == status ? Color.brandBlack : Color.brandWhite)
                                                .clipShape(.capsule)
                                        }
                                }
                                
                            }
                            
                            Spacer()
                            
                        }.padding(.horizontal, 15)
//                            .padding(.top, 8)
                        
                    }
                    .padding(.bottom, 5)
                    .scrollIndicators(.hidden)
                    
                    if invoices.isEmpty {
                        Text("There is no Invoice for selected Contractor.")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 40)
                            .padding(.top, 150)
                    } else {
                        if selectedInvoiceStatus == nil {
                            ForEach(invoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else if !selectedInvoices.isEmpty {
                            ForEach(selectedInvoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else {
                            Text("There is no Invoice for selected Invoice Status.")
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundStyle(.brandBlack)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 40)
                                .padding(.top, 150)
                                .padding(.horizontal, 15)
                        }
                    }
                    
                }
                    .padding(.bottom, 105)
                
            }.scrollIndicators(.hidden)
                .navigationDestination(for: Invoice.self) { invoice in
                    InvoiceDetailView(invoice: invoice)
                }
                .navigationDestination(for: Client.self) { client in
                    ClientPreviewScreen(client: client)
                }
                .onChange(of: selectedInvoiceStatus) { value in
                    if selectedInvoiceStatus != nil {
                        withAnimation {
                            selectedInvoices = invoices.filter { $0.statusCase == value }
                        }
                    }
                }
                
            
        }.navigationBarTitleDisplayMode(.inline)
        
        
    }
    
}

fileprivate struct InvoicesScreenTitle: View {
    
    @EnvironmentObject var behaviours: BehavioursViewModel
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

struct InvoiceBubbleView: View {
    
    @FetchRequest var fetchedInvoices: FetchedResults<Invoice>
    
    init(invoice: Invoice) {
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        let invoiceCID = invoice.cId ?? UUID()
        
        request.fetchLimit = 1
        
        request.predicate = NSPredicate(format: "cId == %@", invoiceCID as CVarArg)
        
        _fetchedInvoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let invoice = fetchedInvoices.first {
            
            HStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    
                    if let projectName = invoice.toProject?.name {
                        
                        HStack(spacing: 3) {
                            
                            Text(invoice.stringNumber)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.brandBlack)
                            
                            if let date = invoice.dateCreated, invoice.statusCase != .afterMaturity {
                                Text(date, format: .dateTime.day().month().year())
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack.opacity(0.8))
                            }
                            
                            Spacer()
                        }
                        
                        Text(projectName)
                            .font(.system(size: 20, weight: .semibold))
                            .lineLimit(1)
                            .foregroundStyle(Color.brandBlack)
                            .multilineTextAlignment(.leading)
                        
                    } else {
                        Text(invoice.stringNumber)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                    
                    if let clientName = invoice.toClient?.name {
                        Text(clientName)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }
                    
                    
                    
                }.frame(height: 50)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    
                    invoice.bubble
                    
                    Text(invoice.priceWithoutVat, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .semibold))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color.brandBlack)
                        
                    Text("VAT not included")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.brandBlack)
                        .lineLimit(1)
                    
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.brandBlack)
                
            }.padding(10)
                .padding(.horizontal, 5)
                .background(Color.brandGray)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
        }
        
    }
    
}

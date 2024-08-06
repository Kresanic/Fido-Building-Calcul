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
        
        if let activeContractor { request.predicate = NSPredicate(format: "toContractor == %@", activeContractor) }
        
        _invoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        NavigationStack(path: $behavioursVM.invoicesPath) {
            
            ScrollView {
                
                LazyVStack {
                    
                    InvoicesScreenTitle()
                        .padding(.horizontal, 15)
                    
                    HorizontalInvoiceFilterView(selectedInvoiceStatus: $selectedInvoiceStatus)
                    
                    if invoices.isEmpty {
                        /// If no invoices were fetched at all
                        Text("There is no Invoice for selected Contractor.")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(.brandBlack)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 40)
                            .padding(.top, 150)
                    } else {
                        if selectedInvoiceStatus == nil {
                            /// If no invoice filter was selected
                            /// Showing all Invoices
                            ForEach(invoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else if !selectedInvoices.isEmpty {
                            /// Showing filtered invoices by invoice status
                            ForEach(selectedInvoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else {
                            /// For selected filter no invoices exist
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

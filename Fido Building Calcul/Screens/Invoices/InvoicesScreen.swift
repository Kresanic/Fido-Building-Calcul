
import SwiftUI

struct InvoicesScreen: View {
    
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @FetchRequest var invoices: FetchedResults<Invoice>
    @Environment(\.managedObjectContext) var viewContext
    @State var selectedInvoiceStatus: InvoiceStatus?
//    @State var selectedYear: Int?
    @AppStorage("selectedYear") var selectedYear: Int?
    @State var selectedInvoices: [Invoice] = []
    
    init(activeContractor: Contractor?) {
        
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.number, ascending: false)]
        
        if let activeContractor { request.predicate = NSPredicate(format: "toContractor == %@", activeContractor) }
        
        _invoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        let earliestYear = invoices.compactMap { invoice in
                    invoice.dateCreated.map { Calendar.current.component(.year, from: $0) }
                }.min() ?? Calendar.current.component(.year, from: Date())
        
        NavigationStack(path: $behavioursVM.invoicesPath) {
            
            ScrollView {
                
                LazyVStack {
                    
                    InvoicesScreenTitle()
                        .padding(.horizontal, 15)
                    
                    HorizontalInvoiceFilterView(selectedInvoiceStatus: $selectedInvoiceStatus, selectedYear: $selectedYear, yearRangeFrom: earliestYear)
                    
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
                        if selectedInvoiceStatus == nil && selectedYear == nil {
                            /// If no invoice filter was selected
                            /// Showing all Invoices
                            ForEach(invoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else if !selectedInvoices.isEmpty {
                            /// Showing filtered invoices by invoice status and/or year
                            ForEach(selectedInvoices) { invoice in
                                Button { behavioursVM.invoicesPath.append(invoice) } label: {
                                    InvoiceBubbleView(invoice: invoice)
                                }
                            }
                            .padding(.horizontal, 15)
                        } else {
                            /// For selected filter no invoices exist
                            Text("There is no Invoice for the selected filter criteria.")
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
                .onChange(of: selectedInvoiceStatus) { _ in
                    filterInvoices()
                }
                .onChange(of: selectedYear) { _ in
                    filterInvoices()
                }
            
        }.navigationBarTitleDisplayMode(.inline)
            .task {
                filterInvoices()
            }
            .task { await behavioursVM.checkForLoyaltyPass() }
        
    }
    
    private func filterInvoices() {
        withAnimation {
            selectedInvoices = invoices.filter { invoice in
                var matchesStatus = true
                var matchesYear = true
                
                if let status = selectedInvoiceStatus {
                    matchesStatus = invoice.statusCase == status
                }
                
                if let year = selectedYear, let invoiceCreatedDate = invoice.dateCreated {
                    let invoiceYear = Calendar.current.component(.year, from: invoiceCreatedDate)
                    matchesYear = invoiceYear == year
                }
                
                return matchesStatus && matchesYear
            }
        }
    }
}

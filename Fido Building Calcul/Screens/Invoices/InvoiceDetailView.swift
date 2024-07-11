//
//  InvoiceDetailView.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 04/05/2024.
//

import SwiftUI
import PDFKit

struct InvoiceDetailView: View {
    
    @FetchRequest var fetchedInvoices: FetchedResults<Invoice>
    @State var dialog: Dialog?
    @State var isShowingPreview = false
    @State var isPreviewingCashReceipt = false
    var invoiceProject: Project?
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    init(invoice: Invoice) {
        self.invoiceProject = invoice.toProject
        let request = Invoice.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Invoice.dateCreated, ascending: false)]
        
        let invoiceCID = invoice.cId ?? UUID()
        
        request.fetchLimit = 1
        
        request.predicate = NSPredicate(format: "cId == %@", invoiceCID as CVarArg)
        
        _fetchedInvoices = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        if let invoice = fetchedInvoices.first {
            
            ScrollView {
                
                VStack(alignment:. center) {
                    // MARK: Invoice Details
                    HStack {
                        
                        // Invoice Name and Number
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Text(invoice.stringNumber)
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundStyle(.brandBlack)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let projectNum = invoice.toProject?.projectNumber {
                                Text(projectNum)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.brandBlack)
                            }
                            
                        }
                        
                        // Invoice Status Case Bubble Management
                        if invoice.statusCase != .paid {
                            Button {
                                withAnimation {
                                    invoice.status = InvoiceStatus.paid.rawValue
                                    try? viewContext.save()
                                }
                            } label: {
                                HStack(spacing: 2) {
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.brandGreen)
                                    
                                    Text("Mark as Paid")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.brandBlack)
                                    
                                }   .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.brandGray)
                                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                            }
                        } else {
                            
                            Button {
                                if invoice.statusCase == .paid {
                                    withAnimation {
                                        invoice.status = InvoiceStatus.unpaid.rawValue
                                        try? viewContext.save()
                                    }
                                } else {
                                    withAnimation {
                                        invoice.status = InvoiceStatus.paid.rawValue
                                        try? viewContext.save()
                                    }
                                }
                            } label: {
                                invoice.statusCase.bigBubble
                            }
                            
                        }
                        
                    }
                    
                    VStack {
                        
                        // Invoice Client
                        if let client = invoice.toClient {
                            
                            HStack(alignment: .center) {
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Client")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }.padding(.bottom, -5)
                            
                            Button {
                                behaviours.invoicesPath.append(client)
                            } label: {
                                ClientBubble(client: client, isDeleting: false)
                            }
                        }
                        
                        // Invoice Project
                        if let project = invoice.toProject {
                            
                            HStack(alignment: .center) {
                                
                                Image(systemName: "pencil.and.ruler.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Project")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }.padding(.bottom, -5)
                            
                            Button {
                                behaviours.switchToProjectsPage(with: project)
                            } label: {
                                ProjectInvoiceBubbleView(project: project)
                            }
                        }
                        
                        // Invoice Contractor
                        if let contractor = invoice.toContractor {
                            HStack(alignment: .center) {
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Contractor")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }.padding(.bottom, -5)
                            Button { behaviours.switchToContractor(with: contractor) } label: {
                                ContractorBubble(contractor: contractor)
                            }
                        }
                    
                        // MARK: Invoice PDF Management
                        HStack(alignment: .center) {
                            
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("PDF")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.bottom, -5)
                        
                        // Invoice Preview
                        Button {
                            isShowingPreview = true
                        } label: {
                            HStack {
                                
                                Text("Preview Invoice")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.brandBlack)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.brandBlack)
                                
                            }.padding(15)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                        .background(Color.brandGray)
                                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                }
                        }
                        
                        // Invoice CashReceipt Preview
                        if let _ = invoice.cashReceipt {
                            Button {
                                isPreviewingCashReceipt = true
                            } label: {
                                HStack {
                                    
                                    Text("Preview Cash Receipt")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                }.padding(15)
                                    .padding(.vertical, 5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                            .background(Color.brandGray)
                                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                    }
                            }
                        }
                        
                        // Invoice Sharing
                        if let pdfURL = generatePDFURL(invoice.pdfFile) {
                            ShareLink(item: pdfURL) {
                                HStack {
                                    
                                    Text("Resend Invoice")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                }.padding(15)
                                    .padding(.vertical, 5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                            .background(Color.brandGray)
                                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                    }
                            }
                            .simultaneousGesture(TapGesture().onEnded() {
                                if let project = invoiceProject {
                                    project.addToToHistoryEvent(ProjectEvents.invoiceSent.entityObject)
                                    project.addToToHistoryEvent(ProjectEvents.finished.entityObject)
                                    project.status = 3
                                }
                                if let fInvoice = fetchedInvoices.first {
                                    fInvoice.status = "unpaid"
                                }
                                try? viewContext.save()
                            })
                        }
                        
                        // Invoice Cash Receipt Sharing
                        if let pdfURL = generatePDFURL(invoice.cashReceipt, isInvoice: false) {
                            ShareLink(item: pdfURL) {
                                HStack {
                                    
                                    Text("Resend Cash Receipt")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                        .foregroundStyle(Color.brandBlack)
                                    
                                }.padding(15)
                                    .padding(.vertical, 5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Color.brandBlack, lineWidth: 1.5)
                                            .background(Color.brandGray)
                                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                    }
                            }
                        }
                        
                    }
                    
                    // Invoice Deletion
                    Button {
                        dialog = .init(alertType: .warning, title: "Delete Invoice?", subTitle: "Are you sure you want to delete this invoice? This action is irreversible, and it will permanently erase all related data. The invoice number will also be freed for future use.", action: {
                            deleteCurrentInvoice(invoice)
                        })
                    } label: {
                        HStack(spacing: 1) {
                            Image(systemName: "trash")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.brandWhite)
                            
                            Text("Delete")
                                .font(.system(size: 21, weight: .medium))
                                .foregroundStyle(.brandWhite)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(.brandBlack)
                        .clipShape(.capsule)
                        .padding(.horizontal, 50)
                        
                    }.padding(.top, 15)
                    
                }.frame(maxWidth: .infinity)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 105)
                    .padding(.top, 5)
                
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $dialog) { dialog in
                DialogWindow(dialog: dialog)
            }
            .sheet(isPresented: $isShowingPreview) {
                if let data = invoice.pdfFile {
                    InvoicePDFDocumentPreviewSheet(pdfDoc: PDFDocument(data: data))
                }
            }
            .sheet(isPresented: $isPreviewingCashReceipt) {
                if let data = invoice.cashReceipt {
                    InvoicePDFDocumentPreviewSheet(pdfDoc: PDFDocument(data: data))
                }
            }
            
        }
        
        
        
    }
    
    private func deleteCurrentInvoice(_ invoice: Invoice) {
        viewContext.delete(invoice)
        try? viewContext.save()
        dismiss()
    }
        
    private func generatePDFURL(_ pdfData: Data?, isInvoice: Bool = true) -> URL? {
        /// Generates URL for PDF which was already created and saved, e.g. to CoreData as an attribute
        // Check if the PDF data is available
        guard let pdfData else {
            print("No PDF data available.")
            return nil
        }
        
        // Get the documents directory URL
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory is not accessible.")
            return nil
        }
        
        var fileName = ""
        if isInvoice {
            let invoiceLoc = NSLocalizedString("Invoice", comment: "")
            fileName = "\(invoiceLoc) \(fetchedInvoices.first?.stringNumber ?? "").pdf"
        } else {
            let cashRecLoc = NSLocalizedString("Cash Receipt", comment: "")
            fileName = "\(cashRecLoc) \(fetchedInvoices.first?.stringNumber ?? "").pdf"
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // Write the PDF data to the file
        do {
            try pdfData.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save PDF: \(error)")
            return nil
        }
    }
    
}




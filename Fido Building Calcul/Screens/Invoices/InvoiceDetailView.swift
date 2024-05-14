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
    
    @EnvironmentObject var behaviours: BehavioursViewModel
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
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
            
            ScrollView {
                
                VStack(alignment:. center) {
                    
                    HStack {
                        
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
                    
                        HStack(alignment: .center) {
                            
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("PDF")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.bottom, -5)
                        
                        Button {
                            isShowingPreview = true
                        } label: {
                            HStack {
                                
                                Text("Preview invoice")
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
                        
                        if let pdfURL = generatePDFURL(invoice) {
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
                        }
                        
                    }
                    
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
                        
                    }.padding(.top, 20)
                    
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
            
        }
        
        
        
    }
    
    private func deleteCurrentInvoice(_ invoice: Invoice) {
        viewContext.delete(invoice)
        try? viewContext.save()
        dismiss()
    }
        
    private func generatePDFURL(_ invoice: Invoice) -> URL? {
        // Check if the PDF data is available
        guard let pdfData = invoice.pdfFile else {
            print("No PDF data available.")
            return nil
        }

        // Get the documents directory URL
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory is not accessible.")
            return nil
        }
        
        // Create a unique file name for the PDF
        let fileName = NSLocalizedString("Invoice \(invoice.stringNumber).pdf", comment: "")
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


struct ProjectInvoiceBubbleView: View {
    
    var project: Project
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @EnvironmentObject var priceCalc: PricingCalculations
    @EnvironmentObject var behavioursVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @State var paddingVertical: CGFloat = 10
    
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
            
            Image(systemName: "chevron.right")
                .font(.system(size: 24))
                .foregroundStyle(Color.brandBlack)
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, paddingVertical)
        .background(Color.brandGray)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .scaleEffect(1.0)
        .redrawable()
        
        
    }
    
}

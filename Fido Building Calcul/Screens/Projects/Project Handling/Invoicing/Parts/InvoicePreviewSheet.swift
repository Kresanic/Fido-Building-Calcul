//
//  InvoicePreviewSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/04/2024.
//

import SwiftUI
import PDFKit

struct InvoicePreviewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    var project: Project
    let pdfURL: URL
    @State var pdfDoc: PDFDocument?
    @State var showingShareSheet = false
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        VStack {
            if let pdfDoc {
                PDFKitView(showing: pdfDoc)
                    .padding(.bottom, 80)
                    .padding(.top, 40)
            } else { Text("Loading...") }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .center) {
            
            VStack {
                
                HStack {
                    
                    Spacer().frame(width: 50)
                    
                    Text("Invoice Preview")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.brandBlack)
                    }.frame(width: 50, alignment: .trailing)
                    
                }.padding(15)
                    .padding([.top, .horizontal], 5)
                    .background(Color.brandWhite.opacity(0.5))
                    .background(.ultraThinMaterial)
                
                
                Spacer()
                
                ShareLink(item: pdfURL) {
                    PDFExportButton()
                }
                .padding(.top, 15)
                .padding(.horizontal, 20)
                .padding(.bottom, 35)
                .background(Color.brandWhite.opacity(0.5))
                .background(.ultraThinMaterial)
                .simultaneousGesture(TapGesture().onEnded() {
                    project.addToToHistoryEvent(ProjectEvents.invoiceSent.entityObject)
                    project.addToToHistoryEvent(ProjectEvents.finished.entityObject)
                    project.status = 3
                    try? viewContext.save()
                })
                
            }
            
        }
        .background(Color.brandGray)
        .ignoresSafeArea()
        .presentationCornerRadius(30)
        .task { withAnimation { pdfDoc = PDFDocument(url: pdfURL) } }
    }
    
}


fileprivate struct PDFKitView: UIViewRepresentable {

    let pdfDocument: PDFDocument

    init(showing pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

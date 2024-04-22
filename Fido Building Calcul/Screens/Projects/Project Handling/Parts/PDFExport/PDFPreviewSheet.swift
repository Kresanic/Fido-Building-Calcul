//
//  PDFPreviewSheet.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 16/01/2024.
//

import SwiftUI
import PDFKit

struct PDFPreviewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    var pdfViewModel: ProjectPDF
    let pdfProject: Project
    @State var pdfTitle: String?
    @State var pdfDoc: PDFDocument?
    @State var pdfURL: URL?
    
    var body: some View {
        VStack {
            if let pdfDoc {
                PDFKitView(showing: pdfDoc)
                    .padding(.bottom, 50)
                    .padding(.top, 35)
                    .task { pdfTitle = pdfViewModel.getProjectLocalizedTitle(from: pdfProject) }
            } else { Text("Loading...") }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .center) {
            
            VStack {
            
                HStack {
                    
                    Spacer().frame(width: 50)
                    
                    Text(pdfTitle ?? "PDF Preview")
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
                
                Button {
                    pdfProject.addToToHistoryEvent(ProjectEvents.sent.entityObject)
                    withAnimation { pdfViewModel.shouldSharePDF = true }
                    dismiss()
                } label: {
                    PDFExportButton()
                }
                    .padding(.top, 15)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 35)
                    .background(Color.brandWhite.opacity(0.5))
                    .background(.ultraThinMaterial)
                    .disabled(pdfURL == nil)
                
            }
            
        }
        .background(Color.brandGray)
        .ignoresSafeArea()
        .presentationCornerRadius(30)
        .task {
            withAnimation {
                pdfViewModel.shouldSharePDF = false
                pdfURL = pdfViewModel.previewPDFLoad(from: pdfProject)
                if let pdfURL { pdfDoc = PDFDocument(url: pdfURL) }
            }
        }
    }
    
}

struct PDFKitView: UIViewRepresentable {

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

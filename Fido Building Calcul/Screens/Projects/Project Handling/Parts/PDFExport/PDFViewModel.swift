//
//  PDFViewModel.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 29/11/2023.
//

import SwiftUI
import PDFKit

@MainActor final class ProjectPDF: ObservableObject {
    
    @Published var isLoading = false
    @Published var isShowingPreview = false
    @Published var previewPDFURL: URL?
    @Published var shouldSharePDF = true
    @AppStorage("priceOfferValidity") private var priceOfferValidity = 7
    
    func getProjectLocalizedTitle(from project: Project) -> String {
        
        var projectCategory: String {
            
            let category = PropertyCategories.parseToReadable(project.category)
            
            return String(NSLocalizedString(category, comment: "").uppercased().prefix(1))
            
        }
        
        let priceOfferKey = NSLocalizedString("PO", comment: "")
        
        let localizedTitle = "\(priceOfferKey) \(projectCategory) \(project.projectNumber)"
        
        return localizedTitle
    }
    
    func pdfContent(from project: Project) -> some View {
        // Checked
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .top) {
                
                let localizedTitle = getProjectLocalizedTitle(from: project)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("\(localizedTitle) - \(project.unwrappedName)")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    if let notes = project.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.black)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .frame(width: 300)
                    }
                    
                    Spacer()
                    
                    if let client = project.client {
                        
                        VStack(alignment: .leading) {
                            
                            Text(NSLocalizedString("Customer", comment: ""))
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.black)
                            PDFClientInfoView(client: client)
                            
                        }
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                        
                    if let imageData = project.contractor?.logo, let logo =  UIImage(data: imageData)  {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175)
                            .clipShape(.rect(cornerRadius: 10, style: .continuous))
                            .padding(.bottom, 10)
                    }
                    
                    Spacer()
                    
                    let dateOfCreation = project.dateCreated ?? Date.now
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Date of issue", comment: ""), value: dateOfCreation.formatted(date: .numeric, time: .omitted), spaced: true)
                    
                    PDFPersonalInfoView(title: NSLocalizedString("Valid until", comment: ""), value: dateOfCreation.addingTimeInterval(TimeInterval(priceOfferValidity*24*60*60)).formatted(date: .numeric, time: .omitted), spaced: true)
                    
                }.frame(width: 175)
                
            }.frame(maxHeight: 170)
            
            if let projectSumUp = projectSumUp(project) {
                
                HStack {
                    
                    Text(NSLocalizedString("Description", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                    
                    Spacer()
                    
                    Text(NSLocalizedString("Count", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 60, alignment: .trailing)
                    
                    Text(NSLocalizedString("Price per unit", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 70, alignment: .trailing)
                    
                    Text(NSLocalizedString("VAT(%)", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 60, alignment: .trailing)
                    
                    Text(NSLocalizedString("VAT", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 80, alignment: .trailing)
                    
                    Text(NSLocalizedString("Price", comment: ""))
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 80, alignment: .trailing)
                    
                }.foregroundStyle(.black)
                .padding(.top, 20)
                
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
                
                if !projectSumUp.works.isEmpty {
                    Text(NSLocalizedString("Work", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.works) { work in
                    
                    PDFRowView(priceBillRow: work, percentage: projectSumUp.VATPercentage)
                    
                }
                
                if !projectSumUp.materials.isEmpty {
                    Text(NSLocalizedString("Material", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.materials) { material in
                    
                    PDFRowView(priceBillRow: material, percentage: projectSumUp.VATPercentage)
                    
                }
                
                if !projectSumUp.others.isEmpty {
                    Text(NSLocalizedString("Others", comment: ""))
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.bottom, 2)
                }
                
                ForEach(projectSumUp.others) { other in
                    
                    PDFRowView(priceBillRow: other, percentage: projectSumUp.VATPercentage)
                    
                }
                
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, maxHeight: 1).padding(.vertical, 4)
                
                VStack(alignment: .trailing, spacing: 10) {
                    
                    PDFTotalPriceView(priceWithoutVat: projectSumUp.priceWithoutVat, percentage: projectSumUp.VATPercentage)
                    
                    if let imageData = project.contractor?.signature, let signature =  UIImage(data: imageData) {
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text(NSLocalizedString("Issued by:", comment: ""))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.black)
                            
                            Image(uiImage: signature)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 80)
                                .clipShape(.rect(cornerRadius: 10, style: .continuous))
                        }.padding(.top, 10)
                    }
                    
                }
                
            } else { Text(NSLocalizedString("PDF could not be created.", comment: "")) }
            
            Spacer()
            
            if let contractor = project.contractor {
                PDFContractorInfoView(contractor: contractor)
            }
            
            Text(NSLocalizedString("Created using Fido Building Calcul app.", comment: ""))
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 15)
            
        }.padding(.horizontal, 35)
            .padding(.vertical, 35)
            .frame(width: 630)
            .frame(minHeight: 891)
        
    }
    
    func projectSumUp(_ project: Project) -> PDFProjectPriceBill? {
        
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND fromProject == %@", project as CVarArg)
        
        let pricingCalculations = PricingCalculations()
        
        if let fetchedPriceList = try? viewContext.fetch(request).first {
            
            var pdfProjectPriceBill: PDFProjectPriceBill = PDFProjectPriceBill(projectName: project.unwrappedName, VATPercentage: fetchedPriceList.othersVatPrice)
            
            for room in project.associatedRooms {
                
                let priceBillRowOfRoom = pricingCalculations.roomPriceBillCalculation(room: room, priceList: fetchedPriceList)
                
                for work in priceBillRowOfRoom.works {
                    pdfProjectPriceBill.addWorks(work)
                }
                
                for material in priceBillRowOfRoom.materials {
                    pdfProjectPriceBill.addMaterials(material)
                }
                    
                for other in priceBillRowOfRoom.others {
                    pdfProjectPriceBill.addOthers(other)
                }
            }
            
            return pdfProjectPriceBill
            
        } else { return nil }
        
    }
    
    func render(from project: Project) -> URL {
        
        let pdfContent = pdfContent(from: project)
        
        let renderer = ImageRenderer(content: pdfContent)
        
        var projectCategory: String {
            
            let category = PropertyCategories.parseToReadable(project.category)
            return String(NSLocalizedString(category, comment: "").uppercased().prefix(1))
            
        }
        
        let priceOfferKey = NSLocalizedString("PO", comment: "")
        
        let localizedTitle = "\(priceOfferKey) \(projectCategory) \(project.projectNumber)"
        
        let url = URL.documentsDirectory.appending(path: "\(localizedTitle) - \(project.unwrappedName).pdf")
        
        renderer.render { size, context in
            
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
    
        return url
    
    }
    
    func sharePDF(from project: Project) {
        let url = render(from: project)
        shareButton(to: url)
        let viewContext = PersistenceController.shared.container.viewContext
        withAnimation {
            project.status = Int64(ProjectStatus.sent.rawValue)
            try? viewContext.save()
        }
    }
  
    func shareButton(to url: URL) {
        
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first {
            window.rootViewController?.present(activityController, animated: true, completion: nil)
        }
        
    }
    
    func previewPDFLoad(from project: Project) -> URL {
        let url = render(from: project)
        return url
    }
    
}

//
//  CustomPricesScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/09/2023.
//

import SwiftUI

struct InProjectPricesListView: View {
    
    @StateObject var viewModel = InProjectPricesListViewModel()
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @State private var priceList: PriceList?
    
    init(priceList: PriceList) {
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        let customId = priceList.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND cId == %@", customId as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    // MARK: Title and Settings Gear
                    VStack {
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "hammer.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Práca")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 95)
                        
                        InProjectPriceBubble(title: "Búracie práce", price: $viewModel.workDemolitionPrice, unit: .hour, viewModel: viewModel)
                        InProjectPriceBubble(title: "Elektroinštalatérske práce", subTitle: "vývod", price: $viewModel.workWiringPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Vodoinštalatérske práce", subTitle: "vývod", price: $viewModel.workPlumbingPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Murovanie priečok", subTitle: "75 - 175 mm", price: $viewModel.workBrickPartitionsPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Murovanie nosného muriva", subTitle: "200 - 450mm", price: $viewModel.workBrickLoadBearingWallPrice
                                             , unit: .cubicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Sádrokartón", subTitle: "priečka 2 vrstvy", price: $viewModel.workSimplePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Sádrokartón", subTitle: "strop", price: $viewModel.workPlasterboardingCeilingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Sieťkovanie", subTitle: "stena", price: $viewModel.workNettingWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Sieťkovanie", subTitle: "strop", price: $viewModel.workNettingCeilingPrice, unit: .squareMeter, viewModel: viewModel)
                        
                    }
                    VStack {
                        InProjectPriceBubble(title: "Omietka", subTitle: "stena", price: $viewModel.workPlasteringWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Omietka", subTitle: "strop", price: $viewModel.workPlasteringCeilingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie rohovej lišty", price: $viewModel.workInstallationOfCornerBeadPrice, unit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Omietka špalety", price: $viewModel.workPlasteringOfWindowSashPrice, unit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Penetračny náter", price: $viewModel.workPenetrationCoatingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Maľovanie", subTitle: "stena 2 vrstvy", price: $viewModel.workPaintingWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Maľovanie", subTitle: "strop 2 vrstvy", price: $viewModel.workPaintingCeilingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Nivelačka", price: $viewModel.workLevellingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Plávajúca podlaha", subTitle: "pokládka", price: $viewModel.workLayingFloatingFloorsPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Lištovanie", subTitle: "plávajúca podlaha", price: $viewModel.workSkirtingOfFloatingFloorPrice, unit: .basicMeter, viewModel: viewModel)
                    }
                    VStack {
                        
                        InProjectPriceBubble(title: "Obklad", subTitle: "keramický", price: $viewModel.workTilingCeramicPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Dlažba", subTitle: "keramická", price: $viewModel.workPavingCeramicPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Špárovanie", subTitle: "obkladu a dlažby", price: $viewModel.workGroutingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Silikónovanie", price: $viewModel.workSiliconingPrice, unit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "rohový ventil", price: $viewModel.workSanitaryCornerValvePrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "batéria stojanova", price: $viewModel.workSanitaryStandingMixerTapPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "batéria nástenná", price: $viewModel.workSanitaryWallMountedTapPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "batéria podomietková", price: $viewModel.workSanitaryFlushMountedTapPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "wc kombi", price: $viewModel.workSanitaryToiletCombiPrice, unit: .piece, viewModel: viewModel)
                    }
                    
                    VStack {
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "wc podomietkové", price: $viewModel.workSanitaryToiletWithConcealedCisternPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "umývadlo", price: $viewModel.workSanitarySinkPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "umývadlo so skrinkou", price: $viewModel.workSanitarySinkWithCabinetPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "vaňa", price: $viewModel.workSanitaryBathtubPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "sprchový kút", price: $viewModel.workSanitaryShowerCubiclePrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie sanity", subTitle: "osadenie žľabu", price: $viewModel.workSanitaryGutterPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie okna", price: $viewModel.workWindowInstallationPrice, unit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Osadenie obložkovej zárubne", price: $viewModel.workDoorJambInstallationPrice, unit: .piece, viewModel: viewModel)
                        InProjectPriceBubble(title: "Pomocné a ukončovacie práce", price: $viewModel.workAuxiliaryAndFinishingPrice, unit: .percentage, viewModel: viewModel)
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Materiál")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                    }
                    
                    VStack {
                        InProjectPriceBubble(title: "Priečkove murivo", subTitle: "75 - 175 mm", price: $viewModel.materialPartitionMasonryPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Nosné murivo", subTitle: "200 - 375 mm", price: $viewModel.materialLoadBearingMasonryPrice, unit: .cubicMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Sadrokartón", subTitle: "priečka", price: $viewModel.materialPlasterboardingCeilingPrice, unit: .piece, capacityPerPackage: $viewModel.materialPlasterboardingCeilingCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Sadrokartón", subTitle: "strop", price: $viewModel.materialPlasterboardingCeilingPrice, unit: .piece, capacityPerPackage: $viewModel.materialPlasterboardingCeilingCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Sklotextilna mriežka", price: $viewModel.materialMeshPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Lepidlo", subTitle: "sieťkovanie", price: $viewModel.materialAdhesiveNettingPrice, unit: .package, capacityPerPackage: $viewModel.materialAdhesiveNettingCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Lepidlo", subTitle: "obklad a dlažba", price: $viewModel.materialAdhesiveTilingAndPavingPrice, unit: .package, capacityPerPackage: $viewModel.materialAdhesiveTilingAndPavingCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Omietka", price: $viewModel.materialPlasterPrice, unit: .package, capacityPerPackage: $viewModel.materialPlasterCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Rohová lišta", price: $viewModel.materialCornerBeadPrice, unit: .piece, capacityPerPackage: $viewModel.materialCornerBeadCapacity, capacityPerPackageUnit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Penetrak", price: $viewModel.materialPrimerPrice, unit: .squareMeter, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceBubble(title: "Farba", subTitle: "stena", price: $viewModel.materialPaintWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Farba", subTitle: "strop", price: $viewModel.materialPaintCeilingPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Samonivelizačna hmota", price: $viewModel.materialSelfLevellingCompoundPrice, unit: .package, capacityPerPackage: $viewModel.materialSelfLevellingCompoundCapacity, capacityPerPackageUnit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Podlaha plávajúca", price: $viewModel.materialFloatingFloorPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Soklové lišty", price: $viewModel.materialSkirtingBoardPrice, unit: .basicMeter, viewModel: viewModel)
                        InProjectPriceBubbleForPackageBased(title: "Silikón", price: $viewModel.materialSiliconePrice, unit: .package, capacityPerPackage: $viewModel.materialSiliconeCapacity, capacityPerPackageUnit: .basicMeter, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceBubble(title: "Obklad", price: $viewModel.materialTilesPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Dlažba", price: $viewModel.materialPavingsPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: "Pomocný a spojovací materiál", price: $viewModel.materialAuxiliaryAndFasteningPrice, unit: .percentage, viewModel: viewModel)
                        HStack(alignment: .center) {
                            
                            Image(systemName: "list.bullet.rectangle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Ostatné")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                        InProjectPriceBubble(title: "Požičovňa náradia", price: $viewModel.othersToolRentalPrice, unit: .hour, viewModel: viewModel)
                        InProjectPriceBubble(title: "Cesta", price: $viewModel.othersCommutePrice, unit: .kilometer, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceBubble(title: "DPH", price: $viewModel.othersVatPrice, unit: .percentage, viewModel: viewModel)
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification), perform: { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                        }
                    })
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
            }.scrollIndicators(.hidden)
                .overlay(alignment: .top) {
                    
                    VStack {
                        
                        HStack {
                            ScreenTitle(title: "Cenník")
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.brandBlack)
                            }
                        }
                            
                        HStack(alignment: .firstTextBaseline, spacing: 3) {
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.brandBlack.opacity(0.7))
                            
                            Text("Zmena cenníka prepíše ceny v tomto projekte")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.brandBlack.opacity(0.7))
                            
                            Spacer()
                            
                        }.padding(.top, -10)
                            .padding(.bottom, 2)
                            
                    }.padding(.horizontal, 15)
                        .background(Color.brandWhite)
                        .background(.ultraThinMaterial)
                    
                }
                .navigationBarHidden(true)
                .onTapGesture { dismissKeyboard() }
                .onAppear {
                    viewModel.priceList = fetchedPriceList.last
                    viewModel.loadPriceList(priceList: fetchedPriceList.last)
                }
            
        }
    }
    
}


struct InProjectPriceBubble: View {

    var title: String
    var subTitle: String?
    @Binding var price: String
    var unit: UnitsOfMeasurment
    @ObservedObject var viewModel: InProjectPricesListViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState var isFocused: Bool

    var body: some View {

        VStack {

            HStack {

                VStack(alignment: .leading) {

                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    if let subTitle {
                        Text(subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                            .lineLimit(1)
                    }

                }

                Spacer()

                if unit == .percentage {

                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)

                    Text("\(UnitsOfMeasurment.readableSymbol(unit))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)

                } else {

                    TextField("0.00 €", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)

                    Text("\(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")/\((UnitsOfMeasurment.readableSymbol(unit)))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)

                }
            }

        }.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
                behaviourVM.toRedraw.toggle()
            }

    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }

}

struct InProjectPriceBubbleForPackageBased: View {

    var title: String
    var subTitle: String?
    @Binding var price: String
    var unit: UnitsOfMeasurment
    @Binding var capacityPerPackage: String
    var capacityPerPackageUnit: UnitsOfMeasurment
    @ObservedObject var viewModel: InProjectPricesListViewModel
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        VStack {

            HStack {

                VStack(alignment: .leading) {

                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    if let subTitle {
                        Text(subTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.brandBlack.opacity(0.75))
                    }

                }

                Spacer()

                if unit == .percentage {

                    TextField("", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)

                    Text("\(UnitsOfMeasurment.readableSymbol(unit))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)

                } else {

                    TextField("0.00 €", text: $price)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.brandBlack)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .frame(width: 90, height: 40)
                        .background(Color.brandWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .focused($isFocused)

                    Text("\(getSymbol(forCurrencyCode: Locale.current.currency?.identifier ?? "USD") ?? "$")/\(UnitsOfMeasurment.readableSymbol(unit))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.brandBlack)
                        .frame(width: 55)

                }
            }



            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .foregroundStyle(Color.brandWhite)
                .frame(maxWidth: .infinity, maxHeight: 1.5)

            HStack {

                Spacer()

                Text("výdatnosť na \(unit == .piece ? "kus" : "balenie")")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)

                TextField("0.0", text: $capacityPerPackage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.brandBlack)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .frame(width: 75, height: 35)
                    .background(Color.brandWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .focused($isFocused)

                Text("/\(UnitsOfMeasurment.readableSymbol(capacityPerPackageUnit))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.brandBlack)
                    .frame(width: 55)

            }

        }.padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 10)
            .background(Color.brandGray)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onChange(of: isFocused) { _ in
                viewModel.saveAll()
                behaviourVM.toRedraw.toggle()
            }

    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }

}

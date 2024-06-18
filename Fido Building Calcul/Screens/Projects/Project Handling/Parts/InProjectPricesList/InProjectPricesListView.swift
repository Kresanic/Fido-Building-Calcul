//
//  CustomPricesScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 11/09/2023.
//

import SwiftUI

struct InProjectPricesListView: View {
    
    @StateObject var viewModel = InProjectPricesListViewModel()
    @EnvironmentObject var behaviourVM: BehavioursViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest var fetchedPriceList: FetchedResults<PriceList>
    @State private var priceList: PriceList?
    @State private var showingDialogWindow: Dialog? = nil
    
    init(priceList: PriceList) {
        
        let request = PriceList.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)]
        
        let customId = priceList.cId ?? UUID()
        
        request.predicate = NSPredicate(format: "isGeneral == NO AND cId == %@", customId as CVarArg)
        
        _fetchedPriceList = FetchRequest(fetchRequest: request)
        
    }
    
    var body: some View {
        
            
        ScrollView {
            
            VStack {
                
                // MARK: Title and Settings Gear
                LazyVStack {
                    VStack {
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "hammer.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Work")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }
                        
                        InProjectPriceWorkBubble(work: Demolition.self, price: $viewModel.workDemolitionPrice, viewModel: viewModel)
                        InProjectPriceBubble(title: Wiring.title, subTitle: Wiring.priceListSubTitle, price: $viewModel.workWiringPrice, unit: Wiring.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: Plumbing.title, subTitle: Plumbing.priceListSubTitle, price: $viewModel.workPlumbingPrice, unit: Plumbing.unit, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: BrickPartition.self, price: $viewModel.workBrickPartitionsPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: BrickLoadBearingWall.self, price: $viewModel.workBrickLoadBearingWallPrice, viewModel: viewModel)
                        InProjectPriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.simpleSubTitle, price: $viewModel.workSimplePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.doubleSubTitle, price: $viewModel.workDoublePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.tripleSubTitle, price: $viewModel.workTriplePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: PlasterboardingOffsetWall.title, subTitle: PlasterboardingOffsetWall.simpleSubTitle, price: $viewModel.workSimplePlasterboardingOffsetWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceBubble(title: PlasterboardingOffsetWall.title, subTitle: PlasterboardingOffsetWall.doubleSubTitle, price: $viewModel.workDoublePlasterboardingOffsetWallPrice, unit: .squareMeter, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PlasterboardingCeiling.self, price: $viewModel.workPlasterboardingCeilingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: NettingWall.self, price: $viewModel.workNettingWallPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: NettingCeiling.self, price: $viewModel.workNettingCeilingPrice, viewModel: viewModel)
                        
                    }
                    VStack {
                        InProjectPriceWorkBubble(work: PlasteringWall.self, price: $viewModel.workPlasteringWallPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PlasteringCeiling.self, price: $viewModel.workPlasteringCeilingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: FacadePlastering.self, price: $viewModel.workFacadePlastering, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: InstallationOfCornerBead.self, price: $viewModel.workInstallationOfCornerBeadPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PlasteringOfWindowSash.self, price: $viewModel.workPlasteringOfWindowSashPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PenetrationCoating.self, price: $viewModel.workPenetrationCoatingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PaintingWall.self, price: $viewModel.workPaintingWallPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PaintingCeiling.self, price: $viewModel.workPaintingCeilingPrice, viewModel: viewModel)
                        
                        InProjectPriceWorkBubble(work: Levelling.self, price: $viewModel.workLevellingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: LayingFloatingFloors.self, price: $viewModel.workLayingFloatingFloorsPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: SkirtingOfFloatingFloor.self, price: $viewModel.workSkirtingOfFloatingFloorPrice, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceWorkBubble(work: TileCeramic.self, price: $viewModel.workTilingCeramicPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: PavingCeramic.self, price: $viewModel.workPavingCeramicPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: LargeFormatPavingAndTiling.self, price: $viewModel.workLargeFormatPavingAndTilingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: Grouting.self, price: $viewModel.workGroutingPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: Siliconing.self, price: $viewModel.workSiliconingPrice, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.cornerValveSubTitle, price: $viewModel.workSanitaryCornerValvePrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.standingMixerTapSubTitle, price: $viewModel.workSanitaryStandingMixerTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.wallMountedTapSubTitle, price: $viewModel.workSanitaryWallMountedTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.flushMountedTapSubTitle, price: $viewModel.workSanitaryFlushMountedTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.toiletCombiSubTitle, price: $viewModel.workSanitaryToiletCombiPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.toiletWtihConcealedCisternSubTitle, price: $viewModel.workSanitaryToiletWithConcealedCisternPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.sinkSubTitle, price: $viewModel.workSanitarySinkPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.sinkWithCabinetSubTitle, price: $viewModel.workSanitarySinkWithCabinetPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.bathtubSubTitle, price: $viewModel.workSanitaryBathtubPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.showerCubicleSubTitle, price: $viewModel.workSanitaryShowerCubiclePrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.intallationOfGutterSubTitle, price: $viewModel.workSanitaryGutterPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.urinal, price: $viewModel.workSanitaryUrinal, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.bathScreen, price: $viewModel.workSanitaryBathScreen, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.mirror, price: $viewModel.workSanitaryMirror, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: WindowInstallation.self, price: $viewModel.workWindowInstallationPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: InstallationOfDoorJamb.self, price: $viewModel.workDoorJambInstallationPrice, viewModel: viewModel)
                        InProjectPriceWorkBubble(work: AuxiliaryAndFinishingWork.self, price: $viewModel.workAuxiliaryAndFinishingPrice, viewModel: viewModel)
                        
                        HStack(alignment: .center) {
                            
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Material")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                    }
                    VStack {
                        InProjectPriceMaterialBubble(material: PartitionMasonry.self, price: $viewModel.materialPartitionMasonryPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: LoadBearingMasonry.self, price: $viewModel.materialLoadBearingMasonryPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: SimplePlasterboardPartition.self, price: $viewModel.materialSimplePlasterboardingPartitionPrice, capacity: $viewModel.materialSimplePlasterboardingPartitionCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: DoublePlasterboardPartition.self, price: $viewModel.materialDoublePlasterboardingPartitionPrice, capacity: $viewModel.materialDoublePlasterboardingPartitionCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: TriplePlasterboardPartition.self, price: $viewModel.materialTriplePlasterboardingPartitionPrice, capacity: $viewModel.materialTriplePlasterboardingPartitionCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: SimplePlasterboardOffsetWall.self, price: $viewModel.materialSimplePlasterboardingOffsetWallPrice, capacity: $viewModel.materialSimplePlasterboardingOffsetWallCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: DoublePlasterboardOffsetWall.self, price: $viewModel.materialDoublePlasterboardingOffsetWallPrice, capacity: $viewModel.materialDoublePlasterboardingOffsetWallCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: PlasterboardCeiling.self, price: $viewModel.materialPlasterboardingCeilingPrice, capacity: $viewModel.materialPlasterboardingCeilingCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: Mesh.self, price: $viewModel.materialMeshPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: AdhesiveNetting.self, price: $viewModel.materialAdhesiveNettingPrice, capacity: $viewModel.materialAdhesiveNettingCapacity, viewModel: viewModel, hasKgNote: true)
                        InProjectPriceMaterialBubblePackageBased(material: AdhesiveTilingAndPaving.self, price: $viewModel.materialAdhesiveTilingAndPavingPrice, capacity: $viewModel.materialAdhesiveTilingAndPavingCapacity, viewModel: viewModel, hasKgNote: true)
                        InProjectPriceMaterialBubblePackageBased(material: Plaster.self, price: $viewModel.materialPlasterPrice, capacity: $viewModel.materialPlasterCapacity, viewModel: viewModel, hasKgNote: true)
                        InProjectPriceMaterialBubblePackageBased(material: FacadePlaster.self, price: $viewModel.materialFacadePlasterPrice, capacity: $viewModel.materialFacadePlasterCapacity, viewModel: viewModel, hasKgNote: true)
                        InProjectPriceMaterialBubblePackageBased(material: CornerBead.self, price: $viewModel.materialCornerBeadPrice, capacity: $viewModel.materialCornerBeadCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: Primer.self, price: $viewModel.materialPrimerPrice, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceMaterialBubble(material: PaintWall.self, price: $viewModel.materialPaintWallPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: PaintCeiling.self, price: $viewModel.materialPaintCeilingPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: SelfLevellingCompound.self, price: $viewModel.materialSelfLevellingCompoundPrice, capacity: $viewModel.materialSelfLevellingCompoundCapacity, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: FloatingFloor.self, price: $viewModel.materialFloatingFloorPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: SkirtingBoard.self, price: $viewModel.materialSkirtingBoardPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubblePackageBased(material: Silicone.self, price: $viewModel.materialSiliconePrice, capacity: $viewModel.materialSiliconeCapacity, viewModel: viewModel)
                    }
                    VStack {
                        InProjectPriceMaterialBubble(material: Tiles.self, price: $viewModel.materialTilesPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: Pavings.self, price: $viewModel.materialPavingsPrice, viewModel: viewModel)
                        InProjectPriceMaterialBubble(material: AuxiliaryAndFasteningMaterial.self, price: $viewModel.materialAuxiliaryAndFasteningPrice, viewModel: viewModel)
                        HStack(alignment: .center) {
                            
                            Image(systemName: "list.bullet.rectangle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Text("Others")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.brandBlack)
                            
                            Spacer()
                            
                        }.padding(.top, 10)
                        
                        InProjectPriceOtherBubble(other: Scaffolding.self, price: $viewModel.othersScaffoldingPrice, viewModel: viewModel)
                        InProjectPriceOtherBubble(other: ScaffoldingAssemblyAndDisassembly.self, price: $viewModel.othersScaffoldingAssemblyAndDisassemblyPrice, viewModel: viewModel)
                        InProjectPriceOtherBubble(other: CoreDrill.self, price: $viewModel.othersCoreDrillRentalPrice, viewModel: viewModel)
                        InProjectPriceOtherBubble(other: ToolRental.self, price: $viewModel.othersToolRentalPrice, viewModel: viewModel)
                        InProjectPriceOtherBubble(other: Commute.self, price: $viewModel.othersCommutePrice, viewModel: viewModel)
                        InProjectPriceOtherBubble(other: VAT.self, price: $viewModel.othersVatPrice, viewModel: viewModel)
                    }
                }.ctaPopUp().padding(.top, 115)
                
            }.padding(.horizontal, 15)
                .padding(.bottom, 105)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }.scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Color.brandWhite)
            .overlay(alignment: .top) {
                
                VStack {
                    
                    HStack {
                        
                        ScreenTitle(title: "Price list")
                        
                        Spacer()
                        
                        Button {
                            showingDialogWindow = .init(alertType: .warning, title: "Update prices from general price list?", subTitle: "By updating the prices, you will replace all existing prices with those from the general price list. This action is irreversible.", action: {
                                withAnimation {
                                    viewModel.loadPriceList(priceList: behaviourVM.generalPriceListObject(toProject: priceList?.fromProject))
                                    viewModel.saveAll()
                                }
                            })
                        } label: {
                            Image(systemName: "eurosign.arrow.circlepath")
                                .font(.system(size: 24))
                                .foregroundColor(Color.brandBlack)
                                .frame(width: 44, height: 44)
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.brandBlack)
                                .frame(width: 44, height: 44)
                        }
                        
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.brandBlack.opacity(0.7))
                        
                        Text("Changing the price list will overwrite the prices in this project only")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.brandBlack.opacity(0.7))
                        
                        Spacer()
                        
                    }.padding(.top, -10)
                        .padding(.bottom, 2)
                    
                }.padding(.horizontal, 15)
                    .background(Color.brandWhite)
                
            }
            .navigationBarHidden(true)
            .onTapGesture { dismissKeyboard() }
            .onAppear {
                viewModel.priceList = fetchedPriceList.last
                viewModel.loadPriceList(priceList: fetchedPriceList.last)
            }
            .sheet(item: $showingDialogWindow) { dialogContent in
                DialogWindow(dialog: dialogContent)
            }
        
        
    }
    
}

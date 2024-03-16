//
//  PricesScreen.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 30/07/2023.
//

import SwiftUI

struct PricesScreen: View {
    
    @StateObject var viewModel = PricesScreenViewModel()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: PriceList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PriceList.dateEdited, ascending: false)], predicate: NSPredicate(format: "isGeneral == YES")) var fetchedPriceList:  FetchedResults<PriceList>
    
    @State private var priceList: PriceList?
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    ScreenTitle(title: "Price list")
                    
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.brandBlack.opacity(0.7))
                        
                        Text("Changes will affect prices in new projects")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.brandBlack.opacity(0.7))
                        
                        Spacer()
                        
                    }.padding(.top, -10)
                        .padding(.bottom, 5)
                    
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
                            
                            PriceWorkBubble(work: Demolition.self, price: $viewModel.workDemolitionPrice, viewModel: viewModel)
                            PriceBubble(title: Wiring.title, subTitle: Wiring.priceListSubTitle, price: $viewModel.workWiringPrice, unit: Wiring.unit, viewModel: viewModel)
                            PriceBubble(title: Plumbing.title, subTitle: Plumbing.priceListSubTitle, price: $viewModel.workPlumbingPrice, unit: Plumbing.unit, viewModel: viewModel)
                            PriceWorkBubble(work: BrickPartition.self, price: $viewModel.workBrickPartitionsPrice, viewModel: viewModel)
                            PriceWorkBubble(work: BrickLoadBearingWall.self, price: $viewModel.workBrickLoadBearingWallPrice, viewModel: viewModel)
                            PriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.simpleSubTitle, price: $viewModel.workSimplePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                            PriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.doubleSubTitle, price: $viewModel.workDoublePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                            PriceBubble(title: PlasterboardingPartition.title, subTitle: PlasterboardingPartition.tripleSubTitle, price: $viewModel.workTriplePlasterboardingPartitionPrice, unit: .squareMeter, viewModel: viewModel)
                            PriceBubble(title: PlasterboardingOffsetWall.title, subTitle: PlasterboardingOffsetWall.simpleSubTitle, price: $viewModel.workSimplePlasterboardingOffsetWallPrice, unit: .squareMeter, viewModel: viewModel)
                            PriceBubble(title: PlasterboardingOffsetWall.title, subTitle: PlasterboardingOffsetWall.doubleSubTitle, price: $viewModel.workDoublePlasterboardingOffsetWallPrice, unit: .squareMeter, viewModel: viewModel)
                            PriceWorkBubble(work: PlasterboardingCeiling.self, price: $viewModel.workPlasterboardingCeilingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: NettingWall.self, price: $viewModel.workNettingWallPrice, viewModel: viewModel)
                            PriceWorkBubble(work: NettingCeiling.self, price: $viewModel.workNettingCeilingPrice, viewModel: viewModel)
                        }
                        VStack {
                            PriceWorkBubble(work: PlasteringWall.self, price: $viewModel.workPlasteringWallPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PlasteringCeiling.self, price: $viewModel.workPlasteringCeilingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: InstallationOfCornerBead.self, price: $viewModel.workInstallationOfCornerBeadPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PlasteringOfWindowSash.self, price: $viewModel.workPlasteringOfWindowSashPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PenetrationCoating.self, price: $viewModel.workPenetrationCoatingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PaintingWall.self, price: $viewModel.workPaintingWallPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PaintingCeiling.self, price: $viewModel.workPaintingCeilingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: Levelling.self, price: $viewModel.workLevellingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: LayingFloatingFloors.self, price: $viewModel.workLayingFloatingFloorsPrice, viewModel: viewModel)
                            PriceWorkBubble(work: SkirtingOfFloatingFloor.self, price: $viewModel.workSkirtingOfFloatingFloorPrice, viewModel: viewModel)
                        }
                        VStack {
                            PriceWorkBubble(work: TileCeramic.self, price: $viewModel.workTilingCeramicPrice, viewModel: viewModel)
                            PriceWorkBubble(work: PavingCeramic.self, price: $viewModel.workPavingCeramicPrice, viewModel: viewModel)
                            PriceWorkBubble(work: Grouting.self, price: $viewModel.workGroutingPrice, viewModel: viewModel)
                            PriceWorkBubble(work: Siliconing.self, price: $viewModel.workSiliconingPrice, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.cornerValveSubTitle, price: $viewModel.workSanitaryCornerValvePrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.standingMixerTapSubTitle, price: $viewModel.workSanitaryStandingMixerTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.wallMountedTapSubTitle, price: $viewModel.workSanitaryWallMountedTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.flushMountedTapSubTitle, price: $viewModel.workSanitaryFlushMountedTapPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.toiletCombiSubTitle, price: $viewModel.workSanitaryToiletCombiPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                        }
                        VStack {
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.toiletWtihConcealedCisternSubTitle, price: $viewModel.workSanitaryToiletWithConcealedCisternPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.sinkSubTitle, price: $viewModel.workSanitarySinkPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.sinkWithCabinetSubTitle, price: $viewModel.workSanitarySinkWithCabinetPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.bathtubSubTitle, price: $viewModel.workSanitaryBathtubPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.showerCubicleSubTitle, price: $viewModel.workSanitaryShowerCubiclePrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.intallationOfGutterSubTitle, price: $viewModel.workSanitaryGutterPrice, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.urinal, price: $viewModel.workSanitaryUrinal, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.bathScreen, price: $viewModel.workSanitaryBathScreen, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceBubble(title: InstallationOfSanitary.generalTitle, subTitle: InstallationOfSanitary.mirror, price: $viewModel.workSanitaryMirror, unit: InstallationOfSanitary.unit, viewModel: viewModel)
                            PriceWorkBubble(work: WindowInstallation.self, price: $viewModel.workWindowInstallationPrice, viewModel: viewModel)
                            PriceWorkBubble(work: InstallationOfDoorJamb.self, price: $viewModel.workDoorJambInstallationPrice, viewModel: viewModel)
                            PriceWorkBubble(work: AuxiliaryAndFinishingWork.self, price: $viewModel.workAuxiliaryAndFinishingPrice, viewModel: viewModel)
                            
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
                            PriceMaterialBubble(material: PartitionMasonry.self, price: $viewModel.materialPartitionMasonryPrice, viewModel: viewModel)
                            PriceMaterialBubble(material: LoadBearingMasonry.self, price: $viewModel.materialLoadBearingMasonryPrice, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: SimplePlasterboardPartition.self, price: $viewModel.materialSimplePlasterboardingPartitionPrice, capacity: $viewModel.materialSimplePlasterboardingPartitionCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: DoublePlasterboardPartition.self, price: $viewModel.materialDoublePlasterboardingPartitionPrice, capacity: $viewModel.materialDoublePlasterboardingPartitionCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: TriplePlasterboardPartition.self, price: $viewModel.materialTriplePlasterboardingPartitionPrice, capacity: $viewModel.materialTriplePlasterboardingPartitionCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: SimplePlasterboardOffsetWall.self, price: $viewModel.materialSimplePlasterboardingOffsetWallPrice, capacity: $viewModel.materialSimplePlasterboardingOffsetWallCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: DoublePlasterboardOffsetWall.self, price: $viewModel.materialDoublePlasterboardingOffsetWallPrice, capacity: $viewModel.materialDoublePlasterboardingOffsetWallCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: PlasterboardCeiling.self, price: $viewModel.materialPlasterboardingCeilingPrice, capacity: $viewModel.materialPlasterboardingCeilingCapacity, viewModel: viewModel)
                            PriceMaterialBubble(material: Mesh.self, price: $viewModel.materialMeshPrice, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: AdhesiveNetting.self, price: $viewModel.materialAdhesiveNettingPrice, capacity: $viewModel.materialAdhesiveNettingCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: AdhesiveTilingAndPaving.self, price: $viewModel.materialAdhesiveTilingAndPavingPrice, capacity: $viewModel.materialAdhesiveTilingAndPavingCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: Plaster.self, price: $viewModel.materialPlasterPrice, capacity: $viewModel.materialPlasterCapacity, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: CornerBead.self, price: $viewModel.materialCornerBeadPrice, capacity: $viewModel.materialCornerBeadCapacity, viewModel: viewModel)
                            PriceMaterialBubble(material: Primer.self, price: $viewModel.materialPrimerPrice, viewModel: viewModel)
                        }
                        VStack {
                            PriceMaterialBubble(material: PaintWall.self, price: $viewModel.materialPaintWallPrice, viewModel: viewModel)
                            PriceMaterialBubble(material: PaintCeiling.self, price: $viewModel.materialPaintCeilingPrice, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: SelfLevellingCompound.self, price: $viewModel.materialSelfLevellingCompoundPrice, capacity: $viewModel.materialSelfLevellingCompoundCapacity, viewModel: viewModel)
                            PriceMaterialBubble(material: FloatingFloor.self, price: $viewModel.materialFloatingFloorPrice, viewModel: viewModel)
                            PriceMaterialBubble(material: SkirtingBoard.self, price: $viewModel.materialSkirtingBoardPrice, viewModel: viewModel)
                            PriceMaterialBubblePackageBased(material: Silicone.self, price: $viewModel.materialSiliconePrice, capacity: $viewModel.materialSiliconeCapacity, viewModel: viewModel)
                        }
                        VStack {
                            PriceMaterialBubble(material: Tiles.self, price: $viewModel.materialTilesPrice, viewModel: viewModel)
                            PriceMaterialBubble(material: Pavings.self, price: $viewModel.materialPavingsPrice, viewModel: viewModel)
                            PriceMaterialBubble(material: AuxiliaryAndFasteningMaterial.self, price: $viewModel.materialAuxiliaryAndFasteningPrice, viewModel: viewModel)
                            HStack(alignment: .center) {
                                
                                Image(systemName: "list.bullet.rectangle.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Text("Others")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.brandBlack)
                                
                                Spacer()
                                
                            }.padding(.top, 10)
                            
                            PriceOtherBubble(other: ToolRental.self, price: $viewModel.othersToolRentalPrice, viewModel: viewModel)
                            PriceOtherBubble(other: Commute.self, price: $viewModel.othersCommutePrice, viewModel: viewModel)
                            PriceOtherBubble(other: VAT.self, price: $viewModel.othersVatPrice, viewModel: viewModel)
                            
                        }
                    }.ctaPopUp()
                    
                }.padding(.horizontal, 15)
                    .padding(.bottom, 105)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
            }.scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .navigationBarHidden(true)
                .onTapGesture { dismissKeyboard() }
                .onAppear {
                    viewModel.priceList = fetchedPriceList.last
                    viewModel.loadPriceList(priceList: fetchedPriceList.last)
                }
            
            
        }
    }
    
}

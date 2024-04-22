//
//  Room+CoreDataClass.swift
//  Fido Building Calcul
//
//  Created by Peter Kresanič on 01/08/2023.
//
//


import CoreData
import SwiftUI

@objc(Room)
public class Room: NSManagedObject {
    
    public var unwrappedName: String {
        
        return name ?? "No name"
        
    }
    
    func areaAssociatedWorks() -> [[AreaBasedWorkType & NSManagedObject]] {
        
        let areaArray: [[AreaBasedWorkType & NSManagedObject]] = [
            associatedBrickPartitions,
            associatedBrickLoadBearingWalls
        ]
        
        return areaArray
        
    }
    
    public var associatedDemolitions: [Demolition] {
    
        let set = containsDemolitions as? Set<Demolition> ?? []
    
        return Array(set)
        
    }
    
    public var associatedWirings: [Wiring] {
    
        let set = containsWirings as? Set<Wiring> ?? []
    
        return Array(set)
        
    }

    public var associatedPlumbings: [Plumbing] {
    
        let set = containsPlumbings as? Set<Plumbing> ?? []
    
        return Array(set)
        
    }
    
    public var associatedBrickPartitions: [BrickPartition] {
    
        let set = containsBrickPartitions as? Set<BrickPartition> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedSkirtingsOfFloatingFloor: [SkirtingOfFloatingFloor] {
    
        let set = containsSkirtingFloatingFloor as? Set<SkirtingOfFloatingFloor> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedBrickLoadBearingWalls: [BrickLoadBearingWall] {
    
        let set = containsBrickLoadBearingWalls as? Set<BrickLoadBearingWall> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasterboardingPartitions: [PlasterboardingPartition] {
    
        let set = containsPlasterboardingPartitions as? Set<PlasterboardingPartition> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedSimplePlasterboardingPartitions: [PlasterboardingPartition] {
    
        let set = containsPlasterboardingPartitions as? Set<PlasterboardingPartition> ?? []
        
        let selected = set.filter { $0.type == 1 }
        
        return selected.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedDoublePlasterboardingPartitions: [PlasterboardingPartition] {
    
        let set = containsPlasterboardingPartitions as? Set<PlasterboardingPartition> ?? []
        
        let selected = set.filter { $0.type == 2 }
        
        return selected.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedTriplePlasterboardingPartitions: [PlasterboardingPartition] {
    
        let set = containsPlasterboardingPartitions as? Set<PlasterboardingPartition> ?? []
        
        let selected = set.filter { $0.type == 3 }
        
        return selected.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasterboardingOffsetWalls: [PlasterboardingOffsetWall] {
    
        let set = containsPlasterboardingOffsetWall as? Set<PlasterboardingOffsetWall> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedSimplePlasterboardingOffsetWalls: [PlasterboardingOffsetWall] {
    
        let set = containsPlasterboardingOffsetWall as? Set<PlasterboardingOffsetWall> ?? []
        
        let selected = set.filter { $0.type == 1 }
        
        return selected.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedDoublePlasterboardingOffsetWalls: [PlasterboardingOffsetWall] {
    
        let set = containsPlasterboardingOffsetWall as? Set<PlasterboardingOffsetWall> ?? []
        
        let selected = set.filter { $0.type == 2 }
        
        return selected.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasterboardingCeilings: [PlasterboardingCeiling] {
    
        let set = containsPlasterboardingCeilings as? Set<PlasterboardingCeiling> ?? []
        
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedNettingWalls: [NettingWall] {
    
        let set = containsNettingWalls as? Set<NettingWall> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedNettingCeilingss: [NettingCeiling] {
    
        let set = containsNettingCeilings as? Set<NettingCeiling> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasteringWalls: [PlasteringWall] {
    
        let set = containsPlasteringWalls as? Set<PlasteringWall> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedFacadePlasterings: [FacadePlastering] {
    
        let set = containsFacadePlastering as? Set<FacadePlastering> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasteringCeilings: [PlasteringCeiling] {
    
        let set = containsPlasteringCeilings as? Set<PlasteringCeiling> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedInstallationOfCornerBeads: [InstallationOfCornerBead] {
    
        let set = containsInstallationOfCornerBeads as? Set<InstallationOfCornerBead> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPlasteringOfWindowSasheses: [PlasteringOfWindowSash] {
    
        let set = containsPlasteringOfWindowSashes as? Set<PlasteringOfWindowSash> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPenetrationCoatings: [PenetrationCoating] {
    
        let set = containsPenetrationCoatings as? Set<PenetrationCoating> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPaintingWalls: [PaintingWall] {
    
        let set = containsPaintingWalls as? Set<PaintingWall> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPaintingCeilings: [PaintingCeiling] {
    
        let set = containsPaintingCeilings as? Set<PaintingCeiling> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedLevellings: [Levelling] {
    
        let set = containsLevellings as? Set<Levelling> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedLayingFloatingFloors: [LayingFloatingFloors] {
    
        let set = containsLayingFloatingFloors as? Set<LayingFloatingFloors> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }

    public var associatedTileCeramics: [TileCeramic] {
    
        let set = containsTileCeramics as? Set<TileCeramic> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedPavingCeramics: [PavingCeramic] {
    
        let set = containsPavingCeramics as? Set<PavingCeramic> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedGroutings: [Grouting] {
    
        let set = containsGroutings as? Set<Grouting> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedInstallationOfSanitaries: [InstallationOfSanitary] {
    
        let set = containsInstallationOfSanitaries as? Set<InstallationOfSanitary> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedInstallationOfSanitarysByType: [String: (Double, Double)] {
        
        // Returns the dictionary in which key is the name of the SanitaryType and in tuple, first double is the count of sanitaries and the second double
        // is price per sanitary, if user wants to count material as well.
    
        let set = containsInstallationOfSanitaries as? Set<InstallationOfSanitary> ?? []
        
        var finalDic: [String: (Double, Double)] = [:]
        
        for ware in set {
            
            finalDic[ware.type ?? "" ] = ((finalDic[ware.type ?? ""]?.0 ?? 0.0) + ware.count, ware.pricePerSanitary)
        }
    
        return finalDic
        
    }
    
    public var associatedWindowInstallations: [WindowInstallation] {
    
        let set = containsWindowInstallations as? Set<WindowInstallation> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedInstallationOfDoorJambss: [InstallationOfDoorJamb] {
    
        let set = containsInstallationOfDoorJambs as? Set<InstallationOfDoorJamb> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedSiliconings: [Siliconing] {
    
        let set = containsSiliconings as? Set<Siliconing> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedCustomWorks: [CustomWork] {
    
        let set = containsCustomWorks as? Set<CustomWork> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
    public var associatedCustomMaterials: [CustomMaterial] {
    
        let set = containsCustomMaterials as? Set<CustomMaterial> ?? []
    
        return set.sorted {
            $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now
        }
        
    }
    
}

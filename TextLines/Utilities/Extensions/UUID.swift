//
//  UUID.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/6/21.
//

import Foundation

extension UUID
{
    // MARK - Convenience extensions for UUID.
    
    /// Returns an empty UUID (all zero values for all fields).
    public static var Empty: UUID
    {
        get
        {
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        }
    }
}

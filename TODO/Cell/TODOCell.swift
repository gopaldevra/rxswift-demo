//
//  TODOCell.swift
//  TODO
//
//  Created by e01919 on 15/10/22.
//

import Foundation
import UIKit

final class TODOCell: UITableViewCell {
    
    // MARK: Designated Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

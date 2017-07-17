//
//  PokeCell.swift
//  PokeSearch
//
//  Created by Matt Tripodi on 7/17/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
	
	@IBOutlet weak var thumbImg: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	//index of poke in pokmon array
	
	func configureCell(poke: String){
		var indexNumber: Int
		
		nameLabel.text = poke.capitalized
		//index of poke in pokemon Array
		indexNumber = pokemon.index(of: poke)!
		thumbImg.image = UIImage(named: "\(indexNumber + 1)")
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		layer.cornerRadius = 5.0
		
	}
}

//
//  Pokemon.swift
//  PokeSearch
//
//  Created by Matt Tripodi on 7/17/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import Foundation

class Pokemon {
	
	private var _name: String!
	private var _pokedexId: Int!
	
	var name: String {
		if _name == nil {
			_name = ""
		}
		return _name
	}
	
	var pokedexId: Int {
		return _pokedexId
	}
	
	init(name: String, pokedexId: Int) {
		self._name = name
		self._pokedexId = pokedexId
	}
}

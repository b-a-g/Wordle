//
//  Database+Extensions.swift
//  Wordle
//
//  Created by Александр Беляев on 04.05.2022.
//

import FirebaseDatabase

extension Database {
  class var root: DatabaseReference {
    return database().reference()
  }
}

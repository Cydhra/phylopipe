taxonomy = db.getSiblingDB("taxonomy")

// create indices over the collections (if they do not exist yet), so the aggregate pipeline is faster
taxonomy.citations.createIndex( { "cit_id": 1 }, { unique: true } )
taxonomy.delnodes.createIndex( { "tax_id": 1 }, { unique: true } )
taxonomy.division.createIndex( { "division_id": 1 }, { unique: true } )
taxonomy.gencode.createIndex( { "gen_code_id": 1 }, { unique: true } )
taxonomy.images.createIndex( { "image_id": 1 }, { unique: true } )
taxonomy.merged.createIndex( { "old_tax_id": 1, "new_tax_id": 1 }, { unique: true } )
taxonomy.names.createIndex( { "tax_id": 1 } )
taxonomy.nodes.createIndex( { "tax_id": 1 }, { unique: true } )
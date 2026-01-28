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

// post processing for certain tables
// split taxid_list into an actual list
db.citations.updateMany(
    {},
    [
        {
            $set: {
                taxid_list: {
                    $map: {
                        input: {
                            $filter: {
                                input: {
                                    $split: ["$taxid_list", " "]
                                },
                                as: "num",
                                cond: { $ne: [ "$$num", "" ] }
                            }
                        },
                        as: "num",
                        in: { $toInt: "$$num" }
                    }
                }
            }
        }
    ]
)

// split taxid_list into an actual list
db.images.updateMany(
    {},
    [
        {
            $set: {
                taxid_list: {
                    $map: {
                        input: {
                            $filter: {
                                input: {
                                    $split: ["$taxid_list", " "]
                                },
                                as: "num",
                                cond: { $ne: [ "$$num", "" ] }
                            }
                        },
                        as: "num",
                        in: { $toInt: "$$num" }
                    }
                }
            }
        }
    ]
)

// create a parent-hierarchy to pre-compute all (partial) lineages
taxonomy.nodes.aggregate([
    // lookup the entire lineage
    {
        $graphLookup: {
            from: "nodes",
            startWith: "$tax_id",
            connectFromField: "parent_tax_id",
            connectToField: "tax_id",
            as: "parent_hierarchy",
        }
    },
    // lookup the scientific names for each node
    {
        $lookup: {
            from: "names",
            localField: "parent_hierarchy.tax_id",
            foreignField: "tax_id",
            as: "nameInfo",
            pipeline: [
                { $match: { name_class: "scientific name" } },
                { $project: { tax_id: 1, name_txt: 1 } }
            ]
        }
    },
    // add the hierarchy into a new field
    {
        $addFields: {
            parent_hierarchy: {
                // map the hierarchy onto smaller objects containing only the id, rank and name
                $map: {
                    input: "$parent_hierarchy",
                    as: "parent",
                    in: {
                        id: "$$parent.tax_id",
                        rank: "$$parent.rank",
                        name: {
                            // select the name object that matches the parent node id
                            $arrayElemAt: [
                                {
                                    // map the name object into only its scientific name value
                                    $map: {
                                        input: {
                                            $filter: {
                                                input: "$nameInfo",
                                                as: "info",
                                                cond: { $eq: ["$$info.tax_id", "$$parent.tax_id"] }
                                            }
                                        },
                                        as: "name_obj",
                                        in: "$$name_obj.name_txt"
                                    }
                                },
                                0
                            ]
                        }
                    }
                }
            }
        }
    },
    // remove the name info field containing the name objects
    {
        $project: {
            tax_id: 1,
            parent_hierarchy: 1
        }
    },
    {
        $merge: {
            into: "nodes_hierarchy",
            whenMatched: "replace",
            whenNotMatched: "insert"
        }
    }
])

// lastly, create an index over the new collection
taxonomy.nodes_hierarchy.createIndex({"tax_id": 1}) // no need for uniqueness, it's auto-generated anyway
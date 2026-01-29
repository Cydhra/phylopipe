Provides access to the NCBI database for taxonomy.
The database does not have an API endpoint, and therefore this module hosts the database
in a local mongodb service.

- The database is downloaded from NCBI (download.ps1),
- and prepared for consumption by mongodb (download.ps1).
- indices for the different tables are created in mongodb (create_indices.js),
- the data is imported into mongodb (import.ps1),
- and then an aggregation pipeline is created in mongodb that can quickly collect the
lineages of any taxon id (aggregate_hierarchy.js)

The module forces the installation of the conda and mongodb modules.
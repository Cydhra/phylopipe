# Phylopipe
A [PowerShell 7](https://github.com/PowerShell/) pipeline for phylogenetic analysis.

## What is this
This is a set of PowerShell modules for my personal workflows with various phylogenetic tools.
I use this setup both for analysis pipelines, and manual work from a PowerShell terminal.

The project is designed to be able to auto-bootstrap provided that PowerShell 7 is installed,
and the Operating System is either Windows or Linux.
macOS is not supported.

Most modules require an installation through the respective installation script:
```ps1
& .\modules\raxml\install.ps1
```
The installations are purely local, meaning uninstalling is as simple as deleting the phylopipe directory.

Then, any module can be imported into the current PowerShell session using

```ps1
Import-Module .\phylopipe\modules\<name>
```

An example:
```ps1
Import-Module .\phylopipe\modules\raxml

Invoke-Raxml -Command search -Msa .\datasets\alignment.afa -Model "GTR+G" -Prefix .\workspace\test_tree
```

The modules provide tab-completion for the commands they support, as well as help commands:

```
help Invoke-Raxml                                                                                                      
                                                                                                                                                                                                          
NAME
    Invoke-Raxml
    
SYNOPSIS
    Calls the RAxML-ng tool on Linux using the provided arguments.
    
    
SYNTAX
    Invoke-Raxml -Command <String> [-Msa <String>] [-Model <String>] [-StateEncoding <String>] [-Tree <String>] [-Prefix <String>] [-BrLen <String>] [-TreeConstraint <String>] [-Outgroup <String[]>] 
    [-SiteWeights <String>] [-Threads <Int32>] [-LhEpsilon <Int32>] [-Redo] [-ForceThreads] [-ManualArgs <String[]>] [<CommonParameters>]
    
    Invoke-Raxml -Command <String> [-Msa <String>] -ModelFile <String> -ModelType <String> [-StateEncoding <String>] [-Tree <String>] [-Prefix <String>] [-BrLen <String>] [-TreeConstraint <String>] 
    [-Outgroup <String[]>] [-SiteWeights <String>] [-Threads <Int32>] [-LhEpsilon <Int32>] [-Redo] [-ForceThreads] [-ManualArgs <String[]>] [<CommonParameters>]
    
    Invoke-Raxml -Command <String> [-Msa <String>] -PartitionFile <String> [-Tree <String>] [-Prefix <String>] [-BrLen <String>] [-TreeConstraint <String>] [-Outgroup <String[]>] [-SiteWeights 
    <String>] [-Threads <Int32>] [-LhEpsilon <Int32>] [-Redo] [-ForceThreads] [-ManualArgs <String[]>] [<CommonParameters>]
    
-- More  -- 
```

Many tools use WSL on Windows to run their tools.

## Prerequisites
Module installation scripts are set up to download and compile the software tools they are managing themselves,
mostly without intervention.
Modules that provide software written in C and C++ do expect a **valid development environment** though.
On Windows, a working **WSL installation** and setup is required.

Many modules are provided through [conda](https://www.anaconda.com/docs/getting-started/miniconda/main),
but the `conda` module will download and manage a self-contained conda environment for all conda-dependent
modules.

## Installation
Most modules require installation. They contain an `install.ps1` script in their module path.
The global `install.ps1` script calls all but the most expensive install-scripts to make everything
available.
If you want to be able to import the scripts globally, rather than having to specify the file path to the modules,
run `install_repository.ps1` after running the install-scripts.

After you ran `install_repository.ps1`, you can import any module from anywhere like this:

```ps1
Import-Module reseek
```

## Versions
There is no versioning system for the modules.
Most modules fix the version of their software through the `config.ps1` script and I update the version
when I need new functionality.

## EULA Stuff
The `conda` module silently installs miniconda.
If you are using this pipeline, you are agreeing to the [Anaconda EULA](https://www.anaconda.com/legal/terms/miniconda).

## Can I use this
Sure. If you are using PowerShell for phylogenetics, this might be useful to you.
If you are using a different shell, or a different pipeline approach, there are probably better
alternatives.
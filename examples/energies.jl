#
# git clone https://github.com/mcubeg/namdjl
#

# Path to PDBEnergy module
push!(LOAD_PATH, "../");

# Load PDB energy module
using PDBEnergy

# Load PSF file data
atoms, bonds, angles, dihedrals, impropers = readpsf("./structure.psf");

# Load coordinates from PDB
getpdbcoords!("./structure.pdb",atoms);

# Select atoms of residue number 17
sel1 = [ atom.index for atom in filter( atom -> atom.residue == 17, atoms) ];

# Select atoms of residue number 19
sel2 = [ atom.index for atom in filter( atom -> atom.residue == 19, atoms) ];

# Compute electrostatic interaction between these two selections
elecenergy = coulomb(atoms,sel1,sel2);

# Read parameter files (which contain eps and sig vdW parameters)
parfiles = [ "/home/leandro/programs/toppar/charmm/par_all36_prot.prm", 
             "/home/leandro/programs/toppar/charmm/toppar_water_ions.str", 
             "/home/leandro/programs/toppar/charmm/par_all36_lipid.prm" ]
readprm!(parfiles,atoms)

# Compute vdw interaction between these two selections
vdwenergy = vdw(atoms,sel1,sel2);

println("Electrostatic interaction between residues 17 and 19 = $elecenergy")
println("vdW interaction between residues 17 and 19 = $vdwenergy") 


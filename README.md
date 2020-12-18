# MEEGtools
Octave Etard (octave.etard11@imperial.ac.uk)

Matlab package for the analysis of M/EEG data. Contains basic functions to manipulate datasets, see also the [LMpackage](https://github.com/octaveEtard/LMpackage) for analysis.

## Quick start

### Installation
Add the `functions` folder to your path. The code is structured as a [Matlab package](https://uk.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html) contained in `functions/+MEEGtools`. Functions can be called by using the `MEEGtools.` prefix (e.g. `out = MEEGtools.someFunction(x,y,z)`). Alternatively the required functions can also be [imported](https://uk.mathworks.com/help/matlab/matlab_oop/importing-classes.html) (e.g. `import MEEGtools.someFunction; out = someFunction(x,y,z)`).

To add to a project do:

`git submodule add https://github.com/malhal/MHNamespaceGenerator.git dependencies/MHNamespaceGenerator`

Then add a new Aggregate target "Namespace". Under Build Phases, add the framework as a dependency then add a new Run Script phase with this:

`dependencies/MHNamespaceGenerator/script.sh FrameworkName.framework FrameworkName FrameworkPrefix`

e.g.

`dependencies/MHNamespaceGenerator/script.sh MHFoundation.framework MHFoundation MHF`

We'll now use my MHFoundation/MHF for the rest of the examples.

Build the Namespace target, then drag the MHFoundation+Namespace.h into the project. Open your MHFoundationDefines.h (or create one if don't have one yet also make sure to include it in every header) and at the end of the file add this line:

`#import <MHFoundation/MHFDefines+Namespace.h>`

Now to make use of this namespace, in another project add the framework as a dependency. Then in Build settings, under Preprocessor Macros Not Used in Precompiled Headers add this:

`MHFOUNDATION_NAMESPACE=MHF`
and
`MHFOUNDATION_NAMESPACE_LOWER=mhf`
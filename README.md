This project aims to help with the Objective-C class name clash problem that can be an issue when creating reusable code libraries. It gives the capability of prefixing classes and categories in a framework with a unique prefix so that multiple frameworks in a project can make use of their own isolated version of the shared framework.

To add to a project do:

`git submodule add https://github.com/malhal/MHNamespaceGenerator.git dependencies/MHNamespaceGenerator`

Then add a new Cross-Platform, Aggregate target "Namespace". Under Build Phases, add the framework as a dependency then add a new Run Script phase with this:

`dependencies/MHNamespaceGenerator/script.sh FrameworkName.framework FrameworkName FrameworkPrefix`

e.g.

`dependencies/MHNamespaceGenerator/script.sh MHFoundation.framework MHFoundation MHF`

We'll now use my MHFoundation/MHF for the rest of the examples.

Build the Namespace target, then drag the MHFoundation+Namespace.h into the project and mark its Target Membership as public. Open your MHFoundationDefines.h (or create one if don't have one yet also make sure to include it in every header) and at the end of the file add this line:

`#import <MHFoundation/MHFDefines+Namespace.h>`

Now to make use of this namespace, in another project add the framework as a dependency. Then in Build settings, under Preprocessor Macros Not Used in Precompiled Headers add this:

`MHFOUNDATION_NAMESPACE=XYZ`
and
`MHFOUNDATION_NAMESPACE_LOWER=xyz`

The result is that XYZ_ will be prefixed to all class names and categories. And xyc_ will be prefixed to all category methods.

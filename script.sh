#
#  script.sh
#  MHNamespaceGenerator
#
#  Created by Malcolm Hall on 31/07/2016.
#  Copyright © 2016 Malcolm Hall. All rights reserved.
#
#  Usage:
#  Add a dependency to this git.
#      E.g. git submodule add https://github.com/malhal/MHNamespaceGenerator.git dependencies/MHNamespaceGenerator
#  Add a new run script phase to your framework project and in the second box enter the path to this script with the name and the prefix as params.
#      E.g. dependencies/MHNamespaceGenerator/script.sh MHCloudKit MHCK
#
#  This script is a modified version of this: https://github.com/jverkoey/nimbus/blob/master/scripts/generate_namespace_header
#  The first uniq optimises for when its a universal binary. The final uniq prevents dup defines when there are methods with same name but different params.

name=$1
upperName="$(echo $name | tr '[a-z]' '[A-Z]')"
prefix=$2
lowerPrefix="$(echo $prefix | tr '[A-Z]' '[a-z]')"

filename=${prefix}NamespaceDefines.h
header=$SRCROOT/$name/$filename
binary=$CODESIGNING_FOLDER_PATH/$name
now=$(date +"%d/%m/%Y")

echo "Generating $header from $binary..."

echo "//
//  $filename
//  $name
//
//  Generated using MHNamespaceGenerator on $now
//

#if !defined(__${upperName}_NS_SYMBOL) && defined(${upperName}_NAMESPACE)
    #define __${upperName}_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __${upperName}_NS_BRIDGE(ns, symbol) __${upperName}_NS_REWRITE(ns, symbol)
    #define __${upperName}_NS_SYMBOL(symbol) __${upperName}_NS_BRIDGE(${upperName}_NAMESPACE, symbol)" > $header

echo "// Classes" >> $header

nm $binary -j | sort | uniq | grep "^_OBJC_CLASS_\$_$prefix" | sed -e "s/_OBJC_CLASS_\$_\(.*\)/    #define \1 __${upperName}_NS_SYMBOL(\1)/g" >> $header

echo "// Categories" >> $header

nm $binary -j | sort | uniq | grep "^[+-]\[.*($prefix) ${lowerPrefix}_" | sed -e "s/[+-]\[.*($prefix) \(${lowerPrefix}_[a-zA-Z]*\).*/    #define \1 __${upperName}_NS_SYMBOL(\1)/g" | sort | uniq >> $header

#echo "// Functions" >> $header

#nm $CODESIGNING_FOLDER_PATH | sort | uniq | grep " T " | cut -d' ' -f3 | grep -v "\$_NS" | grep -v "\$_UI" | sed -e 's/_\(.*\)/    #define \1 __${upperName}_NS_SYMBOL(\1)''/g' >> $header

echo "// Externs" >> $header

#nm $CODESIGNING_FOLDER_PATH | sort | uniq | grep " D " | cut -d' ' -f3 | sed -e 's/_\(.*\)/    #define \1 __${upperName}_NS_SYMBOL(\1)''/g' >> $header

nm $binary | sort | uniq | grep " S _\($prefix\|$name\)" | cut -d' ' -f3 | sed "/${name}VersionNumber/d" | sed "/${name}VersionString/d" | sed -e "s/_\(.*\)/    #define \1 __${upperName}_NS_SYMBOL(\1)/g" | sort | uniq >> $header

echo "#endif" >> $header
#echo "#import <$name/$name.h>" >> $header
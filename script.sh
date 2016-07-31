# This script is a modified version of this: https://github.com/jverkoey/nimbus/blob/master/scripts/generate_namespace_header
# The first uniq optimises for when its a universal binary. The final uniq prevents dup defines when there are methods with same name but different params.

name="MHCloudKit"
upperName="MHCLOUDKIT"
prefix="MHCK"
lowerPrefix="mhck"
filename=${prefix}NamespaceDefines.h
header=$SRCROOT/$name/$filename
binary=$CODESIGNING_FOLDER_PATH/$name

echo "Generating $header from $binary..."

echo "//
//  $filename
//  $name
//
//  Auto-generated using script created by Malcolm Hall on 30/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
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

nm $binary | sort | uniq | grep " S _\($prefix\|$name\)" | cut -d' ' -f3 | sed -e "s/_\(.*\)/    #define \1 __${upperName}_NS_SYMBOL(\1)/g" | sort | uniq >> $header

echo "#endif" >> $header
#echo "#import <$name/$name.h>" >> $header
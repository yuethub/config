#!/bin/bash

cTemplate()
{
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        printf "#include <stdio.h>\n" >> $1
        printf "\n" >> $1
        printf "int main(int argc, char *argv[])\n" >> $1
        printf "{\n\n}\n" >> $1
    fi
}

hTemplate()
{
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        preffix=$(echo $1 | cut -d '.' -f 1)
        printf "#ifndef _${preffix^^}_H_\n" >> $1
        printf "#define _${preffix^^}_H_\n" >> $1
        printf "\n\n" >> $1
        printf "#endif\n" >> $1
        unset preffix
    fi
}

cppTemplate()
{
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        preffix=$(echo $1 | cut -d '.' -f 1)

        # create c++ header file
        hfile="${preffix}.h"
        if [ ! -f $hfile ];then
            printf "#ifndef _${preffix^^}_H_\n" >> $hfile
            printf "#define _${preffix^^}_H_\n" >> $hfile
            printf "\n" >> $hfile
            printf "class ${preffix^}\n" >> $hfile
            printf "{\npublic:\n" >> $hfile
            printf "\t${preffix^}();\n" >> $hfile
            printf "\t~${preffix^}();\n\n" >> $hfile
            printf "private:\n\n" >> $hfile
            printf "};\n\n\n" >> $hfile
            printf "#endif\n" >> $hfile
        fi

        # create C++ source file
        printf "#include \"$hfile\"\n\n"  >> $1
        printf "${preffix^}::${preffix^}()\n" >> $1 
        printf "{\n\n}\n\n" >> $1
        printf "${preffix^}::~${preffix^}()\n" >> $1
        printf "{\n\n}\n\n" >> $1
        unset hfile
        unset preffix
    fi
}

shTemplate()
{
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        printf "#!/bin/sh\n\n" >> $1
    fi
}

pyTemplate()
{
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        printf "#!/usr/bin/python3\n\n" >> $1
    fi
}

for arg in $@
do
    suffix=$(echo $arg | cut -d '.' -f 2)
    case $suffix in 
        c)
            cTemplate $arg
            ;;
        cpp|cc)
            cppTemplate $arg
            ;;
        h|hpp)
            hTemplate $arg
            ;;
        sh)
            shTemplate $arg
            ;;
        py)
            pyTemplate $arg
    esac
done

/usr/bin/vim $@
exit



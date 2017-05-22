#!/bin/bash

select svar in  Release Relwithdebinfo Debug; do
    case $svar in
        Release ) buildType=$svar;echo "Du valde $buildType. "; break;;
        Relwithdebinfo ) buildType=$svar; echo "Du valde $buildType"; break;;
	Debug ) buildType=$svar; echo "Du valde $buildType"; break;;
    esac
done

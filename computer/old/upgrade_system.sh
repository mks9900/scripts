#!/bin/bash

echo "Vill du synka?"
select sync in  Ja Nej; do
    case $sync in
	Ja ) echo "Ok, synkar portage och layman."; sudo layman -S && sudo emerge --sync --quiet;break;;
	Nej ) echo "Ok, hoppar över synkningen.";break;;
    esac
done

echo "Vill du kompilera med --newuse eller --upgrade?"
select newOrUpdate in N U; do
    case $newOrUpdate in
	N ) echo "Ok, bygger @world med --new-use."; sudo emerge -avDN @world;break;;
	U ) echo "Ok, bygger @world med --upgrade."; sudo emerge -avuD @world;break;;
    esac
done

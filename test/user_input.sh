

# =============================================================================================
# Har kvar den här satsen för framtida bruk...

echo "Vill du ta bort eller döpa om den gamla versionen av RawTherapee? (D/T)?"
select dt in "Döp om" "Ta bort"; do
    case $dt in
        "Döp om" ) echo "Döper om nu."; mv $target $HOME/rt_default_release_OLD ; break;;
        "Ta bort" ) echo "Tar bort nu."; mv $target $wasteBin; break;;
    esac
done
# =============================================================================================

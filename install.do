* Local installation script for statanotify
cap program drop statanotify
net install statanotify, from("`c(pwd)'") replace
rehash
display as text "statanotify has been installed locally from `c(pwd)'"

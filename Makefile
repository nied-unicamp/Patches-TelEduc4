copy:
	cp atualizador43to44.sh ~/public_html
	cp unsafe_install.sh ~/public_html

run: copy
	$here=$(pwd)
	cd ~/public_html
	sudo bash atualizador43to44.sh
	cd $here

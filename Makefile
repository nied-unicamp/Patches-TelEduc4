copy:
	cp atualizador43to44.sh ~/public_html
	cp unsafe_install.sh ~/public_html

run: copy
	sudo bash ~/public_html/atualizador43to44.sh

#!/bin/bash
# Exibe linhas em toda a largura do terminal.
echo_c()
{
  w=$(stty size | cut -d" " -f2)       # width of the terminal
  l=${#1}                              # length of the string
  printf "%"$((l+(w-l)/2))"s\n" "$1"   # print string padded to proper width (%Ws)
}

# Exibe o header do instalador.
show_title()
{
	clear
	title="ATUALIZADOR - TELEDUC 4.3.2 PARA 4.4"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	echo_c "$title"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

test_internet_connection()
{
	wget -q --tries=10 --timeout=20 --spider http://teleduc.org.br
	if [[ $? -eq 0 ]]; then
	        echo "Conexao com o servidor efetuada com sucesso."
	else
	        echo "
Nao foi possivel se conectar ao servidor do TelEduc.
Este script exige acesso a internet. Por favor verifique sua conexao.
"
	        exit
	fi
}

# Verifica que o script esta sendo executado a partir da raiz do teleduc.
# Busca o arquivo teleduc.inc para isso.
test_script_location()
{
	if [ ! -e ./cursos/aplic/bibliotecas/teleduc.inc ]; then
		show_title
		echo "Este script nao esta na pasta raiz do teleduc.
	Por favor copie este script na pasta raiz do teleduc e execute-o a partir de la."
		echo ""
		exit
	fi
}

test_script_permissions()
{
	if [[ $UID != 0 ]]; then
		show_title
		echo "Esse script nao foi executado com privilegios de administrador."
		echo "Por favor execute este script com o seguinte comando:"
	    echo "
sudo bash $0 $*
	    "
	    exit
	fi
}

test_internet_connection
test_script_location
test_script_permissions


MYSQL=/usr/bin/mysql

# Utiliza os dados de teleduc.inc para obter acesso ao banco de dados.
BD=$(grep "'dbnamebase'" ./cursos/aplic/bibliotecas/teleduc.inc | sed "s|\$_SESSION\['dbnamebase'\]='||" | sed "s/';//")
MYSQL_USER=$(grep "'dbuser'" ./cursos/aplic/bibliotecas/teleduc.inc | sed "s|\$_SESSION\['dbuser'\]='||" | sed "s/';//")
MYSQL_PASSWORD=$(grep "'dbpassword'" ./cursos/aplic/bibliotecas/teleduc.inc | sed "s|\$_SESSION\['dbpassword'\]='||" | sed "s/';//")

atual=$(pwd)

# Caminho completo da pasta onde estao os arquivos anexos.
archives=$($MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -e "use $BD; select diretorio from Diretorio where item='Arquivos';" | grep "/")

# Caminho da pasta onde estao os arquivos anexos, relativo a raiz do teleduc. 
relative_archives=$($MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -e "use $BD; select diretorio from Diretorio where item='Arquivos';" | grep "/" | sed "s|$atual||" | sed "s|/||")

# Este laco testa se a pasta de arquivos anexos esta dentro da raiz do teleduc.
# Inside recebe 1 se a pasta de arquivos eh subpasta da raiz.
inside="0"
cd "$archives"
while [ "$archives" != "/" ]; do
	if [ "$archives" == "$atual" ]; then
		inside="1"
		break
	fi
	cd ./..
	archives=$(pwd)
done
cd "$atual"



# Tenta obter document_root do apache a partir de possiveis arquivos de configuracao.
if [ -a /etc/apache2/sites-enabled/000-default.conf ]; then

	buscaDocumentRoot=$(grep "/var/www/html" /etc/apache2/sites-enabled/000-default.conf)
	if [ "$buscaDocumentRoot" != "" ]; then
		document_root="/var/www/html"
	else
		document_root="/var/www"
	fi

elif [ -a /etc/httpd/conf/httpd.conf ]; then

	buscaDocumentRoot=$(grep "/var/www/html" /etc/httpd/conf/httpd.conf)
	if [ "$buscaDocumentRoot" != "" ]; then
		document_root="/var/www/html"
	else
		document_root="/var/www"
	fi

elif [ -a /etc/apache2/sites-enabled/000-default ]; then

	buscaDocumentRoot=$(grep "/var/www/html" /etc/apache2/sites-enabled/000-default)
	if [ "$buscaDocumentRoot" != "" ]; then
		document_root="/var/www/html"
	else
		document_root="/var/www"
	fi

else
	document_root="/var/www/html"
fi

#document_root=$(grep 'DocumentRoot' /etc/apache2/sites-enabled/000-default.conf | sed 's/DocumentRoot//' | sed 's/\t//' | sed 's/ //')
#if [ -z $document_root ]; then
#	$document_root="/var/www/html"
#fi
#http://www.commandlinefu.com/commands/view/9020/how-to-get-the-apache-document-root
#http://stackoverflow.com/questions/19752834/where-do-i-find-documentroot-on-ubuntu-after-installing-php-mysql-and-apache2


ANSWER="5"
while [  "$ANSWER" != "1" ] && [ "$ANSWER" != "2" ]; do
	show_title
	echo "Por favor escolha uma opcao.
	1 - Instalar telduc em /usr/share (RECOMENDADO).

	2 - Manter o teleduc instalado na pasta atual. (NAO recomendado)."

	read ANSWER
	
	if [ "$ANSWER" == "2" ]; then
		#Inicializa resposta do usuario.
		ANSWER="5"
		while [  "$ANSWER" != "1" ] && [ "$ANSWER" != "sim" ] && [ "$ANSWER" != "2" ] && [ "$ANSWER" != "nao" ] && [ "$ANSWER" != "n" ] && [ "$ANSWER" != "s" ]; do
			show_title

			echo "Para que a atualizacao forneca importantes melhorias de seguranca, RECOMENDAMOS FORTEMENTE que o teleduc seja instalado em /usr/share.
Voce deseja realizar a atualizacao sem instalar o teleduc em /usr/share?
1 - sim
2 - nao"
			#Recebe resposta do usuario.
			read ANSWER
			#Torna a resposta composta apenas por letras minusculas.
			#ANSWER=${USER_ENTRY,,}
		done
		
		#Se o user deseja instalar de forma insegura.
		if [ "$ANSWER" == "1" ] || [ "$ANSWER" == "sim" ] || [ "$ANSWER" == "s" ]; then
			ANSWER="5"
			#Confirma o desejo do usuario de instalar de forma insegura.
			while [  "$ANSWER" != "1" ] && [ "$ANSWER" != "sim" ] && [ "$ANSWER" != "2" ] && [ "$ANSWER" != "nao" ] && [ "$ANSWER" != "n" ] && [ "$ANSWER" != "s" ]; do
				show_title
				echo "Voce TEM CERTEZA que deseja abrir mao das importantes melhorias de seguranca da nova versao? Faca-o por sua conta e risco.
1 - sim
2 - nao"
				read ANSWER
				#ANSWER=${USER_ENTRY,,}
			done
			if [ "$ANSWER" == "1" ] || [ "$ANSWER" == "sim" ] || [ "$ANSWER" == "s" ]; then
				#Executa script de copia de arquivos atualizados.
				sudo bash unsafe_install.sh
				exit
			fi		
		fi
		ANSWER="5"	

	fi
	
done


	
# ANSWER="5"
# while [  "$ANSWER" != "1" ] && [ "$ANSWER" != "2" ]; do	
	
# 	show_title
	
# 	echo "Por favor escolha a pasta do TelEduc no servidor.
# 	1 - Manter pasta atual  -  (RECOMENDADO. A url nao sera modificada)

# 	2 - $document_root  -  (A url pode acabar sendo modificada)"

# 	read ANSWER
# done

# Nome da pasta raiz do teleduc.
THIS_FOLDER=${PWD##*/}

# Se o usuario escolheu por manter o teleduc na pasta atual, entao o link para
# webdriver sera o endereco atual.
# if [ "$ANSWER" == "1" ]; then
	LINK_ADR=$(pwd)
	OPTION="1"
# fi

# Se o usuario escolheu utilizar a pasta padrao do apache para a raiz do teleduc,
# entao o link para webdriver deve estar em document_root/nome-da-raiz-do-teleduc.
# if [ "$ANSWER" == "2" ]; then
LINK_ADR="$document_root/$THIS_FOLDER"
OPTION="2"
# fi

# Pasta raiz antiga.
OLD_INSTALL_DIR=$(pwd)
# Pasta raiz nova: em usr/share/teleduc/webdriver.
NEW_INSTALL_DIR=/usr/share/teleduc/webdriver

cd ./cursos/diretorio

# Pasta atual.
DIR=$(pwd)

show_title
echo "Criando restaurador de links da pasta diretorio..."

# Fornece todos os links, e seus destinos, criando o comando de recriacao de cada link.
for dir in $DIR/* ; do
	if [ -d $dir ] && [ ! -L $dir ]; then
		echo "cp -R $dir /usr/share/teleduc/webdriver/cursos/diretorio"
	fi    
    if [ -L "$dir" ]; then
	# Obtem local para o onde o link vai apontar.
	destiny=$(readlink "$dir")
        printf "%s %s " "ln -s" "$destiny"
	# O sed e executado apenas no endereco do link, pois o local apontado nao mudara.
	printf "%s\n" $dir | sed 's|'$OLD_INSTALL_DIR'|'$NEW_INSTALL_DIR'|'
    fi
done > ./../../recria_links.sh

cd ./../../..

# renomeia pasta atual para permitir criacao do link.
mv $THIS_FOLDER $THIS_FOLDER'old' # falta tratar erro que surge se ja existe pasta com esse nome.
cd $THIS_FOLDER'old'

echo "Instalando o teleduc atraves do pacote do sistema..."

###### Simula uma instalacao via DEB ou RPM.
simula_pacote()
{
	sudo cp -R ./teleduc /usr/share
	sudo chmod -v 711 /var/www
	sudo chmod -v 755 /usr/share/teleduc
	sudo chmod -v 775 /usr/share/teleduc/config
	sudo chown -v www-data:www-data /usr/share/teleduc/config/teleduc.inc
	sudo chmod -v 700 /usr/share/teleduc/config/teleduc.inc
	sudo chown -v www-data /usr/share/teleduc
	sudo chown -v www-data /usr/share/teleduc/webdriver/cursos/aplic/bibliotecas
	sudo chown -v www-data /usr/share/teleduc/webdriver/cursos/diretorio
	sudo chown -Rv www-data /usr/share/teleduc/webdriver/instalacao
	sudo chown -Rv www-data /usr/share/teleduc/config
	sudo ln -s /usr/share/teleduc/webdriver /var/www/html/teleduc
}
######

so=$(lsb_release -si | tr [A-Z] [a-z])

if [ "$so" == "ubuntu" ] || [ "$so" == "debian" ]; then
	# Importa chave do deb do teleduc.
	wget -O - http://143.106.157.5/repos/apt/Ubuntu/equipe.teleduc@gmail.com.gpg.key | sudo apt-key add -
	# Adiciona URL do repositorio do teleduc ao arquivo de configuracao do apt.
	echo "deb http://143.106.157.5/repos/apt/Ubuntu/ trusty main" >> /etc/apt/sources.list
	sudo apt-get update
	# Instala o teleduc.
	sudo apt-get install teleduc
elif [ "$so" == "fedora" || "$so" == "centos" ]; then
	# Baixa repositorio.
	wget http://www.teleduc.org.br/repo/rpm/noarch/teleduc-repo-1.0-0.noarch.rpm
	# Instala o repositorio.
	sudo yum localinstall teleduc-repo-1.0-0.noarch.rpm
	# Instala o teleduc.
	sudo yum install teleduc
	# Apaga arquivo baixado.
	rm teleduc-repo-1.0-0.noarch.rpm
else
	# Executa simulacao de instalacao via pacote DEB ou RPM sem exibir nada no terminal.
	simula_pacote > scriptname >/dev/null
fi

echo "Restaurando dados da instalacao antiga..."

if [ -L /var/www/html/teleduc ]; then
	rm /var/www/html/teleduc	
fi

if [ ! -L $LINK_ADR ]; then
	sudo ln -s /usr/share/teleduc/webdriver $LINK_ADR
	#mv /var/www/html/teleduc $LINK_ADR	
fi

# Remove teleduc.inc vazio instalado pelo pacote.
rm /usr/share/teleduc/config/teleduc.inc

# Restaura teleduc.inc da versao antiga
cp ./cursos/aplic/bibliotecas/teleduc.inc /usr/share/teleduc/config/

# Redefine permissoes do arquivo teleduc.inc
chown www-data:www-data /usr/share/teleduc/config/teleduc.inc
chmod 700 /usr/share/teleduc/config/teleduc.inc

# Apaga pasta instalacao
rm -R /usr/share/teleduc/webdriver/instalacao

echo "Atualizando informacoes do banco de dados..."

# Caso a raiz do teleduc nao tenha mudado de lugar.
if [ "$OPTION" == "1" ]; then
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "USE $BD; update Config set valor='4.4' where item='versao';"`	
fi
# Caso a raiz do teleduc tenha mudado de lugar, sera preciso atualizar o novo lugar no BD.
if [ "$OPTION" == "2" ]; then
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "USE $BD; update Diretorio set diretorio='/$THIS_FOLDER' where item='raiz_www'; update Config set valor='4.4' where item='versao';"`	
fi


echo "Restaurando links da pasta diretorio..."

# Se a pasta de arquivos esta dentro da raiz do teleduc, entao eh preciso muda-la de lugar e armazenar a nova pasta no BD.
if [ "$inside" == "1" ]; then

	cp -R $relative_archives /usr/share/teleduc/config
	atual=$(pwd)

	cd $relative_archives

	THIS_FOLDER=${PWD##*/}

	cd ./..

	cp -R $THIS_FOLDER ./arquivos

	mv arquivos /usr/share/teleduc/config	

	cd $atual

	sed -i "s|$OLD_INSTALL_DIR/$relative_archives|/usr/share/teleduc/config/arquivos|g" recria_links.sh
	
	databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "USE $BD; update Diretorio set diretorio='/usr/share/teleduc/config/arquivos' where item='Arquivos';"`
fi

c=$OLD_INSTALL_DIR'old'
sed -i "s|$OLD_INSTALL_DIR|$c|g" recria_links.sh

# Restaura links da pasta diretorio na raiz da nova versao do teleduc:
bash recria_links.sh

echo "Atualizacao concluida!"


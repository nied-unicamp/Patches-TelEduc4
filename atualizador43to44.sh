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

document_root="/var/www/html"

#Inicializa resposta do usuario.
ANSWER="5"
while [  "$ANSWER" != "1" ] && [ "$ANSWER" != "2" ]; do
    show_title
    if [ "$ANSWER" != "1" ] && [ "$ANSWER" == "2" ] && [ "$ANSWER" == "5" ]; then
	echo "Resposta invalida"
    fi
    echo "Por favor escolha uma opcao.
	1 - Atualizar o TelEduc instalado na pasta atual para a versao 2.4.

	2 - Sair"

    read ANSWER
    
    if [ "$ANSWER" == "1" ]; then
	#executar script de instalacao
	sudo bash update_install.sh

	
	
    elif [ "$ANSWER" == "2" ]; then
	exit
    fi
done

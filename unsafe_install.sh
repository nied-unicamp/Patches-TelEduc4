#!/bin/bash
# Nome da pasta raiz do teleduc.
THIS_FOLDER=${PWD##*/}

# Caso haja uma pasta chamada config em um nivel acima da raiz, entao nao eh possivel atualizar o teleduc com este script.
if [ -d ./../config ]; then
	cd ./..
	UP_FOLDER=$(pwd)
	echo "ERRO!
A atualizacao nao pode ser feita pois ja existe uma pasta chamada config em $UP_FOLDER.
Se deseja forcar a atualizacao, por favor remova ou renomeie a pasta $UP_FOLDER/config."
	cd $THIS_FOLDER
	exit
fi

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
echo "atual criado: $atual"
echo "archives criado: $archives"
echo "relative_archives criado: $relative_archives"

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

# Se anexos dentro da raiz do teleduc...
	# Criar recria_links.sh, alterando destiny de coisa-dentro-da-raiz para /usr/share/teleduc/config/arquivos

# Baixa o codigo fonte do teleduc 4.4.

mkdir teleduc
cd teleduc
wget http://www.teleduc.org.br/repo/TelEduc/sources/teleduc-4.4.0-2.tar.gz
tar -vzxf teleduc-4.4.0-2.tar.gz
cd ..

# Ajusta permissoes antes de instalar.
chmod -v 755 teleduc
chmod -v 775 teleduc/config
chmod -v 700 teleduc/config/teleduc.inc

if [ "$so" == "ubuntu" ] || [ "$so" == "debian" ]; then
	chown -v www-data:www-data teleduc/config/teleduc.inc
	chown -v www-data:www-data teleduc
	chown -v www-data:www-data teleduc/webdriver/cursos/aplic/bibliotecas
	chown -v www-data:www-data teleduc/webdriver/cursos/diretorio
	chown -Rv www-data:www-data teleduc/webdriver/instalacao
	chown -Rv www-data:www-data teleduc/config
elif [ "$so" == "fedora" ] || [ "$so" == "centos" ]; then
	chown -v apache:apache teleduc/config/teleduc.inc
	chown -v apache:apache teleduc
	chown -v apache:apache teleduc/webdriver/cursos/aplic/bibliotecas
	chown -v apache:apache teleduc/webdriver/cursos/diretorio
	chown -Rv apache:apache teleduc/webdriver/instalacao
	chown -Rv apache:apache teleduc/config
fi

# Instala a pasta config mantendo as permissoes.
cp -rp teleduc/config ./..

# Se arquivos dentro da raiz do teleduc
	# Copiar antiga pasta na raiz para ./../config
	# Reomea-la para arquivos.

# Criacao de variaveis usadas na criacao da pasta com a nova instalacao.
cd ./..
# A instalacao antiga fica salva em uma pasta com posfixo old.
mv $THIS_FOLDER $THIS_FOLDER'old'
old=$THIS_FOLDER'old'

cd $old

# Instala a raiz do teleduc mantendo as permissoes.
cp  -Rp teleduc/webdriver ./../$THIS_FOLDER
cd ./..

# Caso os arquivos de anexos estejam dentro da raiz, sera preciso copia-los da pasta old.
if [ "$inside" == "1" ]; then
	cd $old
	# Copia os anexos da pasta old para a nova pasta raiz.
	cp -Rn ./$relative_archives ./../$THIS_FOLDER
	cd ..
fi

#cd ..
rm -R ./$THIS_FOLDER/cursos/diretorio

# Copia a pasta diretorio antiga, mantendo seus links.
cp -rp ./$old/cursos/diretorio $THIS_FOLDER/cursos

# Se anexos dentro da raiz do teleduc:
	# Remover todos os links da pasta diretorio...
	# Executar recria_links.sh

cp -p ./$old/cursos/aplic/bibliotecas/teleduc.inc ./config

# Remove os itens da pasta instalacao um a um.
# Eh feito assim para nao apagar os arquivos de anexos caso eles estejam na pasta instalacao.
rm $THIS_FOLDER/instalacao/index.php
rm $THIS_FOLDER/instalacao/instalacao.css
rm $THIS_FOLDER/instalacao/instalacao.inc
rm $THIS_FOLDER/instalacao/template_instalacao.php
rm $THIS_FOLDER/instalacao/base_geral.sql
rm $THIS_FOLDER/instalacao/textos.sql

# Atualiza versao do teleduc no banco de dados.
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "USE $BD; update Config set valor='4.4' where item='versao';"`


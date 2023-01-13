#!/bin/bash

localiza_arquivo () 
{
	ARQUIVOS=$(find ./ ! -executable)
	for ATUAL in $ARQUIVOS
	do
		file $ATUAL | cut -d':' -f2 | grep -i ascii > /dev/null 2>&1
		if [ $(echo $?) -eq 0 ]; then
			VAR5=$(cat $ATUAL)
		fi
	done
}

entra_se_diretorio ()
{
	if [ -d "$VAR4" ] ; then
		cd "$VAR4"
	fi
}

main ()
{
	echo "Executando em `hostname`"
	
	cd /home/html/inf/cursos/ci1001/tshell1

	#VAR1 recebe o texto "arquivo1"
	VAR1=$(cat README)
	
	#VAR2 recebe o numero "13"
	VAR2=$(cat $VAR1 | head -n1 | cut -d';' -f3)

	BYTE=c

	#ARQUIVO recebe o texto que corresponde ao caminho e nome do arquivo de 13 bytes
	ARQUIVO=$(find ./ -size $VAR2$BYTE)

	#VAR3 = recebe o texto "backup velho"
	VAR3=$(cat $ARQUIVO)

	PONTO=.

	#VAR4 recebe o texto que corresponde ao caminho de ".backup velho"
	VAR4=$(find ./ -type d -name $PONTO"$VAR3")

	#Verificando se ".backup velho" é msm um diretorio para poder entrar nele
	entra_se_diretorio $VAR4

	localiza_arquivo

	cp ../senha.gpg /nobackup/bcc/rbfj19	

	cd /nobackup/bcc/rbfj19

	#A VAR LINHA_DA_SENHA recebe o valor 101 apos o calculo, correspondente a linha que se deve analisar
	LINHA_DA_SENHA=$(echo "(($(ls -l senha.gpg | awk '{print $5}')/2000000)-43)" | bc)

	nice -n 13 gpg --batch -o senha.txt --passphrase $VAR5 senha.gpg > /dev/null 2>&1

	SENHA_DA_CASA=$(cat -n senha.txt | sed -n "$LINHA_DA_SENHA p" | tr -d "[a-z0-1.' ']" | sed 'y/AEIOU/12345/')

	STRING_FINAL=$(echo "A senha da casa eh"$SENHA_DA_CASA)

	echo $STRING_FINAL && echo $STRING_FINAL > ~/tmp/resultado.txt

	rm senha.gpg senha.txt
}

login () {
ssh orval 'bash -s' < ~/bin/tshell1.sh || ssh cpu1 'bash -s' < ~/bin/tshell1.sh || ssh cpu2 'bash -s' < ~/bin/tshell1.sh
}

inicio () {
	if [ `hostname` != "macalan" ]; then
		main
	else
		login
	fi
}

inicio

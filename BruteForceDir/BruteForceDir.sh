#!/bin/bash

YellowBold="\e[1;33m"
YellowDim="\e[2;33m"
White="\e[0;97m"
WhiteBold="\e[1;97m"
WhiteDim="\e[2;97m"
Cyan="\e[0;36m"
Hidden="\e[8;97m]"
ResetColor="\e[0;97m"

echo -e "$YellowBold
  ____             _       _____                  ____  _
 | __ ) _ __ _   _| |_ ___|  ___|__  _ __ ___ ___|  _ \(_)_ __
 |  _ \| '__| | | | __/ _ \ |_ / _ \| '__/ __/ _ \ | | | | '__|
 | |_) | |  | |_| | ||  __/  _| (_) | | | (_|  __/ |_| | | |
 |____/|_|   \__,_|\__\___|_|  \___/|_|  \___\___|____/|_|_|    $ResetColor
                                              $YellowDim Giuliano Mantovi$ResetColor\n\n  "

WordList=ListaPadrao
UserAgent=BruteForceDir
FileSearch=0

while [ True ]; do
  if [ "$1" = "--help" -o "$1" = "-h" ]; then

    echo -e "$WhiteBold Sintaxe:$ResetColor BruteForceDir [Opcoes] [URL-Base]\n"
    echo -e "$WhiteBold Opcoes:$ResetColor"
    echo -e "$White -f\t ou\t --file-search\t Ativa a busca por arquivos nos diretorios encontrados"
    echo -e "$White -h\t ou\t --help\t\t Exibe este guia"
    echo -e "$White -u\t ou\t --user-agent\t Altera o User-Agent da requisicao$ResetColor\t$WhiteDim BruteForceDir -u [user-agent]"
    echo -e "$White -w\t ou\t --word-list\t Utiliza a WordList especificada$ResetColor\t$WhiteDim BruteForceDir -w [word-list]"
    exit
    shift 1

  elif [ "$1" = "-w" -o "$1" = "--word-list" ]; then

    WordList=$2
    echo -e "$WhiteBold Word List:$ResetColor\t$White$2$ResetColor"

    shift 2

  elif [ "$1" = "-u" -o "$1" = "--user-agent" ]; then

    UserAgent=$2
    echo -e "$WhiteBold User Agent:$ResetColor\t$White$2$ResetColor"

    shift 2

  elif [ "$1" = "-f" -o "$1" = "--file-search" ]; then

    echo -e "$WhiteBold Busca por arquivos ativa$ResetColor"
    FileSearch=1

    shift 1

  else
    break
  fi
done

echo -e "$WhiteBold Dominio:$ResetColor\t$White$1$ResetColor"
echo -e "$Cyan------------------------------------------------------------------$ResetColor"

for palavra in $(cat $WordList); do
  echo -ne "$WhiteBold Diretorio:$ResetColor\thttp://$1/$palavra/\033[0K\r"

  Request=$(curl -o "dev/null" -w "%{http_code}" -s -A "$UserAgent"  $1/$palavra/)

  if [ "$Request" = 200 ]; then
    echo ""
    echo "$palavra" >> Temp
  fi

done

if [ "$FileSearch" = 1 ]; then

  for palavra2 in $(cat Temp); do

    echo -e "$Cyan------------------------------------------------------------------$ResetColor\033[0K\r"
    echo -e "$WhiteBold Buscando em:$ResetColor $1/$palavra2"

    for arquivo in $(cat ListaArquivo); do

      echo -ne " ->$WhiteBold Arquivo:$ResetColor\thttp://$1/$palavra2/$arquivo\033[0K\r"

      Request=$(curl -o "dev/null" -w "%{http_code}" -s -A "$UserAgent"  $1/$palavra2/$arquivo)

      if [ "$Request" = 200 ]; then
        echo ""
      fi

    done

  done

fi

rm Temp

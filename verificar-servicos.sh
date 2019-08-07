#!/bin/bash

PATH=/usr/bin:/sbin:/bin:/usr/sbin
export PATH

#GEARMAN=$(ls /usr/lib/systemd/system/ | grep -owih gearmand.*)
#if [[ -z $GEARMAN ]]; then
#	echo "ERROR: Instalação do Gearman não pode ser localizada." 	
#	exit 1
#else
#	ps cax | grep -ih gearman.* > /dev/null
#	if [ $? -ne 0 ]; then
#        echo "Gearman: Iniciando serviço de gerenciamento de fila de tarefas..."
#		service $GEARMAN start;	        
#	fi
#fi
#
#SUPERVISOR=$(ls /usr/lib/systemd/system/ | grep -owih supervisord.*)
#if [[ -z $SUPERVISOR ]]; then
#	echo "ERROR: Instalação do Supervisor não pode ser localizada."
#	exit 1
#else
#	ps cax | grep -ih supervisor.* > /dev/null
#	if [ $? -ne 0 ]; then
#            echo "Supervisor: Iniciando serviço de monitoramento dos processos de integração..."
#        	service $SUPERVISOR start;
#	else
#	
#	    COMMAND=$(ps -C php -f | grep -o "PendenciasTramiteRN.php");
#	    if [ -z "$COMMAND" ]; then
#            echo "Supervisor: Reiniciando serviço de monitoramento dos processos de integração..."
#            service $SUPERVISOR stop;
#            service $SUPERVISOR start;                 
#	    fi
#	
#        COMMAND=$(ps -C php -f | grep -o "ProcessarPendenciasRN.php");
#        if [ -z "$COMMAND" ]; then
#            echo "Supervisor: Reiniciando serviço de monitoramento dos processos de integração..."
#	        service $SUPERVISOR stop;
#	        service $SUPERVISOR start;	                
#	    fi
#	fi
#fi


echo "vou verificar"

d=$(dirname "$0")
echo "dir: $d"
cd $d

python verificar-pendencias-represadas.py
r=$?
echo "verifiquei $r"
if [ "$r" == "2" ]; then
    echo "reboot"
    supervisorctl stop all;
    systemctl stop gearmand;
    systemctl start gearmand;
    supervisorctl start all;
    
    echo "rebootado"
    rm -rf pendencias.json
fi

exit 0

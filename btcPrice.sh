#/bin/bash
#Autor -> Charly0n3
#Funcionamiento -> Busca en la api de coindesk el precio de bitcoin en euros usando curl para la petición y jq para el formateo de los datos en formato json y lo imprime junto a la fecha actual en tiempo real.
#Nota -> Necesitarás conexión a internet para que se pueda enviar la petición a la api



# Colores

green="\e[0;32m\033[1m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
end="\033[0m\e[0m"


# Función dependencias, comprueba en un bucle si los programas almacenados en el array están en el sistema
# en caso de no estar, avisa al usuario y los instala, en caso de no tener conectividad avisa al usuario.


dependencies() {
        dep=(curl jq)
        for program in "${dep[@]}"; do

                test -f /usr/bin/$program

                if [ $(echo $?) -eq 0 ]; then
                        echo -e "\n${green}- [V]${end} $program\n" &> /dev/null
                else
                        echo -e "${red}- [X]${end} $program" > /dev/null
                        echo -e "${red}- [*]${end} Instalando herramienta.. [ $program ]"; > /dev/null
			apt-get install $program -y &> /dev/null

				ping=$(ping -c1 www.google.es &> /dev/null; echo $?)

				if [ $ping -ne 0 ]; then
					echo -e "\n${red}[x]${end} Tienes un problema de red y no se han podido instalar los paquetes: [$program]"
					sleep 1; exit 1
				fi
                fi
        done
}

# Función precio, esta función se conecta a la api de coindesk, y filtra el formato json con jq para sacar solo el precio de bitcoin,
# además añadí la fecha actual.

price() {
date=$(date +%d/%m/%y)

btc=$(curl -s https://api.coindesk.com/v1/bpi/currentprice.json | jq -r '.bpi.EUR.rate' 2> /dev/null)

for i in $(seq 1 15); do
        echo -n
        echo -n "--"
	echo -n
done; echo

echo -e "   Fecha => ${green}$date${end}"
echo
echo -e "   ${yellow}BTC${end} => $btc€"

for i in $(seq 1 15); do
        echo -n
        echo -n "--"
	echo -n
done; echo


}

# main, en primer lugar ejecutamos la función dependencias. después comprueba si hay conectividad de nuevo (Aun que no haría falta ya que en dependencias controlamos esto).
# Si hay conectividad enseña el precio, si no avisa de que hay un problema.

#if [ $(id -u) -eq 0 ]; then

	dependencies

	ping=$(ping -c1 www.google.es &> /dev/null; echo $?)
	if [ $ping -eq 0 ]; then
		price
	else

		echo -e "\n${red}[x]${end} Tienes un problema de red y no se ha podido cargar la cotización de Bitcoin."
	fi

#else
#	echo -e "\n${red}[ERROR]${end} Debes ejecutar el script como root"; sleep 1
#	exit 1

#fi

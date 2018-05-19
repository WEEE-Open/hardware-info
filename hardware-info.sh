#! /bin/bash
commands=("echo WEEE Open" "lshw" "lspci -v" "lscpu" "./WEEE_SmartCTL")
#Checking root
if (( $EUID != 0 )); then
    echo "Please run me as root"
   exit 1
fi

# Installing only smartmontools
echo "Installing smartmontools"
apt-get --no-install-recommends install -y smartmontools

# Creating output file
echo "Sto creando il file di log..."
touch $1

#Run commands
for ((i = 0; i < ${#commands[@]}; i++))
do
    echo "Running ${commands[$i]}"
    eval ${commands[$i]} >> $1
done

#View result
echo "This is the result!"
cat $1

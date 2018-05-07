#! /bin/sh
# Variables
dependencies=( "grep" "lsblk" "lshw" "lspci" "lscpu" "smartctl")
commands=("echo WEEE Open" "lshw" "lspci -v" "lscpu" "./WEEE_SmartCTL")

#Check dependencies
for dep in ${dependencies[@]}
do
	echo "Testing $dep ..."
    if ! [ -x "$(command -v $dep)" ]; then
  		echo "Error: $dep is not installed. Do you want me to try to install it?"
  		read answer
  		if [ "$answer" != "${answer#[Yy]}" ] ;then
			if (( $EUID != 0 )); then
    			echo "Please run me as root"
   				 exit 1
			fi

			#Installing missing dependencies
			echo "Trying to install $dep"
			apt-get install -y $dep

			#Testing if dep is now installed
			if ! [ -x "$(command -v $dep)" ]; then
				echo "Installation failed :("
				exit 3
			fi
		else
    		echo No
    		exit 2
		fi
	fi
done

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

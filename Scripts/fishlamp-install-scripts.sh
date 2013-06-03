#!/bin/bash


MY_PATH="`dirname \"$0\"`"              
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  
INSTALL_PATH="/usr/local/fishlamp"

cd "$MY_PATH"

# reset install folder
if [ -d "$INSTALL_PATH" ]; then
	rm -r "$INSTALL_PATH"
fi

mkdir "$INSTALL_PATH" || { echo "unable to create folder: $INSTALL_PATH"; exit 1; }
chmod u+rwx "$INSTALL_PATH" || { echo "unable to change permissions on: $INSTALL_PATH"; exit 1; }

# install scripts

FILES=`ls`
for file in $FILES; 
	do
		extension=${file##*.}
		if [[ "$extension" == "sh" ]]
		then
			filename_no_extension=`basename "$file" .sh`

			src="`pwd`/$file"
			dest="$INSTALL_PATH/$filename_no_extension"
			
			cp "$src" "$dest" || { echo "unable to copy script to: $dest"; exit 1; }
			chmod u+rx "$dest" || { echo "unable to change permissions on: $dest"; exit 1; }
			
			echo "# installed: \"$dest\""
		fi
done

# update bash profile

sed -i -e "/usr\/local\/fishlamp/d" ~/.bash_profile 
echo "export PATH=\"\$PATH:$INSTALL_PATH\"" >> ~/.bash_profile

echo "# updated: $HOME/.bash_profile"
echo ""
echo "Please restart your terminal session"
echo ""
echo "Hint: command \"fishlamp\" will list the scripts installed here."
echo ""

exit 0


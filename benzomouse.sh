#!/bin/bash

USERNAME=$(whoami)
SOURCE_DIR="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/Resources/cursors"
DEST_DIR="/Users/$USERNAME/cursors"

# Check if the symlink has been created
if grep -q "cursors $DEST_DIR" /etc/synthetic.conf; then
  echo "Synthetic symlink detected. Proceeding to copy and modify cursors..."
  
  # Copy the cursors folder to the destination directory
  cp -R "$SOURCE_DIR" "$DEST_DIR"

  # Iterate through all the plist files and modify hotx and hoty values
  find "$DEST_DIR" -name "*.plist" -exec sed -i '' -E '/<key>hotx<\/key>/ {n; s/<integer>[0-9]+<\/integer>/<integer>4<\/integer>/;} /<key>hoty<\/key>/ {n; s/<integer>[0-9]+<\/integer>/<integer>4<\/integer>/;}' {} \;

  echo "Done! Modifications have been made."
  
  # Reboot prompt to apply changes
  read -p "A reboot is recommended to apply the changes. Reboot now? (y/n): " choice
  if [ "$choice" == "y" ]; then
    sudo reboot
  fi

else
  echo "Creating synthetic symlink entry..."
  echo "cursors $DEST_DIR" | sudo tee -a /etc/synthetic.conf

  read -p "A reboot is required to apply the synthetic symlink. Reboot now? (y/n): " choice
  if [ "$choice" == "y" ]; then
    sudo reboot
  fi

  echo "Please run this script again after rebooting to complete the process."
fi

# Benzomouse
A simple script designed to fix the jittery cursor issue on M1 Macbook Pro and potentially other Macs. As root volume is read-only in macOS now, this utilizes synthetic symlinks - the script makes the necessary modifications without altering the system's security settings or any system config files.

## Dependencies

This script uses XMLStarlet to modify the plist files.

### macOS - Homebrew

```bash
brew install xmlstarlet
```

## Underlying Issue

The jittery cursor stems from a graphical bug (that Apple has yet to fix) causing misalignment between the hot spots of different cursors. The hot spot is the exact point within the cursor's graphical representation that corresponds to the actual screen location being pointed to. When transitioning from one cursor to another (e.g., from an arrow to a hand), if the hot spots are misaligned, it can cause a visible jump or jitter in the cursor's position on the screen.

Benzomouse addresses this by standardizing the `hotx` and `hoty` values across all cursor types, ensuring that the hot spots are aligned. This eliminates the discrepancy that causes the jitter, providing a smooth cursor transition experience.

## Instructions

### How to Use

1. **Install Dependencies**: Make sure to install XMLStarlet as mentioned in the dependencies section above.
2. **Clone or Download the Repository**: Clone this repository or download the `benzomouse.sh` script to your local machine.
3. **Make the Script Executable**: Open a terminal window, navigate to the directory where the script is saved, and run:
   ```bash
   chmod +x benzomouse.sh
   ```
4. **Run the Script**: Execute the script by running:
   ```bash
   ./benzomouse.sh
   ```
5. **Follow the Prompts**: The script will guide you through the process and will prompt you to reboot your system.

## Reverting Changes

If you encounter any issues or wish to revert the changes made by Benzomouse, follow these steps:

1. **Delete the Synthetic Symlink Entry**:
   Open a terminal window and run:
   ```bash
   sudo nano /etc/synthetic.conf
   ```
   Remove the line that contains the symlink for the cursors, then save and exit `nano`.

2. **Reboot Your Mac**:
   Since the synthetic symlink requires a reboot to take effect, you'll need to reboot again to remove it. Run:
   ```bash
   sudo reboot
   ```

3. **Delete the Copied Cursors Folder**:
   After restarting, open a terminal window and delete the copied cursors folder by running:
   ```bash
   rm -rf ~/cursors
   ```

After these steps, the system should revert to using the original cursor files, and the modified copies will be deleted.

## Note

- **No Need to Disable SIP or Authenticated-Root**: Benzomouse does not require you to disable System Integrity Protection (SIP) or authenticated-root.
- **Scaled Displays**: I don't use a scaled display, nor do I use an external monitor. If needed, you can modify the script to change `hotx-scaled` and `hoty-scaled`. Replace the XMLStarlet command with the following:

   ```bash
   xmlstarlet edit --update "/plist/dict/key[text()=\\\"hotx-scaled\\\"]/following-sibling::*[1]" --value "YOUR_HOTX-SCALE_VALUE_HERE" \\
                   --update "/plist/dict/key[text()=\\\"hoty-scaled\\\"]/following-sibling::*[1]" --value "YOUR_HOTY-SCALE_VALUE_HERE" -L "{}"
   ```

   I recommend making a backup of ~/cursors (the copy in your Users folder) before doing this, in case you need to repeatedly revert changes.
  
   Like the `hotx` and `hoty` fix, a `hotx-scaled` and `hoty-scaled` fix probably requires consistent hot spot values.
  
   Replace `YOUR_HOTX-SCALE_VALUE_HERE` and `YOUR_HOTY-SCALE_VALUE_HERE` with the desired scaled values for `hotx` and `hoty`, respectively.


## License

GPLv3.

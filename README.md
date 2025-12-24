# EWW Bar Configuration
     
Custom EWW bar for Hyprland with dual monitor support.

## Features
- Modular workspace pairs (1&2, 3&4, etc)
- CPU/GPU/RAM monitoring with task manager popups
- Cava audio visualizer
- Audio controls with device selection
- Power menu
- System monitor popups
- AI SLOP!
## Dependencies
```bash
sudo pacman -S eww jq socat playerctl cava wireplumber bluez networkmanager xdotool zenity
```

## Installation
```bash
git clone <your-repo-url> ~/.config/eww
chmod +x ~/.config/eww/bar/scripts/*.sh
eww daemon
eww open bar
```

## Structure
- `eww.yuck` - Main config
- `eww.css` - All styling
- `bar/` - Bar components and modules
- `bar/scripts/` - Shell scripts for data polling
- `bar/popup-menus/` - Popup windows

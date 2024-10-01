import subprocess

subprocess.run(f"nitrogen --set-scaled ~/wallpaper/gargantua-black-2880x1800-9659.jpg", shell=True, check=True)
subprocess.run(f"bash ~/.config/awesome/scripts/wallpaper.sh set ~/wallpaper/gargantua-black-2880x1800-9659.jpg", shell=True, check=True)
subprocess.run(f"rm -f ~/.config/awesome/theme/launcher/image.jpg", shell=True, check=True)
subprocess.run(f"cp ~/.config/awesome/theme/launcher/kafu-image.jpg ~/.config/awesome/theme/launcher/image.jpg", shell=True, check=True)
subprocess.run(f"spicetify config color_scheme kafu", shell=True, check=True)
subprocess.run(f"spicetify apply", shell=True, check=True)

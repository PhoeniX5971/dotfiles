import subprocess

subprocess.run(f"nitrogen --set-scaled ~/wallpaper/miku3.jpg", shell=True, check=True)
subprocess.run(f"bash ~/.config/awesome/scripts/wallpaper.sh set ~/wallpaper/miku3.jpg", shell=True, check=True)
subprocess.run(f"rm -f ~/.config/awesome/theme/launcher/image.jpg", shell=True, check=True)
subprocess.run(f"cp ~/.config/awesome/theme/launcher/zerotwo-image.jpg ~/.config/awesome/theme/launcher/image.jpg", shell=True, check=True)
subprocess.run(f"spicetify config color_scheme mikutwo", shell=True, check=True)
subprocess.run(f"spicetify apply", shell=True, check=True)

import subprocess
import argparse

# Set up argument parsing
parser = argparse.ArgumentParser(description="Update color scheme and restart AwesomeWM.")
parser.add_argument('color', type=str, help="The color scheme to apply")

args = parser.parse_args()
color = args.color

def restart_awesome_wm():
    subprocess.run(f"sed -i 's/gtk-theme-name=.*/gtk-theme-name={color}/' ~/.config/gtk-3.0/settings.ini", shell=True, check=True)
    subprocess.run(f"sed -i 's/gtk-theme-name=.*/gtk-theme-name={color}/' ~/.config/gtk-4.0/settings.ini", shell=True, check=True)
    subprocess.run(f'sed -i \'s/Net\\/ThemeName ".*"/Net\\/ThemeName "{color}"/\' ~/.config/xsettingsd/xsettingsd.conf', shell=True, check=True)
    subprocess.run(f"rm -f ~/.config/Vencord/settings/quickCss.css", shell=True, check=True)
    subprocess.run(f"cp ~/.config/awesome/other/discord/{color}.css ~/.config/Vencord/settings/quickCss.css", shell=True, check=True)
    subprocess.run(f"python3 ~/.config/awesome/scripts/theme/{color}.py", shell=True, check=True)
    try:
        # Run the awesome-client command to restart AwesomeWM
        subprocess.run(["awesome-client", "awesome.restart()"], check=True)
        print("AwesomeWM restarted successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to restart AwesomeWM: {e}")

file = "~/.config/awesome/user.lua"

with open(file, "r") as f:
    data = f.readlines()

for i, line in enumerate(data):
    if line.startswith("user.color ="):
        data[i] = f'user.color = "{color}"\n'
        break

with open(file, "w") as f:
    f.writelines(data)

restart_awesome_wm()
subprocess.run(f"bash ~/.config/awesome/scripts/discord.sh", shell=True, check=True)

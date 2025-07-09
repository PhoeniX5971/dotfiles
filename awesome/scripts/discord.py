import os
import re

# Paths
wal_path = os.path.expanduser("~/.cache/wal/colors.sh")
output_path = os.path.expanduser("~/.config/awesome/theme/material-you.theme.css")

# Parse colors.sh
with open(wal_path, "r") as f:
    lines = f.readlines()

colors = {}
for line in lines:
    match = re.match(r"(\w+)=['\"](#\w{6})['\"]", line)
    if match:
        key, value = match.groups()
        colors[key] = value

# Use foreground as accent
accent_hex = colors.get("color1", "#8ed6f1")
accent_text = colors.get("foreground", "#ffffff")


# Convert hex to HSL
def hex_to_hsl(hex_color):
    hex_color = hex_color.lstrip("#")
    r = int(hex_color[0:2], 16) / 255
    g = int(hex_color[2:4], 16) / 255
    b = int(hex_color[4:6], 16) / 255

    max_c = max(r, g, b)
    min_c = min(r, g, b)
    l = (max_c + min_c) / 2

    if max_c == min_c:
        h = s = 0
    else:
        d = max_c - min_c
        s = d / (2 - max_c - min_c) if l > 0.5 else d / (max_c + min_c)
        if max_c == r:
            h = ((g - b) / d + (6 if g < b else 0)) % 6
        elif max_c == g:
            h = (b - r) / d + 2
        else:
            h = (r - g) / d + 4
        h *= 60

    return int(h), round(s * 100), round(l * 100)


h, s, l = hex_to_hsl(accent_hex)

# Generate CSS
css = f"""/**
 * Auto-generated Material Discord Theme (via pywal)
 * Accent: {accent_hex}
 */

@import url(https://capnkitten.github.io/BetterDiscord/Themes/Material-Discord/css/source.css);
@import url(https://capnkitten.github.io/BetterDiscord/Themes/Material-Discord/css/addons/material-you/source.css);

:root {{
    --accent-hue: {h};
    --accent-saturation: {s}%;
    --accent-lightness: {l}%;
    --accent-text-color: {accent_text};
    --accent-button-action: {accent_text};

    --alert-hue: 0;
    --alert-saturation: 85%;
    --alert-lightness: 61%;
    --alert-text-color: {accent_text};

    --message-radius: 18px;
    --media-radius: 10px;
    --card-radius: 8px;
    --card-radius-big: 18px;
    --button-height: 36px;
    --input-height: 36px;
    --popout-radius: 8px;
    --tooltip-radius: 8px;
    --tooltip-color: hsl(0, 0%, 38%, 0.9);
    --tooltip-text-color: hsl(0, 0%, 87%);
    --tooltip-font-size: 12px;
    --scrollbar-width: 10px;
    --scrollbar-thin-width: 6px;
}}
"""

# Save CSS
os.makedirs(os.path.dirname(output_path), exist_ok=True)
with open(output_path, "w") as f:
    f.write(css)

print(f"✅ Theme generated at: {output_path}")

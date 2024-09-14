local user = {}

-- widgets variables --

user.notif_center = true
user.control = true
user.calendar = true
user.dnd = false
user.float_value = false
user.opacity_value = true
user.tray = true

-- actual colorsheme --

user.color = "mikutwo"

-- openweather --

user.opweath_api = "ada31498b0ff685c2407d0700eb9139c"
user.opweath_passwd = ""
user.coordinates = { "53.9", "27.566667" }

-- user home and awm config --

user.home = os.getenv("HOME") .. "/"
user.awm_config = user.home .. ".config/awesome/"

-- bins --

user.bins = {
	lutgen = user.awm_config .. "other/bin/lutgen",
	greenclip = user.awm_config .. "/other/bin/greenclip",
	colorpicker = user.awm_config .. "other/bin/colorpicker",
	qr_codes = user.awm_config .. "other/bin/qr_codes",
}

return user

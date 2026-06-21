-- DMS Window Rules — managed by DankMaterialShell
-- Do not edit manually; changes may be overwritten

-- DMS-RULE: id=wr_1781523929678757120, name=wechat
hl.window_rule({ match = { class = "^wechat$" }, float = true })

-- DMS-RULE: id=wr_1781523980938117711, name=QQ
hl.window_rule({ match = { class = "^QQ$" }, float = true })

-- DMS-RULE: id=wr_1781524086090929595, name=v2rayN
hl.window_rule({ match = { class = "^v2rayN$" }, float = true, size = "monitor_w/2 monitor_h/2", move = "monitor_w/4 monitor_h/4" })

-- DMS-RULE: id=wr_1781524205349181452, name=org.gnome.Software
hl.window_rule({ match = { class = "^org.gnome.Software$" }, float = true })

-- DMS-RULE: id=wr_1781524229746532753, name=io.missioncenter.MissionCenter
hl.window_rule({ match = { class = "^io.missioncenter.MissionCenter$" }, float = true, size = "monitor_w/2 monitor_h/2" })

-- DMS-RULE: id=wr_1781524277808751935, name=com.vysp3r.ProtonPlus
hl.window_rule({ match = { class = "^com.vysp3r.ProtonPlus$" }, float = true })

-- DMS-RULE: id=wr_1781524298659314762, name=eudic
hl.window_rule({ match = { class = "^eudic$" }, float = true })

-- DMS-RULE: id=wr_1781524319560633483, name=qqmusic
hl.window_rule({ match = { class = "^qqmusic$" }, float = true })

-- DMS-RULE: id=wr_1781524347648114199, name=open-orpheus
hl.window_rule({ match = { class = "^open-orpheus$" }, float = true })

-- DMS-RULE: id=wr_1781524532990089643, name=fix-blue-xwayland
hl.window_rule({ match = { xwayland = true }, no_blur = true })

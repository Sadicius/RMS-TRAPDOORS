Config = {}
Config.AutoCloseTime = 30000
Config.Trapdoors = {
    ['p_gunsmithtrapdoor01x'] = {
        objectName = "p_gunsmithtrapdoor01x",
        openPosition = vector3(1326.07, -1326.36, 76.98),
        closedPosition = vector3(1326.04, -1326.38, 76.92),
        interactRange = 5.0,
        objectRange = 2,
        openYaw = vector3(-90.0, 0.0, 165.0),
        closedYaw = vector3(0.0, 0.0, 165.0)
    },
    ['p_trapdoor01x'] = {
        objectName = "p_trapdoor01x",
        openPosition = vector3(-1790.744, -390.1504, 159.2894),
        closedPosition = vector3(-1790.744, -390.1504, 159.2894),
        interactRange = 5.0,
        objectRange = 2,
        openYaw = vector3(-90.0, 0.0, 145.0879),
        closedYaw = vector3(0.0, 0.0, 145.0879)
    },
    ['s_clothingcasedoor01x'] = {
        objectName = "s_clothingcasedoor01x",
        openPosition = vec3(2858.862793, -1194.916504, 47.991444),
        closedPosition = vec3(2858.862793, -1194.916504, 47.991444),
        interactRange = 5.0,
        objectRange = 2,
        openYaw = vector3(0.0, 0.0, 184.999939),
        closedYaw = vec3(0.000000, 0.000000, 94.999939)
    },
}
Config.TrapdoorZones = {
    ['p_gunsmithtrapdoor01x'] = {
        zones = { -- rhodes
            vec2(1330.581, -1320.445),
            vec2(1329.585, -1329.684),
            vec2(1320.119, -1326.980),
            vec2(1321.921, -1318.421)
        },
        name = "p_gunsmithtrapdoor01x",
        minZ = 75.764,
        maxZ = 78.764
    },
    ['p_trapdoor01x'] = {
        zones = { -- strawberry
            vec2(-1799.502, -384.299),
            vec2(-1793.803, -379.005),
            vec2(-1783.904, -385.976),
            vec2(-1789.248, -393.441)
        },
        name = "p_trapdoor01x",
        minZ = 379.00,
        maxZ = 393.00
    },
}

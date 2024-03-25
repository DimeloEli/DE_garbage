Config = {}

-- General Config
Config.Notify = 'ox' -- 'ox'/'esx'/'other'
Config.Progress = 'circle' -- 'circle'/'bar'

-- Model Config
Config.Models = {'prop_dumpster_01a'}

-- Job Config
Config.RequireJob = false
Config.Job = 'garbage'

-- Bags Config
Config.PayPerBag = 20
Config.MaxBags = 25

-- Vehicle Config
Config.VehicleModel = 'trash'
Config.VehicleSpawn = vector4(-324.4425, -1523.8933, 27.2586, 266.4719)

-- Location & Blip Config
Config.JobClock = vector3(-322.2470, -1545.8246, 31.0199)
Config.Blip = {
    Show = true,
    Sprite = 318,
    Color = 25,
    Scale = 0.8,
}
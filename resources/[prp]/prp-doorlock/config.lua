PRP = {}

PRP.Doors = {
	--- door1 for pacific opened with security card B
	{
		objName = 'hei_v_ilev_bk_gate2_pris',
		objCoords  = vector3(261.83, 221.39, 106.41),
		textCoords = vector3(261.83, 221.39, 106.41),
		authorizedJobs = { 'police' },
		objYaw = -110.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	--door2 for pacific opened with thermite right near the vault door
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(252.98, 220.65, 101.8),
		textCoords = vector3(252.98, 220.65, 101.8),
		authorizedJobs = { 'police' },
		objYaw = 160.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- door3 for pacific opened with thermite after passing the door near vault
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(261.68, 215.62, 101.81),
		textCoords = vector3(261.68, 215.62, 101.81),
		authorizedJobs = { 'police' },
		objYaw = -110.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 1 opened with security card A
	{
		objName = 'v_ilev_cbankvaulgate01',
		objCoords  = vector3(-105.77, 6472.59, 31.81),
		textCoords = vector3(-105.77, 6472.59, 31.81),
		objYaw = 45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 2 opened with thermite
	{
		objName = 'v_ilev_cbankvaulgate02',
		objCoords  = vector3(-106.26, 6476.01, 31.98),
		textCoords = vector3(-105.5, 6475.08, 31.99),
		objYaw = -45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- First Pacific Door opened with lockpick
	{
		objName = 'hei_v_ilev_bk_gate_pris',			
		objCoords  = vector3(257.41, 220.25, 106.4),
		textCoords = vector3(257.41, 220.25, 106.4),
		authorizedJobs = { 'police' },
		objYaw = -20.0,
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Second Pacific Door opened with lockpick
	{
		objName = 'v_ilev_bk_door',
		objCoords  = vector3(265.19, 217.84, 110.28),
		textCoords = vector3(265.19, 217.84, 110.28),
		authorizedJobs = { 'police' },
		objYaw = -20.0,
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},	
	-- Fleeca Door opened with lockpick
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(314.61, -285.82, 54.49),
		textCoords = vector3(313.3, -285.45, 54.49),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Fleeca Door opened with lockpick
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(148.96, -1047.12, 29.7),
		textCoords = vector3(148.96, -1047.12, 29.7),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Fleeca Door opened with lockpick
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-351.7, -56.28, 49.38),
		textCoords = vector3(-351.7, -56.28, 49.38),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Fleeca Door opened with lockpick
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-1208.12, -335.586, 37.759),
		textCoords = vector3(-1208.12, -335.586, 37.759),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Fleeca Door opened with lockpick
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, 483.96, 16.02),
		textCoords = vector3(-2956.18, 483.96, 16.02),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	

	-- Mission Row Cells

	--Vespucci Police Station
	{
		textCoords = vector3(-1061.68, -827.56, 19.41),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = -55.0,
				objCoords  = vector3(-1061.32, -828.19, 19.43),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = 127.5,
				objCoords  = vector3(-1062.13, -826.99, 19.43)
			}
		}
	},
	{
		textCoords = vector3(-1091.26, -809.39, 19.39),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = 37.5,
				objCoords  = vector3(-1090.87, -809.18, 19.37),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = -142.5,
				objCoords  = vector3(-1091.68, -809.92, 19.37)
			}
		}
	},

	{
		textCoords = vector3(-1093.47, -811.2, 19.37),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = 37.5,
				objCoords  = vector3(-1093.0, -811.0, 19.37),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = -142.5,
				objCoords  = vector3(-1094.02, -811.77, 19.37)
			}
		}
	},
	{
		textCoords = vector3(-1112.01, -847.97, 13.48),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = 127.5,
				objCoords  = vector3(-1112.38, -847.45, 13.48),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = -53.0,
				objCoords  = vector3(-1111.49, -848.43, 13.48)
			}
		}
	},

	{
		objName = 'vesp_garage_door',
		distance = 4,
		size = 2,
		objCoords  = vector3(-1072.74, -851.43, 4.88),         -- GARAZA DONJA
		textCoords = vector3(-1072.85, -850.83, 4.96),
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'vesp_garage_door',
		distance = 10,
		size = 2,
		objCoords  = vector3(-1118.91, -838.93, 13.42),		-- GARAZA GORNJA
		textCoords = vector3(-1118.91, -838.93, 13.42),
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -142.0,
		distance = 1.0,
		objCoords  = vector3(-1073.23, -827.07, 5.49),
		textCoords = vector3(-1073.23, -827.07, 5.49),		-- ULAZ U CELIJE
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -142.0,
		distance = 1.0,
		objCoords  = vector3(-1087.32, -829.52, 5.48),
		textCoords = vector3(-1087.32, -829.52, 5.48),		-- ULAZ U CELIJE
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1091.09, -820.99, 5.48),
		textCoords = vector3(-1091.09, -820.99, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1088.78, -824.09, 5.48),
		textCoords = vector3(-1088.78, -824.09, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1086.16, -827.38, 5.48),
		textCoords = vector3(-1086.16, -827.38, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1096.3, -820.36, 5.48),
		textCoords = vector3(-1096.3, -820.36, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1093.91, -823.28, 5.48),
		textCoords = vector3(-1093.91, -823.28, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1091.46, -826.57, 5.48),
		textCoords = vector3(-1091.46, -826.57, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -52.0,
		distance = 1.0,
		objCoords  = vector3(-1089.24, -829.7, 5.48),
		textCoords = vector3(-1089.24, -829.7, 5.48),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		textCoords = vector3(-1091.48, -835.15, 5.48),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = -52.5,
				objCoords  = vector3(-1091.71, -834.57, 5.48),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 127.5,
				objCoords  = vector3(-1091.23, -835.44, 5.48)
			}
		}
	},
	{
		textCoords = vector3(-1057.94, -839.74, 5.11),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 37.5,
				objCoords  = vector3(-1058.19, -840.13, 5.11),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -143.0,
				objCoords  = vector3(-1057.17, -839.45, 5.11)
			}
		}
	},
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 37.5,
		objCoords  = vector3(-1079.34, -855.71, 5.21),
		textCoords = vector3(-1079.34, -855.71, 5.21),		
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		textCoords = vector3(-1094.51, -834.93, 14.28),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = -142.5,
				objCoords  = vector3(-1093.96, -834.4, 14.28),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 37.5,
				objCoords  = vector3(-1094.97, -835.39, 14.28)
			}
		}
	},
	{
		textCoords = vector3(-1111.81, -825.14, 19.33),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = -142.0,
				objCoords  = vector3(-1112.15, -825.5, 19.33),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = 36.0,
				objCoords  = vector3(-1111.32, -824.79, 19.33)
			}
		}
	},
	{
		textCoords = vector3(-1108.22, -843.06, 19.32),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = 125.0,
				objCoords  = vector3(-1108.51, -842.63, 19.32),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = -52.5,
				objCoords  = vector3(-1107.77, -843.61, 19.32)
			}
		}
	},
	{
		textCoords = vector3(-1106.59, -845.28, 19.32),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'vesp_glav_door',
				objYaw = 125.0,
				objCoords  = vector3(-1106.85, -844.08, 19.32),
			},

			{
				objName = 'vesp_glav_door',
				objYaw = -52.5,
				objCoords  = vector3(-1106.15, -845.75, 19.32)
			}
		}
	},
	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.45, -992.6, 25.10),
		textCoords = vector3(463.45, -992.6, 25.10),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(461.89, -993.31, 25.13),
		textCoords = vector3(461.89, -993.31, 25.13),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(461.89, -998.81, 25.13),
		textCoords = vector3(461.89, -998.81, 25.13),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(461.89, -1002.44, 25.13),
		textCoords =  vector3(461.89, -1002.44, 25.13),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(464.61, -1003.64, 24.98),
		textCoords = vector3(464.61, -1003.64, 24.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Mission Row Back
	-- Back (double doors)
	{
		textCoords = vector3(468.67, -1014.43, 26.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},
	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 14,
		size = 2
	},
	-- Mission Row Extension
	-- Briefing room
	{
		textCoords = vector3(455.86, -981.31, 26.86),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 90.0,
				objCoords  = vector3(455.94, -980.57, 26.67)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 270.0,
				objCoords  = vector3(455.85, -982.14, 26.67)
			}
		}
	},
	-- To Breakrooms
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 90.0,
		objCoords  = vector3(465.62, -985.93, 25.74),
		textCoords = vector3(465.62, -985.93, 25.74),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(468.57, -999.44, 25.07),
		textCoords = vector3(468.57, -999.44, 25.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(472.16, -999.47, 25.05),
		textCoords = vector3(472.16, -999.47, 25.05),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(476.4, -1007.68, 24.41),
		textCoords = vector3(476.4, -1007.68, 24.41),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- New Cell 4
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 180.0,
		objCoords  = vector3(480.0, -1007.7, 24.41),
		textCoords = vector3(480.0, -1007.7, 24.41),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Photoroom
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 0.0,
		objCoords  = vector3(475.05, -995.08, 24.46),
		textCoords = vector3(475.05, -995.08, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Standplace
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 180.0,
		objCoords  = vector3(485.71, -996.08, 24.45),
		textCoords = vector3(485.71, -996.08, 24.45),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Interigation 1
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(484.63, -999.74, 24.46),
		textCoords = vector3(484.63, -999.74, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Interigation 2
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(491.37, -999.81, 24.46),
		textCoords = vector3(491.37, -999.81, 24.46),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- To Evidence
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 180.0,
		objCoords  = vector3(470.78, -992.21, 25.12),
		textCoords = vector3(470.78, -992.21, 25.12),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	-- Bureau Paleto Bay
	{
		textCoords = vector3(-435.57, 6008.76, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = -135.0,
				objCoords = vector3(-436.5157, 6007.844, 28.13839),			
			},
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = 45.0,
				objCoords = vector3(-434.6776, 6009.681, 28.13839)			
			}
		}
	},
	-- Back door left
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 135.0,
		objCoords  = vector3(-450.9664, 6006.086, 31.99004),		
		textCoords = vector3(-451.38, 6006.55, 31.84),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Back door right
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-447.2363, 6002.317, 31.84003),		
		textCoords = vector3(-446.77, 6001.84, 31.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Locker room
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-450.7136, 6016.371, 31.86523),				
		textCoords = vector3(-450.15, 6015.96, 31.71),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Locker room 2
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 45.0,
		objCoords  = vector3(-454.0435, 6010.243, 31.86106),						
		textCoords = vector3(-453.56, 6010.73, 31.71),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -135.0,
		objCoords  = vector3(-439.1576, 5998.157, 31.86815),						
		textCoords = vector3(-438.64, 5998.51, 31.71), 
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Interrogation room
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 45.0,
		objCoords  = vector3(-436.6276, 6002.548, 28.14062),							
		textCoords = vector3(-437.09, 6002.100, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Entrance cells 1
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-438.228, 6006.167, 28.13558),							
		textCoords = vector3(-438.610, 6005.64, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Entrance cells 2
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-442.1082, 6010.052, 28.13558),							
		textCoords = vector3(-442.55, 6009.61, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Cel
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-444.3682, 6012.223, 28.13558),								
		textCoords = vector3(-444.77, 6011.74, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	-- Hallway (double doors)
	{
		textCoords = vector3(-442.09, 6011.93, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 225.0,
				objCoords  = vector3(-441.0185, 6012.795, 31.86523),			
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 45.0,
				objCoords  = vector3(-442.8578, 6010.958, 31.86523)			
			}
		}
	},
	-- Hallway to the back (double doors)
	{
		textCoords = vector3(-448.67, 6007.52, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 135.0,
				objCoords = vector3(-447.7283, 6006.702, 31.86523),				
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -45.0,
				objCoords = vector3(-449.5656, 6008.538, 31.86523)		
			}
		}
	},
	--outside doors
	{
		objName = 'prop_fnclink_03gate5',
		objCoords = vector3(1796.322, 2596.574, 45.565),
		textCoords = vector3(1796.322, 2596.574, 45.965),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1821.677, 2477.265, 45.945),
		textCoords = vector3(1821.677, 2477.265, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1760.692, 2413.251, 45.945),
		textCoords = vector3(1760.692, 2413.251, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1543.58, 2470.252, 45.945),
		textCoords = vector3(1543.58, 2470.25, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1659.733, 2397.475, 45.945),
		textCoords = vector3(1659.733, 2397.475, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1537.731, 2584.842, 45.945),
		textCoords = vector3(1537.731, 2584.842, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1571.964, 2678.354, 45.945),
		textCoords = vector3(1571.964, 2678.354, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1650.18, 2755.104, 45.945),
		textCoords = vector3(1650.18, 2755.104, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1771.98, 2759.98, 45.945),
		textCoords = vector3(1771.98, 2759.98, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1845.7, 2699.79, 45.945),
		textCoords = vector3(1845.7, 2699.79, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1820.68, 2621.95, 45.945),
		textCoords = vector3(1820.68, 2621.95, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- Bolingbroke Extra
	-- To Offices
	{
		objName = 'prop_pris_door_03',
		objYaw = 270.0,
		objCoords  = vector3(1819.129, 2593.64, 46.09929),
		textCoords = vector3(1843.3, 2579.39, 45.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- To Changingroom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 360.0,
		objCoords  = vector3(1827.365, 2587.547, 46.09929),
		textCoords = vector3(1835.76, 2583.15, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prop_pris_door_03',
		objYaw = 90.0,
		objCoords  = vector3(1835.48, 2586.63, 46.01),
		textCoords = vector3(1835.48, 2586.63, 46.01),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	
	-- To CrimChangingroom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(1826.466, 2585.271, 46.09929),
		textCoords = vector3(1835.77, 2589.76, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	-- To CheckingRoom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(1827.521, 2583.905, 45.28576),
		textCoords = vector3(1828.638, 2584.675, 45.95233),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- Checking Gate
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 270.0,
		objCoords  = vector3(1837.714, 2595.185, 46.09929),
		textCoords = vector3(1837.714, 2595.185, 46.09929),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- To CheckingRoomFromCheck
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(1837.697, 2585.24, 46.09929),
		textCoords = vector3(1837.697, 2585.24, 46.09929),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- To SecondCheckGate
	{
		objName = 'prop_pris_door_03',
		objYaw = 90.0,
		objCoords  = vector3(1845.198, 2585.24, 46.09929),
		textCoords = vector3(1845.198, 2585.24, 46.09929),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- To MainHall
	{
		objName = 'v_ilev_ph_door002',
		objYaw = 90.0,
		objCoords  = vector3(1791.18, 2593.11, 546.15),
		textCoords = vector3(1791.18, 2593.11, 546.15),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Prison Door 1
	{
		objName = 'prop_gate_prison_01',
		objYaw = 90.0,
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	-- Prison Door 2	
	{
		objName = 'prop_gate_prison_01',
		objYaw = 90.0,
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},

	-- Luxury Cars
	-- Park Ranger
	{
		objName = 'prop_pr_gate_door',
		objYaw = 90.0,
		objCoords  = vector3(383.43, 796.72, 187.68),		
		textCoords = vector3(383.43, 796.72, 187.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	{
		objName = 'prop_pr_gate_door',
		objYaw = 0.0,
		objCoords  = vector3(380.62, 795.53, 187.68),		
		textCoords = vector3(380.62, 795.53, 187.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	-- Entrance Doors 
	{
		textCoords = vector3(-803.0223, -223.8222, 37.87975),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 'prop_doorluxyry2',
				objYaw = 120.0,
				objCoords = vector3(-803.0223, -222.5841, 37.87975)
			},

			{
				objName = 'prop_doorluxyry2',
				objYaw = -60.0,
				objCoords = vector3(-801.9622, -224.5203, 37.87975)			
			}
		}
	},
	-- Side Entrance Doors 
	{
		textCoords = vector3(-777.1855, -244.0013, 37.333889),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 'prop_doorluxyry',				
				objYaw = -160.0,
				objCoords = vector3(-778.1855, -244.3013, 37.33388)
			},

			{
				objName = 'prop_doorluxyry',
				objYaw = 23.0,
				objCoords = vector3(-776.1591, -243.5013, 37.33388)				
			}
		}
	},
	-- Garage Doors
	{
		textCoords = vector3(-768.1264, -238.9737, 37.43247),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13.0,
		doors = {
			{
				objName = 'prop_autodoor',
				objCoords = vector3(-770.6311, -240.0069, 37.43247)    
			},

			{
				objName = 'prop_autodoor',
				objCoords = vector3(-765.6217, -237.9405, 37.43247) 		
			}
		}
	},
	-- Pickle Rental
	-- Front door 1
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-21.71276, -1392.778, 29.63847),		
		textCoords = vector3(-22.31276, -1392.778, 29.63847),
		authorizedJobs = { 'cardealer' },
		objYaw = -180.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- Front door 2
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-32.67987, -1392.064, 29.63847),		
		textCoords = vector3(-32.10987, -1392.064, 29.63847),
		authorizedJobs = { 'cardealer' },
		objYaw = 0.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- Door to cellar
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-24.22668, -1403.067, 29.63847),				
		textCoords = vector3(-24.22668, -1402.537, 29.63847),
		authorizedJobs = { 'cardealer' },
		objYaw = 90.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Back door
	{
		objName = 'apa_prop_apa_cutscene_doorb',
		objCoords  = vector3(-21.27107, -1406.845, 29.63847),			
		textCoords = vector3(-21.27107, -1406.245, 29.63847),
		authorizedJobs = { 'cardealer' },
		objYaw = 90.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Garage door
	{
		objName = 'prop_com_gar_door_01',
		objCoords  = vector3(-21.04025, -1410.734, 30.51094),			
		textCoords = vector3(-21.04025, -1410.734, 30.51094),
		authorizedJobs = { 'cardealer' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 15.0,
		size = 2
	},





-------------------------------------------
-------------------------------------------
--------- G A B Z M R P D -----------------
--------- G A B Z M R P D -----------------
--------- G A B Z M R P D -----------------
--------- G A B Z M R P D -----------------
--------- G A B Z M R P D -----------------
-------------------------------------------
-------------------------------------------





	{
		textCoords = vector3(434.81, -981.93, 30.89),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = -90.0,
				objCoords = vector3(434.7444, -980.7556, 30.8153)
			},

			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = 90.0,
				objCoords = vector3(434.7444, -983.0781, 30.8153)
			}
		}
	},


	{
		objName = "gabz_mrpd_door_04",
		objYaw = 0.0,
		objCoords = vector3(440.5201, -977.6011, 30.82319),
		textCoords = vector3(440.5201, -977.6011, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	{
		objName = "gabz_mrpd_door_05",
		objYaw = 180.0,
		objCoords = vector3(440.5201, -986.2335, 30.82319),
		textCoords = vector3(440.5201, -986.2335, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	{
		objName = "gabz_mrpd_door_04",
		objYaw = 90.0,
		objCoords = vector3(445.4067, -984.2014, 30.82319),
		textCoords = vector3(445.4067, -984.2014, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	{ -- DOOR NUM.5 , COP TALKER.
		textCoords = vector3(438.1971, -993.9113, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_01",
				objYaw = 90.0,
				objCoords = vector3(438.1971, -996.3167, 30.82319)
			},

			{
				objName = "gabz_mrpd_door_01",
				objYaw = -90.0,
				objCoords = vector3(438.1971, -993.9113, 30.82319)
			}
		}
	},

	{ -- DOOR NUM.6 , Door side station exit.
		textCoords = vector3(440.7392, -998.7462, 30.8153),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = 0.0,
				objCoords = vector3(440.7392, -998.7462, 30.8153)
			},

			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = 180.0,
				objCoords = vector3(443.0618, -998.7462, 30.8153)
			}
		}
	},

	{
		objName = "gabz_mrpd_door_05",
		objYaw = 135.0,
		objCoords = vector3(452.2663, -995.5254, 30.82319),
		textCoords = vector3(452.2663, -995.5254, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	{
		objName = "gabz_mrpd_door_02",
		objYaw = 225.0,
		objCoords = vector3(458.0894, -995.5247, 30.82319),
		textCoords = vector3(458.0894, -995.5247, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	{ -- DOOR 9
		objName = "gabz_mrpd_door_05",
		objYaw = 270.0,
		objCoords = vector3(458.6543, -990.6498, 30.82319),
		textCoords = vector3(458.6543, -990.6498, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	
	{
		objName = "gabz_mrpd_door_04",
		objYaw = 270.0,
		objCoords = vector3(458.6543, -976.8864, 30.82319),
		textCoords = vector3(458.6543, -976.8864, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	{ -- DOOR NUM.11 , Door side station exit.
		textCoords = vector3(455.8862, -972.2543, 30.81531),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = 0.0,
				objCoords = vector3(455.8862, -972.2543, 30.81531)
			},

			{
				objName = "gabz_mrpd_reception_entrancedoor",
				objYaw = 180.0,
				objCoords = vector3(458.2087, -972.2543, 30.81531)
			}
		}
	},


	{ -- DOOR NUM.12
		textCoords = vector3(469.4406, -987.4377, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_01",
				objYaw = -90.0,
				objCoords = vector3(469.4406, -985.0313, 30.82319)
			},

			{
				objName = "gabz_mrpd_door_01",
				objYaw = 90.0,
				objCoords = vector3(469.4406, -987.4377, 30.82319)
			}
		}
	},


	{ -- DOOR NUM.13
		textCoords = vector3(475.3837, -984.3722, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_02",
				objYaw = 0.0,
				objCoords = vector3(472.9781, -984.3722, 30.82319)
			},

			{
				objName = "gabz_mrpd_door_02",
				objYaw = 180.0,
				objCoords = vector3(475.3837, -984.3722, 30.82319)
			}
		}
	},


	{  -- DOOR NUM.14 - Ambulance stuff
		textCoords = vector3(479.7534, -988.6204, 30.82319),
		authorizedJobs = { 'police', 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_04",
				objYaw = -90.0,
				objCoords = vector3(479.7534, -986.2151, 30.82319)
			},

			{
				objName = "gabz_mrpd_door_05",
				objYaw = -90.0,
				objCoords = vector3(479.7534, -988.6204, 30.82319)
			}
		}
	},



	-- Door 15:
	{ 
		textCoords = vector3(472.9777, -989.8247, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_04",
				objYaw = -180.0,
				objCoords = vector3(475.3837, -989.8247, 30.82319)
			},

			{
				objName = "gabz_mrpd_door_05",
				objYaw = 180.0,
				objCoords = vector3(472.9777, -989.8247, 30.82319)
			}
		}
	},


	-- 16
	{
		objName = "gabz_mrpd_door_03",
		objYaw = 90.0,
		objCoords = vector3(479.7507, -999.629, 30.78917),
		textCoords = vector3(479.7507, -999.629, 30.78917),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- 17
	{
		objName = "gabz_mrpd_door_04",
		objYaw = 90.0,
		objCoords = vector3(476.7512, -999.6307, 30.82319),
		textCoords = vector3(476.7512, -999.6307, 30.82319),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- 18
	{
		objName = "gabz_mrpd_door_03",
		objYaw = 180.0,
		objCoords = vector3(487.4378, -1000.189, 30.78697),
		textCoords = vector3(487.4378, -1000.189, 30.78697),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	-- Door 19:
	{ 
		textCoords = vector3(485.6133, -1002.902, 30.78697),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_03",
				objYaw = -180.0,
				objCoords = vector3(488.0184, -1002.902, 30.78697)
			},

			{
				objName = "gabz_mrpd_door_03",
				objYaw = 0.0,
				objCoords = vector3(485.6133, -1002.902, 30.78697)
			}
		}
	},



	-- GGGGGGGGGGGG DONE FLOOR 1 !!!!!!!!!!!!!!!!!!!!!!!
	-- FLOOR 2 [ called main due size ]

	-- Door 2 | [Missing 1 due helicopter floor, will be in the end of config].
	{
		objName = "gabz_mrpd_door_04",
		objYaw = 180.0,
		objCoords = vector3(459.9454, -981.0742, 35.10398),
		textCoords = vector3(459.9454, -981.0742, 35.10398),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 3
	{
		objName = "gabz_mrpd_door_05",
		objYaw = 0.0,
		objCoords = vector3(459.9454, -990.7053, 35.10398),
		textCoords = vector3(459.9454, -990.7053, 35.10398),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 4
	{
		objName = "gabz_mrpd_door_05",
		objYaw = 135.0,
		objCoords = vector3(448.9868, -981.5785, 35.10376),
		textCoords = vector3(448.9868, -981.5785, 35.10376),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},



	-- Door 5
	{
		objName = "gabz_mrpd_door_04",
		objYaw = 45.0,
		objCoords = vector3(448.9868, -990.2007, 35.10376),
		textCoords = vector3(448.9868, -990.2007, 35.10376),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 6
	{
		objName = "gabz_mrpd_door_05",
		objYaw = 135.0,
		objCoords = vector3(448.9846, -995.5264, 35.10376),
		textCoords = vector3(448.9846, -995.5264, 35.10376),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},



	-- NO Door 1 [ Shitty helicopters - GABZ FUCK U ITS WRONG DOOR NAME -_- ]

	

	-- GGGGGGGGGGGG DONE FLOOR 2 !!!!!!!!!!!!!!!!!!!!!!!
	-- FLOOR 0

	-- Door 3
	{
		objName = "gabz_mrpd_room13_parkingdoor",
		objYaw = -90.0,
		objCoords = vector3(464.1591, -974.6656, 26.3707),
		textCoords = vector3(464.1591, -974.6656, 26.3707),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 4
	{
		objName = "gabz_mrpd_room13_parkingdoor",
		objYaw = 90.0,
		objCoords = vector3(464.1566, -997.5093, 26.3707),
		textCoords = vector3(464.1566, -997.5093, 26.3707),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	

	-- Door 5:
	{ 
		textCoords = vector3(471.3753, -987.4374, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_04",
				objYaw = -90.0,
				objCoords = vector3(471.3753, -985.0319, 26.40548)
			},

			{
				objName = "gabz_mrpd_door_05",
				objYaw = -90.0,
				objCoords = vector3(471.3753, -987.4374, 26.40548)
			}
		}
	},


	
	-- Door 10:
	{ 
		textCoords = vector3(479.0624, -987.4376, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_02",
				objYaw = -90.0,
				objCoords = vector3(479.0624, -985.0323, 26.40548)
			},

			{
				objName = "gabz_mrpd_door_02",
				objYaw = 90.0,
				objCoords = vector3(479.0624, -987.4376, 26.40548)
			}
		}
	},

	-- Door 11
	{
		objName = "gabz_mrpd_door_04",
		objYaw = -90.0,
		objCoords = vector3(482.6694, -983.9868, 26.40548),
		textCoords = vector3(482.6694, -983.9868, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 12 -- FUCK U GABZ U FORGOT THE X -_-


	-- Door 13
	{
		objName = "gabz_mrpd_door_04",
		objYaw = -90.0,
		objCoords = vector3(482.6699, -992.2991, 26.40548),
		textCoords = vector3(482.6699, -992.2991, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 14
	{
		objName = "gabz_mrpd_door_04",
		objYaw = -90.0,
		objCoords = vector3(482.6703, -995.7285, 26.40548),
		textCoords = vector3(482.6703, -995.7285, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	
	-- Door 15:
	{ 
		textCoords = vector3(479.6638, -997.91, 26.4065),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_02",
				objYaw = 180.0,
				objCoords = vector3(482.0686, -997.91, 26.4065)
			},

			{
				objName = "gabz_mrpd_door_02",
				objYaw = 0.0,
				objCoords = vector3(479.6638, -997.91, 26.4065)
			}
		}
	},

	-- Door 16
	{
		objName = "gabz_mrpd_door_02",
		objYaw = 180.0,
		objCoords = vector3(478.2892, -997.9101, 26.40548),
		textCoords = vector3(478.2892, -997.9101, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	-- Door 17
	{
		objName = "gabz_mrpd_door_01",
		objYaw = 0.0,
		objCoords = vector3(479.06, -1003.173, 26.4065),
		textCoords = vector3(479.06, -1003.173, 26.4065),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	-- Door 18
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 180.0,
		objCoords = vector3(481.0084, -1004.118, 26.48005),
		textCoords = vector3(481.0084, -1004.118, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},



	-- Door 19
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 180.0,
		objCoords = vector3(484.1764, -1007.734, 26.48005),
		textCoords = vector3(484.1764, -1007.734, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	

	-- Door 20
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 0.0,
		objCoords = vector3(486.9131, -1012.189, 26.48005),
		textCoords = vector3(486.9131, -1012.189, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 21
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 0.0,
		objCoords = vector3(483.9127, -1012.189, 26.48005),
		textCoords = vector3(483.9127, -1012.189, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},



	-- Door 22
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 0.0,
		objCoords = vector3(480.9128, -1012.189, 26.48005),
		textCoords = vector3(480.9128, -1012.189, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 23
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = 0.0,
		objCoords = vector3(477.9126, -1012.189, 26.48005),
		textCoords = vector3(477.9126, -1012.189, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},


	-- Door 24
	{
		objName = "gabz_mrpd_cells_door",
		objYaw = -90.0,
		objCoords = vector3(476.6157, -1008.875, 26.48005),
		textCoords = vector3(476.6157, -1008.875, 26.48005),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	

	-- Door 25
	{
		objName = "gabz_mrpd_door_01",
		objYaw = 180.0,
		objCoords = vector3(475.9539, -1006.938, 26.40639),
		textCoords = vector3(475.9539, -1006.938, 26.40639),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	-- Door 26 missing.
	

	-- Door 7
	{ 
		textCoords = vector3(471.3758, -1010.198, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_mrpd_door_02",
				objYaw = -90.0,
				objCoords = vector3(471.3679, -1007.793, 26.40548)
			},

			{
				objName = "gabz_mrpd_door_02",
				objYaw = 90.0,
				objCoords = vector3(471.3758, -1010.198, 26.40548)
			}
		}
	},


	-- Door 8
	{ 
		textCoords = vector3(467.3686, -1014.406, 26.48382),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{ -- BROKEN
				objName = "gabz_mrpd_door_03",
				objYaw = -90.0,
				objCoords = vector3(469.7743, -1014.406, 26.48382)
			},

			{
				objName = "gabz_mrpd_door_03",
				objYaw = 0.0,
				objCoords = vector3(467.3686, -1014.406, 26.48382)
			}
		}
	},



	-- Door 9
	{ 
		textCoords = vector3(467.5222, -1000.544, 26.40548),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{ -- BROKEN
				objName = "gabz_mrpd_door_01",
				objYaw = 180.0,
				objCoords = vector3(469.9274, -1000.544, 26.40548)
			},

			{
				objName = "gabz_mrpd_door_01",
				objYaw = 0.0,
				objCoords = vector3(467.5222, -1000.544, 26.40548)
			}
		}
	},


}

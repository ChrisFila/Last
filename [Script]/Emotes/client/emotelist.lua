
RegisterCommand("e", function(source, args, rawCommand)
    target_animation = args[1]
    for k, v in pairs(AnimationList) do
        if k == target_animation then
            ClearPedTasks(GetPlayerPed(-1))
            Citizen.CreateThread(function()
                _Utiles.animation_load(v[1], v[2])
                ChosenDict = v[1]
                ChosenAnimation = v[2]
                MovementType = 1
                AnimationDuration = -1
                --print(ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType)
                TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
            end)
        end
    end
end)






AnimationList = {
    ["beast"] = { "anim@mp_fm_event@intro", "beast_transform", "Peté un plomb", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 5000,
    } },
    ["chill"] = { "switch@trevor@scares_tramp", "trev_scares_tramp_idle_tramp", "Couché tranquillement", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["prone"] = { "missfbi3_sniping", "prone_dave", "Couché sur le ventre", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["pullover"] = { "misscarsteal3pullover", "pull_over_right", "Pullover", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1300,
    } },
    ["idle"] = { "anim@heists@heist_corona@team_idles@male_a", "idle", "Idle", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle9"] = { "friends@fra@ig_1", "base_idle", "Attendre (femme)", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle10"] = { "mp_move@prostitute@m@french", "idle", "Attendre 10", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["idle11"] = { "random@countrysiderobbery", "idle_a", "Attendre 11", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle2"] = { "anim@heists@heist_corona@team_idles@female_a", "idle", "Attendre", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle3"] = { "anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", "Attendre (petite dance)", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle4"] = { "anim@mp_celebration@idles@female", "celebration_idle_f_a", "Attendre 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle5"] = { "anim@mp_corona_idles@female_b@idle_a", "idle_a", "Attendre 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle6"] = { "anim@mp_corona_idles@male_c@idle_a", "idle_a", "Attendre 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idle7"] = { "anim@mp_corona_idles@male_d@idle_a", "idle_a", "Attendre stressé", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk"] = { "random@drunk_driver_1", "drunk_driver_stand_loop_dd1", "Attendre bourré", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk2"] = { "random@drunk_driver_1", "drunk_driver_stand_loop_dd2", "Attendrebourré 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["idledrunk3"] = { "missarmenian2", "standing_idle_loop_drunk", "Attendrebourré 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["bringiton"] = { "misscommon@response", "bring_it_on", "Regarde moi !", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["comeatmebro"] = { "mini@triathlon", "want_some_of_this", "Viens me voir", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["cop2"] = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "police 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cop3"] = { "amb@code_human_police_investigate@idle_a", "idle_b", "police 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["crossarms"] = { "amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a", "Bras croisés", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms2"] = { "amb@world_human_hang_out_street@male_c@idle_a", "idle_b", "Bras croisés 2", AnimationOptions = {
        EmoteMoving = true,
    } },
    ["crossarms3"] = { "anim@heists@heist_corona@single_team", "single_team_loop_boss", "Bras croisé simple", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms4"] = { "random@street_race", "_car_b_lookout", "Bras croisé 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms5"] = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", "Bras croisés 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarms6"] = { "random@shop_gunstore", "_idle", "Bras croisé 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["crossarmsside"] = { "rcmnigel1a_band_groupies", "base_m2", "Bras croisé Side", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["damn"] = { "gestures@m@standing@casual", "gesture_damn", "Damn", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["damn2"] = { "anim@am_hold_up@male", "shoplift_mid", "Fait chier !", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["pointdown"] = { "gestures@f@standing@casual", "gesture_hand_down", "Pointer du doigt au sol", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["surrender"] = { "random@arrests@busted", "idle_a", "Couchez les mains en l'air", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender2"] = { "mp_bank_heist_1", "f_cower_02", "Couchez les mains sur la tête", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender3"] = { "mp_bank_heist_1", "m_cower_01", "Surrender 3", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender4"] = { "mp_bank_heist_1", "m_cower_02", "Surrender 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender5"] = { "random@arrests", "kneeling_arrest_idle", "Surrender 5", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["surrender6"] = { "rcmbarry", "m_cower_01", "Ce rendre", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["facepalm2"] = { "anim@mp_player_intcelebrationfemale@face_palm", "face_palm", "Facepalm 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm"] = { "random@car_thief@agitated@idle_a", "agitated_idle_a", "Facepalm", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm3"] = { "missminuteman_1ig_2", "tasered_2", "Facepalm 3", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 8000
    } },
    ["facepalm4"] = { "anim@mp_player_intupperface_palm", "idle_a", "Facepalm 4", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["fallasleep"] = { "mp_sleep", "sleep_loop", "Tomber", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["finger"] = { "anim@mp_player_intselfiethe_bird", "idle_a", "Doigt d'honneur", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["finger2"] = { "anim@mp_player_intupperfinger", "idle_a_fp", "Doigt d'honneur 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["handshake"] = { "mp_ped_interaction", "handshake_guy_a", "Poignée de main", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["handshake2"] = { "mp_ped_interaction", "handshake_guy_b", "Poignée de main 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["wait"] = { "random@shop_tattoo", "_idle_a", "Attendre les bras sur les anches", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitb"] = { "missbigscore2aig_3", "wait_for_van_c", "Attendre B", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitc"] = { "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", "Attendre C", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitd"] = { "amb@world_human_hang_out_street@Female_arm_side@idle_a", "idle_a", "Attendre D", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waite"] = { "missclothing", "idle_storeclerk", "Mains devant les jambes", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitf"] = { "timetable@amanda@ig_2", "ig_2_base_amanda", "Attendre F", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitg"] = { "rcmnigel1cnmt_1c", "base", "Mains sur la anches", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waith"] = { "rcmjosh1", "idle", "Mains sur les anches", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waiti"] = { "rcmjosh2", "josh_2_intp1_base", "Attendre I", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitj"] = { "timetable@amanda@ig_3", "ig_3_base_tracy", "Attendre J", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitk"] = { "misshair_shop@hair_dressers", "keeper_base", "Attendre K", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitl"] = { "rcmjosh1", "keeper_base", "Attendre L", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["waitm"] = { "rcmnigel1a", "base", "Attendre M", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["hiking"] = { "move_m@hiking", "idle", "Randonnée", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog2"] = { "amb@world_human_jog_standing@male@idle_a", "idle_a", "Jogging 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog3"] = { "amb@world_human_jog_standing@female@idle_a", "idle_a", "Jogging 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog4"] = { "amb@world_human_power_walker@female@idle_a", "idle_a", "Jogging 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jog5"] = { "move_m@joy@a", "walk", "Jogging 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["jumpingjacks"] = { "timetable@reunited@ig_2", "jimmy_getknocked", "Sauts de cheval", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["kneel2"] = { "rcmextreme3", "idle", "S'agenouiller 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["kneel3"] = { "amb@world_human_bum_wash@male@low@idle_a", "idle_a", "S'agenouille 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["knock"] = { "timetable@jimmy@doorknock@", "knockdoor_idle", "Toquer à une porte", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["knock2"] = { "missheistfbi3b_ig7", "lift_fibagent_loop", "Toquer à une porte 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["knucklecrunch"] = { "anim@mp_player_intcelebrationfemale@knuckle_crunch", "knuckle_crunch", "Knuckle Crunch", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lean2"] = { "amb@world_human_leaning@female@wall@back@hand_up@idle_a", "idle_a", "Attendre avec une cigarette", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lean3"] = { "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", "idle_a", "Posé 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lean4"] = { "amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a", "Posé 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanflirt"] = { "random@street_race", "_car_a_flirt_girl", "Posé Flirt", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar2"] = { "amb@prop_human_bum_shopping_cart@male@idle_a", "idle_c", "Posé Bar 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar3"] = { "anim@amb@nightclub@lazlow@ig1_vip@", "clubvip_base_laz", "Posé Bar 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanbar4"] = { "anim@heists@prison_heist", "ped_b_loop_a", "Posé contre un bar ", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["leanhigh"] = { "anim@mp_ferris_wheel", "idle_a_player_one", "Posé High", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanhigh2"] = { "anim@mp_ferris_wheel", "idle_a_player_two", "Posé High 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside"] = { "timetable@mime@01_gc", "idle_a", "Posé sur le coté", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside3"] = { "misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Mains contre un mur", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["leanside4"] = { "misscarstealfinalecar_5_ig_1", "waitloop_lamar", "Leanside 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["leanside5"] = { "rcmjosh2", "josh_2_intp1_base", "Leanside 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["me"] = { "gestures@f@standing@casual", "gesture_me_hard", "Moi ?", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000
    } },
    ["mechanic"] = { "mini@repair", "fixing_a_ped", "Réparation accroupie", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic2"] = { "mini@repair", "fixing_a_player", "Mechanic 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic3"] = { "amb@world_human_vehicle_mechanic@male@base", "base", "Mechanic 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = false,
    } },
    ["mechanic4"] = { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", "Mechanic 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["mechanic5"] = { "amb@prop_human_movie_bulb@idle_a", "idle_b", "Mechanic 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["medic2"] = { "amb@medic@standing@tendtodead@base", "base", "Medic 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["meditate"] = { "rcmcollect_paperleadinout@", "meditiate_idle", "Meditation", AnimationOptions = -- CHANGE ME
    {
        EmoteLoop = true,
    } },
    ["meditate2"] = { "rcmepsilonism3", "ep_3_rcm_marnie_meditating", "Meditation 2", AnimationOptions = -- CHANGE ME
    {
        EmoteLoop = true,
    } },
    ["meditate3"] = { "rcmepsilonism3", "base_loop", "Meditation 3", AnimationOptions = -- CHANGE ME
    {
        EmoteLoop = true,
    } },
    ["metal"] = { "anim@mp_player_intincarrockstd@ps@", "idle_a", "Metal", AnimationOptions = -- CHANGE ME
    {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["no"] = { "anim@heists@ornate_bank@chat_manager", "fail", "Non", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["no2"] = { "mp_player_int_upper_nod", "mp_player_int_nod_no", "Non 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nosepick"] = { "anim@mp_player_intcelebrationfemale@nose_pick", "nose_pick", "Nose Pick", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["noway"] = { "gestures@m@standing@casual", "gesture_no_way", "C'est pas possible !", AnimationOptions = {
        EmoteDuration = 1500,
        EmoteMoving = true,
    } },
    ["ok"] = { "anim@mp_player_intselfiedock", "idle_a", "OK", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["dock"] = { "anim@mp_player_intincardockstd@rds@", "idle_a", "Dock", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["outofbreath"] = { "re@construction", "out_of_breath", "Out of Breath", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pickup"] = { "random@domestic", "pickup_low", "Pickup" },
    ["push"] = { "missfinale_c2ig_11", "pushcar_offcliff_f", "Push", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["push2"] = { "missfinale_c2ig_11", "pushcar_offcliff_m", "Push 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["point"] = { "gestures@f@standing@casual", "gesture_point", "Pointer du doigt", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pushup"] = { "amb@world_human_push_ups@male@idle_a", "idle_d", "Pushup", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["countdown"] = { "random@street_race", "grid_girl_race_start", "Countdown", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["pointright"] = { "mp_gun_shop_tut", "indicate_right", "Pointer du doigt a gauche", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute"] = { "anim@mp_player_intincarsalutestd@ds@", "idle_a", "Salut police 1", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute2"] = { "anim@mp_player_intincarsalutestd@ps@", "idle_a", "Salut police 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["salute3"] = { "anim@mp_player_intuppersalute", "idle_a", "Salut police 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["scared"] = { "random@domestic", "f_distressed_loop", "Scared", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["scared2"] = { "random@homelandsecurity", "knees_loop_girl", "Avoir peur au sol", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["screwyou"] = { "misscommon@response", "screw_you", "Screw You", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["shakeoff"] = { "move_m@_idles@shake_off", "shakeoff_1", "Shake Off", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3500,
    } },
    ["shot"] = { "random@dealgonewrong", "idle_a", "Shot", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sleep"] = { "timetable@tracy@sleep@", "idle_c", "Sleep", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["shrug"] = { "gestures@f@standing@casual", "gesture_shrug_hard", "Shrug", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["shrug2"] = { "gestures@m@standing@casual", "gesture_shrug_hard", "Shrug 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["sit"] = { "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", "Assis", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit2"] = { "rcm_barry3", "barry_3_sit_loop", "Sit 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit3"] = { "amb@world_human_picnic@male@idle_a", "idle_a", "Assis 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit4"] = { "amb@world_human_picnic@female@idle_a", "idle_a", "Assis 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit5"] = { "anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle", "Assis simplement", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit6"] = { "timetable@jimmy@mics3_ig_15@", "idle_a_jimmy", "Assis 6", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit7"] = { "anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", "Assis triste 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit8"] = { "timetable@jimmy@mics3_ig_15@", "mics3_15_base_jimmy", "Assis 8", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sit9"] = { "amb@world_human_stupor@male@idle_a", "idle_a", "Assis 9", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitlow"] = { "anim@veh@lowrider@std@ds@arm@base", "sit_low_lowdoor", "Coude sur la vitre", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitlean"] = { "timetable@tracy@ig_14@", "ig_14_base_tracy", "Assis Lean", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitsad"] = { "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", "Assis triste", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared"] = { "anim@heists@ornate_bank@hostages@hit", "hit_loop_ped_b", "Assis peur 1", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared2"] = { "anim@heists@ornate_bank@hostages@ped_c@", "flinch_loop", "Assis peur 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitscared3"] = { "anim@heists@ornate_bank@hostages@ped_e@", "flinch_loop", "Assis peur 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitdrunk"] = { "timetable@amanda@drunk@base", "base", "Assis Alcool", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair2"] = { "timetable@ron@ig_5_p3", "ig_5_p3_base", "Assis sur une chaise 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair3"] = { "timetable@reunited@ig_10", "base_amanda", "Assis sur une chaise (Femme)", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair4"] = { "timetable@ron@ig_3_couch", "base", "Assis sur une chaise 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sitchair5"] = { "timetable@jimmy@mics3_ig_15@", "mics3_15_base_tracy", "Jambe croisées", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["situp"] = { "amb@world_human_sit_ups@male@idle_a", "idle_a", "Sit Up", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["slowclap3"] = { "anim@mp_player_intupperslow_clap", "idle_a", "Claqué des mains lent 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["clap"] = { "amb@world_human_cheering@male_a", "base", "Claqué des mains", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slowclap"] = { "anim@mp_player_intcelebrationfemale@slow_clap", "slow_clap", "Claqué des mains lent", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slowclap2"] = { "anim@mp_player_intcelebrationmale@slow_clap", "slow_clap", "Claqué des mains lent 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stumble"] = { "misscarsteal4@actor", "stumble", "Trébucher", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sunbathe"] = { "amb@world_human_sunbathe@male@back@base", "base", "Bain de soleil", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["sunbathe2"] = { "amb@world_human_sunbathe@female@back@base", "base", "Bain de soleil 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["t"] = { "missfam5_yoga", "a2_pose", "T", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["t2"] = { "mp_sleep", "bind_pose_180", "T 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["think5"] = { "mp_cp_welcome_tutthink", "b_think", "Pensez 5", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["think"] = { "misscarsteal4@aliens", "rehearsal_base_idle_director", "Pensez", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["think3"] = { "timetable@tracy@ig_8@base", "base", "Pensez 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },

    ["think2"] = { "missheist_jewelleadinout", "jh_int_outro_loop_a", "Pensez 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["thumbsup3"] = { "anim@mp_player_intincarthumbs_uplow@ds@", "enter", "Les pouces en l'air 3", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },
    ["thumbsup2"] = { "anim@mp_player_intselfiethumbs_up", "idle_a", "Les pouces en l'air 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["thumbsup"] = { "anim@mp_player_intupperthumbs_up", "idle_a", "Les pouces en l'air", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type"] = { "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", "Clavier", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["type2"] = { "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", "Tapez au clavier", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave4"] = { "random@mugging5", "001445_01_gangintimidation_1_female_idle_b", "Salut 4", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },
    ["wave2"] = { "anim@mp_player_intcelebrationfemale@wave", "wave", "Salut 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave3"] = { "friends@fra@ig_1", "over_here_idle_a", "Salut 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave"] = { "friends@frj@ig_1", "wave_a", "Salut 1", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave5"] = { "friends@frj@ig_1", "wave_b", "Salut 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave6"] = { "friends@frj@ig_1", "wave_c", "Salut 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave7"] = { "friends@frj@ig_1", "wave_d", "Salut 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave8"] = { "friends@frj@ig_1", "wave_e", "Salut 8", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["wave9"] = { "gestures@m@standing@casual", "gesture_hello", "Salut 9", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["whistle"] = { "taxi_hail", "hail_taxi", "Siffler", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 1300,
    } },
    ["yeah"] = { "anim@mp_player_intupperair_shagging", "idle_a", "Yeah", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lift"] = { "random@hitch_lift", "idle_f", "Taxi", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["lol"] = { "anim@arena@celeb@flat@paired@no_props@", "laugh_a_player_b", "LOL", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["lol2"] = { "anim@arena@celeb@flat@solo@no_props@", "giggle_a_player_b", "LOL 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["statue2"] = { "fra_0_int-1", "cs_lamardavis_dual-1", "Statue 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["statue3"] = { "club_intro2-0", "csb_englishdave_dual-0", "Statue 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["gangsign"] = { "mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", "Gang Sign", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["gangsign2"] = { "mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", "Gang Sign 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["passout"] = { "missarmenian2", "drunk_loop", "Couché l", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["passout2"] = { "missarmenian2", "corpse_search_exit_ped", "Couché 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["passout3"] = { "anim@gangops@morgue@table@", "body_search", "Couché 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["passout4"] = { "mini@cpr@char_b@cpr_def", "cpr_pumpchest_idle", "Couché 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["passout5"] = { "random@mugging4", "flee_backward_loop_shopkeeper", "Couché 5", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["petting"] = { "creatures@rottweiler@tricks@", "petting_franklin", "Caressé", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["crawl"] = { "move_injured_ground", "front_loop", "Crawl", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["bow2"] = { "anim@arena@celeb@podium@no_prop@", "regal_a_1st", "Bow 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["keyfob"] = { "anim@mp_player_intmenu@key_fob@", "fob_click", "Key Fob", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = true,
        EmoteDuration = 1000,
    } },
    ["reaching"] = { "move_m@intimidation@cop@unarmed", "idle", "Reaching", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["slap"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Donné une claque", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
        EmoteDuration = 2000,
    } },
    ["fishdance"] = { "anim@mp_player_intupperfind_the_fish", "idle_a", "Vague avec sa mains", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace"] = { "mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", "Paix", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace2"] = { "anim@mp_player_intupperpeace", "idle_a", "Paix 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace3"] = { "anim@mp_player_intupperpeace", "idle_a_fp", "Paix 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace4"] = { "anim@mp_player_intincarpeacestd@ds@", "idle_a", "Paix 4", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
     } },
    ["peace5"] = { "anim@mp_player_intincarpeacestd@ds@", "idle_a_fp", "Paix 5", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace6"] = { "anim@mp_player_intincarpeacebodhi@ds@", "idle_a", "Paix 6", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peace7"] = { "anim@mp_player_intincarpeacebodhi@ds@", "idle_a_fp", "Paix 7", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peacef"] = { "anim@mp_player_intcelebrationfemale@peace", "peace", "Paix Femme", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["cpr"] = { "mini@cpr@char_a@cpr_str", "cpr_pumpchest", "CPR", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cpr2"] = { "mini@cpr@char_a@cpr_str", "cpr_pumpchest", "CPR 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["ledge"] = { "missfbi1", "ledge_loop", "Ledge", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["airplane"] = { "missfbi1", "ledge_loop", "Air Plane", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["peek"] = { "random@paparazzi@peek", "left_peek_a", "Peek", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["cough"] = { "timetable@gardener@smoking_joint", "idle_cough", "Toussé", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["stretch"] = { "mini@triathlon", "idle_e", "Étirement", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch2"] = { "mini@triathlon", "idle_f", "Étirement 2", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch3"] = { "mini@triathlon", "idle_d", "Étirement 3", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["stretch4"] = { "rcmfanatic1maryann_stretchidle_b", "idle_e", "Étirement 4", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["superhero"] = { "rcmbarry", "base", "Superhero", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["superhero2"] = { "rcmbarry", "base", "Superhero 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nervous2"] = { "mp_missheist_countrybank@nervous", "nervous_idle", "Stressé", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nervous"] = { "amb@world_human_bum_standing@twitchy@idle_a", "idle_c", "Stressé 2", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["nervous3"] = { "rcmme_tracey1", "nervous_loop", "Stressé 3", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["namaste"] = { "timetable@amanda@ig_4", "ig_4_base", "Namaste", AnimationOptions = {
        EmoteLoop = true,
        EmoteMoving = true,
    } },
    ["spiderman"] = { "missexile3", "ex03_train_roof_idle", "Spider-Man", AnimationOptions = {
        EmoteLoop = true,
    } },
    ["boi"] = { "special_ped@jane@monologue_5@monologue_5c", "brotheradrianhasshown_2", "BOI", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 3000,
    } },
    ["adjust"] = { "missmic4", "michael_tux_fidget", "Ajuster vos vêtements", AnimationOptions = {
        EmoteMoving = true,
        EmoteDuration = 4000,
    } },
    ["handsup"] = { "missminuteman_1ig_2", "handsup_base", "Mains en l'air", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["handsup2"] = { "anim@mp_player_intuppersurrender", "idle_a_fp", "Mains en l'air 2", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["tighten"] = { "timetable@denice@ig_1", "idle_b", "Yoga", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["fspose"] = { "missfam5_yoga", "c2_pose", "Fesse en l'air", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["fspose2"] = { "missfam5_yoga", "c6_pose", "F Sex Pose 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["fspose4"] = { "anim@amb@carmeet@checkout_car@", "female_c_idle_d", "F Sex Pose 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerf"] = { "mp_safehouseshower@female@", "shower_enter_into_idle", "Douche Entrez Femme", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerf2"] = { "mp_safehouseshower@female@", "shower_idle_a", "Douche féminine", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerf3"] = { "mp_safehouseshower@female@", "shower_idle_b", "Douche féminine 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm"] = { "mp_safehouseshower@male@", "male_shower_idle_a", "Douche Homme", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm2"] = { "mp_safehouseshower@male@", "male_shower_idle_b", "Douche homme 2", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm3"] = { "mp_safehouseshower@male@", "male_shower_idle_c", "Douche homme 3", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["showerm4"] = { "mp_safehouseshower@male@", "male_shower_idle_d", "Douche homme 4", AnimationOptions = {
        EmoteMoving = false,
        EmoteLoop = true,
    } },
    ["cleanhands"] = { "missheist_agency3aig_23", "urinal_sink_loop", "Nettoyer ces mains sales", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["cleanface"] = { "switch@michael@wash_face", "loop_michael", "Nettoyez votre visage", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["buzz"] = { "anim@apt_trans@buzzer", "buzz_reg", "Sonné à une porte", AnimationOptions = {
        EmoteLoop = false,
        EmoteMoving = false,
    } },
    ["grieve"] = { "anim@miss@low@fin@vagos@", "idle_ped05", "Pleurez les morts", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = true,
     } },
    ["respect"] = { "anim@mp_player_intcelebrationmale@respect", "respect", "Respect Male", AnimationOptions = {
        EmoteMoving = true,
        EmoteLoop = false,
    } },
}

danceList  ={
    ["crossbounce"] = {"custom@crossbounce", "crossbounce", "Cross bounce(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["dontstart"] = {"custom@dont_start", "dont_start", "Dont Start(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["floss"] = {"custom@floss", "floss", "Floss(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["orangejustice"] = {"custom@orangejustice", "orangejustice", "Orange Justice(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["renegade"] = {"custom@renegade", "renegade", "Renegade(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["rickroll"] = {"custom@rickroll", "rickroll", "Rick Roll(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["savage"] = {"custom@savage", "savage", "Savage(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["sayso"] = {"custom@sayso", "sayso", "Say So(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["takel"] = {"custom@take_l", "take_l", "Take the L(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
  
    ["tslide"] = {"custom@toosie_slide", "toosie_slide", "Tootsie Slide(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    ["clock"] = {"custom@around_the_clock", "around_the_clock", "Around the clock(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["dancemoves"] = {"custom@dancemoves", "dancemoves", "Dance moves(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["discodance"] = {"custom@disco_dance", "disco_dance", "Disco Dance(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["electroshuffle"] = {"custom@electroshuffle_original", "electroshuffle_original", "Electro Shuffle(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["electroshuffle2"] = {"custom@electroshuffle", "electroshuffle", "Electro Shuffle 2(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["fresh"] = {"custom@fresh_fortnite", "fresh_fortnite", "Fresh(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["gylphic"] = {"custom@gylphic", "gylphic", "Glyphic(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["hitit"] = {"custom@hitit", "hitit", "Hit It(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["inparty"] = {"custom@in_da_party", "in_da_party", "In Da Party(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["robotdance"] = {"custom@robotdance_fortnite", "robotdance_fortnite", "Robot Dance(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["frightfunk"] = {"custom@frightfunk", "frightfunk", "Fright Funk(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["gloss"] = {"custom@gloss", "gloss", "Gloss(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["lastforever"] = {"custom@last_forever", "last_forever", "Last Forever(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["smoothmoves"] = {"custom@smooth_moves", "smooth_moves", "Smooth moves(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["introducing"] = {"custom@introducing", "introducing", "Introducing...(Fortnite)", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
    }},
    
    ["bellydance2"] = {"custom@bellydance2", "bellydance2", "·Belly Dance 2", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
  ["footwork"] = {"custom@footwork", "footwork", "·Footwork", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
     ["headspin"] = {"custom@headspin", "headspin", "·Headspin", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = false,
  }},
  
     ["pumpup"] = {"custom@hiphop_pumpup", "hiphop_pumpup", "·Hiphop Pumpup", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
     ["hiphop_yeah"] = {"custom@hiphop_yeah", "hiphop_yeah", "·Hiphop Yeah", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = false,
  }},
  
  ["salsatime"] = {"custom@salsatime", "salsatime", "·Salsa Time", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
  ["samba"] = {"custom@samba", "samba", "·Samba", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
  ["shockdance"] = {"custom@shockdance", "shockdance", "·Shock Dance", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
  ["specialdance"] = {"custom@specialdance", "specialdance", "·Special Dance", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
  ["toetwist"] = {"custom@toetwist", "toetwist", "·Toe twist", AnimationOptions =
  {
     EmoteMoving = false,
     EmoteLoop = true,
  }},
  
    ["salsor"] = {"anim@mp_player_intuppersalsa_roll", "idle_a", "Salso Roll", AnimationOptions =
     {
         EmoteLoop = true,
     }},
     ["unclej"] = {"anim@mp_player_intcelebrationfemale@uncle_disco", "uncle_disco", "Uncle Josh ", AnimationOptions =
     {
         EmoteLoop = true,
     }},
    ["jmonkeyd"] = {"anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", "high_center", "Monkey Dance  ", AnimationOptions =
     {
         EmoteLoop = true
      }},
      ["jmonkeyd2"] = {"anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", "high_center_down", "Monkey Dance 2  ", AnimationOptions =
      {
          EmoteLoop = true
       }},
       ["jmonkeyd3"] = {"anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", "med_center_down", "Monkey Dance 3  ", AnimationOptions =
       {
           EmoteLoop = true
        }},
      ["jrightdown"] = {"anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", "med_right_down", "Boxing Dance Solo  ", AnimationOptions =
      {
          EmoteLoop = true
       }},
       ["jlowdance"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_a@", "low_center", "Low Dance · Female ", AnimationOptions =
      {
          EmoteLoop = true
         }},
         ["jlowdance2"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_a@", "high_center", "Low Dance · Female", AnimationOptions =
         {
          EmoteLoop = true
          }},
         ["jhiphop"] = {"anim@amb@nightclub@mini@dance@dance_paired@dance_d@", "ped_a_dance_idle", "Hip Hop Dance ", AnimationOptions =
          {
             EmoteLoop = true
          }},
         ["jhiphop2"] = {"anim@amb@nightclub@mini@dance@dance_paired@dance_b@", "ped_a_dance_idle", "Hip Hop Dance ", AnimationOptions =
         {
             EmoteLoop = true
           }},
          ["jhiphop3"] = {"anim@amb@nightclub@mini@dance@dance_paired@dance_a@", "ped_a_dance_idle", "Hip Hop Dance ", AnimationOptions =
          {
             EmoteLoop = true
          }},
    ["jhiphop3"] = {"anim@amb@nightclub@mini@dance@dance_paired@dance_a@", "ped_a_dance_idle", "Hip Hop Dance ", AnimationOptions =
    {
       EmoteLoop = true
    }},
  
  
    ["jdrill"] = {"anim@amb@nightclub_island@dancers@crowddance_single_props@", "mi_dance_prop_13_v1_male^3", "Drill · Male", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill2"] = {"anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", "mi_dance_crowd_13_v2_male^1", "Drill · Male 2", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill3"] = {"anim@amb@nightclub_island@dancers@crowddance_facedj@", "mi_dance_facedj_17_v2_male^4", "Drill · Male 3", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill4"] = {"anim@amb@nightclub_island@dancers@crowddance_facedj@", "mi_dance_facedj_15_v2_male^4", "Drill · Male 4", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill5"] = {"anim@amb@nightclub_island@dancers@crowddance_facedj@", "hi_dance_facedj_hu_15_v2_male^5", "Drill · Male 5", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill6"] = {"anim@amb@nightclub_island@dancers@crowddance_facedj@", "hi_dance_facedj_hu_17_male^5", "Drill · Male 6", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill7"] = {"anim@amb@nightclub@mini@dance@dance_solo@shuffle@", "high_right_up", "Drill · Solo 1", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill8"] = {"anim@amb@nightclub@mini@dance@dance_solo@shuffle@", "med_center", "Drill · Solo 2", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["jdrill9"] = {"anim@amb@nightclub@mini@dance@dance_solo@shuffle@", "high_right_down", "Drill · Solo 3", AnimationOptions =
    {
        EmoteLoop = true,
    }}, 
    ["jdrill10"] = {"anim@amb@nightclub@mini@dance@dance_solo@shuffle@", "high_center", "Drill · Solo 4", AnimationOptions =
    {
         EmoteLoop = true,
    }}, 
    ["jdrill11"] = {"anim@amb@nightclub@mini@dance@dance_solo@shuffle@", "high_left_down", "Drill · Solo 5", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dance"] = {"anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5", "Dance", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance2"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down", "Dance 2", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance3"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", "Dance 3", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance4"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_up", "Dance 4", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance5"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_a@", "med_center", "Dance 5", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["dance6"] = {"misschinese2_crystalmazemcs1_cs", "dance_loop_tao", "Dance 6", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance7"] = {"misschinese2_crystalmazemcs1_ig", "dance_loop_tao", "Dance 7", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance8"] = {"missfbi3_sniping", "dance_m_default", "Dance 8", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dance9"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_center_up", "Dance 9", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef"] = {"anim@amb@nightclub@dancers@solomun_entourage@", "mi_dance_facedj_17_v1_female^1", "Dance F", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center", "Dance F2", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F3", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef4"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^1", "Dance F4", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef5"] = {"anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_female^3", "Dance F5", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancef6"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_up", "Dance F6", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceclub"] = {"anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m03", "Dance Club", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub2"] = {"anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m05", "Dance Club 2", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub3"] = {"anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_a_m02", "Dance Club 3", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub4"] = {"anim@amb@nightclub_island@dancers@beachdance@", "hi_idle_b_f01", "Dance Club 4", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub5"] = {"anim@amb@nightclub_island@dancers@club@", "hi_idle_a_f02", "Dance Club 5", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub6"] = {"anim@amb@nightclub_island@dancers@club@", "hi_idle_b_m03", "Dance Club 6", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["danceclub7"] = {"anim@amb@nightclub_island@dancers@club@", "hi_idle_d_f01", "Dance Club 7", AnimationOptions =
    {
      EmoteLoop = true
    }},

    ["danceslow2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center", "Dance Slow 2", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceslow3"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_center_down", "Dance Slow 3", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceslow4"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center", "Dance Slow 4", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceupper"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Upper", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = true,
    }},
    ["danceupper2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center_up", "Dance Upper 2", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = true,
    }},
    ["danceshy"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "low_center", "Dance Shy", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceshy2"] = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down", "Dance Shy 2", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["danceslow"] = {"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "low_center", "Dance Slow", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly9"] = {"rcmnigel1bnmt_1b", "dance_loop_tyler", "Dance Silly 9", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly"] = {"special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag", "Dance Silly", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly2"] = {"move_clown@p_m_zero_idles@", "fidget_short_dance", "Dance Silly 2", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly3"] = {"move_clown@p_m_two_idles@", "fidget_short_dance", "Dance Silly 3", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly4"] = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_11_buttwiggle_b_laz", "Dance Silly 4", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly5"] = {"timetable@tracy@ig_5@idle_a", "idle_a", "Dance Silly 5", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly6"] = {"timetable@tracy@ig_8@idle_b", "idle_d", "Dance Silly 6", AnimationOptions =
    {
      EmoteLoop = true,
    }},
    ["dancesilly8"] = {"anim@mp_player_intcelebrationfemale@the_woogie", "the_woogie", "Dance Silly 8", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["dancesilly7"] = {"anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", "Dance Silly 7", AnimationOptions =
    {
      EmoteLoop = true
    }},
    ["dj"] = {"anim@amb@nightclub@djs@dixon@", "dixn_dance_cntr_open_dix", "DJ", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = true,
    }},
    ["dj2"] = {"anim@amb@nightclub@djs@solomun@", "sol_idle_ctr_mid_a_sol", "DJ 2", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj3"] = {"anim@amb@nightclub@djs@solomun@", "sol_dance_l_sol", "DJ 3", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj4"] = {"anim@amb@nightclub@djs@black_madonna@", "dance_b_idle_a_blamadon", "DJ 4", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj5"] = {"anim@amb@nightclub@djs@dixon@", "dixn_end_dix", "DJ 5", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj5"] = {"anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_a_dix", "DJ 5", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj6"] = {"anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_b_dix", "DJ 6", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj7"] = {"anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_g_dix", "DJ 7", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj8"] = {"anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_gb_dix", "DJ 8", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["dj9"] = {"anim@amb@nightclub@djs@dixon@", "dixn_sync_cntr_j_dix", "DJ 9", AnimationOptions =
    {
      EmoteLoop = true,
      EmoteMoving = false,
    }},
    ["twerk"] = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper", "Twerk", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdance"] = {"mp_safehouse", "lap_dance_girl", "Lapdance"},
    
    ["lapdance2"] = {"mini@strip_club@private_dance@idle", "priv_dance_idle", "Lapdance 2", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdance3"] = {"mini@strip_club@private_dance@part1", "priv_dance_p1", "Lapdance 3", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdance4"] = {"mini@strip_club@private_dance@part2", "priv_dance_p2", "Lapdance 4", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdance5"] = {"mini@strip_club@private_dance@part3", "priv_dance_p3", "Lapdance 5", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdance6"] = {"oddjobs@assassinate@multi@yachttarget@lapdance", "yacht_ld_f", "Lapdance 6", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdancewith"] = {"mini@strip_club@lap_dance_2g@ld_2g_p3", "ld_2g_p3_s2", "Lapdance With", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdancewith2"] = {"mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s2", "Lapdance With2", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapdancewith3"] = {"mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s2", "Lapdance With3", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapchair"] = {"mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", "Lap Chair", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapchair2"] = {"mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f", "Lap Chair2", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["lapchair3"] = {"mini@strip_club@lap_dance@ld_girl_a_song_a_p3", "ld_girl_a_song_a_p3_f", "Lap Chair3", AnimationOptions =
    {
       EmoteLoop = true,
    }},
    ["salsa"] = {"custom@salsa", "salsa", "Salsa", AnimationOptions =
    {
       EmoteLoop = true,
  
    }},
    ["hiphopslide"] = {"custom@hiphop_slide", "hiphop_slide", "HipHop Slide", AnimationOptions =
     {
        EmoteMoving = false,
        EmoteLoop = true,
     }},
     
     ["hiphop1"] = {"custom@hiphop1", "hiphop1", "HipHop 1", AnimationOptions =
     {
        EmoteMoving = false,
        EmoteLoop = true,
     }},
     
     ["hiphop2"] = {"custom@hiphop2", "hiphop2", "HipHop 2", AnimationOptions =
     {
        EmoteMoving = false,
        EmoteLoop = true,
     }},
     
     ["hiphop3"] = {"custom@hiphop3", "hiphop3", "HipHop 3", AnimationOptions =
     {
        EmoteMoving = false,
        EmoteLoop = true,
     }},
     
     ["hiphopold"] = {"custom@hiphop90s", "hiphop90s", "HipHop Old", AnimationOptions =
     {
        EmoteMoving = false,
        EmoteLoop = true,
     }},
     ["gangnamstyle"] = {"custom@gangnamstyle", "gangnamstyle", "Gangnamstyle", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
  
    }},
    ["makarena"] = {"custom@makarena", "makarena", "Makarena", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
  
    }},
    ["maraschino"] = {"custom@maraschino", "maraschino", "Maraschino", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
  
    }},
    ["breakdance"] = {"export@breakdance", "breakdance", "Break Dance", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
  
    }},
    ["breakdance"] = {"mini@strip_club@pole_dance@pole_dance1", "pd_dance_0", "PoleDance", AnimationOptions =
    {
       EmoteMoving = false,
       EmoteLoop = true,
  
    }},

}


PoleDance = { -- allows you to pole dance at the strip club, you can of course add more locations if you want.
     {['Position'] = vector3(112.60, -1286.76, 28.56), ['Number'] = '3'},
    {['Position'] = vector3(104.18, -1293.94, 29.26), ['Number'] = '1'},
    {['Position'] = vector3(102.24, -1290.54, 29.26), ['Number'] = '2'}
}



















Animation_Config_Synced = {
    {
        ['Label'] = 'Câlin',
        ['RequesterLabel'] = 'hug',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Câlin amoureux',
        ['RequesterLabel'] = 'hug2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_chad', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_girl', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 0,
                ['xP'] = 0.0,
                ['yP'] = 0.53,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Claque',
        ['RequesterLabel'] = 'hug2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_slap', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Grosse claque',
        ['RequesterLabel'] = 'hug2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_backslap', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_backslap', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Petit Bisous',
        ['RequesterLabel'] = 'hug2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Embrassez',
        ['RequesterLabel'] = 'kiss',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'cs_lestercrest_3_dual-20', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'csb_georginacheng_dual-20', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 0,
                ['xP'] = 0.0,
                ['yP'] = 0.53,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Tape-là',
        ['RequesterLabel'] = 'do a high five with',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Câlin de frère',
        ['RequesterLabel'] = 'do a bro hug with',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.025,
                ['yP'] = 1.15,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Check du poing',
        ['RequesterLabel'] = 'fistbump',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.6,
                ['yP'] = 0.9,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 270.0,
            }
        }
    },
    {
        ['Label'] = 'Serrer la main (ami)',
        ['RequesterLabel'] = 'shake hands with',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 1.2,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Serrer la main (travail)',
        ['RequesterLabel'] = 'shake hands with',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.075,
                ['yP'] = 1.0,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
        -- NSFW animations vvvvvvvv
        {
            ['Label'] = 'Faire une fellation (debout)',
            ['RequesterLabel'] = 'get a blowjob from',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.0,
                    ['yP'] = 0.65,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Se faire baiser (debout)',
            ['RequesterLabel'] = 'fuck',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 0.4,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Anal (debout)', 
            ['RequesterLabel'] = 'get taken in the ass by',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.015,
                    ['yP'] = 0.35,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 0.0,
                },
            },
        },
        {
            ['Label'] = "Faire l'amour (véhicule)", 
            ['RequesterLabel'] = 'get fucked by',
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Faire l'amour (véhicule)", 
            ['RequesterLabel'] = 'fuck',
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Fellation (véhicule)", 
            ['RequesterLabel'] = 'give blowjob to',
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 1,
            },
        },
}
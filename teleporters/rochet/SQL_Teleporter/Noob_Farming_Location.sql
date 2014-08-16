REPLACE INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES 
(50010, 3, 2, 'Noobz Farming mobs for Wolf Coin\'s', 1, 1, 0, 0, 0, 0, 'Are you sure, that you want to go to farm for Wolf Coin\'s?');

REPLACE INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(190000, 0, 136, 0, 62, 0, 100, 0, 50010, 3, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 8, 0, 0, -737.18, -3924.01, 22.8694, 2.31676, 'Teleporter script');

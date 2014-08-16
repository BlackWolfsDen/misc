REPLACE INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES 
(50010, 5, 2, 'Pug\'z', 1, 1, 0, 0, 0, 0, 'Are you sure, that you want to go farm for Pug\'z?');

REPLACE INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(190000, 0, 138, 0, 62, 0, 100, 0, 50010, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 8, 0, 0, 9024.37, -6682.55, 16.8973, 3.14131, 'Pugz teleport location');

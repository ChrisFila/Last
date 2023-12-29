RegisterNetEvent('cmg2_animations:sync', function(animationLib, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
	if targetSrc ~= -1 then
		TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
		TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
	else
		DropPlayer(source, 'Désynchronisation avec le serveur ou detection de Cheat')
	end
end)

RegisterNetEvent('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)

RegisterNetEvent('cmg3_animations:sync', function(animationLib, animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget, attachFlag)
	if targetSrc ~= -1 then
		TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget, attachFlag)
		TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
	else
		DropPlayer(source, 'Désynchronisation avec le serveur ou detection de Cheat')
	end
end)

RegisterNetEvent('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)
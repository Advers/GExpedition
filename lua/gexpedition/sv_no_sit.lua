hook.Add("OnPlayerSit", "PreventGExSitting", function(_, _, _, parent)
	if parent.UnSittable then
		return false
	end
end)

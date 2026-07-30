local HurtSound = {
	Pending = nil
}

---@diagnostic disable-next-line: undefined-field
events.ON_PLAY_SOUND:register(function (id, pos, volume, pitch, looping, category, soundID)
	--他プレイヤーの被ダメージ音まで置き換えないよう、自分の座標と一致する場合のみ処理する
	if id == "minecraft:entity.player.hurt" and pos:sub(player:getPos()):length() < 0.1 then
		--ここでsounds:playSoundを直接呼ぶとON_PLAY_SOUNDの再入になり音が消えるため、次のTICKまで遅延させる
		--posはコピー(:copy())すると壊れて(0,0,0)になるため保持せず、再生時にplayer:getPos()を取り直す
		HurtSound.Pending = {volume = volume, pitch = pitch}
		return true
	end
end)

events.TICK:register(function ()
	if HurtSound.Pending then
		sounds:playSound(CompatibilityUtils:checkSound("minecraft:entity.wolf.hurt"), player:getPos(), HurtSound.Pending.volume, HurtSound.Pending.pitch)
		HurtSound.Pending = nil
	end
end)

return HurtSound

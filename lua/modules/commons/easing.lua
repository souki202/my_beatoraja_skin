--[[
    @param  {int} t アニメーション開始からの時間
    @param  {int} s 開始の値
    @param  {int} e 終了の値
    @param  {int} d アニメーション時間
]]
function easeOut(t, s, e, d)
    local c = e - s
    local rate = t / d
    rate = 1 - (rate - 1) * (rate - 1)
    return c * rate + s
end

--[[
    アニメーションの状態から, 対応する時刻を取得する
    @param  int n 現在の値
    @param  int s 開始の値
    @param  int e 終了の値
    @param  int d アニメーション時間
]]
function easeOutTime(n, s, e, d)
	local c = e - s
	-- n = c * rate + s
	-- n - s = c * rate
	-- rate = (n - s) / c
	local rate = (n - s) / c
	-- r2 = 1-(r-1)^2
	-- r2 = 1 - (r^2 - 2r + 1)
	-- r2 = -r^2 + 2r
	-- r^2 - 2r + r2 = 0
	if rate > 1 then return d end
	return d * (1 - math.sqrt(1 - rate))
end
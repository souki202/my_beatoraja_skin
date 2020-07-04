function pivotEdgeToCenter(x, y)
    x = x - BASE_WIDTH / 2
    y = y - BASE_HEIGHT / 2
    return x, y
end

function pivotCenterToEdge(x, y)
    x = x + BASE_WIDTH / 2
    y = y + BASE_HEIGHT / 2
    return x, y
end

function linearRotation(x, y, radian)
    local tx, ty = x, y
    x = tx * math.cos(radian) + ty * -math.sin(radian)
    y = tx * math.sin(radian) + ty * math.cos(radian)
    return x, y
end

-- 画面中央を中心に座標を回転 動くのは座標だけで画像自体は回転しない
function rotationByCenter(x, y, radian)
    x, y = pivotEdgeToCenter(x, y)
    x, y = linearRotation(x, y, radian)
    return pivotCenterToEdge(x, y)
end

-- z, y, z座標(zはbeatoraja画面上に対する相対座標)をbeatoraja画面上に透視投影した2D座標x, yに変換する
-- fovは度数法
-- 座標系は左手系
function perspectiveProjection(x, y, z, fov)
    -- 受け付けないfov
    if fov == 0 or fov < -1 or fov >= 180 then
        return 0, 0
    end
    -- 0なら平行投影とする
    if fov == -1 then
        return x, y
    end
    -- 平行移動
    x, y = pivotEdgeToCenter(x, y)

    local radFov = math.rad(fov)
    -- fovからカメラのzを求める
    local r = BASE_WIDTH / 2 / math.tan(radFov / 2)

    -- 変換
    x = x / (1 + z / r)
    y = y / (1 + z / r)

    return pivotCenterToEdge(x, y)
end

-- @param  float w もとの幅
-- @param  float h もとの高さ
-- @param  float z beatoraja画面に対する相対座標 画面より奥なら正, 手前なら負
-- @param  int fov
-- @return float, float 新しいw, h
function perspectiveProjectionSize(w, h, z, fov)
    -- 受け付けないfov
    if fov == 0 or fov < -1 or fov >= 180 then
        return 0, 0
    end
    -- 0なら平行投影とする
    if fov == -1 then
        return w, h
    end

    local radFov = math.rad(fov)
    -- fovからカメラのzを求める
    local r = BASE_WIDTH / 2 / math.tan(radFov / 2)
    -- カメラの目の前にある場合
    if r == -z then
        return 99999, 99999
    end
    local p = r / (r + z)
    return w * p, h * p
end
return {
    BAR = {
        N = 17, -- 描画するバーの本数. 通常は変更する必要はありません
        CENTER_IDX = 8, -- 中央のバーのID 通常は変更する必要はありません

        W = 607, -- 描画するバーの幅と高さ
        H = 78,

        CENTER_X = 1197, -- 中央のバーの左端のx座標 左下が(0, 0)
        CENTER_Y = 571, -- 中央のバーの下のy座標
        PREV_CENTER_X = 1197 - 11.2 * 1.75, -- 中央のバーのすぐ下のバーの座標
        PREV_CENTER_Y = 571 - 80 * 1.75,
        NEXT_CENTER_X = 1197 + 11.2, -- 中央のバーのすぐ上の座標
        NEXT_CENTER_Y = 571 + 80,


        INTERVAL_Y = 80, -- 各バーのy座標の間隔
        INTERVAL_X = 80 * 0.14, -- 各バーのx座標の間隔

        ANIM_INTERVAL = 20, -- 選曲画面突入時の各バーのアニメーションの時間差分 上にあるバーから出現

        -- 難易度描画の, バーに対するサイズと相対座標
        DIFFICULTY = {
            X = 18,
            Y = 12,
            W = 16,
            H = 21,
        },

        -- 今は非対応
        -- TROPHY = {
        --     W = 56,
        --     H = 56,
        -- },

        -- タイトル名の描画最大幅と相対座標 文字のxは右端
        FONT_SIZE = 32, -- 各バーのタイトル名のフォントサイズ
        TITLE = {
            X = 570,
            Y = 21,
            W = 397,
        },

        -- フォルダランプのグラフのサイズと相対座標
        GRAPH = {
            X = 170,
            Y = 9,
            W = 397,
            H = 8,
        },

        -- LN等の表記のサイズと相対座標
        LABEL = {
            X = 70,
            Y = 11,
            W = 50,
            H = 22,
        },

        -- 各楽曲のクリアランプのサイズと相対座標
        LAMP = {
            X = 17,
            Y = 41,
            W = 110,
            H = 28,
        },
    },

    ACTIVE_FRAME = {
        -- アクティブなバーの部分のフレーム座標
        FRAME = {
            X = 1143,
            Y = 503,
            W = 714,
            H = 154,
        },
        -- アクティブなバーの箇所のアーティスト名とサブアーティスト名のサイズ
        TEXT = {
            ARTIST_SIZE = 24,
            SUBARTIST_SIZE = 18,
        },
        -- アーティスト表記の描画最大幅と絶対座標 xは右端
        ARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 40 end,
            W = 370,
        },
        -- サブアーティスト表記の描画最大幅と絶対座標 xは右端
        SUBARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 13 end,
            W = 310,
        },
        ITEM_TEXT = {
            W = 168,
            H = 22,
        },

        -- BPM等の各種設定は未実装
    }
}
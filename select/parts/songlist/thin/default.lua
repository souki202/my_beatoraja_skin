return {
    BAR = {
        N = 25,
        W = 607,
        H = 50,

        PREV_CENTER_X = 1196 - 11.2 * 1.75 + 4,
        PREV_CENTER_Y = 573 - 50 * 1.75 - 30,
        CENTER_X = 1196,
        CENTER_Y = 573,
        NEXT_CENTER_X = 1196 + 7.7,
        NEXT_CENTER_Y = 573 + 57,

        CENTER_IDX = 12,

        INTERVAL_Y = 50,
        INTERVAL_X = 50 * 0.14,
        ANIM_INTERVAL = 15,

        DIFFICULTY = {
            X = 143,
            Y = 14,
            W = 16,
            H = 21,
        },
        -- TROPHY = {
        --     W = 56,
        --     H = 56,
        -- },
        FONT_SIZE = 24,
        TITLE = {
            X = 570,
            Y = 11,
            W = 380,
        },
        GRAPH = {
            X = 179,
            Y = 8,
            W = 403,
            H = 4,
        },
        LABEL = {
            X = 580,
            Y = 0,
            W = 20,
            H = 50,
        },
        LAMP = {
            W = 110,
            H = 28,
            X = 17,
            Y = 11,
        },
    },
    ACTIVE_FRAME = {
        -- アクティブなバーの部分のフレーム座標
        FRAME = {
            X = 1143,
            Y = 503,
            W = 714,
            H = 130,
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
        -- FAVORITEボタンの絶対座標とサイズ
        FAVORITE = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 669 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 86 end,
            W = 26,
            H = 25,
        },
    }
}
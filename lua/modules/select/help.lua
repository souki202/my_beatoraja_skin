local main_state = require("main_state")

require("modules.commons.my_window")
require("modules.commons.input")
local commons = require("modules.select.commons")

local TEXTURE_SIZE = 2048

local help = {
    WND = {
        X = 160,
        Y = 90,
        W = 1600,
        H = 900
    },
    BUTTON = {
        X = 728,
        Y = 12,
    },
    H1 = {
        X = 62,
        Y = 845,
        H = 30,
    },
    MASK = {
        X = 49, -- Yは計算
        W = 1502,
        UPPER_H = 90,
        BOTTOM_H = 86,
    },
    ITEM = {
        AREA = {
            X = 49,
            W = 1502,
            Y = 86,
            START_Y = 760, -- WNDからの相対
            H = 724,
        },
        BG = {
            HEADER = {
                X = 49,
                W = 1502,
                H = 50,
                EDGE_W = 11,
                INTERVAL = 64,
                VIEW_DELAY = 300,
            },
            ITEM = {
                X = 49,
                W = 1502,
                H = 36,
                BRIGHT = 75,
                INTERVAL = 38,
                APPEAR_ANIMATION_TIME = 100 * 1000, -- マイクロ秒
            },
        },
        TEXT = {
            X = 76,
            Y = 12, -- これだけ各項目からの差分
            HEADER_H = 24,
            ITEM_H = 20,
        }
    },
    ANIMATION_TIME = 150,
    closeTime = 0,

    isOpening = false, -- 開いている最中かどうか
    isClosing = false, -- 閉じている最中かどうか
    hasAllClosed = true, -- すべて閉じている状態かどうか
    didProcessAllClose = false, -- すべて閉じる処理を完了したかどうか
    hasOpened = false, -- 開いている状態かどうか

    TIME_PER_Y = 1000, -- Y座標-1ごとにtime(ms)をどれだけ足すか

    minScrollY = 0,
    scrollY = 0,
    maxScrollY = 0,

    WINDOW_TIMER = 10010,
    TIMER_START = 10011,
    TIME_GAPS = {},
    START_TIME = 10000000,
    TEXTS = {
        { -- これが全要素持っているやつ
            HEADER = "基本",
            item = {
                {
                    TEXT = "プレイにあたって",
                    timerId = 0,
                    description = {
                        TEXT = "BMSは良識を持ってプレイしましょう. 本家譜面及び曲の流用や, その他版権等違法性のあるBMSはプレイしないようにしましょう. BMSは, 各プレイヤーや製作者の良識をもって存続しています.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "鍵",
                    timerId = 0,
                    description = {
                        TEXT = "専用コントローラにおいて, 左のボタンから順番に1鍵, 2鍵...7鍵となります. そのため白色はそれぞれ左から1357鍵, 青色は246鍵となります.\nキーボードでは, 初期設定の場合, 1鍵から順にzsxdcfvが対応しています.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "皿",
                    timerId = 0,
                    description = {
                        TEXT = "専用コントローラにおいて, 左端または右端に配置されている円盤(ターンテーブル)のことです. 他項目では, 便宜上「皿」と表現します.",
                        timerId = 0,
                    },
                },
            },
            timerId = 0,
            time = 0,
            y = 0, -- 1項目目の初期座標に対する, すべての項目が閉じているときの相対座標
            nowY = 0, -- 各項目の最新座標
            isOpen = false,
            openAnimationTime = 0
        },
        {
            HEADER = "選曲",
            item = {
                {
                    TEXT = "プレイ開始",
                    timerId = 0,
                    description = {
                        TEXT = "1鍵, エンターキー, 方向キー右, 決定ボタンのいずれかでプレイを開始することができます.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "プラクティス",
                    description = {
                        TEXT = "3鍵を押すと, プラクティスモードでプレイできます.\nプラクティスでは, 開始, 終了位置の変更や, 各種オプション, TOTAL値等を設定しながら練習することが可能です.",
                    },
                },
                {
                    TEXT = "オートプレイ",
                    description = {
                        TEXT = "5鍵を押すか, AUTOボタンでオートプレイを鑑賞できます.",
                    },
                },
                {
                    TEXT = "リプレイ",
                    description = {
                        TEXT = "6鍵で再生するリプレイを変更でき, 7鍵で再生できます. 各リプレイの保存条件はbeatoraja起動時のプレイオプションタブから設定可能です.",
                    },
                },
                {
                    TEXT = "曲リスト移動",
                    description = {
                        TEXT = "皿を回転させる, またはキーボードの矢印キーの上下で曲リストを上下移動できます."
                    }
                },
                {
                    TEXT = "フォルダ, テーブル選択",
                    description = {
                        TEXT = "1鍵, エンターキー, 方向キー右, 決定ボタンのいずれかでフォルダ及びテーブル内に移動できます. 2,4鍵, 右クリック(アクティブな曲バー上), 方向キー左で親フォルダに戻ることができます."
                    }
                },
                {
                    TEXT = "ランダムセレクト",
                    description = {
                        TEXT = "ランダムセレクトを選択すると, そのフォルダ内にある全ての譜面からランダムに1つが選択され, プレイが開始します."
                    }
                },
                {
                    TEXT = "同楽曲の譜面表示",
                    description = {
                        TEXT = "数字キーの8を押すと, 同じ楽曲の譜面一覧を表示できます."
                    }
                },
            },
        },
        {
            HEADER = "各画面共通の操作",
            item = {
                {
                    TEXT = "フレームレート表示",
                    description = {
                        TEXT = "F1を押すと, フレームレートを表示できます."
                    }
                },
                {
                    TEXT = "スクリーンショット",
                    description = {
                        TEXT = "F6を押すと, スクリーンショットを保存できます. スクリーンショットはbeatoraja内のscreenshotディレクトリに保存されます."
                    }
                },
            }
        },
        {
            HEADER = "その他の選曲画面の設定や操作",
            item = {
                {
                    TEXT = "鍵盤数フィルター",
                    description = {
                        TEXT = "数字キーの1を押すと, 5鍵, 7鍵等の鍵盤数で絞り込むことができます."
                    }
                },
                {
                    TEXT = "ソート",
                    description = {
                        TEXT = "数字キーの2を押すと, 楽曲の並び順を変更できます. また, ルートディレクトリで2,4鍵, 右クリック(アクティブな曲バー上), 方向キー左でも変更できます."
                    }
                },
                {
                    TEXT = "LN種類切り替え",
                    description = {
                        TEXT = "数字キーの3を押すと, LN, CN, HCNを切り替えることができます."
                    }
                },
                {
                    TEXT = "ライバル変更",
                    description = {
                        TEXT = "数字キーの7を押すと, ライバルを切り替えることができます. ライバル未選択状態にも変更可能です."
                    }
                },
                {
                    TEXT = "リロード",
                    description = {
                        TEXT = "F2を押すと, 楽曲リストのリロードを実行できます."
                    }
                },
                {
                    TEXT = "フォルダ検索",
                    description = {
                        TEXT = "F3を押すと, 選択中の曲が入っているフォルダをエクスプローラで開きます."
                    }
                },
                {
                    TEXT = "お気に入り",
                    description = {
                        TEXT = "F8キーを押すと, その楽曲の全譜面をお気に入りに追加します. F9キーの場合, 譜面単体をお気に入りに追加します."
                    }
                },
                {
                    TEXT = "IR表示",
                    description = {
                        TEXT = "F11キーを押すと, 該当のIRページをブラウザで開きます."
                    }
                },
                {
                    TEXT = "スキンセレクト",
                    description = {
                        TEXT = "F12を押すと, スキンセレクト画面に入ります."
                    }
                },
                {
                    TEXT = "キーコンフィグ",
                    description = {
                        TEXT = "数字キーの6を押すと, キーコンフィグ画面に入ります.\nキーコンフィグでは, 変更したい項目に矢印キーで移動し, エンターキー押した後, 設定したいキーを押すことで設定できます. 数字キー, Fnキー等, 一部beatorajaのシステムで利用されているキーは設定できません."
                    }
                },
            }
        },
        {
            HEADER = "プレイコンフィグ",
            item = {
                {
                    TEXT = "設定方法",
                    description = {
                        TEXT = "STARTボタンを押している間, 対応する鍵盤を入力すると変更できます. 対応する鍵盤は, オプション内の各項目名の左に記載しています. キーボードの場合, 初期設定はQキーです."
                    }
                },
                {
                    TEXT = "譜面オプション",
                    description = {
                        TEXT = "MIRROR: 鍵盤部分の左右が逆転します.\nRANDOM: 鍵盤部分がレーン毎にランダムで入れ替わります.\nR-RANDOM: 鍵盤部分のレーンがランダムにローテーションします. 1234567->5671234のように順番に移動したもの, またはそれのMIRRORになります.\nS-RANDOM: 鍵盤部分がノート毎にランダムで配置されます.\nSPIRAL: \nH-RANDOM: 縦連が発生しないS-RANDOMです.\nALL-SCR: ノートがある部分すべてが皿に配置されます. 同時押しの場合, ランダムな1つが選ばれます.\nRANDOM-EX(RANDOM+): 皿も入れ替わるRANDOMです.\nS-RANDOM-EX(S-RANDOM+): 皿も入れ替わるS-RANDOMです."
                    }
                },
                {
                    TEXT = "ゲージの種類",
                    description = {
                        TEXT = "EASY: NORMALより減りにくいゲージです. 80%を超えた状態で曲を終えるとクリアです.\nGROOVE(NORMAL): 普通のゲージです. 80%を超えた状態で曲を終えるとクリアです.\nHARD: ゲージが0になると強制終了します. 完奏できればクリアです.\nEX-HARD: HARDより少し増えにくく, 大きく減りやすいゲージです.\nHAZARD: コンボが切れた時点で失敗になります. \nASSISTED EASY: EASYより減りにくいゲージです. 60%を超えた状態で曲を終えるとクリアです."
                    }
                },
                {
                    TEXT = "ハイスピードの固定",
                    description = {
                        TEXT = "START BPM: スクロール速度が曲開始時点のもので統一されます.\nMAX BPM: スクロール速度がその曲の最高BPMで統一されます.\nMAIN BPM: スクロール速度がその曲の主なBPMで統一されます.\nMIN BPM: スクロール速度がその曲の最小BPMで統一されます."
                    }
                },
                {
                    TEXT = "ターゲット設定",
                    description = {
                        TEXT = "プレイコンフィグを開いている状態で皿を回すと, 目標とするスコアを設定できます. 本スキンでは, スキンコンフィグでターゲットオプションの表示をONにしている場合のみ表示されます."
                    }
                },
            }
        },
        {
            HEADER = "アシストオプション",
            item = {
                {
                    TEXT = "設定方法",
                    description = {
                        TEXT = "SELECTボタンを押している間, 対応する鍵盤を入力すると変更できます. 対応する鍵盤は, オプション内の各項目名の左に記載しています. キーボードの場合, 初期設定はWキーです.\nこれらのオプションを1つでも有効にした状態でクリアすると, ASSIST EASY CLEAR扱いになります. (ASSISTED EASYゲージより下の扱いです.)\n各項目については, オプション画面を開いて確認してください."
                    }
                },
            },
        },
        {
            HEADER = "その他オプション",
            item = {
                {
                    TEXT = "設定方法",
                    description = {
                        TEXT = "START+SELECTボタンを押している間, 対応する鍵盤を入力すると変更できます. 対応する鍵盤は, オプション内の各項目名の左に記載しています. キーボードの場合, 初期設定はQ+Wキーです."
                    }
                },
                {
                    TEXT = "ゲージオートシフト",
                    description = {
                        TEXT = "CONTINUE: ハードゲージ以上の場合, 0%になっても曲を続行できます. 0%になっている場合はFAILED扱いです.\nHARD TO GROOVE: ハードゲージ以上で0%になった場合, NORMALゲージに移行します.\nBEST CLEAR: その時点でクリア状態にあるゲージの中で最も良いゲージが選択されます.\nSELECT TO UNDER: 選択したゲージより下のゲージで, クリア状態になる中で最も良いゲージが選択されます."
                    }
                },
                {
                    TEXT = "BGA表示",
                    description = {
                        TEXT = "AUTOを選択すると, オートプレイでのみBGAが表示されるようになります."
                    }
                },
            },
        },
        {
            HEADER = "プレイ",
            item = {
                {
                    TEXT = "EXSCORE",
                    description = {
                        TEXT = "BMSにおいて, 一般的に使用されるスコアです. PERFECT*2+GREATがスコアになります."
                    }
                },
                {
                    TEXT = "空プア",
                    description = {
                        TEXT = "各レーンにおいて, ノーツがある程度近くにある状態で押すと, ノートが消えずにPOOR判定が発生しゲージが少し減少します. 空プアではコンボは途切れません."
                    }
                },
                {
                    TEXT = "ロングノート(LN)",
                    description = {
                        TEXT = "長押しをすることで成功になります. CN, HCNの場合は終点をタイミングよく離す必要があります"
                    }
                },
                {
                    TEXT = "ハイスピード(スクロール速度)",
                    description = {
                        TEXT = "STARTを押しながら青鍵を押すとスクロール速度が早くなり, 白鍵を押すと遅くなります. 速度変更の間隔は, beatoraja起動時のプレイオプションタブから変更できます.\nまた, SELECTキーを押しながら皿を回すと細かく調整できます."
                    },
                },
                {
                    TEXT = "レーンカバー",
                    description = {
                        TEXT = "STARTボタンを押しながら皿を回すことで, 譜面部分の上を隠すことができます. 常用する場合は, beatoraja起動時のプレイコンフィグタブで, レーンカバーにチェックを入れましょう."
                    },
                },
                {
                    TEXT = "リフト",
                    description = {
                        TEXT = "判定位置を上にずらすことができます. beatoraja起動時のプレイコンフィグタブで設定できます."
                    },
                },
                {
                    TEXT = "プレイの中断",
                    description = {
                        TEXT = "START+SELECTキー, またはESCキーでプレイを中断することができます. この場合, 譜面が終了している場合を除きFAILEDとなります."
                    },
                },
            }
        },
        {
            HEADER = "リザルト操作",
            item = {
                {
                    TEXT = "選曲画面に戻る",
                    description = {
                        TEXT = "1または3鍵で選曲画面に戻ることができます."
                    }
                },
                {
                    TEXT = "再プレイ",
                    description = {
                        TEXT = "5鍵長押しで, ランダム等の配置を維持せずに再プレイできます.\n7鍵長押しで, ランダム等の配置を維持して再プレイできます."
                    }
                },
                {
                    TEXT = "他の種類のゲージの結果を見る",
                    description = {
                        TEXT = "6鍵で, 別の種類のゲージの推移を見ることができます.\nより上位のゲージでクリアできていたか, 下位のゲージならクリアできていたかを確認してクリアランプの更新を目指しやすくなります."
                    }
                },
            }
        },
        {
            HEADER = "本スキン独自仕様",
            item = {
                {
                    TEXT = "プレイヤーランク",
                    description = {
                        TEXT = "本スキンでは, プレイを重ねて経験値を貯めるとランクが上昇します(リザルトスキン併用時のみ). ランクと同時に実力も上げていきましょう!"
                    },
                },
                {
                    TEXT = "スタミナ",
                    description = {
                        TEXT = "譜面をプレイをするとスタミナを消費します. スタミナが不足している場合, 経験値を入手することができません."
                    },
                },
            },
        },
        {
            HEADER = "その他",
            item = {
                {
                    TEXT = "バージョン",
                    description = {
                        TEXT = "選曲スキン: " .. string.format( "%2.3f", SKIN_INFO.SELECT_VRESION) .. "\nリザルトスキン: " .. string.format("%.2f", SKIN_INFO.RESULT_VERSION) .. "\n決定スキン: " .. string.format("%.2f", SKIN_INFO.DECIDE_VERSION)
                    },
                },
                {
                    TEXT = "著作権",
                    description = {
                        TEXT = "本スキンの改変や再配布は, 申告無しで自由に行って良いですが, https://tori-blog.net/bms/1392/ へのリンクをお願いします.\n本スキンでは, 一部フリー素材を利用しています. 各フリー素材に関しては, その配布元に従ってください."
                    },
                },
                {
                    TEXT = "クレジット",
                    description = {
                        TEXT = "背景画像: 花のイラストなら「百花繚乱」 – 無料で使えるフリー素材\nフォント: Source Han Sans, 小塚ゴシック\n一部アイコン: ICOOON MONO\n一部効果音: 無料効果音で遊ぼう！, 魔王魂"
                    },
                },
            }
        }
    },

    detail = {
        timerId = 0,
        descriptionTimerId = 0,
        HEADER = {
            X = 118,
            Y = 768,
            W = 1450,
            EDGE_W = 16, -- OPTION_INFO.HEADER2_EDGE_BG_W
            H = 42, -- OPTION_INFO.HEADER2_EDGE_BG_H
            TEXT = {
                X = 30,
                Y = 6,
                SIZE = 24,
            },
        },
        BODY = {
            X = 0, -- headerに対する相対座標
            Y = -45,
            W = 1450,
            SIZE = 20,
        },
        BUTTON = {
            X = 46, -- WNDに対する相対座標
            Y = 758,
            W = 62,
            H = 62,
        },
    },

    isOpenDescription = false,
    maxTimerId = 0,

    functions = {},
}

local operationState = {
    isClicking = false,
    isScrollStop = false,
    clickTime = 0,
    dy = 0,
    numAbsMove = 0,
    totalY = 0
}

local function getIsInRect(x, y, tx, ty, w, h)
    return tx <= x and x <= tx + w and ty <= y and y <= ty + h
end

function itemListOperation()
    if isLeftClicking() == true then
        myPrint("ヘルプ操作領域クリック")
        operationState.isClicking = true
    elseif isRightClicking() == true then
        if help.isOpenDescription then
            help.functions.closeDetail()
        else
            closeHelpList()
        end
    end
end

-- yは操作領域最上部項目の座標からの相対座標
local function yToTime(y)
    return help.START_TIME + y * help.TIME_PER_Y
end

-- @return number, number HEADERのインデックス, 項目のインデックス (非選択なら0)
help.functions.selectItem = function()
    local x, y = getMousePos()
    -- 操作領域右上になるようになおす
    x = x - (help.WND.X + help.ITEM.AREA.X)
    y = HEIGHT - y - (help.WND.Y + help.ITEM.AREA.START_Y)
    myPrint(x, y)

    for i, item in pairs(help.TEXTS) do
        if item.timerId ~= nil and item.timerId >= 10000 then
            -- ヘッダー部分
            local hy = item.nowY

            local isSelect = getIsInRect(x, y, 0, hy, help.ITEM.BG.HEADER.W, help.ITEM.BG.HEADER.H)
            if isSelect then
                return i, 0
            end

            for j, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 and item.isOpen and item.openAnimationTime >= help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME then
                    local iy = hy - help.ITEM.BG.ITEM.INTERVAL * j
                    isSelect = getIsInRect(x, y, 0, iy, help.ITEM.BG.ITEM.W, help.ITEM.BG.ITEM.H)
                    if isSelect then
                        return i, j
                    end
                end
            end
        end
    end

    return 0, 0
end

help.functions.updateOperationArea = function()
    if operationState.isClicking then
        if isLeftClicking() == false then
            operationState.isClicking = false
            if operationState.numAbsMove <= 20 then
                -- メニューを選択する(あれば)
                local h, i = help.functions.selectItem()
                myPrint("選択情報", "header: " .. h, "item: " .. i)

                -- openする
                if h > 0 and i == 0 then
                    help.TEXTS[h].isOpen = not help.TEXTS[h].isOpen
                elseif h > 0 and i > 0 then
                    -- 小項目をクリックしたら詳細表示
                    myPrint("詳細表示: " .. help.TEXTS[h].item[i].TEXT, "timer: " .. help.TEXTS[h].item[i].description.timerId)
                    help.functions.openDetail(help.TEXTS[h].item[i].description.timerId)
                end
            end

            operationState.numAbsMove = 0
        else
            operationState.dy = getDeltaY()
            operationState.numAbsMove = operationState.numAbsMove + math.abs(operationState.dy + getDeltaX())
            -- スクロールする高さがなければ終わり
            if operationState.totalY <= help.ITEM.AREA.H then
                operationState.dy = 0
                return
            end
            help.scrollY = help.scrollY + operationState.dy
        end
    end
    help.scrollY = math.min(math.max(math.min(help.ITEM.AREA.H - operationState.totalY, 0), help.scrollY), 0)
end

-- yは1項目目に対する相対座標
local upperY = help.WND.Y + help.ITEM.AREA.Y + help.ITEM.AREA.H
local bottomY = help.WND.Y + help.ITEM.AREA.Y
local function examineOutOfArea(y, h)
    y = y + help.WND.Y + help.ITEM.AREA.START_Y
    -- 上側に出ている
    if upperY <= y then return true end
    -- 下側に出ている
    if y + h <= bottomY then return true end
    return false
end

local function helpMainLogic()
    help.functions.updateOperationArea()

    local now = main_state.time()
    local sumOpenMenuGap = 0
    local time = 0
    local maxGap = 0
    local item = nil
    local item2 = nil

    for i = 1, #help.TEXTS do
        item = help.TEXTS[i]
        if item.timerId ~= nil and item.timerId >= 10000 then
            -- ヘッダー部分
            -- 現在のy座標に対応するtimeを求める 間違いなく震えるので少し動かす
            item.nowY = item.y + 0.25 - help.scrollY - sumOpenMenuGap
            time = yToTime(item.nowY) * 1000

            if examineOutOfArea(item.nowY, help.ITEM.BG.HEADER.H) then
                -- 外に出ていたら表示しない
                main_state.set_timer(item.timerId, main_state.timer_off_value)
            else
                main_state.set_timer(item.timerId, now - time)
            end

            -- 開くアニメーションの時間更新
            if item.isOpen then
                item.openAnimationTime = item.openAnimationTime + getDeltaTime()
            else
                item.openAnimationTime = item.openAnimationTime - getDeltaTime()
            end

            -- minmax重いらしいので変えるかも
            item.openAnimationTime = math.max(0, math.min(item.openAnimationTime, help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME))

            maxGap = 0
            for j = 1, #item.item do
                item2 = item.item[j]
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    local offset = -7
                    if item.openAnimationTime  ~= 0 then
                        offset = j * help.ITEM.BG.ITEM.INTERVAL * item.openAnimationTime / help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME
                    end

                    maxGap = math.max(maxGap, offset)

                    -- 各項目部分
                    local iy = item.y + 0.25 - help.scrollY - offset - sumOpenMenuGap
                    time = yToTime(iy) * 1000

                    if examineOutOfArea(iy, help.ITEM.BG.ITEM.H) then
                        -- 外に出ていたら表示しない
                        main_state.set_timer(item2.timerId, main_state.timer_off_value)
                    else
                        main_state.set_timer(item2.timerId, now - time)
                    end

                end
            end

            -- 小項目の最も下の位置のずれだけ次の大項目をずらす
            sumOpenMenuGap = sumOpenMenuGap + maxGap
        end
    end
    operationState.totalY = sumOpenMenuGap + #help.TEXTS * help.ITEM.BG.HEADER.INTERVAL
end

function helpTimer()
    if help.hasAllClosed and help.didProcessAllClose == false then
        help.functions.allClose()
        help.didProcessAllClose = true
    elseif help.isOpening then
        -- 開ききったらstateを変える
        if main_state.time() - main_state.timer(help.WINDOW_TIMER) >= (help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY)*1000 then
            -- myPrint("開ききった: " .. main_state.time() - main_state.timer(help.WINDOW_TIMER))
            help.isOpening = false
            help.hasOpened = true
        end
    elseif help.isClosing then
        help.closeTime = help.closeTime - getDeltaTime()
        help.functions.setAllTimerWithoutDescription(getElapsedTime() - help.closeTime)
        help.functions.setTimeDescription(getElapsedTime())
        -- 閉じきったら後処理
        if help.closeTime <= 0 then
            myPrint("閉じきった: " .. main_state.time() - main_state.timer(help.WINDOW_TIMER))
            help.functions.allClose()
            help.isClosing = false
        end
    elseif help.hasOpened then -- ここがメインロジック
        pcall(helpMainLogic)
    end
end


function openHelpList()
    if help.isOpening == false and help.hasOpened == false then
        -- myPrint("ヘルプを開く")
        help.isOpening = true
        help.hasOpened = false
        help.didProcessAllClose = false
        help.hasAllClosed = false
        main_state.set_timer(help.WINDOW_TIMER, main_state.time())
    end
end

function closeHelpList()
    if help.isClosing == false and help.hasAllClosed == false and help.hasOpened == true then
        -- myPrint("ヘルプを閉じる")
        help.isOpening = false
        help.hasOpened = false
        help.isClosing = true
        help.closeTime = help.ANIMATION_TIME * 1000
    end
end

help.functions.openDetail = function(descriptionTimerId)
    if help.isOpenDescription == false then
        main_state.set_timer(help.detail.timerId, 0)
        main_state.set_timer(descriptionTimerId, 0)
        help.detail.descriptionTimerId = descriptionTimerId
        help.isOpenDescription = true
    end
end

help.functions.closeDescription = function()
    myPrint("詳細閉じる")
    help.functions.setTimeDescription(main_state.timer_off_value)
    help.isOpenDescription = false
    help.detail.descriptionTimerId = 0
end

help.functions.setTimeDescription = function(time)
    if help.detail.descriptionTimerId ~= nil and help.detail.timerId ~= nil and help.detail.descriptionTimerId > 10000 then
        main_state.set_timer(help.detail.timerId, time)
        main_state.set_timer(help.detail.descriptionTimerId, time)
    end
end

function closeDescriptionRightClickEvent()
    if isRightClicking() == true then
        help.functions.closeDescription()
    end
end

function closeDescriptionClickEvent()
    help.functions.closeDescription()
end

-- description以外
help.functions.setAllTimerWithoutDescription = function(time)
    main_state.set_timer(help.WINDOW_TIMER, time)
    for _, item in pairs(help.TEXTS) do
        if item.timerId ~= nil and item.timerId >= 10000 then
            main_state.set_timer(item.timerId, time)
            for _, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    main_state.set_timer(item2.timerId, time)
                end
            end
        end
    end
end

help.functions.allClose = function()
    help.functions.closeDescription()
    help.functions.setAllTimerWithoutDescription(main_state.timer_off_value)
end

help.functions.activateAllTimer = function()
    help.functions.setAllTimerWithoutDescription(main_state.time())
end

-- カスタムタイマ, カスタムアクション, textの後に配置すること
help.functions.loadHelpItem = function(skin)
    loadPopupWindowSelect(skin)

    -- ボタン
    table.insert(skin.customEvents, {id = 1000, action = "openHelpList()"})
    table.insert(skin.customEvents, {id = 1001, action = "closeHelpList()"})
    table.insert(skin.customEvents, {id = 1002, action = "itemListOperation()"})
    table.insert(skin.customEvents, {id = 1003, action = "closeDescriptionRightClickEvent()"})
    table.insert(skin.customEvents, {id = 1004, action = "closeDescriptionClickEvent()"})

    table.insert(skin.image, {
        id = "helpOpenButton", src = 0, x = 1415, y = commons.PARTS_OFFSET + 771, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = 1000
    })
    loadCloseButtonSelect(skin, "helpCloseButton", 1001)

    -- 背景は閉じるボタン
    table.insert(skin.image, {
        id = "blackHelpClose", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1001
    })

    -- メニュー開閉移動用のダミー
    table.insert(skin.image, {
        id = "blankHelpOperation", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1002
    })

    -- 各項目の背景
    table.insert(skin.image, {
        id = "whiteListItem", src = 999, x = 2, y = 0, w = 1, h = 1
    })

    -- 項目を隠したり, action発生を妨害したり
    table.insert(skin.image, {
        id = "whiteMask", src = 999, x = 2, y = 0, w = 1, h = 1, act = 0
    })

    table.insert(skin.image, {
        id = "whiteDetailBg", src = 999, x = 2, y = 0, w = 1, h = 1, act = 1003
    })

    -- 詳細の戻るボタン
    table.insert(skin.image, {
        id = "closeDescriptionButton", src = 0, x = 1699, y = commons.PARTS_OFFSET + 771, w = help.detail.BUTTON.W, h = help.detail.BUTTON.H, act = 1004
    })

    -- 各ヘッダー項目
    table.insert(skin.image, {
        id = "helpHeaderBgLeft", src = 2, x = 1591, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = help.ITEM.BG.HEADER.EDGE_W, h = help.ITEM.BG.HEADER.H
    })
    table.insert(skin.image, {
        id = "helpHeaderBgCenter", src = 2, x = 1591 + help.ITEM.BG.HEADER.EDGE_W, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = 1, h = help.ITEM.BG.HEADER.H
    })
    table.insert(skin.image, {
        id = "helpHeaderBgRight", src = 2, x = 1591 + help.ITEM.BG.HEADER.EDGE_W + 1, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = help.ITEM.BG.HEADER.EDGE_W, h = help.ITEM.BG.HEADER.H
    })

    -- 各テキスト
    for _, item in pairs(help.TEXTS) do
        -- header
        table.insert(skin.text, {
            id = item.HEADER, font = 0, size = 24, overflow = 1, constantText = item.HEADER
        })
        -- 各項目
        for j, item2 in pairs(item.item) do
            -- 各項目文字
            table.insert(skin.text, {
                id = item2.TEXT, font = 0, size = 20, overflow = 1, constantText = item2.TEXT
            })
            table.insert(skin.text, {
                id = item2.TEXT .. "Detail" .. j, font = 0, size = help.detail.HEADER.TEXT.SIZE, overflow = 1, constantText = item2.TEXT
            })
            -- 詳細テキスト 1.5倍はアンチエイリアス
            table.insert(skin.text, {
                id = item2.description.TEXT .. j, font = 0, size = help.detail.BODY.SIZE*1.5, wrapping = true, constantText = item2.description.TEXT
            })
        end
    end
end

help.functions.destinationOpenButton = function(skin)
    table.insert(skin.destination, {
        id = "helpOpenButton", dst = {
            {x = 1768, y = 0, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H}
        }
    })
end

help.functions.setWindowDestination = function(skin)
    -- 背景
    table.insert(skin.destination, {
        id = "blackHelpClose", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
            {time = help.ANIMATION_TIME, a = 64},
        }
    })

    local initial = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}

    local dst = {
        initial,
        {time = help.ANIMATION_TIME, x = help.WND.X, y = help.WND.Y, w = help.WND.W, h = help.WND.H},
    }
    destinationWindowWithTimer(skin, POPUP_WINDOW_SELECT.ID, POPUP_WINDOW_SELECT.EDGE_SIZE, POPUP_WINDOW_SELECT.SHADOW_LEN, {}, help.WINDOW_TIMER, help.ANIMATION_TIME, dst)

    -- 操作用オブジェクト出力
    table.insert(skin.destination, {
        id = "blankHelpOperation", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0, a = 0},
            {time = help.ANIMATION_TIME - 1},
            {time = help.ANIMATION_TIME, x = help.WND.X + help.ITEM.AREA.X, y = help.WND.Y + help.ITEM.AREA.Y, w = help.ITEM.AREA.W, h = help.ITEM.AREA.H}
        }
    })
end

-- 項目の上に乗せる出力
help.functions.setWindowDestination2 = function(skin)
    local initial = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}

    -- 上部マスク
    table.insert(skin.destination, {
        id = "whiteMask", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.MASK.X, y = help.WND.Y + help.ITEM.AREA.Y + help.ITEM.AREA.H, w = help.MASK.W, h = help.MASK.UPPER_H}
        }
    })
    -- 下部マスク
    table.insert(skin.destination, {
        id = "whiteMask", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.MASK.X, y = help.WND.Y, w = help.MASK.W, h = help.MASK.UPPER_H}
        }
    })


    -- closeボタン
    table.insert(skin.destination, {
        id = "helpCloseButton", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.BUTTON.X, y = help.WND.Y + help.BUTTON.Y, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H}
        }
    })

    dstHeaderSelect(skin, {}, help.WINDOW_TIMER, help.ANIMATION_TIME, "helpText")
end

help.functions.setListDestination = function(skin)
    local timer = help.TIMER_START
    local viewTime = help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY

    for i, item in pairs(help.TEXTS) do
        -- 各項目の出力
        for j, item2 in pairs(item.item) do
            -- 各項目用にtimer移動
            timer = timer + 1
            -- 背景
            table.insert(skin.destination, {
                id = "whiteListItem", timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = 75, g = 75, b = 75, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = help.WND.X + help.ITEM.BG.ITEM.X, y = help.WND.Y + help.ITEM.AREA.START_Y, w = help.ITEM.BG.ITEM.W, h = help.ITEM.BG.ITEM.H, a = 255},

                    -- 動く部分
                    {time = yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000},
                    {time = yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000},
                    {time = 99999999},
                }
            })
            -- 文字
            table.insert(skin.destination, {
                id = item2.TEXT, timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = help.WND.X + help.ITEM.TEXT.X, y = help.WND.Y + help.ITEM.AREA.START_Y, w = help.ITEM.BG.ITEM.W, h = help.ITEM.TEXT.ITEM_H, a = 255},

                    -- 動く部分
                    {time = yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000 + 6},
                    {time = yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000 + 6},
                    {time = 99999999},
                }
            })
            item2.timerId = timer
        end

        timer = timer + 1

        -- headerの出力
        item.timerId = timer
        local bgIds = {"helpHeaderBgLeft", "helpHeaderBgCenter", "helpHeaderBgRight", item.HEADER}
        local allX = {
            help.WND.X + help.ITEM.BG.HEADER.X,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.TEXT.X,
        }
        local offsetY = {0, 0, 0, help.ITEM.TEXT.Y}
        local allW = {help.ITEM.BG.HEADER.EDGE_W, help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W * 2, help.ITEM.BG.HEADER.EDGE_W, 9999}
        local allH = {help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.TEXT.HEADER_H}
        for j, id in pairs(bgIds) do
            local b = 255
            if bgIds[j] == item.HEADER then
                b = 0
            end
            table.insert(skin.destination, {
                id = id, timer = item.timerId, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = b, g = b, b = b, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = allX[j], y = help.WND.Y + help.ITEM.AREA.START_Y, w = allW[j], h = allH[j], a = 255},

                    -- 動く部分
                    {time = yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000 + offsetY[j]},
                    {time = yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000 + offsetY[j]},
                    {time = 99999999},
                }
            })
        end

        -- この項目にどれだけyがずれているかの初期値を設定する
        item.y = -(i - 1) * help.ITEM.BG.HEADER.INTERVAL
        item.nowY = item.y

        item.isOpen = false
        item.openAnimationTime = 0
    end

    help.maxTimerId = timer
end

help.functions.setDestinationDescription = function(skin)
    local viewTime = help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY
    local timer = help.maxTimerId
    -- 詳細項目の出力
    -- 項目背景(オプションのを使いまわし)
    do
        timer = timer + 1
        myPrint("descriptionヘッダータイマ: " .. timer)
        help.detail.timerId = timer
        local init = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1}
        local headerX = help.WND.X + help.detail.HEADER.X
        local headerY = help.WND.Y + help.detail.HEADER.Y
        table.insert(skin.destination, {
            id = "whiteDetailBg", timer = timer, loop = viewTime, dst = {
                init,
                {time = viewTime, x = help.WND.X + help.ITEM.AREA.X, y = help.WND.Y + help.ITEM.AREA.Y, w = help.ITEM.AREA.W, h = help.ITEM.AREA.H, a = 255}
            }
        })

        -- 詳細の暗い背景ヘッダー背景
        dstSubHeaderSelect(skin, headerX, headerY, help.detail.HEADER.W, {}, timer, viewTime, nil)
        
        -- ボタン出力
        table.insert(skin.destination, {
            id = "closeDescriptionButton", timer = timer, loop = viewTime, dst = {
                init,
                {time = viewTime, x = help.WND.X + help.detail.BUTTON.X, y = help.WND.Y + help.detail.BUTTON.Y, w = help.detail.BUTTON.W, h = help.detail.BUTTON.H, a = 255},
            }
        })

        for _, item in pairs(help.TEXTS) do
            -- 各項目の出力
            for j, item2 in pairs(item.item) do
                timer = timer + 1
                table.insert(skin.destination, {
                    id = item2.TEXT .. "Detail" .. j, timer = timer, loop = viewTime, dst = {
                        -- 開幕の登場する部分
                        {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
                        {time = viewTime, x = headerX + help.detail.HEADER.TEXT.X, y = headerY + help.detail.HEADER.TEXT.Y, w = 9999, h = help.detail.HEADER.TEXT.SIZE, a = 255},
                    }
                })
                table.insert(skin.destination, {
                    id = item2.description.TEXT .. j, timer = timer, loop = viewTime, filter = 1, dst = {
                        -- 開幕の登場する部分
                        {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
                        {time = viewTime, x = headerX + help.detail.BODY.X, y = headerY + help.detail.BODY.Y, w = help.detail.BODY.W, h = help.detail.BODY.SIZE, r = 0, g = 0, b = 0, a = 255},
                    }
                })
                item2.description.timerId = timer
            end
        end
    end
end

return help.functions
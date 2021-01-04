require("modules.commons.http")
local timer_util = require("timer_util")
local main_state = require("main_state")
require("modules.select.commons")

-- キャッシュファイル読み込みエラー対策でpcallできるようにする
local function cacheRequire()
    if isUseMusicDb() then
        require("cache.music_data")
    end
end

local MUSIC_DETAIL = {
    GET_WAIT_TIME = 1000,
    CACHE_PATH = "cache/music_data.lua",
    VAR_NAME = "MUSIC_DATA_CACHE",
}

local musicDetail = {
    getMusicDataObj = nil,
    musicData = nil,
    tablesString = "",
    wasDrawed = false,
    lastGetDataTitle = "",
    event = {
        name = "",
        url = "",
        musicList = "",
    },
    musicLink = "",
    functions = {}
}

musicDetail.functions.getHttpTimer = function ()
    return 10700
end

musicDetail.functions.clearViewData = function ()
    musicDetail.musicData = nil
    musicDetail.getMusicDataObj = nil
    musicDetail.tablesString = ""
    musicDetail.wasDrawed = false
    musicDetail.lastGetDataTitle = ""
    musicDetail.musicLink = ""
    musicDetail.event = {
        name = "",
        url = "",
        musicList = "",
    }
end

local EVENT_LIST = {
    YARUKI0 = {
        A1_5th = {name = "A-1 ClimaX 5th -いちぬけた！-", url = "http://yaruki0.sakura.ne.jp/event/A1_5th/", musicList = ""},
        A1_6th = {name = "A-1 ClimaX 6th -To Air Graduation-", url = "http://a1climax6th.web.fc2.com", musicList = ""}
    },
    MUMEI0 = {name = "無名戦対抗戦", url = "https://event.yaruki0.net/mumeiVS/", musicList = "https://event.yaruki0.net/VSevent/"},
    KBMS = {
        {name = "PABAT! 2013 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=1", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=1"},
        {name = "PABAT! 2014 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=11", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=11"},
        {name = "PABAT! 2015 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=15", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=15"},
        {name = "PABAT! 2016 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=16", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=16"},
        {name = "PABAT! 2017 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=17", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=17"},
        {name = "PABAT! 2018 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=18", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=18"},
        {name = "PABAT! 2019 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=19", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=19"},
        {name = "PABAT! 2020 Seasons", url = "https://k-bms.com/party_pabat/party.jsp?board_num=20", musicList = "https://k-bms.com/party_pabat/party.jsp?board_num=20"},
    },
    MANBOW = {
        -- 適当に1~500まで配列埋めしてから初期化
    }
}

--[[
    楽曲のイベント情報を取得する
    @return array {name, url}
]]
musicDetail.functions.getEventData = function ()
    return musicDetail.event
end

musicDetail.functions.getMusicLink = function ()
    return musicDetail.musicLink
end

musicDetail.functions.initManbowEvent = function ()
    local m = EVENT_LIST.MANBOW
    for i = 1, 500 do
        m[i] = {
            name = "",
            url = "http://manbow.nothing.sh/event/event.cgi?action=List_def&event=" .. i,
            musicList = "http://manbow.nothing.sh/event/event.cgi?action=List_def&event=" .. i,
        }
    end
    m[1] = {name = "SUMMER BGA event", url = "http://nothing.sh/~manbow/dee_news/event_bga.html"}
    m[2] = {name = "NOIZE SPHERE - ノイズ系ジャンル限定BMSイベント - ", url = "http://www.sango.sakura.ne.jp/~grey/noize/index.html"}
    m[3] = {name = "Be Happy!", url = "http://nothing.sh/~manbow/event_03x.html"}
    m[4] = {name = "AUTUMN BGA PARTY", url = "http://isweb37.infoseek.co.jp/play/mpcm_kr/"}
    m[5] = {name = "Winter Ambience BMS Event", url = "http://www.scn-net.ne.jp/~pons58/"}
    m[6] = {name = "WINTER BGA PARTY(2nd season)", url = "http://isweb37.infoseek.co.jp/play/mpcm_kr/"}
    m[7] = {name = "5KB BMS Event [ごけび]", url = "http://www9.ocn.ne.jp/~we-love/"}
    m[8] = {name = "BGA PARTY -beatmania respect SP-", url = "http://isweb37.infoseek.co.jp/play/mpcm_kr/"}
    m[9] = {name = "第三回自称無名BMS作者が物申す！ ", url = "http://www1.kcn.ne.jp/~e-bird/"}
    m[10] = {name = "LiZvsOMT", url = "http://nothing.sh/~manbow/dee_news/lvo/"}
    m[11] = {name = "仮装BMS舞踏会 ～中の人は誰だ!!～", url = "http://spiral.cside.com/fdp/"}
    m[12] = {name = "Spring Phase", url = "http://nothing.sh/~manbow/dee_news/spphase/"}
    m[13] = {name = "BGA PARTY FINAL", url = "http://mpcm-kr.hp.infoseek.co.jp/"}
    m[14] = {name = "BGAparty ;revival featuring SpringPhase", url = "http://www.geocities.jp/retrofuture_ag/"}
    m[15] = {name = "nazobmplay 2weeks Score Attack", url = "http://nothing.sh/~manbow/dee_news/2weekir/"}
    m[16] = {name = "I respect you", url = "http://nothing.sh/~manbow/dee_news/2weekir/"}
    m[17] = {name = "BMS OF FIGHTERS 2004", url = "http://f34.aaacafe.ne.jp/~bofhall/"}
    m[18] = {name = "ウラ・キューキービーツ", url = "http://f34.aaacafe.ne.jp/~bofhall/"}
    m[19] = {name = "BGAparty ;revival autumn -the long time flight-", url = "http://www.geocities.jp/retrofuture_ag/"}
    m[20] = {name = "BGAparty ;revival ::RW05:: -Red vs White-", url = "http://f22.aaa.livedoor.jp/~arpd/bgaparty_v2/"}
    m[21] = {name = "第五回自称無名作家が物申す！", url = "http://mumei.nobody.jp/"}
    m[22] = {name = "BMS OF FIGHTERS 2005", url = "http://dee.manbow.org/event/page/bof2005/"}
    m[23] = {name = "BMS OF FIGHTERS 2005 前夜祭", url = "http://www.yamajet.com/"}
    m[24] = {name = "BMS OF FIGHTERS 2005 後夜祭", url = "http://www.ismusic.ne.jp/s-curve/bofafter/"}
    m[25] = {name = "BMS OF FOON 2005", url = "http://miku22.hp.infoseek.co.jp/bofoon2005.html"}
    m[26] = {name = "B-1 \"Unrestricted\"", url = "http://nekomimi.name/b-1/"}
    m[28] = {name = "第二回・仮装BMS舞踏会", url = "http://fdp2.bms.ms/"}
    m[29] = {name = "BGAparty ;revival ::RW06:: -Red vs White-", url = "http://members3.jcom.home.ne.jp/cyclia."}
    m[30] = {name = "東方音弾遊戯", url = "http://mumei.nobody.jp/toho/"}
    m[31] = {name = "ten:tax", url = "http://phantomscape.in/event/10tax/"}
    m[32] = {name = "BMS OF FOON 2006", url = "http://www.geocities.jp/rf_mirai/bms/event/02/bofoon2006.html"}
    m[33] = {name = "Be Happy! 2nd season", url = "http://www.yamajet.com/music/behappy2/"}
    m[34] = {name = "dark music BMS Event", url = "http://stnspr.hp.infoseek.co.jp/event.html"}
    m[35] = {name = "BOF III - THE BMS OF FIGHTERS 2006 - 前哨戦", url = "http://dee.manbow.org/event/page/bof2006/"}
    m[36] = {name = "BMS OF FIGHTERS 2006", url = "http://manbow.nothing.sh/event/page/bof2006/"}
    m[37] = {name = "BOF III - THE BMS OF FIGHTERS 2006 - 後夜祭", url = "http://www.planetoid.biz/bof2006ac/"}
    m[38] = {name = "BMS活性化運動 [SIDE A]", url = "http://a-p.cside.ne.jp/k/"}
    m[39] = {name = "BMS活性化運動 [SIDE B]", url = "http://a-p.cside.ne.jp/k/"}
    m[40] = {name = "第六回自称無名BMS作家が物申す！[ビジネスクラス]", url = "http://mumei.nobody.jp/"}
    m[41] = {name = "第六回自称無名BMS作家が物申す！[エコノミークラス]", url = "http://mumei.nobody.jp/"}
    m[42] = {name = "Chaotic Field", url = "http://www.yamajet.com/"}
    m[43] = {name = "Be Happy! 3rd season", url = "http://sky.geocities.jp/behappy3rd/"}
    m[44] = {name = "戦 [sen-goku] 國 ～夏の陣～", url = "http://sen-goku.info/"}
    m[45] = {name = "BMS OF FOON 2007", url = "http://www.geocities.jp/rf_mirai/bms/event/03/bofoon2007.html"}
    m[46] = {name = "戦国後夜祭", url = "http://www.h4.dion.ne.jp/~fity/sengokukouya.htm"}
    m[47] = {name = "東方音弾遊戯２", url = "http://tohotodan2.iza-yoi.net/"}
    m[48] = {name = "Wire Puller", url = "http://wirepuller.xxxxxxxx.jp/"}
    m[49] = {name = "BGA BATTLE", url = "http://www.planetoid.biz/bgabattle/page.html"}
    m[50] = {name = "MAXBEAT", url = "http://www4.pf-x.net/~scytheleg/tempyou/event/maxbeat/"}
    m[51] = {name = "Foot Pedal Party", url = "http://yukisite.com/johnny/fpp/index.html"}
    m[52] = {name = "A-1 ClimaX ", url = "http://www.qumarich.net/a-1/"}
    m[53] = {name = "24時間BMS ～愛はBMSを救う～", url = "http://a-p.cside.ne.jp/ap2/"}
    m[54] = {name = "THE BMS OF FIGHTERS 2008 - Resurrection -", url = "https://www.bmsoffighters.net/bof2008/index.html"}
    m[55] = {name = "THE BMS OF FIGHTERS 2008 後夜祭", url = "http://iimode-do.jp/event/bof2008a.html"}
    m[56] = {name = "BMS OF FOON 2008", url = "http://www.geocities.jp/rf_mirai/bms/event/04/bofoon2008.html"}
    m[57] = {name = "既存ジャンル禁止BMSイベント「experimentation」", url = "http://vfpq.890m.com/event/ex/"}
    m[58] = {name = "曲変更差分イベント 「Music Objective」", url = "http://soundwing.com/event/music_objective.html"}
    m[59] = {name = "BGA BATTLE 2", url = "http://www.planetoid.biz/bgabattle2/"}
    m[60] = {name = "THE BMS OF FIGHTERS 2009 - revolutionary battles -", url = "https://www.bmsoffighters.net/bof2009/index.html"}
    m[61] = {name = "EXTREMEBEAT", url = "http://scytheleg.bms.ms/tempyou/event/extremebeat/"}
    m[62] = {name = "ChaosStage", url = "http://scytheleg.bms.ms/tempyou/event/chaos/"}
    m[63] = {name = "第七回自称無名BMS作家が物申す！", url = "http://cerebralmuddystream.hp.infoseek.co.jp/mumei7/index.shtml"}
    m[64] = {name = "FIVE VS SEVEN", url = "http://scytheleg.bms.ms/tempyou/event/5vs7/"}
    m[65] = {name = "THE BMS OF FIGHTERS 2010 - The Evolution of War -", url = "https://www.bmsoffighters.net/bof2010/index.html"}
    m[66] = {name = "THE BMS OF FIGHTERS 2010 - 場外乱闘編 -", url = "https://www.bmsoffighters.net/bof2010/index.html"}
    m[67] = {name = "Wire Puller 2", url = "http://scytheleg.bms.ms/tempyou/event/wp2/"}
    m[68] = {name = "第一回 ”なんちゃって”無名BMS作家が物申す！", url = "http://www.luzeria.net/mumei_nantyatte.html"}
    m[69] = {name = "SPRING 9KEYS ROAD 2011", url = "http://www.yw-works.com/9keysroad/"}
    m[70] = {name = "みにけび！ - 32KB制限 BMSイベント -", url = "http://www.bmsoffighters.net/minikb/"}
    m[71] = {name = "第8回自称無名BMS作家が物申す！", url = "http://www.geocities.jp/mumeisen8/mumei.html"}
    m[72] = {name = "A-1 Climax 2nd ", url = "http://whirlwind.boy.jp/bms_event/"}
    m[73] = {name = "BOF2011 preliminary skirmish", url = "http://www.bmsoffighters.net/bof2011/rule_ps.html"}
    m[74] = {name = "THE BMS OF FIGHTERS 2011 - Intersection of conflict -", url = "https://www.bmsoffighters.net/bof2011/index.html"}
    m[75] = {name = "ULTRAEXTREMEBEAT", url = "http://scytheleg.bms.ms/tempyou/event/uxt/"}
    m[76] = {name = "低速BMS限定イベント『easymotion』", url = "http://phantomscape.in/event/easymotion/"}
    m[77] = {name = "BMS OF FOON 2012", url = "http://tbstk.main.jp/BOFoon/2012/"}
    m[78] = {name = "ノンジャンル", url = "http://suudooon.web.fc2.com/nongenre/index.html"}
    m[79] = {name = "第9回自称無名BMS作家が物申す！", url = "http://www.geocities.jp/mumeisen9/"}
    m[80] = {name = "SUMMER 9KEYS FESTIVAL 2012", url = "http://www.yw-works.com/9keys2012/"}
    m[81] = {name = "SUMMER 9KEYS FESTIVAL 2012 譜面エディット祭", url = "http://www.yw-works.com/9keys2012/edit.html"}
    m[82] = {name = "BOF2012 preliminary skirmish", url = "http://www.bmsoffighters.net/bof2012/ruleps.html"}
    m[83] = {name = "THE BMS OF FIGHTERS 2012 - Ein neuer Heiliger -", url = "https://www.bmsoffighters.net/bof2012/index.html"}
    m[84] = {name = "[COPY&ARRANGE ONLY BMS EVENT] Re:", url = "http://www.bmsoffighters.net/re/"}
    m[85] = {name = "ノンジャンル2 - Unlimited Fighters -", url = "http://elecplcb.web.fc2.com/nongenre2/"}
    m[86] = {name = "第10回自称無名BMS作家が物申す！", url = "http://mumei10.com/"}
    m[87] = {name = "BOF2013 preliminary skirmish", url = "http://www.bmsoffighters.net/bof2012/ruleps.html"}
    m[88] = {name = "konzertsaal - THE BMS OF FIGHTERS 2013 -", url = "https://www.bmsoffighters.net/bof2013/index.html"}
    m[89] = {name = "AUTUMN 9KEYS STORY 2013", url = "http://www.yw-works.com/9keys2013/"}
    m[90] = {name = "RETRO BMS EVENT", url = "http://bmsoffighters.net/retrobms/"}
    m[91] = {name = "Wire Puller 3", url = "http://railroad.moto-chika.com/wirepuller3.html"}
    m[92] = {name = "東方音弾遊戯6", url = "http://colorfulumbrella.sakura.ne.jp/ondan/ondan6.html"}
    m[93] = {name = "戦[sen-goku]國 ～甲午の乱～", url = "http://sen-goku-3rd.info/"}
    m[94] = {name = "合作！DPBMS差分大会", url = "http://yuyuyu.soudesune.net/dpbms_taikai.htm"}
    m[95] = {name = "第11回自称無名BMS作家が物申す！", url = "http://mumei11bms.web.fc2.com/"}
    m[96] = {name = "G2R2014 \"GO BACK 2 YOUR ROOTS\"", url = "https://www.bmsoffighters.net/g2r2014/index.html"}
    m[97] = {name = "G2R2014 反省会", url = "https://www.bmsoffighters.net/g2r2014/index.html"}
    m[98] = {name = "TRIDENT -三拍子限定BMSイベント-", url = "http://tcheb.web.fc2.com/trident.html"}
    m[99] = {name = "G2R後夜祭", url = "http://cerebralmuddystream.nekokan.dyndns.info/g2rafter/"}
    m[100] = {name = "WINTER 9KEYS SPARKLE 2015", url = "http://www.yw-works.com/9keys2015/"}
    m[101] = {name = "第12回自称無名BMS作家が物申す！", url = "http://www.geocities.jp/mumei12_bms/"}
    m[102] = {name = "東方音弾遊戯7", url = "http://miohosina.moe.hm/ondan7/index.html"}
    m[103] = {name = "ノンジャンル3", url = "http://manbow.nothing.sh/event/event.cgi?event=9"}
    m[104] = {name = "大血戦 -THE BMS OF FIGHTERS ULTIMATE-", url = "https://www.bmsoffighters.net/bofu_daikessen/index.html"}
    m[105] = {name = "BMS OF FOON ULTIMATE 2015", url = "http://www.geocities.jp/asahi3jpn/bofoon2015.html"}
    m[106] = {name = "BMS Charater Respect Party 2016", url = "http://bcrp2016.web.fc2.com/"}
    m[107] = {name = "Portable Memories March -BMS Edition-", url = "http://sbfr.info/special/pmm_bms/index.html"}
    m[108] = {name = "第13回自称無名BMS作家が物申す！", url = "http://www.geocities.jp/mumeisen13/"}
    m[109] = {name = "Be Happiness!!!! - HAPPY BMS EVENT -", url = "http://nextreflection.net/behappiness/"}
    m[110] = {name = "BOFU2016 [THE BMS OF FIGHTERS ULTIMATE 2016] - Legendary Again -", url = "https://www.bmsoffighters.net/bofu2016/index.html"}
    m[111] = {name = "BOFU2016 - preliminary skirmish -", url = "https://www.bmsoffighters.net/bofu2016/index.html"}
    m[112] = {name = "Wire Puller IV", url = "http://wirepullerorg.xxxxxxxx.jp/index.html"}
    m[113] = {name = "WE LUV VGBMS", url = "http://bmsoffighters.net/vgbms/index.html"}
    m[114] = {name = "DNBmsFesta", url = "http://dnbmsfesta.webcrow.jp/"}
    m[115] = {name = "「第14回自称無名BMS作家が物申す！」 VS 「A-1 ClimaX 7th -Break Through!-」", url = "http://scytheleg.sakura.ne.jp/tempyou/event/mumei_vs_a1/"}
    m[116] = {name = "BOFU2017 - LEGENDA EST A MYTH -", url = "https://www.bmsoffighters.net/bofu2017/index.html"}
    m[117] = {name = "ＢＭＳＡイベント２０１７", url = "http://bmsoffighters.net/bmsa2017/"}
    m[118] = {name = "東方音弾遊戯8", url = "http://nekonotsuka.com/ondan8/index.html"}
    m[119] = {name = "Battle in the Mist 2ndMIX", url = "http://bmsoffighters.net/bim/"}
    m[120] = {name = "OLDSKOOL VS FUTURE", url = "http://scytheleg.sakura.ne.jp/tempyou/event/oldvsfuture/"}
    m[121] = {name = "第15回自称無名BMS作家が物申す！ & A-1 ClimaX 8th -Stand out shines-", url = "https://mumeisen15.wixsite.com/event"}
    m[122] = {name = "OLDSKOOL VS FUTURE 後夜祭", url = "http://scytheleg.sakura.ne.jp/tempyou/event/oldvsfuture/"}
    m[123] = {name = "G2R2018 Climax -GO BACK 2 YOUR ROOTS 2018 climax-", url = "https://www.bmsoffighters.net/g2r2018/index.html"}
    m[124] = {name = "BGA PARTY Classic / Unlimited", url = "https://bgaparty.tumblr.com/"}
    m[125] = {name = "HYPER SELF REMIX -Re:union-", url = "http://scytheleg.sakura.ne.jp/tempyou/event/remix/"}
    m[126] = {name = "第16回自称無名BMS作家が物申す！ & A-1 ClimaX 9th -Be Spring Star!-", url = "https://mumeisen16.jimdofree.com/"}
    m[127] = {name = "BOFXV - THE BMS OF FIGHTERS eXtreme Violence -", url = "https://www.bmsoffighters.net/bofxv/index.html"}
    m[128] = {name = "BOFoonXV - THE BMS OF FOON eXtreme Violence -", url = "https://nasashiki.web.fc2.com/bofoonxv.html"}
    m[129] = {name = "東方音弾遊戯9", url = "http://nekonotsuka.com/ondan9/index.html"}
    m[130] = {name = "SPRING 9KEYS BLOSSOM 2020", url = "https://zero31zero.wixsite.com/9keys2020"}
    m[131] = {name = "第17回自称無名BMS作家が物申す！ & A-1 ClimaX 10th - Like a shining Diamond -", url = "https://to12lz.github.io/mumeisen17/index.html"}
    m[132] = {name = "WORLD WAR -BATTLE ROYALE IN ALL REGIONS-", url = "http://scytheleg.sakura.ne.jp/tempyou/event/ww_battle/"}
    m[133] = {name = "THE BMS OF FIGHTERS XVI -NEO DYSTOPIA-", url = "https://www.bmsoffighters.net/bofxvi/index.html"}
    -- 名前を揃えてからイベントの楽曲リストURLを入れる
    for i = 1, 500 do
        m[i].musicList = "http://manbow.nothing.sh/event/event.cgi?action=List_def&event=" .. i
    end
end

musicDetail.functions.guessEvent = function (url)
    if url:find("yaruki0.sakura.ne.jp", 1, true) then
        for key, value in pairs(EVENT_LIST.YARUKI0) do
            if url:find(key, 1, true) then
                return value
            end
        end
    elseif url:find("mumeiVS", 1, true) then
        return EVENT_LIST.MUMEI0
    elseif url:find("k-bms", 1, true) then
        local _, _, str = url:find("board_num=(%d+)")
        if str == nil then
            return {name = "", url = ""}
        elseif isNumber(str) and tonumber(str) > 0 then
            str = tonumber(str)
            if str == 1 then
                return EVENT_LIST.KBMS[1]
            elseif str == 11 then
                return EVENT_LIST.KBMS[2]
            elseif str >= 15 then
                return EVENT_LIST.KBMS[str - 12]
            end
            return EVENT_LIST.MANBOW[tonumber(str)]
        end
    elseif url:find("manbow.nothing.sh", 1, true) then
        local _, _, str = url:find("event=(%d+)")
        if str == nil then
            return {name = "", url = ""}
        elseif isNumber(str) and tonumber(str) > 0 then
            return EVENT_LIST.MANBOW[tonumber(str)]
        end
    end
    return nil
end

musicDetail.functions.updateMusicDetailData = function (data, title)
    musicDetail.musicData = data
    musicDetail.tablesString = ""
    if musicDetail.musicData.tables ~= nil then
        for _, value in pairs(musicDetail.musicData.tables) do
            -- 楽曲リンクを入れる
            if musicDetail.musicLink == "" then
                musicDetail.musicLink = value.url
            elseif
                value.url:find("(manbow.nothing.sh)|(k-bms.com)|(venue.bmssearch.net)|(toymusical.net)") ~= nil
                or (
                    musicDetail.musicLink:find("(manbow.nothing.sh)|(k-bms.com)|(venue.bmssearch.net)|(toymusical.net)") == nil
                    and #musicDetail.musicLink < #value.url
                )
                then
                musicDetail.musicLink = value.url
                myPrint("イベントリンク優先: " .. musicDetail.musicLink)
            end

            if value.detail ~= nil and value.detail ~= "None" then
                -- level orderとfolder orderは不要なので削除
                value.detail.level_order = {}
                value.detail.folder_order = {}
                -- テーブル名を入れる
                if value.detail.type == nil or value.detail.type == "table" then
                    if musicDetail.tablesString == "" then
                        musicDetail.tablesString = value.detail.name
                    else
                        musicDetail.tablesString = musicDetail.tablesString .. "\n" .. value.detail.name
                    end
                elseif value.detail.type ~= nil and value.detail.type == "event" then
                    -- イベントの場合は, イベント名とurlを取得
                    musicDetail.event.name = value.detail.name
                    if value.detail.event_url ~= nil then
                        musicDetail.event.url = value.detail.event_url
                    else musicDetail.event.url = ""
                    end
                    if value.detail.list_url ~= nil then
                        musicDetail.event.musicList = value.detail.list_url
                    else musicDetail.event.musicList = ""
                    end
                    print("イベント情報: " .. musicDetail.event.name, musicDetail.event.url)
                end
            end
        end
    end
    -- 楽曲URLからイベント情報を取得
    local eventInfo = musicDetail.functions.guessEvent(musicDetail.musicLink)
    if eventInfo ~= nil then
        if musicDetail.event.name == "" then
            myPrint("楽曲URLからイベント情報推測")
            musicDetail.event = eventInfo
        else
            if musicDetail.event.musicList == "" then
                musicDetail.event.musicList = eventInfo.musicList
            end
        end
    end
    musicDetail.wasDrawed = true
    musicDetail.lastGetDataTitle = title
end

--[[
    タイマーから呼び出す関数
    isUseMusicDbがfalseの場合はそもそも呼び出されない
]]
musicDetail.functions.getMusicDetail = function ()
    if MUSIC_DATA_CACHE == nil then
        return
    end

    if not main_state.option(2) or main_state.option(1030) then
        musicDetail.functions.clearViewData()
        return 0
    end

    -- cacheがヒットしたらそれをとって終了
    local title = main_state.text(12)
    if MUSIC_DATA_CACHE[title] ~= nil then
        if musicDetail.lastGetDataTitle ~= title then
            print("キャッシュがヒット: " .. title)
            musicDetail.functions.clearViewData()
            musicDetail.functions.updateMusicDetailData(MUSIC_DATA_CACHE[title], title)
        end
        return
    end

    -- キャッシュがなければ通信して取得する
    local nowTime = (main_state.time() - main_state.timer(11)) / 1000

    -- 楽曲情報を表示開始までは消す
    if nowTime <= MUSIC_DETAIL.GET_WAIT_TIME then
        musicDetail.functions.clearViewData()
        return 0
    end

    if musicDetail.getMusicDataObj == nil and nowTime > MUSIC_DETAIL.GET_WAIT_TIME then
        -- 取得用オブジェクトが無ければ取得する
        musicDetail.getMusicDataObj = getMusicDataAsync(title)
        musicDetail.getMusicDataObj:runHttpRequest(function (isSuccess, data)
            -- callback関数

            if not isSuccess then
                return
            end

            myPrint("テーブル情報更新")
            musicDetail.functions.updateMusicDetailData(data, title)
            musicDetail.functions.addCache(data, title)
        end)
    end
end

musicDetail.functions.clearCache = function ()
    print("キャッシュクリア実行")
    local f = io.open(skin_config.get_path(MUSIC_DETAIL.CACHE_PATH), "w")
    if f == nil then
        print("キャッシュファイルクリアでのファイルオープンに失敗しました")
    end
    f:write("MUSIC_DATA_CACHE = {}\n")
    f:close()
end

musicDetail.functions.createCacheString = function (data, parentKey)
    local str = ""
    if not data then
        return ""
    end
    if type(data) == "table" then
        str = "{"
        if parentKey == "level_order" or parentKey == "folder_order" or parentKey == "tables" then
            for key, value in ipairs(data) do
                str = str .. musicDetail.functions.createCacheString(value, key) .. ","
            end
        else
            for key, value in pairs(data) do
                str = str .. key .. "=" .. musicDetail.functions.createCacheString(value, key) .. ","
            end
        end
        str = str .. "}"
        return str
    else
        -- luaでエラーが出ないように, ダブルクオーテーションと改行はエスケープする
        return '"' .. musicDetail.functions.escapeForLuaValue(data) .. '"'
    end
end

musicDetail.functions.escapeForLuaValue = function (str)
    return string.gsub(tostring(str), '["\n]', function (c)
        if c == '"' then return '\\"'
        elseif c == "\n" then return "\\n"
        else return c
        end
    end)
end

musicDetail.functions.addCache = function (data, localTitle)
    print()
    local f = io.open(skin_config.get_path(MUSIC_DETAIL.CACHE_PATH), "a")
    if f == nil then
        print("キャッシュファイルのオープンに失敗しました")
    end
    io.output(f)
    local cache = musicDetail.functions.createCacheString(data, "")
    io.write(MUSIC_DETAIL.VAR_NAME .. '["' .. musicDetail.functions.escapeForLuaValue(localTitle) .. '"]=' .. cache .. "\n")
    print("add cache: " .. cache)
    io.close(f)
    MUSIC_DATA_CACHE[localTitle] = data
end

musicDetail.functions.load = function ()
    local wasSuccessLoadCache, _ = pcall(cacheRequire)
    if not wasSuccessLoadCache or MUSIC_DATA_CACHE == nil then
        print("キャッシュ読み込み失敗 キャッシュクリア実行")
        musicDetail.functions.clearCache()
        cacheRequire()
    end
    musicDetail.functions.initManbowEvent()
    return {
        text = {
            {id = "tableString" , font = 0, size = 48, align = 0, overflow = 1, value = function () return musicDetail.tablesString end},
        }
    }
end

musicDetail.functions.dst = function ()
    return {
        destination = {
            -- {id = "white", dst = {
            --     {x = 0, y = 0, w = 800, h = 1400}
            -- }},
            -- {id = "tableString", dst = {
            --     {x = 100, y = 900, w = 1000, h = 48, r = 0, g = 0, b = 0}
            -- }}
        }
    }
end

return musicDetail.functions

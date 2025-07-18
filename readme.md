# Social Skin, Glass Style(リザルトのみ)

## 利用方法

beatoraja/skin/にSocialSkinのディレクトリごと入れてください.

## フォルダとスキンの対応

result: SocialSkin

result2: GlassStyle

result3: SpaceShip

## サポートする本体バージョン

beatoraja 0.8.4

なお, スキン自体のサポートは最新バージョンのみとなります. スキンのバージョンは, 本スキン選曲画面右下のメニュー->ヘルプで確認できます.

ユーザの経験値周り, 楽曲DB塔いくつかの機能は本スキン専用の機能となります. beatoraja開発者は関与しておりませんので, そのあたりの機能で何かあれば私の方に連絡をください.

## Favoriteボタン

FavoriteボタンをSongに設定している場合, ボタンを押した結果を反映させるには一度別の画面に移動する必要があります. (orajaの仕様)
Chart時はリアルタイムに反映されます

## カスタムグルーヴゲージ

これは, カスタマイズしたグルーヴゲージを本スキンのプレイ画面とリザルト画面に表示する機能です. 表示のみで, クリアランプには影響しません.

利用するには, プレイスキンで`カスタムゲージの表示`を有効化してください.
対応スキンでゲージの結果を表示したい場合は, リザルトスキンでも同様の設定を有効化してください. Social SkinとGlas Styleが対応しています.

orajaでは各種数値にデフォルト値を設定できないので, 0を設定した場合に特定の値が使用されるよう設定しています.

EASY, NORMAL, HARDのデフォルト値はLR2準拠です.

### AEASY, EASY, NORMAL

#### 増加率

PG, GR, GD判定で, 本来増えるゲージの量に対する割合を設定します.

100と設定すれば通常通り, 120と設定すれば通常と比べて1.2倍増加します. 50とすれば, 増加量は半分になります. 負数を設定すれば, ゲージが減少します.

#### 増加(減少)量

BD, PR, MS判定で, ゲージの増加(減少)量を設定できます. 増加率と違い, TOTAL値に対する依存はありません.
例えば, 単位が0.1%のものに-100と設定すると, ゲージが10%減少します.

### HARD, EXHARD

#### 増加量

各種判定で, ゲージの増加(減少)量を設定できます. TOTAL値に対する依存はありません.
単位が0.01%のものに10と設定すると, 0.1%ゲージが回復します.

### 増減を0にしたい場合

9999か-9999と設定してください.

## 細かい機能周り色々

### 通信をする機能

楽曲DB機能と, バージョンチェック機能がHTTP通信を行います. 通信したくない場合はオフにしてください.

### 楽曲DBについて

楽曲情報は, 難易度表におけるスペースの有無等の表記ゆれによりうまく取得できない場合があります.

また, 差分のフルタイトルが他と一致している場合, その別譜面の情報が表示される場合があります.

## FAQ

### ランクが初期化されている

ユーザデータの読み込みに失敗した可能性があります. beatorajaの再起動, またはPCを再起動してみてください. もしユーザデータが初期化状態で上書きされてしまった場合, SocialSkin/userdata/backupから復元してください. 名前順で並べた場合は最も下のデータが新しいデータになります.

### ユーザデータが保存されない

テキストエディタ等で開いた状態ではないか確認してください.

### 選曲画面に入るのに時間がかかる

楽曲情報のキャッシュを削除してみてください. SocialSkin/lua/cache/music_data.luaを削除すると良いです. (ディレクトリは削除しないでください)

### ヘルプを表示すると重い

シンプルに重いだけです. ごめんなさい.

### プレイスキンが重い

主にビジュアライザ(デフォルトではオフ)とログ機能が重くなっている原因になります.
ログ機能はオフにすると使用できる機能が制限されるためオンのままにしておくことを推奨しますが, どうしても重い場合は切ってみてください.

### クラッシュした

色々と機能を積んでいるので, 対策はしていますがクラッシュしやすい傾向にあります. 今の所自分の環境ではクラッシュは見られないので多分大丈夫だと思います.
もし同じ場面でクラッシュする等あれば連絡をもらえると嬉しいです.

### 一覧にないor解決しなかった

記事にコメントやtwitterでメンション等してもらえれば反応します.

## ライセンス

luaプログラム: GPL-3.0 概要は, 著作表記を残した上で複製, 改変, 再配布等が可能です. これを組み込んだソフトウェア及びプログラムはGPL-3.0になります.

### 画像等

[表示 - 継承 3.0 非移植 (CC BY-SA 3.0)](https://creativecommons.org/licenses/by-sa/3.0/deed.ja) つまり元と同じライセンスかつ著作表記をした上で, 改変や再配布等が可能です.

#### 適用対象

* select/parts/\* (曲バー左下のアイコン除く, 統計ボタンアイコン)
* decide/parts/\* (largeshine以外)
* result/parts/\*\*
* result2/parts/\*\*
* play/parts/\*\* (notes以外)
* \*/noimage/\* です.

その他のアセットは各素材配布元に従ってください.

### 素材

このスキンは, 一部にフリー素材を利用しています.

* 背景画像(*/background/*.png): 花のイラストなら「百花繚乱」 – 無料で使えるフリー素材
* フォント: Copyright © 2014, 2015 Adobe Systems Incorporated (http://www.adobe.com/), with Reserved Font Name ‘Source’., 小塚ゴシック
* 一部アイコン(曲バー左下のアイコン, 統計ボタンアイコン): ICOOON MONO
* 一部画像(decide/parts/largeshine.png): 150 Light Effect Brushes — Photoshop Add-ons
* 効果音: 無料効果音で遊ぼう！ , 魔王魂, フリー効果音素材 くらげ工匠
* 一部画像の素材: Marble Vectors by Vecteezy

### ソースコード

私が作成した部分はGNU General Public Licenseです. ライセンス文はdefine.luaにあります.

deepcopy.lua, url_encoder.lua は配布元に従ってください.

## スキン配布場所

[特設](https://tori-blog.net/bms/1392/)

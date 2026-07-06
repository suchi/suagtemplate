# セットアップガイド — テンプレートから実運用リポジトリを作る手順

このリポジトリの2つのテンプレートから、新しいリポジトリ/プロジェクトを始めるときの手順書。

## 0. テンプレートを選ぶ

| フォルダ | 内容 |
| --- | --- |
| `template/` | すべて英語のテンプレート |
| `template_ja/` | ドキュメント・会話が日本語のテンプレート(コード・識別子は英語) |

## 1. リポジトリを作成し、テンプレートを展開する

主手順(フォルダコピー): 新しい空リポジトリを作成し、選んだフォルダの中身(ドットファイル含む)をルートへコピーする。

```bash
# 例: degitを使う場合(<owner>は自分のアカウントに置き換える)
npx degit <owner>/suagtemplate/template_ja my-repo
cd my-repo && git init

# 例: cloneからコピーする場合
git clone https://github.com/<owner>/suagtemplate.git
cp -r suagtemplate/template_ja/. my-repo/
```

補足(Use this templateを使う場合): GitHubの「Use this template」で全体を複製した後、使わない側のテンプレートフォルダ・`docs/`(メタ文書)・トップのREADME/AGENTS.md等を削除し、選んだフォルダの中身をルートへ移動する。

## 2. 個人グローバル設定を反映する(各マシン初回のみ)

- Linux / macOS / WSL2: `personal/install.sh`
- Windows(PowerShell): `personal/install.ps1`
- Copilotの個人指示とStopフックの登録は`personal/README.md`の手動手順に従う

## 3. READMEを書き換える

`README.md`をプロジェクトの内容に書き換える。

## 4. AGENTS.mdのプレースホルダを埋める

```bash
grep -rn "TODO(project)" .
```

- プロジェクト概要: 目的・技術スタック・対象環境を2〜5行
- 検証コマンド: セットアップ・テスト・リント・型チェック・ビルドの実コマンド(最重要。コマンドやhooks、CIすべての前提になる)
- 言語ルールの上書き: 必要な場合のみ

## 5. dependabot.ymlのエコシステムを有効化する

`.github/dependabot.yml`のコメントアウトされたブロックから、使用するエコシステム(npm・uv・gomodなど)のコメントを外す。`cooldown`設定はサプライチェーン対策なので必ず残す。

## 6. CIワークフローを作成する

`.github/workflows/`に、AGENTS.mdの検証コマンドと同じ内容を実行するワークフローを作る。

- 対象ブランチ: `main`へのpushと、`main`向けpull_request(必要なら`feature/**`等へのpushも)
- 最低限: テスト+リント+ビルド
- アクションのバージョンは実在するタグを確認してから指定する(短縮タグ`v4`が使えるものとフルバージョン指定が必要なものがある)

## 7. GitHubリポジトリ設定(ブラウザで実施)

- Branch protection / ruleset(main): PR必須、CIステータスチェック必須、直接push禁止
- Copilot code review自動化: rulesetで「Request pull request review from Copilot」を有効化(またはPR作成時に`--add-reviewer @copilot`を運用で徹底)
- Actions権限(GitHub Actionsからgh pr createする場合のみ): Settings → Actions → 「Allow GitHub Actions to create and approve pull requests」を有効化(APIでは変更できない)
- ラベル: `gh pr create --label`を使う場合は事前に作成(存在しないラベル指定はエラーになる)

## 8. LICENSEを決める

LICENSEファイルを追加するか、ライセンスなしの方針をREADMEに明記する。

## 9. 動作確認チェックリスト

- [ ] Claude Codeで`/commit`・`/ship`などのコマンドが見える
- [ ] hookが効く: エージェントに`git push origin main`を依頼するとブロックされる
- [ ] hookが効く: `.claude/settings.json`等の変更時に確認(ask)が出る
- [ ] Copilot(コードレビュー含む)がAGENTS.mdの規約に言及する
- [ ] CodexがAGENTS.mdを読んで規約どおりに応答する
- [ ] CIがPRで実行される
- [ ] `grep -rn "TODO(project)" .`が何もヒットしない
- [ ] `personal/`を削除済み(反映が済んでいる前提)

## 10. プロジェクトに応じたカスタマイズ候補

- エージェント別の細かい注意点は[agent-notes.md](agent-notes.md)を参照(必要な項目はAGENTS.mdへ転記する)。
- お任せ開発(vibe coding)寄りにしたい場合は[vibe-coding.md](vibe-coding.md)の手順で緩める(セキュリティゲートは緩めない)。

必要に応じてAGENTS.mdを調整する:

- 言語ルールの上書き(UIラベルの言語など)
- ドキュメントの絵文字禁止の解除
- ASCII文字と日本語の間にスペースを入れない規則の追加(template_ja向け・レンダラ依存)
- テストカバレッジ目標・テスト件数基準の追加
- サブエージェント並列運用パターンの追加(大規模プロジェクト向け)
- 使用フレームワーク固有の規約(例: React型のnamed import強制など)の追記
- 既存リポジトリへ後付け適用する場合は、テンプレートのファイル一式を追加したあとに`git add --renormalize .`を実行して改行コードを正規化する(`.gitattributes`より前にCRLFで格納されたファイルは、属性を追加しただけでは直らない)

# セットアップガイド — テンプレートから実運用リポジトリを作る手順

このテンプレートから新しいリポジトリ/プロジェクトを始めるときの手順書。

## 1. リポジトリを作成する

- GitHubでこのリポジトリをテンプレートリポジトリに設定してあれば、「Use this template」から新規リポジトリを作成する。
- そうでなければcloneしてremoteを差し替える。

## 2. 個人グローバル設定を反映する(初回のみ)

各マシンで一度だけ実施していればよい。未実施なら:

- Linux / macOS / WSL2: `personal/install.sh`
- Windows(PowerShell): `personal/install.ps1`
- Copilotの個人指示: `personal/copilot-personal-instructions.md`の手順で手動貼り付け

## 3. テンプレート専用フォルダを削除する

```bash
git rm -r template-docs personal
```

削除は最初のコミットの前でも後でもよいが、削除したことをコミットメッセージに残す。

## 4. READMEを書き換える

`README.md`と`README_en.md`をプロジェクトの内容に書き換える。

## 5. AGENTS.mdのプレースホルダを埋める

`TODO(project)`マーカーを検索して一覧を出す:

```bash
grep -rn "TODO(project)" .
```

埋めるもの:

- **プロジェクト概要**: 目的・技術スタック・対象環境を2〜5行
- **検証コマンド**: セットアップ・テスト・リント・型チェック・ビルドの実コマンド(最重要。コマンドやhooks、CIすべての前提になる)
- **言語ルールの上書き**: UIラベルを日本語にする場合など(デフォルトはすべて英語)

同じ変更を`AGENTS_en.md`にも反映する。

## 6. dependabot.ymlのエコシステムを有効化する

`.github/dependabot.yml`のコメントアウトされたブロックから、使用するエコシステム(npm・uv・gomodなど)のコメントを外す。`cooldown`設定はサプライチェーン対策なので必ず残す。

## 7. CIワークフローを作成する

`.github/workflows/`に、AGENTS.mdの検証コマンドと同じ内容を実行するワークフローを作る。

- 対象ブランチ: `main`へのpushと、`main`向けpull_request(必要なら`feature/**`等へのpushも)
- 最低限: テスト+リント+ビルド
- アクションのバージョンは実在するタグを確認してから指定する(短縮タグ`v4`が使えるものとフルバージョン指定が必要なものがある)

## 8. GitHubリポジトリ設定(ブラウザで実施)

- **Branch protection / ruleset(main)**: PR必須、CIステータスチェック必須、直接push禁止
- **Copilot code review自動化**: rulesetで「Request pull request review from Copilot」を有効化(または PR作成時に`--add-reviewer @copilot`を運用で徹底)
- **Actions権限**(GitHub Actionsからgh pr createする場合のみ): Settings → Actions → 「Allow GitHub Actions to create and approve pull requests」を有効化(APIでは変更できない)
- **ラベル**: `gh pr create --label`を使う場合は事前に作成(存在しないラベル指定はエラーになる)

## 9. LICENSEを決める

LICENSEファイルを追加するか、ライセンスなしの方針をREADMEに明記する。

## 10. 動作確認チェックリスト

- [ ] Claude Codeで`/commit`・`/ship`などのコマンドが見える
- [ ] hookが効く: エージェントに`git push origin main`を依頼するとブロックされる
- [ ] hookが効く: `_en.md`を持つ日本語mdを編集すると英語版更新のリマインドが出る
- [ ] Copilot(コードレビュー含む)がAGENTS.mdの規約に言及する
- [ ] CodexがAGENTS.mdを読んで日本語で応答する
- [ ] CIがPRで実行される
- [ ] `grep -rn "TODO(project)" .`が何もヒットしない

## 11. プロジェクトに応じたカスタマイズ候補

- エージェント別の細かい注意点は[agent-notes.md](agent-notes.md)を参照(必要な項目はAGENTS.mdへ転記する)。
- お任せ開発(vibe coding)寄りにしたい場合は[vibe-coding.md](vibe-coding.md)の手順で緩める(セキュリティゲートは緩めない)。

必要に応じてAGENTS.md(と_en版)を調整する:

- UIラベル・ARIAラベルを日本語にする(言語ルール表の上書き)
- ドキュメントの絵文字禁止を解除する
- ASCII文字と日本語の間にスペースを入れない規則を追加する(レンダラが自動挿入する環境向け)
- テストカバレッジ目標・テスト件数基準の追加
- サブエージェント並列運用パターンの追加(大規模プロジェクト向け)
- 使用フレームワーク固有の規約(例: React型のnamed import強制など)の追記

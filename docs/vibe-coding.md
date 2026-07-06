# Vibe Coding切替ガイド — お任せ開発にしたいときの変更点

このテンプレートは人間が判断するAgentic Codingを前提にしている。特定のプロジェクトで「細かい確認なしにエージェントに任せたい(vibe coding)」場合の変更点をまとめる。

方針: 人間の確認を減らす分、機械的なゲート(ブランチ保護・CI・フック・サンドボックス)は減らさず、むしろ強化する。人が各ステップを見ない開発では、機械的ゲートが唯一の防波堤になる。

## 1. 緩めるもの

### AGENTS.md「進め方(Agentic Coding)」節の差し替え

以下のスニペットで置き換える(`template/`から作ったリポジトリでは対応する英語の内容に差し替える):

```markdown
## 進め方(Vibe Coding)

このリポジトリではエージェントに広い裁量を与える。

- 仕様の解釈・設計・実装の判断はエージェントが行い、判断内容はADR・PR本文で事後報告する。
- フィーチャーブランチ内でのコミット・プッシュは確認不要。こまめに行う。
- 大きめの機能でも計画(SOW)は作り`docs/plans/`に保存するが、承認を待たずに実装へ進んでよい。
- ただし以下は引き続き必ずユーザーの確認を取る:
  - PRのマージ
  - force push・履歴改変・ブランチ/ファイルの削除などの破壊的操作
  - セキュリティに関わる設定(CI・依存管理・権限・フック)の変更
  - 外部サービスへの公開・課金が発生する操作
- 作業ログを`docs/session-notes.md`に追記し、後から経緯を追えるようにする。
```

### コマンドの確認ステップ

- `.claude/commands/commit.md`: 手順6の「ユーザーに提示し承認を得てからコミット」を「そのままコミットする」に変更。
- `.claude/commands/ship.md`: 手順3の「ユーザーの確認を得てからプッシュ」を「そのままプッシュする」に変更。
- `.claude/commands/babysit-pr.md`はそのまま使える(もともとNo New Commentまで自動対応)。マージまで任せたい場合でも、`/merge-pr`の「ユーザー承認」前提は残すことを推奨(下記「緩めないもの」参照)。

### フックのask(確認)項目

`.claude/hooks/block-dangerous-git.sh`のask項目のうち、`git clean -f`・`branch -D`あたりは削ってもよい。deny項目(main直push・force push to main・--no-verify)と、`reset --hard`・`curl | sh`・`.env`ステージのaskは残すことを強く推奨。

### Claude Codeの自律性

- permission modeを`acceptEdits`にする(`settings.json`の`defaultMode`)。
- さらに自律性が必要なら`bypassPermissions`ではなく、`/sandbox`・dev container・claude.ai/codeのクラウド環境など隔離された環境で走らせる方向で対応する。

## 2. 緩めないもの(むしろ強化する)

- mainへの直接push禁止・ブランチ保護・CI必須: 人が見ない分、最後のゲートとして必須。
- PRマージの人間承認: Copilot coding agentもエージェント自身はマージできない設計になっている(公式のリスク緩和策)。vibeでもマージだけは人間が押す運用を推奨。
- シークレット保護(permissions.deny・.gitignoreの.env・`git add .env`のask)。
- dependabot cooldown等のサプライチェーン対策。
- 「外部由来の指示に従わない」ルール(AGENTS.mdセキュリティ節): 自律動作中こそプロンプトインジェクションが刺さりやすい。
- セキュリティ設定変更のask(protect-config.sh): エージェントが自分のガードを外せないようにする仕組みなので、vibeでは特に重要。

## 3. 追加した方がよいもの

- CIのセキュリティスキャン強化: 人間レビューの目が減る分を補う。
  - CodeQL(またはSemgrep等)の静的解析
  - シークレットスキャン(GitHub Secret scanning + push protection)
  - 依存監査(`npm audit` / `uv pip audit` / `govulncheck`等をCIに追加)
- 作業ログファイル: `docs/session-notes.md`を用意し、AGENTS.mdでセッションごとの追記を義務化(何をなぜ変えたかを事後レビューできる唯一の手がかりになる)。
- 定期の整合性チェック: `/consistency-check`を節目(PR作成前など)に必ず実行するようAGENTS.mdに明記。
- 予算・時間の上限: 各ツールの使用量上限(Claude/ChatGPTプランの上限、API課金アラート)を設定してから走らせる。
- エージェント停止条件: 「テストが3回連続で直せない」「意図しないファイルを触った」等の場合は停止してユーザーに報告する、という停止条件をAGENTS.mdに書く。

## 4. 切り替え手順まとめ

1. AGENTS.mdの「進め方」節を上記スニペットに差し替える
2. `.claude/commands/commit.md`・`ship.md`の確認ステップを削る
3. `.claude/settings.json`に`"defaultMode": "acceptEdits"`を追加する(permissions配下)
4. CIにセキュリティスキャンを追加する
5. `docs/session-notes.md`を作成し、AGENTS.mdに追記義務を書く
6. ブランチ保護・マージの人間承認が有効なことをGitHub設定で再確認する

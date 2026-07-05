# template-docs/ — テンプレート自体のドキュメント

このフォルダは**テンプレート(suagtemplate)そのものの説明**であり、テンプレートから作成した実運用リポジトリでは削除する。

- 新しいリポジトリへの適用手順: [setup-guide.md](setup-guide.md)
- 参照した公式ドキュメント一覧: [references.md](references.md)
- エージェント別の運用ノート(テンプレートで表現しきれない注意点): [agent-notes.md](agent-notes.md)
- Vibe Coding(お任せ開発)へ切り替える場合の変更点: [vibe-coding.md](vibe-coding.md)
- テンプレートの変更履歴(セッション記録): [history.md](history.md)
- `.claude/`のコマンド・スキル(英語)の日本語訳: [ja/](ja/)

## テンプレートの目的

GitHub Copilot・Claude Code・Codexで開発を始めるとき、毎回インストラクションをコピペしなくて済むように、標準的な注意事項と個人の開発スタイルをあらかじめ設定したリポジトリテンプレート。完全お任せ(vibe coding)ではなく、人間が判断を行うAgentic Codingを指向している。

## 構成

```text
.
├── AGENTS.md / AGENTS_en.md      エージェント共通指示の単一ソース(日本語が正)
├── CLAUDE.md                     Claude Code用ポインタ(@AGENTS.mdのみ)
├── README.md / README_en.md      リポジトリREADME(実運用では書き換える)
├── .github/
│   ├── copilot-instructions.md   Copilot用の薄いポインタ+レビュー日本語指定
│   ├── copilot-code-review.yml   レビュー言語設定(互換用、下記参照)
│   └── dependabot.yml            依存更新+サプライチェーン対策(cooldown)
├── .claude/
│   ├── settings.json             シークレット読み取りdeny+hooks登録
│   ├── hooks/
│   │   ├── block-dangerous-git.sh    危険なGit操作のガード
│   │   └── check-docs-en-sync.sh     日英ドキュメント同期リマインダー
│   ├── commands/                 /commit /ship /babysit-pr /consistency-check /merge-pr
│   └── skills/                   adr(ADR作成・改訂)、sync-docs-en(日英同期)
├── docs/adr/                     ADR雛形(テンプレート+インデックス)
├── personal/                     個人(マシン)側グローバル設定(実運用では削除)
└── template-docs/                このフォルダ(実運用では削除)
```

## 設計方針

### AGENTS.md単一ソース

指示は`AGENTS.md`に集約する。CopilotとCodexは`AGENTS.md`をネイティブに読み、Claude Codeは`CLAUDE.md`の`@AGENTS.md`でインポートする。エージェント固有ファイルには各ツール固有の設定だけを書き、指示を重複させない。

### 指示は簡潔に(1ルール1か所)

冗長な指示はエージェントの遵守率を下げるため、規範はAGENTS.mdに短く書き、手順の詳細は参照先に分離する。各ルールの正となる置き場所は1か所だけにする: ADRの運用ルールは`docs/adr/README.md`、整合性チェックリストは`.claude/commands/consistency-check.md`、コミット規約はAGENTS.md。他のファイルはそこを参照する。

### 日英同期ルール

- 日本語の`<名前>.md`が正、`<名前>_en.md`が英語版。日本語版を変更したら同じコミットで英語版も更新する。
- 例外(英語版を作らないもの): `CLAUDE.md`・`.github/copilot-instructions.md`などの薄いポインタ、実プロジェクトの個別ADR。
- `.claude/commands/`と`.claude/skills/`は**英語がベース**。`commands/`内に`commit_en.md`を置くと`/commit_en`という重複コマンドとして登録されてしまうため。日本語訳は[ja/](ja/)に置く(訳の更新はベスト・エフォート。正は英語側)。

### hooks

| フック | イベント | 内容 |
| --- | --- | --- |
| `block-dangerous-git.sh` | PreToolUse(Bash) | main/masterへの直接push・force pushと`--no-verify`をdeny。force push(他ブランチ)・`reset --hard`・`clean -f`・`branch -D`・mainブランチ上でのcommit・`curl \| sh`等のダウンロードスクリプト直接実行・`.env`のステージはユーザー確認(ask)にエスカレート |
| `protect-config.sh` | PreToolUse(Edit/Write) | セキュリティを構成するファイル(`.claude/settings.json`・`.claude/hooks/`・`.github/workflows/`・`.github/dependabot.yml`)の変更をユーザー確認(ask)にエスカレート。エージェントが自分のガードを外すことを防ぐ |
| `check-docs-en-sync.sh` | PostToolUse(Edit/Write) | `_en.md`対応ファイルを持つ日本語mdを編集したとき、英語版の同時更新をエージェントにリマインド |

hooksはシェルスクリプトのため、Windowsでは Git Bash 経由で動作する(Claude CodeのBashツールと同じ前提)。`jq`があれば厳密に、なければフォールバックでペイロード全体をパターンマッチする。

### copilot-code-review.ymlについて

`.github/copilot-code-review.yml`(`language: "ja"`)は2026-07時点で公式ドキュメントに記載がない。過去リポジトリ(cc-todo)からの互換のために残しているが、レビューを日本語にする確実な方法は`.github/copilot-instructions.md`内の指示であり、そちらを主としている。

## このテンプレート自体を変更するとき

1. フィーチャーブランチを切って変更する(このリポジトリ自体もAGENTS.mdのフローに従う)。
2. 日本語版と英語版を同時に更新する。
3. 変更の経緯を[history.md](history.md)に追記する。

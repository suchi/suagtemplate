# テンプレート変更履歴(セッション記録)

このテンプレート自体をエージェントと改良していく過程の記録。テンプレートに変更を加えたセッションごとに、要望・決定事項・設計判断を追記する。

## 2026-07-05: 初版作成(Claude Codeとのセッション)

### 要望

- GitHub Copilot・Claude Code・Codex向けのデフォルト設定を持つリポジトリテンプレートを作る
- Vibe codingではなく、人間が判断するAgentic Codingを指向
- 標準的な注意事項+過去リポジトリから抽出した個人の開発スタイルを入れる
- ドキュメントは日本語ベース、`<ファイル名>_en.md`として英語版も作成・同時更新
- リポジトリではなく個人メモリ(グローバル設定)に置くべきものは別に作成
- AGENTS.mdだけでなく、skills/hooksにしたほうがよいものはそうする
- テンプレート自体のドキュメントは分離し、実運用ではそのフォルダを除けばそのまま使える形にする
- 実運用リポジトリへの適用手順書も作成

### 参考にした過去リポジトリ

cc-todo、cc-todo-next、copyhooker、dotfiles-fm、gctetris、sucheme-go、sucheme-ruby、sucheme-python、tbpview、yfatest(各リポジトリのAGENTS.md・CLAUDE.md・copilot-instructions.md・commands等)

### セッション中の決定事項(Q&A)

1. `.claude/`のコマンド・スキルは英語で作成し、日本語訳を`template-docs/ja/`に置く(`commands/`に`commit_en.md`を置くと`/commit_en`という重複コマンドが登録されてしまう問題の回避)
2. 個人設定は`personal/`+反映スクリプト(`install.sh`/`install.ps1`)の形にする
3. ADR雛形(`docs/adr/`)をテンプレートに含める
4. コード内文字列(ログ・エラー・UIラベル)は英語をデフォルトにし、プロジェクト側で上書き可能とする
5. PR/Issueはタイトルのみ英語、本文は日本語(UIが自動生成したPR #1の本文が英語だったことを受けて明文化。AGENTS.mdの言語ルール表・PR規約と個人設定に反映)

### 主な設計判断

- **AGENTS.md単一ソース**: CopilotとCodexはAGENTS.mdをネイティブサポート(Copilotのコードレビュー/コーディングエージェント対応は2025-11のGitHub変更ログで確認)。Claude Codeは`CLAUDE.md`の`@AGENTS.md`でインポート。
- **薄いポインタファイルには_en版を作らない**: `CLAUDE.md`・`.github/copilot-instructions.md`は翻訳対象外とし、ルールをAGENTS.mdに明記。
- **hooks**: (1)危険Git操作ガード — main/masterへの直接push・force push・`--no-verify`をdeny、その他の破壊的操作はask(自動承認モードでも確認が入る)。(2)日英同期リマインダー — `_en.md`対応ファイルを持つ日本語md編集時にエージェントへ通知。
- **skills**: `adr`(ADRの作成・非推奨化手順)と`sync-docs-en`(日英同期手順)。hooksのリマインドとskillが連動する設計。
- **copilot-code-review.yml**: 2026-07時点で公式ドキュメントに記載がないことを確認。cc-todoからの互換で残しつつ、確実な手段として`copilot-instructions.md`内の日本語レビュー指示を主とする。
- **Dependabot cooldown**: サプライチェーン対策として標準装備し、AGENTS.mdのセキュリティ節に「承認なしで削除禁止」を明記(sucheme-goで発生した削除インシデントの再発防止)。
- **採用しなかったもの**: 絵文字禁止(tbpreview)は標準に採用、ASCII/日本語間スペース規則(tbpreview)はレンダラ依存のため標準にせずsetup-guideのカスタマイズ候補に記載。サブエージェント並列運用パターン(cc-todo-next)はプロジェクト依存が強いため同じくカスタマイズ候補とした。

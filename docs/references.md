# 参考文献 — テンプレートが依拠した公式ドキュメント

このテンプレートの設計・記述のベストプラクティスとして参照した公式ドキュメントの一覧。参照日: 2026-07-05。各ツールの仕様は頻繁に変わるため、疑義がある場合は必ず最新の公式ドキュメントを確認すること。

## エージェント設定の仕組み

| 文書 | 用途 |
| --- | --- |
| [AGENTS.md仕様](https://agents.md/) | AGENTS.mdを単一ソースとする構成の根拠 |
| [GitHub Changelog: Copilot code review and coding agent now support agent-specific instructions (2025-11-12)](https://github.blog/changelog/2025-11-12-copilot-code-review-and-coding-agent-now-support-agent-specific-instructions/) | CopilotのAGENTS.mdネイティブサポート(最も近いディレクトリ優先)と`excludeAgent`の確認 |
| [GitHub Docs: Adding repository custom instructions for GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot) | copilot-instructions.md・path指定`*.instructions.md`・AGENTS.mdの関係 |
| [GitHub Changelog: Copilot code review: Customization for all (2025-06-13)](https://github.blog/changelog/2025-06-13-copilot-code-review-customization-for-all/) | コードレビューがcopilot-instructions.mdを読むことの確認 |
| [GitHub Docs: About GitHub Copilot code review](https://docs.github.com/en/copilot/concepts/agents/code-review) | レビュー運用(自動レビュー設定・言語指示) |
| [Claude Code Docs: Settings](https://code.claude.com/docs/en/settings) | `.claude/settings.json`の構造・permissions |
| [Claude Code Docs: Hooks](https://code.claude.com/docs/en/hooks) | PreToolUse/PostToolUseフックの仕様・`permissionDecision`(deny/ask)・終了コード2の挙動 |
| [Claude Code Docs: Slash commands](https://code.claude.com/docs/en/slash-commands) | `.claude/commands/*.md`の形式(`$ARGUMENTS`・frontmatter) |
| [Claude Code Docs: Skills](https://code.claude.com/docs/en/skills) | `.claude/skills/<name>/SKILL.md`の形式 |
| [Claude Code Docs: Memory (CLAUDE.md)](https://code.claude.com/docs/en/memory) | `@AGENTS.md`インポート・`~/.claude/CLAUDE.md`(個人メモリ) |
| [OpenAI Codex Docs: Config basics](https://developers.openai.com/codex/config-basic) | CodexのAGENTS.md読み込み・`~/.codex/AGENTS.md`(グローバル) |
| [OpenAI Codex Docs: Config reference](https://developers.openai.com/codex/config-reference) | AGENTS.mdサイズ上限・プロジェクトのtrusted/untrusted |

## セキュリティ

| 文書 | 用途 |
| --- | --- |
| [Claude Code Docs: Security](https://code.claude.com/docs/en/security) | プロンプトインジェクション対策(外部コンテンツを信頼しない・curl/wget非自動承認)、権限アーキテクチャ、信頼できないコンテンツの扱いのベストプラクティス |
| [Claude Code Docs: Permission modes](https://code.claude.com/docs/en/permission-modes) | acceptEdits等の各モードとフックの関係 |
| [Claude Code Docs: Sandboxing](https://code.claude.com/docs/en/sandboxing) | ファイルシステム・ネットワーク隔離 |
| [GitHub Docs: Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations) | coding agentのリスク緩和策(人間レビュー必須・Actions実行承認・ファイアウォール・write権限のないユーザーのコメント遮断) |
| [GitHub Docs: Best practices for using GitHub Copilot](https://docs.github.com/en/copilot/get-started/best-practices) | 生成コードを理解してから採用する・自動テストとツールで検証する |
| [GitHub Docs: Responsible use of Copilot cloud agent](https://docs.github.com/en/copilot/responsible-use/copilot-coding-agent) | エージェントPRの人間マージ必須などの設計 |
| [OpenAI Codex Docs: Agent approvals & security](https://developers.openai.com/codex/agent-approvals-security) | サンドボックス(技術的境界)と承認ポリシー(人間確認)の分離、危険操作の確認 |
| [OpenAI Codex Docs: Sandboxing](https://developers.openai.com/codex/concepts/sandboxing) | workspace-write時のネットワーク既定無効、キャッシュ済みWeb検索によるインジェクションリスク低減 |
| [GitHub Docs: Dependabot options reference — cooldown](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#cooldown) | サプライチェーン対策としてのcooldown設定の仕様 |
| [uv Docs: Settings — exclude-newer](https://docs.astral.sh/uv/reference/settings/#exclude-newer) | Python依存のサプライチェーン対策(個人設定に記載) |

## 開発プロセス・規約

| 文書 | 用途 |
| --- | --- |
| [Conventional Commits](https://www.conventionalcommits.org/) | コミットメッセージ規約 |
| [GitHub Docs: GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow) | ブランチ+PRの開発フロー |
| [Architectural Decision Records](https://adr.github.io/) | ADRの考え方・テンプレート構成 |

## 補足

- 上記に加えて、オーナーが過去リポジトリのエージェント運用で蓄積した知見(Copilot再レビューは`gh pr edit --add-reviewer @copilot`、gh 2.88.0以上が必要、PRクローズ/リオープンでは再レビューされない等)を反映している。経緯は[history.md](history.md)を参照。
- `.github/copilot-code-review.yml`は参照日時点で公式ドキュメントに記載が確認できなかった(検索で確認)。互換目的で同梱している。

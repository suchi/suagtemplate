# /babysit-pr(日本語訳)

PR #<引数> の未解決レビュースレッドと最新レビューを確認し、対応する。

## 手順

1. 最新レビューを取得: `gh api repos/{owner}/{repo}/pulls/<番号>/reviews`
2. `gh api graphql`で未解決スレッド(`isResolved: false`)を一覧取得
3. 各指摘について:
   a. コードを修正し、AGENTS.mdの検証コマンドを実行する
   b. コミット(形式はAGENTS.mdに従う)してプッシュする
   c. スレッドに対応内容を日本語で返信する
      (`gh api repos/{owner}/{repo}/pulls/<番号>/comments --method POST -f body="修正しました: ..." -F in_reply_to=COMMENT_ID`)
   d. `resolveReviewThread` GraphQL mutationでスレッドを解決する
4. Copilotに再レビューを依頼する: 必ず`gh pr edit <番号> --add-reviewer @copilot`(gh 2.88.0以上が必要)。REST APIの`.../requested_reviewers`はレビュー済みPRの再レビューをトリガーしない。
5. 未解決スレッドがなく最新レビューが新規コメントなしなら「No New Comment 達成」と報告する。マージはしない — マージには明示的なユーザー承認が必要(/merge-pr)。

## 環境への適応

- ローカルのClaude Code(ghあり): 上記の手順をそのまま実行する。No New Commentになるまで修正のたびにループを回す。
- claude.ai/code(Web、ghなし): 同じ手順をGitHub MCPツールで実行し、subscribe_pr_activityツールでPRを購読してレビューコメント・CIイベントを自動で受け取る。各イベントを上記ループで処理し、PRのマージ/クローズ時またはユーザーの停止指示で購読を解除する。

## 重要ルール

- スレッドをresolveする前に返信を投稿する(Copilotが同じ指摘を繰り返すのを防ぐ)。
- 再レビュー目的でPRをクローズ/リオープン・再作成しない(効果がなく履歴が壊れる)。
- `DELETE .../requested_reviewers`は絶対に使わない(レビュアー状態を壊す)。

# /babysit-pr(日本語訳)

PR #<引数> の未解決レビュースレッドと最新レビューを確認し、対応する。

## 手順

1. 最新レビューを取得: `gh api repos/{owner}/{repo}/pulls/<番号>/reviews`
2. `gh api graphql`で未解決スレッド(`isResolved: false`)を一覧取得
3. 指摘があれば:
   a. コードを修正する
   b. AGENTS.mdの検証コマンド(テスト・リント・ビルド)を実行する
   c. コミット・プッシュする(Conventional Commits: 1行目英語、本文日本語)
   d. 各スレッドに対応内容を日本語で返信する
      (`gh api repos/{owner}/{repo}/pulls/<番号>/comments --method POST -f body="修正しました: ..." -F in_reply_to=COMMENT_ID`)
   e. `resolveReviewThread` GraphQL mutationでスレッドを解決する
   f. Copilotに再レビューを依頼する(下記参照)
4. 未解決スレッドがなく、最新レビューが新規コメントなしなら「No New Comment 達成」と報告する。マージはしない — マージには明示的なユーザー承認が必要(/merge-pr)。

## Copilotレビューの依頼方法

- 初回: `gh pr create --add-reviewer @copilot`、または作成後に`gh pr edit <番号> --add-reviewer @copilot`
- 修正後の再レビュー: 必ず`gh pr edit <番号> --add-reviewer @copilot`を使う(gh 2.88.0以上が必要。`gh --version`で確認)。
  REST APIの`.../requested_reviewers`はレビュー済みPRの再レビューをトリガーしない。

## 重要ルール

- スレッドをresolveする前に必ず返信コメントを投稿する(Copilotが同じ指摘を繰り返すのを防ぐ)。
- 再レビュー目的でPRをクローズ/リオープン・再作成しない(効果がない上に履歴が壊れる)。
- `DELETE .../requested_reviewers`は絶対に使わない(レビュアー状態を壊す)。

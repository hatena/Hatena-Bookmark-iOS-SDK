# はてなブックマーク REST API

## はじめに <a name="intro"></a>

はてなブックマーク REST API を使うと、はてなブックマークのブックマーク、エントリーなどの情報を取得したり、新規に作成・投稿したりできます。

## 本ドキュメントに関する注意事項 <a name="notice"></a>

API の仕様は予告なく変更される可能性があります。

過剰な連続アクセス、 User-Agent を正しく指定しないアクセスなどは予告なしに制限をかける場合があります。

## バージョン <a name="version"></a>

2013年8月現在、バージョン1が提供されています。

## 認証 <a name="authorization"></a>

本 API は OAuth によるユーザー認証に対応しています。OAuth 認証の詳細に関しては、[はてなサービスにおける OAuth](http://developer.hatena.ne.jp/ja/documents/auth/apis/oauth) を参照してください。

## 提供するフォーマット <a name="supported_format"></a>

JSON 形式をサポートしております。各 API の出力の例をご覧ください。

## ブックマーク API <a name="bookmark_api"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="rest/bookmark.md#get_my_bookmark"><code>GET /{version}/my/bookmark</code></a></th>
      <td>ブックマーク情報を取得する</td>
    </tr>
    <tr>
      <th><a href="rest/bookmark.md#post_my_bookmark"><code>POST /{version}/my/bookmark</code></a></th>
      <td>ブックマークを追加または更新する</td>
    </tr>
    <tr>
      <th><a href="rest/bookmark.md#delete_my_bookmark"><code>DELETE /{version}/my/bookmark</code></a></th>
      <td>ブックマークを削除する</td>
    </tr>
  </tbody>
</table>

OAuth 認証したユーザーのブックマークの情報を取得・操作する API です。

## エントリー API <a name="entry_api"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="rest/entry.md#get_entry"><code>GET /{version}/entry</code></a></th>
      <td>ブックマークされたエントリーの情報を取得する</td>
    </tr>
  </tbody>
</table>

ブックマークされたエントリーの情報を取得する API です。

## タグ API <a name="tag_api"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="rest/tags.md#my_tags"><code>GET /{version}/my/tags</code></a></th>
      <td>ユーザーのタグの情報を取得する</td>
    </tr>
  </tbody>
</table>

OAuth 認証したユーザーのタグの情報を取得する API です。

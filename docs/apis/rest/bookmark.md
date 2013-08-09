# はてなブックマーク ブックマーク API

## 本ドキュメントに関する注意事項

本ドキュメントは[はてなブックマーク REST API](../rest.md) の解説の一部です。

## ブックマーク API の概要

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="#get_my_bookmark"><code>GET /{version}/my/bookmark</code></a></th>
      <td>ブックマーク情報を取得する</td>
    </tr>
    <tr>
      <th><a href="#post_my_bookmark"><code>POST /{version}/my/bookmark</code></a></th>
      <td>ブックマークを追加または更新する</td>
    </tr>
    <tr>
      <th><a href="#delete_my_bookmark"><code>DELETE /{version}/my/bookmark</code></a></th>
      <td>ブックマークを削除する</td>
    </tr>
  </tbody>
</table>

## `GET /{version}/my/bookmark` <a name="get_my_bookmark"></a>

### 概要

認証したユーザーのブックマーク情報を取得します。

### URL

```
http://api.b.hatena.ne.jp/{version}/my/bookmark
```

### 認証

[OAuth 認証 (read_public または read_private)](../rest.md#authorization) が必要です。

### HTTP メソッド

HTTP `GET` でアクセスしてください。

### 引数

 * <a href="#get_my_bookmark_parameter_url"><code>url</code></a>

取得したいブックマークの [URL](datatypes.md#url) を <a name="get_my_bookmark_parameter_url"><dfn><code>url</code></dfn></a> 引数に指定します。

### 結果

取得に成功した場合、[ブックマーク](datatypes.md#bookmark)オブジェクトを返します。

ブックマークが存在しない場合、ステータスコード `404` を返します。

リクエストが不正である場合、ステータスコード `400` を返します。

## `POST /{version}/my/bookmark` <a name="post_my_bookmark"></a>

### 概要

認証したユーザーのブックマークを追加・更新します。

既にブックマーク済みのページであれば更新、そうでなければ新たに追加します。

### URL

```
http://api.b.hatena.ne.jp/{version}/my/bookmark
```

### 認証

[OAuth 認証 (write_public または write_private)](../rest.md#authorization) が必要です。

### HTTP メソッド

HTTP `POST` でアクセスしてください。

### 引数

 * <a href="#post_my_bookmark_parameter_url"><code>url</code></a>
 * <a href="#post_my_bookmark_parameter_comment"><code>comment</code></a>
 * <a href="#post_my_bookmark_parameter_tags"><code>tags</code></a>
 * <a href="#post_my_bookmark_parameter_post_twitter"><code>post_twitter</code></a>
 * <a href="#post_my_bookmark_parameter_post_facebook"><code>post_facebook</code></a>
 * <a href="#post_my_bookmark_parameter_post_mixi"><code>post_mixi</code></a>
 * <a href="#post_my_bookmark_parameter_post_evernote"><code>post_evernote</code></a>
 * <a href="#post_my_bookmark_parameter_send_mail"><code>send_mail</code></a>
 * <a href="#post_my_bookmark_parameter_private"><code>private</code></a>

ブックマークしたいページの [URL](datatypes.md#url) を <a name="post_my_bookmark_parameter_url"><dfn><code>url</code></dfn></a> に指定します。

任意でブックマークコメントを <a name="post_my_bookmark_parameter_comment"><dfn><code>comment</code></dfn></a> に指定することができます。

任意でブックマークにタグをつけることができます。<a name="post_my_bookmark_parameter_tags"><dfn><code>tags</code></dfn></a> 引数を最大10個まで指定することができます。

ブックマークした際に各種外部サービスに共有することができます。それぞれのサービスについて OAuth 認証したうえで <a name="post_my_bookmark_parameter_twitter"><dfn><code>post_twitter</code></dfn></a>, <a name="post_my_bookmark_parameter_facebook"><dfn><code>post_facebook</code></dfn></a>, <a name="post_my_bookmark_parameter_post_mixi_check"><dfn><code>post_mixi_check</code></dfn></a>, <a name="post_my_bookmark_parameter_post_evernot"><dfn><code>post_evernote</code></dfn></a> 引数に[真値](datatypes.md#boolean)を渡すと共有できます。

ブックマークを非公開にする場合は <a name="post_my_bookmark_parameter_private"><dfn><code>private</code></dfn></a> 引数に[真値](datatypes.md#boolean)を渡します。

### 結果

追加または更新に成功した場合、[ブックマーク](datatypes.md#bookmark)オブジェクトを返します。

リクエストが不正である場合、ステータスコード `400` を返します。

## `DELETE /{version}/my/bookmark` <a name="delete_my_bookmark"></a>

### 概要

認証したユーザーのブックマークを削除します。

### URL

```
http://api.b.hatena.ne.jp/{version}/my/bookmark
```

### 認証

[OAuth 認証 (write_public または write_private)](../rest.md#authorization) が必要です。

### HTTP メソッド

HTTP `DELETE` でアクセスしてください。

### 引数

 * <a href="#delete_my_bookmark_parameter_url"><code>url</code></a>

削除したいブックマークの [URL](datatypes.md#url) を <a name="delete_my_bookmark_parameter_url"><dfn><code>url</code></dfn></a> 引数に指定します。

### 結果

削除に成功した場合、ステータスコード `204` を返します。

ブックマークが存在しない場合、ステータスコード `404` を返します。

リクエストが不正である場合、ステータスコード `400` を返します。

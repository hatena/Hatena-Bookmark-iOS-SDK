# はてなブックマーク タグ API

## 本ドキュメントに関する注意事項 <a name="notice"></a>

本ドキュメントは[はてなブックマーク REST API](../rest.md) の解説の一部です。

## タグ情報 API の概要 <a name="summary"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="#get_my_tag"><code>GET /{version}/my/tags</code></a></th>
      <td>ユーザーのタグを取得する</td>
    </tr>
  </tbody>
</table>

## `GET /{version}/my/tags` <a name="get_my_tags"></a>

### 概要 <a name="get_my_tags_summary"></a>

認証したユーザーの使用しているタグの情報を取得します。

### URL <a name="get_my_tags_url"></a>

```
http://api.b.hatena.ne.jp/{version}/my/tags
```

### 認証 <a name="get_my_tags_authorization"></a>

[OAuth 認証 (read_private)](../rest.md#authorization) が必要です。

### HTTP メソッド <a name="get_my_tags_http_method"></a>

HTTP `GET` でアクセスしてください。

### 結果 <a name="get_my_tags_response"></a>

取得に成功した場合、[タグ](datatypes.md#tag)オブジェクトを返します。


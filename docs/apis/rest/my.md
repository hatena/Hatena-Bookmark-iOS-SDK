# はてなブックマーク ユーザ情報 API

## 本ドキュメントに関する注意事項 <a name="notice"></a>

本ドキュメントは[はてなブックマーク REST API](../rest.md) の解説の一部です。

## ユーザ情報 API の概要 <a name="summary"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="#get_my"><code>GET /<var>{version}</var>/my</code></a></th>
      <td>ユーザーの情報を取得する</td>
    </tr>
  </tbody>
</table>

## `GET /{version}/my` <a name="get_my"></a>

### 概要 <a name="get_my_summary"></a>

認証したユーザーの情報を取得します。

### URL <a name="get_my_url"></a>

```
http://api.b.hatena.ne.jp/{version}/my
```

### 認証 <a name="get_my_authorization"></a>

[OAuth 認証 (read_private)](../rest.md#authorization) が必要です。

### HTTP メソッド <a name="get_my_http_method"></a>

HTTP `GET` でアクセスしてください。

### 結果 <a name="get_my_response"></a>

取得に成功した場合、[ユーザー](datatypes.md#user)オブジェクトを返します。


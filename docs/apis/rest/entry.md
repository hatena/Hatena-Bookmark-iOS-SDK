# はてなブックマーク エントリ API

## 本ドキュメントに関する注意事項 <a name="notice"></a>

本ドキュメントは[はてなブックマーク REST API](../rest.md) の解説の一部です。

## エントリ API の概要 <a name="summary"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>実行する操作</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><a href="#get_entry"><code>GET /{version}/entry</code></a></th>
      <td>ブックマークされたエントリーの情報を取得する</td>
    </tr>
  </tbody>
</table>

## `GET /{version}/entry` <a name="get_entry"></a>

### 概要 <a name="get_entry_summary"></a>

エントリーの情報を取得します。

### URL <a name="get_entry_url"></a>

```
http://api.b.hatena.ne.jp/{version}/entry
```

### 引数 <a name="get_entry_parameters"></a>

 * <a href="#get_entry_parameter_url"><code>url</code></a>

取得したいエントリーの [URL](datatypes.md#url) を <a name="get_my_bookmark_parameter_url"><dfn><code>url</code></dfn></a> 引数に指定します。

### 認証 <a name="get_entry_authorization"></a>

[OAuth 認証 (read_private)](../rest.md#authorization) が必要です。

### HTTP メソッド <a name="get_entry_http_method"></a>

HTTP `GET` でアクセスしてください。

### 結果 <a name="get_entry_response"></a>

取得に成功した場合、[エントリー](datatypes.md#entry)オブジェクトを返します。


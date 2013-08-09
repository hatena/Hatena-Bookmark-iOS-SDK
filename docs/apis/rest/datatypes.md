# はてなブックマーク REST API のデータの書式

## 本ドキュメントに関する注意事項 <a name="notice"></a>

本ドキュメントは[はてなブックマーク REST API](../rest.md) の解説の一部です。

## API が返すデータの書式 <a name="output_format"></a>

はてなブックマーク REST API は、処理が成功した場合に JSON により結果を返します。結果は UTF-8 で符号化されています。

はてなブックマーク REST API は、処理が失敗した場合には `401`, `401`, `404` などの HTTP 応答を返します。この場合、JSON 形式で結果が返されるとは限りません。

## API に渡すデータの書式 <a name="input_format"></a>

はてなブックマーク REST API に引数を指定する場合、HTTP の `GET` メソッドであれば URL の query 部分に、`POST` メソッドであれば entity-body に <a href="http://www.whatwg.org/specs/web-apps/current-work/#application/x-www-form-urlencoded-encoding-algorithm"><code>application/x-www-form-urlencoded</code></a> 形式で記述してください。文字列はすべて UTF-8 により符号化しておく必要があります。

HTTP の `POST` メソッドを使用する場合は、`application/x-www-form-urlencoded` 形式のかわりに `multipart/form-data` 形式としても構いません。

## ブックマーク <a name="bookmark></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>意味</th>
      <th>データ型</th>
      <th>個数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><code>comment</code></th>
      <td>ブックマークコメント</td>
      <td>文字列</td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>created_datetime</code></th>
      <td>ブックマークした日時</td>
      <td><a href="#datetime">日時</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>created_epoch</code></th>
      <td>ブックマークした日時を表す UNIX epoch time</td>
      <td><a href="#number">数値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>user</code></th>
      <td>ブックマークしたユーザーのはてな ID</td>
      <td>文字列</td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>permalink</code></th>
      <td>ブックマークを表す URL</td>
      <td><a href="#url">URL</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>private</code></th>
      <td>非公開でブックマークされたかどうかを表す</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>tags</code></th>
      <td>ブックマークにつけられたタグ</td>
      <td><a href="#tag">タグ</a>の配列</td>
      <td>1</td>
    </tr>
  </tbody>
</table>

## エントリ <a name="entry"></a>

<dfn>エントリ</dfn>オブジェクトには、次の値が含まれます。

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>意味</th>
      <th>データ型</th>
      <th>個数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><code>title</code></th>
      <td>エントリーのタイトル</td>
      <td>文字列</td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>url</code></th>
      <td>エントリーの URL</td>
      <td><a href="#url">URL</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>entry_url</code></th>
      <td>エントリーページの URL</td>
      <td><a href="#url">URL</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>count</code></th>
      <td>ブックマークの数</td>
      <td><a href="#number">数値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>favicon_url</code></th>
      <td>Favicon の URL</td>
      <td><a href="#url">URL</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>smartphone_app_entry_url</code></th>
      <td>スマートフォンむけにヘッダーなどを省略したコメント一覧ページの URL</td>
      <td><a href="#url">URL</a></td>
      <td>1</td>
    </tr>
  </tbody>
</table>

## ユーザー情報 <a name="user"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>意味</th>
      <th>データ型</th>
      <th>個数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><code>name</code></th>
      <td>ユーザーのはてな ID</td>
      <td>文字列</td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>plususer</code></th>
      <td>はてなブックマークのプラスユーザーかどうか</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>private</code></th>
      <td></td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>is_oauth_twitter</code></th>
      <td>Twitter を OAuth 認証しているかどうか</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>is_oauth_evernote</code></th>
      <td>Evernote を OAuth 認証しているかどうか</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>is_oauth_facebook</code></th>
      <td>Facebook を OAuth で認証しているかどうか</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>is_oauth_mixi_check</code></th>
      <td>mixi を OAuth で認証しているかどうか</td>
      <td><a href="#boolean">真偽値</a></td>
      <td>1</td>
    </tr>
  </tbody>
</table>

## タグ <a name="tag"></a>

<table>
  <thead>
    <tr>
      <th>名前</th>
      <th>意味</th>
      <th>データ型</th>
      <th>個数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><code>count</code></th>
      <td>タグがつけられたブックマークの数</td>
      <td><a href="#number">数値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>modified_epoch</code></th>
      <td>タグが最後に使用された日時を表す UNIX epoch time</td>
      <td><a href="#number">数値</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>modified_datetime</code></th>
      <td>タグが最後に使用された日時</td>
      <td><a href="#datetime">日時</a></td>
      <td>1</td>
    </tr>
    <tr>
      <th><code>tag</code></th>
      <td>タグを表す文字列</td>
      <td>文字列</td>
      <td>1</td>
    </tr>
  </tbody>
</table>

## 値のデータ型 <a name="value_type"></a>

### 真偽値 <a name="boolean"></a>

<dfn>真偽値</dfn>は、偽を `null`, 数値の `0`, 文字列の `0` のいずれかにより、真をそれ以外の値により表します。

### 数値 <a name="number"></a>

<dfn>数値</dfn>は、数値または数値を文字列化したものによって表します。

### 日時 <a name="datetime"></a>

日時は、[妥当な大域日時文字列](http://www.whatwg.org/specs/web-apps/current-work/complete.html#valid-global-date-and-time-string)によって表します。

はてなブックマーク REST API では、「<dfn>HTTP の日時</dfn>」とは RFC 2616 における [rfc1123-date](http://tools.ietf.org/html/rfc2616#page-21) を意味します。

### URL <a name="url"></a>

<dfn>URL</dfn> は、[絶対 URL](http://www.whatwg.org/specs/web-apps/current-work/complete.html#absolute-url) によって表します。

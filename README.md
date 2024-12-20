# Generative_Monster
■サービス概要
# どんなサービスなのかを３行で説明してください。
生成AIで生成したキャラ（モンスター、ロボット、ヒーロー）を戦わせるゲーム。
ユーザーが入力した短い説明を元に、体力、防御力、素早さ、属性、説明文、名前および画像を生成する。
生成したキャラはデータベースに記録され、データベースから選択した2体のキャラ同士を戦わせる（戦闘の様子についての文章と、勝敗を生成する。操作はできない）。

■ このサービスへの思い・作りたい理由
# このサービスの題材となるものに関してのエピソードがあれば詳しく教えてください。
# このサービスを思いつくにあたって元となる思いがあれば詳しく教えてください。
様々なゲームをプレイする中で、通常のゲームはどうしても開発者が用意したものしか体験できないという欠点があると感じました。
そこで、生成AIの技術を活用し、予測できない物語の展開を楽しめるゲームを作りたいと考えました。

■ ユーザー層について
# 決めたユーザー層についてどうしてその層を対象にしたのかそれぞれ理由を教えてください。
RPGやノベルゲームなどのストーリー重視のゲームが好きな人。
単に戦闘シミュレーションではなく、「キャラ生成」から「戦闘結果の物語生成」まで一貫してストーリー性を重視しているという点で、そのような層に魅力的だと考えています。

■サービスの利用イメージ
# ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるかを簡単に説明してください。
プレイヤーが自分のイメージに合ったオリジナルキャラクターを生成し、戦わせて楽しむことができます。まず、プレイヤーは簡単な説明文を入力します。この入力に基づいて生成AIがキャラクターを作成し、体力や防御力、素早さ、属性といった能力値、名前、説明文、さらには画像が自動で生成されます。

生成されたキャラクターはデータベースに保存され、ユーザーはそのキャラクターをいつでも一覧から確認できます。そして、データベースから選んだ2体のキャラクターを戦わせることで、戦闘の詳細な描写や結果が物語形式で楽しめます。例えば、キャラクター同士の属性による有利不利がストーリーに反映されます。

さらに、生成されたキャラクターや戦闘結果はSNSで共有することができ、他のユーザーとも楽しみを分かち合うことが可能です。

■ ユーザーの獲得について
# 想定したユーザー層に対してそれぞれどのようにサービスを届けるのか現状考えていることがあれば教えてください。
RUNTEQのコミュニティに共有
ユーザーが自分の生成キャラクターやプレイ内容をSNSで共有しやすい仕組みを提供

■ サービスの差別化ポイント・推しポイント
# 似たようなサービスが存在する場合、そのサービスとの明確な差別化ポイントとその差別化ポイントのどこが優れているのか教えてください。
# 独自性の強いサービスの場合、このサービスの推しとなるポイントを教えてください。
最大の魅力は、生成AIを活用して多彩なキャラクター同士を戦わせる点にあります。モンスター、ロボット、ヒーローといった異なるジャンルのキャラクター同士を戦わせることで、予想外の展開を体験できます。また、生成AIが戦闘中のエピソードや詳細な描写を物語として生成するため、単なる勝敗結果ではなく、感情移入できる「物語性」を楽しむことができます。この物語性によって、深い没入感を与えることができます。さらに、プレイヤーはキャラクターの説明文を自由に入力することで、生成されるキャラクターやストーリーに独自性を持たせることが可能です。これにより、ユーザー自身が創作者となる新しい楽しみを提供します。

■ 機能候補
# 現状作ろうと思っている機能、案段階の機能をしっかりと固まっていなくても構わないのでMVPリリース時に作っていたいもの、本リリースまでに作っていたいものをそれぞれ分けて教えてください。
現状作ろうと思っている機能
    ユーザー登録機能
    キャラを生成する機能
    生成したキャラを一覧表示する機能
    キャラ同士を戦わせる機能
    生成したキャラやプレイ内容を共有する機能
    キャラの生成や、戦闘の開始前に動画広告を流す機能

MVPリリース時に作っていたいもの
    ユーザー登録機能
    キャラを生成する機能
    生成したキャラを一覧表示する機能
    キャラ同士を戦わせる機能

本リリースまでに作っていたいもの
    生成したキャラやプレイ内容をSNSで共有する機能
    キャラの生成や、戦闘の開始前に動画広告を流す機能

■ 機能の実装方針予定
# 一般的なCRUD以外の実装予定の機能についてそれぞれどのようなイメージ(使用するAPIや)で実装する予定なのか現状考えているもので良いので教えて下さい。
ユーザー登録関連: Devise
広告関連: Google AdMob
生成AI関連 OpenAI API
SNS共有関連: APIは使用せず、戦闘結果の文章や生成したキャラへの詳細ページURLを共有できるようにしたいです。
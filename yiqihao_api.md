![logo](http://www.yiqihao.com/public/hao/img/logo.png)

一起好API (2014/12/31 - Oopos)
-------

---
更新日志：
---
*	2014/12/31	增加投资详情、获取推荐有奖列表接口
*	2014/12/12	兼容金米理财APP接口、增加安全支付接口


---
**一、公共API及参数说明**

* 接口约定
    
    1) 接口中的字段若包含资源文件，如：图片、文档等，比如：/public/hao/img/logo.png，以/开头需要加上
    服务器域名构造完整url进行请求，以http://,https://等开头则可以直接请求。
    
    2) 如果不采用COOKIE机制来进行会话，则所有请求都必须先获取session_key并作为参数带上去，login或auth成功后需要刷新session_key。
   
    3) 如果是手机客户端或AJAX请求，请带上format参数，建议设置为json格式。

* 公共参数及请求约定
        
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        format      |   string  |   否      |   默认为：web方式,暂时支持json,xml两种格式
        session_key |   string  |   否      |   当使用/user/auth接口进行会话后,必须带上
        client      |   string  |   否      |   客户端/版本-平台/系统版本号，如：yqhmobile/1.0.0-ios/7.0.4，移动客户端需带上
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        date        |   string  |   否      |   日期，格式：yyyy-mm-dd，如：2012-12-12
        sdate       |   string  |   否      |   开始日期，如：2012-12-12
        edate       |   string  |   否      |   截止日期，如：2012-12-12

    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data":{/*数据字段*/
                        "list":[],/*数据列表*/
                        "addtime": "添加时间",
                        "uptime": "更新时间",
                    },
                "page": {/*分页字段*/
                        "size": 1,/*每页大小*/
                        "count": 675,/*记录数*/
                        "total": 675,*总页数*/
                        "now": 1,/*当前页*/
                        "prev": 0,/*上一页*/
                        "next": 2,/*下一页*/
                        "up": 1,/*上一屏起始页码*/
                        "down": 11,/*下一屏起始页码*/
                        "list": [/*页码列表*/
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7,
                            8,
                            9,
                            10
                        ]
                    },
                "msg": "成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "验证码不正确",
                "use_captcha": 1,/*存在此项时，则必须带上验证码请求*/
            }

        XML:
            
            --- 成功 ---
            <?xml version="1.0" encoding="utf-8"?>
            <ops>
                <return>1</return>
                <msg>成功</msg>
            </ops>
            
            --- 失败 ---
            <?xml version="1.0" encoding="utf-8"?>
            <ops>
                <return>0</return>
                <errmsg>不正确</errmsg>
                <use_captcha>1</use_captcha><!--存在此项时，则必须带上系统验证码-->
            </ops>
         
* 获取系统验证码图片 /get/captcha
    * 特别说明： 必须通过 f=1 或 type=bid 获取投标验证码
    * 请求方式: GET
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        w       |   string  |   否      |   图片宽度，默认为100
        h       |   string  |   否      |   图片高度，默认为35
        c       |   string  |   否      |   字体颜色（#开头 或者 blue,red...）
        t       |   string  |   否      |   图片类型，可以是：png,jpg,gif等
        f       |   string  |   否      |   1-数字验证码
        type    |   string  |   否      |   默认为字母验证码，type=num 数字验证码, type=bid 投标验证
    
    * 返回结果： 图片资源，默认为png图片
        
        ![alt "验证码"](http://www.yiqihao.com/get/captcha)
        
* 发送短信验证码 /send/smscode/[type] or ?type=[type]
    * 请求方式： GET | POST
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        type    |   string  |   是      |   短信验证码类型，可以是：reg,auth,bankcard,getpwd,drawcash等
        captcha |   string  |   否, PC端必需     |   系统验证码, 当系统要求时需带上
        mobile  |   string  |   否      |   手机号，当type=reg,auth时才需带上
        money   |   string  |   否      |   当type=drawcash时才需带上
        retry   |   int     |   否      |   当重试发送时，需要带上，第一次重试retry=1，第二次retry=2，以次类推
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "发送短信成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "验证码不正确",
                "use_captcha": 1,/*存在此项时，则必须带上验证码请求*/
            }
        
           
* 发送邮件验证码 /send/emailcode/[type] or ?type=[type]
    * 请求方式: POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        type    |   string  |   是      |   邮件证码类型，可以是：reg,login,getpwd等
        captcha |   string  |   否      |   系统验证码, 当系统要求时需带上
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "发送短信成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "验证码不正确",
                "use_captcha": 1,/*存在此项时，则必须使用验证码登录*/
            }

---
**二、用户及权限**

* 登录 /user/login
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        account     |   string  |   是      |   账号，可以是手机号、邮箱等
        password    |   string  |   是      |   密码
        captcha     |   string  |   否      |   验证码，当系统要求验证码时必须带上
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,/*返回值,0->出错,1->成功*/
                "redirect": "/", /*跳转URL*/
                "data": {
                    "uid": "100008",/*用户ID*/
                    "utype": "0", /*户类型：0-理财人,1-贷款人,2-机构,3-机构债权人*/
                    "ugroup": "default", /*用户分组：default-默认*/
                    "auid": "0",/*所属机构ID*/
                    "umobile": "1862118****", /*不为空，表示手机已经认证*/
                    "omobile": "",/*旧手机号*/
                    "uname": "oopos",/*用户名*/
                    "uemail": "****opos@gmail.com", /*不为空，表示邮箱已经认证*/
                    "password": "*",/*登录密码*/
                    "paypwd": "*",/*支付密码*/
                    "question": "fsdfds",/*密保问题*/
                    "answer": "*",/*密保答案*/
                    "idcard": "36072********251", /*身份证号*/
                    "realname": "王五", /*真实姓名*/
                    "amount": "106873855.34", /*可用余额*/
                    "freeze": "872632.64", /*冻结金额*/
                    "feedraw": "106583331.34",/*可提现金额*/
                    "credit_amount": "0",/*可用授信*/
                    "credit_used": "0",/*已用额度*/
                    "credit": "0",/*信用等级*/
                    "score": "100819.0",/*会员积分*/
                    "avlscore": "98401.4",/*可用积分*/
                    "avatar": "upload/avatar/8/100008_avatar_[size].jpg",
                    "vip": "3",/*会员等级：0-普通会员,2-银牌会员,3-金牌会员,8-白金会员*/
                    "viptime": "0",/*会员升级时间*/
                    "hviptime": "0",/*白金会员升级时间*/
                    "status": "11",/*状态:1-未激活,2-已锁定,3-已注销,11-正常*/
                    "province": "上海", /*所在地区*/
                    "auth_idcard": "1", /*是否实名认证：0-未认证，1-已认证*/
                    "auth_bankcard":"0", /*是否通过银行卡认证*/
                    "draw_quick": "0",/*能否预约提现*/
                    "invite_uid": "0", /*上级UID*/
                    "channel": "0", /*渠道*/
                    "invite_money": "0.00", /*贡献奖励金额*/
                    "last_login_time": "1358826156", /*上次登录时间*/
                    "last_login_ip": "127.0.0.1", /*上次登录IP'*/
                    "login_count": "346",/*登陆次数*/
                    "login_time": "1383616081",  /*登录时间*/
                    "login_ip": "111.173.15.126",
                    "error_count": "0", /*登录错误次数*/
                    "error_time": "1383544813", /*错误时间*/
                    "addtime": "1348796489",
                    "uptime": "1382792740",
                    "version": "705", /*版本号*/
                    "msg_bid_sms": "1", /*是否接收放款短信: 1-接收*/
                    "msg_repay_sms": "1", /*是否接收还款短信: 1-接收*/
                    "msg_push_sms": "1", /*是否接收推送短信：1-接收*/
                    "is_follow_home": "0",/*是否只有已关注的人，才有权限访问主页*/
                    "bid_rank": 0, /*投标排名*/
                    "unread_msgcount": 0, /*未读消息数*/
                    "tender_count": 3, /*投标次数 */
                    "loan_count": 0, /*借款次数*/
                    "invest_tendering": 0, /*投标中的投资*/
                    "invest_repaying": 0, /*还款中的投资*/
                    "invest_ok": 0, /*已完成的投资*/
                    "invest_interest": "0.00", /*收益*/
                    "interest_fee": "0.00", /*利息管理费*/
                    "earn_interest": "0.00", /*赚取利息*/
                    "wait_return_amount": "0.00", /*待回收总额*/
                    "wait_repay_amount": "0.00", /*待还总额*/
                    "msg_sub_url": "http://notify.yiqihao.com:8808/sub?cname=test-public&uid=105342",
                    "avatar_url": "/public/upload/avatar/42/105342_avatar_200x200.jpg", /*头像地址*/
                    "recharged": "1"  /*已充值*/             
                   }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "账号不存在或密码错误",
                "use_captcha": 1,/*存在此项时，则必须使用验证码登录*/
            }
            

* 获取会话密钥 /user/auth
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        account     |   string  |   是      |   账号，可以是手机号、邮箱
        password    |   string  |   是      |   密码，当使用/user/auth返回的auto_pwd作为密码时，可以使用用户名登录
        captcha     |   string  |   否      |   验证码，当系统要求验证码时必须带上

    * 返回结果： 请参考 /user/login, 只是增加了session_key,auto_pwd,push_server返回
        
        JSON:
        
            {
                "return": 1,
                "session_key": "100008:029548dbe961ed0ce1b257087af6f8a0:PXvrC__MkPvhRiLIjLXfWDB5zXqlPGxLIYJm79jkTgNAtb2aa_1SLiJkWPCdZwI_yhsNbGp-t-XFVfCzxFgfWY8YleZA55xmMnvR9-iql20.", /*会话key*/
                "push_server": {
                    "public": "http://10.0.0.88:88/notify/test-public",/*公共消息通道*/
                    "user": "http://10.0.0.88:88/notify/test-100008"/*私有消息通道*/
                },
                "auto_pwd": "fb56d4904e0f96e4f650d627ae6384a4eed6de9d",/*自动登录密码*/
                "data": {
                    /*参考/user/login*/
                }
            }
            
        
* 登出、注销 /user/logout
    
    * 请求方式: GET | POST
        
    * 返回结果： JSON | XML
        
        JSON:
            
            ---  成功 ---
            {
                "return": 1,
                "msg": "登出成功"
            }

            ---  失败 ---
            {   
                "return": 0,
                "errmsg": "登出失败"
            }

* 获取会话session_key或session_id：/user/session_key或/user/session_id
    * 请求方式：GET
    * 返回结果：JSON | XML
            
            ---  成功 ---
            {
                "return": 1,
                "session_key": "0:73b681650807fb6d85e9945d718ef859:"
            }
        
* 注册 /user/reg/[method] method可以是空、mobile、email，默认为mobile
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        mobile      |   string  |   是      |   手机号
        name        |   string  |   是      |   用户名或昵称
        email       |   string  |   否      |   邮箱
        realname    |   string  |   否      |   真实姓名
        password    |   string  |   是      |   密码
        captcha     |   string  |   否,PC端通过验证码获取短信验证码      |   验证码,不支持COOKIE时,需要先获取session_key，然后带上session_key=获取
        smscode     |   string  |   否      |   短信验证码，当使用手机注册时需带上
        emailcode   |   string  |   否      |   邮件验证码，当使用邮箱注册时需带上
    
    * 返回结果： JSON | XML
        JSON:
            
            ---  成功 ---
            {
                "return": 1,
                "data": {
                    "umobile": "18621181113", /*手机号*/
                    "uname": "ops2014", /*用户名*/
                    "addtime": 1345198794, /*注册时间*/
                    "addip": "127.0.0.1", /*注册IP*/
                    "uid": "10",   /用户ID*/
                    "freeze": "0.00",  /*冻结金额*/
                    "amount": "0.00",  /*账户余额*/
                    "score": "0",  /*积分*/
                    "credit": "0"  /*信用等级*/
                }
            }
            
            ---  失败 ---
            {
                "return": 0,
                "errmsg": "手机号已存在"
            }

* 找回密码 /user/getpwd/[method]，method可以是mobile,email，默认为mobile
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        method      |   string  |   否      |   找回方式，可以是mobile、email，默认为mobile
        mobile      |   string  |   否      |   手机号码，当使用mobile方式时需带上
        email       |   string  |   否      |   手机号码，当使用email方式时需带上
        type        |   string  |   是      |   密码类型：pay-支付密码, login-登录密码
        password    |   string  |   否      |   原登录密码，当找回支付密码时需带上
        newpassword |   string  |   是      |   要设置的支付、登录新密码
        newpassword2|   string  |   否      |   要设置的支付、登录新密码
        smscode     |   string  |   是      |   短信校验码：获取/user/smscode/getpwd?mobile=
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "新的支付密码已设置成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "短信校验码不正确",
            }

* 检查用户是否注册 /user/check/[type]，type可以是mobile,email,name
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        type        |   string  |   是      |   检查字段类型，可以是mobile,email,name
        value       |   string  |   是      |   字段参数值
        sendcode    |   string  |   否      |   是否自动发送注册验证码，暂时只支持mobile类型, 1-是,0或不传-否
    
    * 返回结果：JSON | XML
    
        JSON:
       
            --- 已存在 ---
            {
                "return": 0,
                "errmsg": "已存在"
            }
            
            --- 不存在 ---
            {
                "return": 1,
                "msg": "不存在"
            }
           
            --- 出错 ---
            {
                "return": 0,
                "errmsg": "参数错误",
            }

    
* 获取用户信息 /user/getinfo
    * 请求方式: GET | POST
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            
            {
                "return": 1,
                "data": {
                    "uid": "100008",
                    "utype": "0",  /*用户类型：0-理财人,1-贷款人,2-机构,3-机构债权人*/
                    "ugroup": "default", /*用户分组：default-默认*/
                    "auid": "0", /*所属机构ID*/
                    "umobile": "1862118****", /*手机号码*/
                    "omobile": "", /*旧手机号码*/
                    "uname": "oopos",  /*用户名*/
                    "uemail": "***opos@gmail.com", /*邮箱*/
                    "idcard": "36072*********5251", /*身份证号*/
                    "realname": "张东", /*真实姓名*/
                    "amount": "1974.57", /*账户余额*/
                    "freeze": "0.00", /*冻结金额*/
                    "feedraw": "0.00", /*可提现总额*/
                    "vcredit": "100000.00", /*授信额度*/
                    "avcredit": "100000.00", /*可用授信额度*/
                    "credit_amount": "0", /*可用额度*/
                    "credit_used": "0", /*已用额度*/
                    "credit": "0", /*信用等级*/
                    "score": "12913.1", /*积分*/
                    "avlscore": "8113.1",  /*可用积分*/
                    "avatar": "upload/avatar/8/100008_avatar_[size].jpg",  /*头像地址*/
                    "vip": "8", /*账号等级*/
                    "viptime": "0", /*升级时间*/
                    "hviptime": "1367341221", /*白金会员升级时间*/
                    "status": "11", /*状态:1-未激活,2-已锁定,3-已注销,11-正常*/
                    "province": "上海", /*所在地区*/
                    "auth_idcard": "0", /*是否通过身份认证*/
                    "auth_bankcard": "0", /*是否通过银行卡认证*/
                    "draw_quick": "1", /*能否预约提现*/
                    "invite_uid": "0", /*上级UID*/
                    "channel": "0", /*渠道*/
                    "invite_money": "0.00", /*贡献奖励金额*/
                    "last_login_time": "1383624587", /*上次登录时间*/
                    "last_login_ip": "183.94.72.79", /*上次登录IP*/
                    "login_count": "1515", /*登录次数*/
                    "login_time": "1383641780", /*登录时间*/
                    "login_ip": "111.173.15.126", /*登录IP*/
                    "error_count": "0", /*错误次数*/
                    "error_time": "1383470607", /*错误时间*/
                    "addtime": "1348796489", /*创建时间*/
                    "uptime": "1383117525", /*所在地区*/
                    "version": "966", /*更新时间*/
                    "msg_bid_sms": "1", /*是否接收放款短信: 1-接收*/
                    "msg_repay_sms": "1", /*是否接收还款短信: 1-接收*/
                    "msg_push_sms": "1", /*是否接收推送短信：1-接收*/
                    "tender_count": 118, /*投标次数*/
                    "loan_count": 0, /*贷款次数*/
                    "invest_tendering": 0, /*投标中的投资数量*/
                    "invest_repaying": 19, /*还款中的投资数量*/
                    "invest_ok": 97, /*完成还款的投资数量*/
                    "invest_interest": "71521.97", /*累计赚取利息收益*/
                    "interest_fee": "3576.10", /*利息管理费*/
                    "earn_interest": "67945.87", /*净赚取利息收益*/
                    "wait_return_amount": "150986.92", /*待收总额*/
                    "wait_repay_amount": "0.00", /*待还总额*/
                    "msg_sub_url": "http://beta.yiqihao.com:8808/sub?cname=test-public&uid=100013",/*消息接收url*/
                    "avatar_url": "/public/upload/avatar/8/100008_avatar_100x100.jpg",
                    "bid_rank": 11,
                    "unread_msgcount": 0, /*未读消息数*/
                    "total_amount": "152961.49", /*总资产*/
                    "nearn_trends": [1,2,3,4,5], /*近N天收益走势*/
                    "today_earn": "1.00" /*今日赚取收益*/
                    "wait_return_amount": "0.00",
                    "wait_repay_amount": "0.00",
                    "msg_sub_url": "http://notify.yiqihao.com:8808/sub?cname=test-public&uid=105342",
                    "avatar_url": "/public/upload/avatar/42/105342_avatar_200x200.jpg",
                    "total_amount": "100000000.00",
                    "recharged": "1", /*已充值*/
                }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "用户未登录"
            }


---
**三、贷款相关**

* 申请贷款 /loan/post
    * 请求方式: POST
    
        参数名      |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        title       |   string  |   是      |   贷款标题，长度：2~30个汉字
        img         |   string  |   是      |   贷款图片地址(系统图片序号范围：1~999)，长度：1~128字节
        use_type    |   int     |   是      |   贷款用途
        amount      |   double  |   是      |   贷款金额 
        deadline    |   int     |   是      |   贷款期限，范围1~36
        apr         |   double  |   是      |   年利率
        repay_method|   char    |   是      |   还款方式，取值：m-等额本息,i-按月付息,e-到期还本息
        exptime     |   int     |   是      |   筹标期限，默认为：3天
        description |   string  |   是      |   贷款描述，长度：6~10240 字节
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "id": "100001", /*贷款编号*/
                "url": "/loan/up", /*跳转URL*/
                "msg": "贷款申请已提交，请尽快上传认证材料"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "贷款提交失败"
            }
            或
            {
                "return": 0,
                "errmsg": "贷款XX不正确"
            }


* 贷款列表 /loan/list
    * 请求方式: POST | GET
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        type        |   string  |   否      |   贷款列表类别，all-全部(默认),new-最新,newok-最近成功,newfull-满标待审
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        sort        |   string  |   否      |   排序：[type]-[asc|desc],如:amount-asc，type可以是：amount,deadline,apr,credit,progress,exptime
        keyword     |   string  |   否      |   搜索关键词, 暂时只搜索：贷款标题
        credit      |   string  |   否      |   信用等级，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:3-表示3星以上
        apr         |   string  |   否      |   收益率，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:12-表示12以上
        deadline    |   string  |   否      |   期限，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:-1表示1个月内
        exptime     |   string  |   否      |   剩余时间，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:-1表示1天内
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功 ---

            {
                "return": 1,
                "data": {
                    /*默认分页*/
                    "page": {
                        "size": 10,
                        "count": 168,
                        "total": 17,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7,
                            8,
                            9,
                            10
                        ]
                    },
                    /*贷款列表*/
                    "list": [
                        {
                            "lid": "100209",
                            "plid": "100206",
                            "uid": "100707",
                            "lgroup": "default", /*项目分组：default-默认*/
                            "buid": "0", /*实际借款人ID*/
                            "auid": "1", /*所属机构ID*/
                            "title": "资金周转续借25万",
                            "img": "/public/upload/loanimg/7/100707_mf0mre494026_100x100.jpg",
                            "type": "4", /*标类型*/
                            "is_flow": "1", /*是否为流转标*/
                            "is_syncday": "0",  /*流转标是否同步债权还款日*/
                            "is_field": "1",    /*是否为实地认证*/
                            "is_plan": "1", /*是否保障计划*/
                            "is_okout": "0",    /*是否自动放款*/
                            "is_newbie": "0",   /*是否为新手专享*/
                            "is_vip": "0",  /*是否为VIP会员专享投标：0-无，3-金牌会员，8-白金会员*/
                            "no_captcha": "0",  /*无需验证码*/
                            "is_mobile": "0",   /*是否为手机客户端专享投标*/
                            "is_carloan": "0",  /*是否为车标*/
                            "use_type": "1", /*贷款用户*/
                            "amount": "20000", /*贷款金额*/
                            "remain_amount": "0.00", /*剩余本金*/
                            "return_amount": "0.00", /*已还总额*/
                            "repay_num": "0", /*已还期数*/
                            "late_fee": "0.00", /*逾期费用*/
                            "early_fee": "0.00", /*违约金*/
                            "mfee_rate": "0.50", /*管理费用*/
                            "field_fee": "0.00", /*实地考察费*/
                            "credit_fee": "0.00", /*征信待察费*/
                            "other_fee": "0.00", /*其它服务费*/
                            "tender_amount": "20000", /*已投标总额*/
                            "flow_amount": "3500",/*已流转金额*/
                            "repo_amount": "0",/*已回购金额*/
                            "flow_date": "20140703",/*流转处理日期*/
                            "tender_min": "0", /*最低投标金额*/
                            "tender_max": "0", /*最高投标金额*/
                            "tender_limit_times": "0", /*投标次数限制*/
                            "tender_count": "1", /*已投标次数*/
                            "tender_begin": "1357816862", /*招标开始时间*/
                            "tender_end": "1357816881", /*招标截止时间*/
                            "deadline": "1", /*贷款期限*/
                            "deadline_type": "m", /*贷款期限单位：m-月、d-天*/
                            "apr": "20.00", /*年利率*/
                            "reward_apr": "3.00", /*奖励年利率*/
                            "reward_money": "0", /*投标奖励金额*/
                            "repay_method": "m", /*还款方式:m-按月分期,i-按月付息,到期还本,e-到期还本息*/
                            "progress": "100", /*贷款进度*/
                            "exptime": "1358076062", /*贷款过期时间*/
                            "begintime": "1357816862", /*还款起始时间*/
                            "endtime": "0", /*贷款结束时间*/
                            "status": "32", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
                            "ostatus": "1", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
                            "auto": "0", /*是否进行过自动投标*/
                            "safestr": "",/*安全保障*/
                            "lrealname": "王小五",/*流转债权人真实姓名*/
                            "lidcard": "11010119800101779X",/*流转债权人身份证号*/
                            "lno": "100001",/*流转借款合同编号*/
                            "lstime": "0",/*流转标借款合同生效时间*/
                            "letime": "0",/*流转标借款合同结束时间*/
                            "addtime": "1357816856", /*创建时间*/
                            "uptime": "1357816881", /*更新时间*/
                            "paytime": "0", /*还款时间*/
                            "uname": "wangsongquan", /*贷款人账号*/
                            "credit": "0", /*贷款人信用等级*/
                            "score": "0.0", /*贷款人积分*/
                            "province": "湖北",
                            "month_reward_apr": "0.25",
                            "remaintime": "-9天-21时-6分",
                            "credit_star": 0,
                            "reward_amount": "0", /*奖励现金红包*/
                            "reward_coupon": "0", /*奖励代金券*/
                            "reward_redbag": "0", /*奖励理财红包*/
                            "repay_method_name": "按月等额本息",
                            "use_type_name": "短期周转",
                            "flow_unit": 35,/*已流份额*/
                            "repo_unit": 0,/*已回购份额*/
                            "remain_unit": 65, /*剩余份数*/
                            "only_mobile": "0", /*手机专享*/
                        },
                        {
                            "lid": "100206",
                            "plid": "100205",
                            "uid": "100707",
                            "title": "资金周转续借25万",
                            "img": "/public/upload/loanimg/7/100707_mf0mre494026_100x100.jpg",
                            /*…*/
                            "use_type_name": "短期周转"
                        },
                        /*…*/
                     ]
                }
            }


* 贷款详情 /loan/detail/[lid] or ?lid=[lid]
    * 请求方式: GET | POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        lid          |  string  |   是      |   贷款编号lid
    
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
					"lid": "100209",
					"plid": "100206",
					"uid": "100707",
					"lgroup": "default", /*项目分组：default-默认*/
					"buid": "0", /*实际借款人ID*/
					"auid": "1", /*所属机构ID*/
					"title": "资金周转续借25万",
					"img": "/public/upload/loanimg/7/100707_mf0mre494026_100x100.jpg",
					"type": "4", /*标类型*/
					"is_flow": "1", /*是否为流转标*/
					"is_syncday": "0",  /*流转标是否同步债权还款日*/
					"is_field": "1",    /*是否为实地认证*/
					"is_plan": "1", /*是否保障计划*/
					"is_okout": "0",    /*是否自动放款*/
					"is_newbie": "0",   /*是否为新手专享*/
					"is_vip": "0",  /*是否为VIP会员专享投标：0-无，3-金牌会员，8-白金会员*/
					"no_captcha": "0",  /*无需验证码*/
					"is_mobile": "0",   /*是否为手机客户端专享投标*/
					"is_carloan": "0",  /*是否为车标*/
					"use_type": "1", /*贷款用户*/
					"amount": "20000", /*贷款金额*/
					"remain_amount": "0.00", /*剩余本金*/
					"return_amount": "0.00", /*已还总额*/
					"repay_num": "0", /*已还期数*/
					"late_fee": "0.00", /*逾期费用*/
					"early_fee": "0.00", /*违约金*/
					"mfee_rate": "0.50", /*管理费用*/
					"field_fee": "0.00", /*实地考察费*/
					"credit_fee": "0.00", /*征信待察费*/
					"other_fee": "0.00", /*其它服务费*/
					"tender_amount": "20000", /*已投标总额*/
					"flow_amount": "3500",/*已流转金额*/
					"repo_amount": "0",/*已回购金额*/
					"flow_date": "20140703",/*流转处理日期*/
					"tender_min": "0", /*最低投标金额*/
					"tender_max": "0", /*最高投标金额*/
					"tender_limit_times": "0", /*投标次数限制*/
					"tender_count": "1", /*已投标次数*/
					"tender_begin": "1357816862", /*招标开始时间*/
					"tender_end": "1357816881", /*招标截止时间*/
					"deadline": "1", /*贷款期限*/
					"deadline_type": "m", /*贷款期限单位：m-月、d-天*/
					"apr": "20.00", /*年利率*/
					"reward_apr": "3.00", /*奖励年利率*/
					"reward_money": "0", /*投标奖励金额*/
					"repay_method": "m", /*还款方式:m-按月分期,i-按月付息,到期还本,e-到期还本息*/
					"progress": "100", /*贷款进度*/
					"exptime": "1358076062", /*贷款过期时间*/
					"begintime": "1357816862", /*还款起始时间*/
					"endtime": "0", /*贷款结束时间*/
					"status": "32", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
					"ostatus": "1", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
					"auto": "0", /*是否进行过自动投标*/
					"safestr": "",/*安全保障*/
					"lrealname": "王小五",/*流转债权人真实姓名*/
					"lidcard": "11010119800101779X",/*流转债权人身份证号*/
					"lno": "100001",/*流转借款合同编号*/
					"lstime": "0",/*流转标借款合同生效时间*/
					"letime": "0",/*流转标借款合同结束时间*/
					"addtime": "1357816856", /*创建时间*/
					"uptime": "1357816881", /*更新时间*/
					"paytime": "0", /*还款时间*/
                    "days": "0", /*days不为0，表示为天标*/
                    "description": "一.基本情况描述:\n       借款人经营一家劳务有限公司，以园林建造,建筑工程承包,劳务派遣等为主要业务的综合性劳务公司,公司自成立以来，成绩显著，信誉度高.先后与十多家企业单位进行合作，已完成各大小市政项目共100多项.借款人已结婚，已提供结婚证（详见图片02），东风车一辆（详见图片06、07），两证齐全面积约396.58平米住房一栋，已提供房产两证（详见图片08、09）.\n\n二.借款用途：\n      此次借款因与某企业单位合作的建筑工程承包项目前已进行到收尾阶段，还需资金周转.\n\n三.提供资料: \n     1.身份证(详见图片01) 2.结婚证（详见图片02）3.营业执照（详见图片03）4.税务登记证（详见图片04）5.资质证书（详见图片05）\n\n四.外勤考察地方:\n     外勤组同事对借款人住房，建筑工程进行了现场确认查看. \n\n五.风控审核\n      风控对借款人提供的资料.及外勤组同事考核结果进行综合审核分析，给予授信额度100万.（备注：1/3；方式：2）",
                    "uname": "chenyanbing",
                    "avatar": "https://yiqihao.com/public/upload/avatar/37/109787_avatar_200x200.jpg",
                    "credit": "5",
                    "score": "0.0",
                    "province": "湖北",
                    "fulldate": "2013-12-09 12:00",
                    "begindate": "2013-12-09 12:01:01",
                    "tender_begindate": "2013-12-09 12:00",
                    "remaintime": "02天23时34分",
                    "credit_star": 100,
                    "repay_method_name": "按月付息，到期还本",
                    "use_type_name": "短期周转",
                    "statusname": "还款中",
                    "repay_amount": 1017566.67,
                    "month_repay_interest": "17566.67",
                    "last_repay_money": 1017566.67,
                    "manage_fee": "5000.00",
                    "remain_time": 257689,
                    "bid_money": 100,
                    "bid_interest": "1.76",
                    "can_access": 0,
                    "show_contract": 0,
                    "show_repay": 0,
                    "repay_money": 0,
                    "repay_progress": 0, /*还款进度*/
                    "show_track": 0,
                    "show_photo": 0,
                    "comment_count": 7,
                    "show_comment_btn": 1,
                    "waittime": 0,
                    "waitpay": 0,
                    "costtime": "2秒", /*满标耗时*/
                    "record": { /*贷款记录*/
                        "post": 1,
                        "success": 1,
                        "ok": 0,
                        "overdue": 0,
                        "soverdue": 0,
                        "repay": "1017566.67",
                        "borrow": "1000000.00",
                        "return": "0.00",
                        "waitrepay": "0.00",
                        "lend": "0.00",
                        "moverdue": "0.00"
                    },
                    "authlist": { /*审核记录*/
                        "idcard": {
                            "type": "身份证认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "job": {
                            "type": "工作认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "credit": {
                            "type": "信用报告",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "income": {
                            "type": "收入认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "estate": {
                            "type": "房产认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "car": {
                            "type": "购车认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "married": {
                            "type": "结婚证明",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "education": {
                            "type": "学历认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "residence": {
                            "type": "居住地证明",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "field": {
                            "type": "实地认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        },
                        "others": {
                            "type": "其他材料认证",
                            "status": "21",
                            "uptime": "1386559591",
                            "date": "2013-12-09",
                            "ok": 1
                        }
                    },
                    "userinfo": { /*贷款用户信息*/
                        "uid": "109787",
                        "auth_realname": "0",
                        "auth_mobile": "0",
                        "auth_email": "0",
                        "auth_avatar": "0",
                        "gender": "1",
                        "auth_gender": "0",
                        "birthdate": "1972-10-08",
                        "auth_birthdate": "0",
                        "idcard_province": "420000",
                        "idcard_city": "420100",
                        "province": "420000",
                        "city": "420100",
                        "district": "0",
                        "address": "",
                        "auth_address": "0",
                        "address_phone": "",
                        "auth_address_phone": "0",
                        "education": "大专",
                        "auth_education": "0",
                        "graduated_year": "0",
                        "auth_graduated_year": "0",
                        "graduated_school": "",
                        "auth_graduated_school": "0",
                        "marriage": "1",
                        "auth_marriage": "0",
                        "have_child": "1",
                        "auth_have_child": "0",
                        "have_house": "1",
                        "auth_have_house": "0",
                        "house_loan": "2",
                        "auth_house_loan": "0",
                        "have_car": "1",
                        "auth_have_car": "0",
                        "car_brand": "",
                        "auth_car_brand": "0",
                        "car_year": "0",
                        "auth_car_year": "0",
                        "car_loan": "2",
                        "auth_car_loan": "0",
                        "job_company": "",
                        "auth_job_company": "0",
                        "job_type": "私营企业主",
                        "auth_job_type": "0",
                        "job_company_type": "一般民营企业",
                        "auth_job_company_type": "0",
                        "job_company_scale": "50-100人",
                        "auth_job_company_scale": "0",
                        "job_industry": "建筑工程",
                        "auth_job_industry": "0",
                        "job_title": "法人代表",
                        "auth_job_title": "0",
                        "job_salary": "100000元以上",
                        "auth_job_salary": "0",
                        "job_years": "5年以上",
                        "auth_job_years": "0",
                        "job_email": "",
                        "auth_job_email": "0",
                        "job_province": "420000",
                        "auth_job_province": "0",
                        "job_city": "420100",
                        "auth_job_city": "0",
                        "job_company_address": "",
                        "auth_job_company_address": "0",
                        "job_company_phone": "",
                        "auth_job_company_phone": "0",
                        "family_name": "",
                        "auth_family_name": "0",
                        "family_who": "",
                        "auth_family_who": "0",
                        "family_phone": "",
                        "auth_family_phone": "0",
                        "other_name": "",
                        "auth_other_name": "0",
                        "other_who": "",
                        "auth_other_who": "0",
                        "other_phone": "",
                        "auth_other_phone": "0",
                        "addtime": "0",
                        "uptime": "0",
                        "status": "11",
                        "age": 41,
                        "job_province_name": "湖北省",
                        "job_city_name": "武汉市"
                    }
                }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "贷款不存在"
            }


* 投标操作 /loan/bid/[lid]  or ?lid=[lid]
    * 请求方式: POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        money       |   string  |   是      |   投标金额
        captcha     |   string  |   否      |   当贷款返回no_captcha=0时需要投标验证码: 通过/get/captcha?type=bid获取

    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 投标成功 ---
            {
                "return": 1,
                "msg": "投标成功"
                /*"msg": "投标部分成功, 有效投标金额为：￥1000.00"*/
            }
           
            --- 余额不足，进入下一步支付界面，直接将支付请求参数传入sdk进行支付请求 ---
            {
                "return": 2,
                "msg": "可用余额不足，请先充值！",
                "data": {
                    "backurl": "/user/authpay/callback", /*客户端回调地址*/
                    "url": "https://yintong.com.cn/llpayh5/authpay.htm", /*支付网关地址，预留*/
                    "query": { /*支付请求参数列表，见相关文档*/
                        "version": "1.0",
                        "oid_partner": "201411121000096507",
                        "sign_type": "MD5",
                        "userreq_ip": "127.0.0.1",
                        "id_type": "0",
                        "valid_order": "1440",
                        "user_id": "111825",
                        "timestamp": "20141212143351",
                        "busi_partner": "101001",
                        "no_order": "1888080800204760",
                        "dt_order": "20141212143351",
                        "name_goods": "一起好账户充值",
                        "info_order": "用户充值:111825:10000.00:5byg5pet5LicOjM2MDcyMTE5ODgxMjA5NTI1MTo.",
                        "money_order": "10000.00",
                        "notify_url": "http://beta.yiqihao.com/pay/notify/authpay",
                        "url_return": "http://beta.yiqihao.com/pay/callback/authpay",
                        "url_order": "http://beta.yiqihao.com",
                        "risk_item": '{\'user_info_mercht_userno\':\'111825\',\'user_info_full_name\':\'\\u5f20\\u65ed\\u4e1c\',\'user_info_dt_register\':\'20140204181604\',\'frms_ware_category\':\'2009\',\'user_info_identify_state\':\'0\'}',
                        "acct_name": "张旭东",
                        "force_bank": 1,
                        "id_no": "360721198812095251",
                        "card_no": "6217002870003895966",
                        "sign": "9898b108f18c0474c539e0ddd515ad9f"
                    },
                    "agreeno": ""
                }
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "此标已经不能投了",
                /*
                "errmsg": "自动投标还未投完，请稍候。。。"
                "errmsg": "投标失败"
                "errmsg": "请绑定银行卡"
                "errmsg": "请重新绑定银行卡" 
                */
                /*如果errmsg包含"绑定银行卡"，则表示用户需要先跳到绑定银行卡界面操作*/
            }


* 贷款详情-投标记录 /loan/tender_list/[lid] or ?lid=[lid] * 请求方式: GET | POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        id          |   string  |   是      |   贷款编号
        size        |   int     |   否      |   分页大小, 默认为：100，取值：1~100
        p           |   int     |   否      |   页码，默认为：1 
        
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "tid": "98745", /*投标ID*/
							"tgroup" : "default", /*分组*/
                            "ptid": "0", /*源投标ID*/
							"tno" : "0", /*投标订单号*/
							"paytype" : "0", /*支付类型: 0-余额, 1-红包, 2-体验金*/
                            "lid": "103020", /*贷款ID*/
							"slid": "0", /*子贷款ID*/
							"scontract" : "0", /*是否发送借款协议*/
                            "uid": "108089", /*用户ID*/
                            "money": "20000", /*借款总金额*/
                            "bidrank": "0", /*投标排名*/              
                            "auto": "1", /*是否为自动投标*/
                            "auto_money": "20000", /*自动投标金额*/
                            "addtime": "1386561601", /*投标时间*/
                            "status": "21", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
							"tstatus" : "0", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "bidtime": "1386561601", /*投标时间*/
                            "uptime": "1386561661",
                            "uname": "hope_zou", /*投标人*/
                            "no": 1, /*投标序号*/
                            "datetime": "2013-12-09 12:00:01", /*投标日期*/
                            "lastdatetime": "2013-12-09 12:00:01",
                            "normal_money": "0", /*正常投标金额*/
                        },
						...
                    ],
                    "page": {
                        "size": 2,
                        "count": 103,
                        "total": 52,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                        ]
                    },
                    "uid": 0 /*当前会话用户uid*/
                }
            }


* 贷款详情-发表评论 /loan/comment_add/[lid] or ?lid=[lid]
    * 请求方式: POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        pid         |   string  |   否      |   要回复的留言编号
        content     |   string  |   是      |   留言内容

    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "pid": 0, /*回复留言id*/
                    "lid": 101573, /*贷款编号*/
                    "uid": "100008", /*评论者UID*/
                    "content": "12345678", /*留言内容*/
                    "addtime": 1386565859, /*留言时间*/
                    "status": 1, /*留言:0-不显示,1-显示*/
                    "id": 5485, /*留言id*/
                    "uname": "oopos", /*评论人*/
                    "date": "2013-12-09 13:10:59", /*评论时间*/
                    "avatar": "/public/upload/avatar/8/100008_avatar_100x100.jpg" /*评论人头像*/
                }
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "你暂时没有留言权限"
            }


* 贷款详情-删除评论 /loan/comment_del/[id] or lid=[lid] （注：此接口只有当会话uid为100001,100008,100677 才显示删除按扭)
    * 请求方式: POST
    
        参数名      |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        id          |   string  |   是      |   留言编号

    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "删除成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "无操作权限"
            }
             
 
* 贷款详情-评论列表 /loan/comment_list/[lid] or ?lid=[lid]
    * 请求方式: GET | POST
    
        参数名      |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "15920", /*留言ID*/
                            "pid": "0", /*上级留言ID*/
                            "lid": "103020", /*贷款ID*/
                            "uid": "100559", /*留言者ID*/
                            "content": "居然抢到了，倒数第二，没有白等！", /*留言内容*/
                            "addtime": "1386562877", /*留言时间*/
                            "status": "1", /*留言状态：0-不显示,1-显示*/
                            "uname": "angeloangelo", /*留言者用户名*/
                            "avatar": "/public/hao/themes/default/images/64x64.jpg", /*留言者头像*/
                            "date": "2013-12-09 12:21:17", /*格式化留言时间*/
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 7,
                        "total": 7,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 7,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7
                        ]
                    },
                    "uid": "109787", /*当前登录者uid*/
                    "aid": 1, /*当前贷款所属机构*/
                    "luid": "109787" /*当前贷款的借款者ID*/
                }
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "用户未登录或会话已过期"
            }


* 贷款详情-贷款人相关资料图片 /loan/photo_list/[lid] or ?lid=[lid]
    * 请求方式: GET | POST
    
        参数名      |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "public_url": "https://yiqihao.com/public", /*图片地址前缀，当list.url是相对地址upload/的时候拼接*/
                    "list": [
                        {
                            "id": "4767", 
                            "no": "0", /*序号*/
                            "lid": "103018", /*贷款编号*/
                            "uid": "100844", /*用户ID*/
                            "url": "upload/loan/103018/photo/52a50f7faa7fe_600x350.jpg", /*图片地址*/
                            "remark": "图片01：借款人基础资料-身份证.jpg", /*图片备注*/
                            "addtime": "1386549120", /*添加时间*/
                            "uptime": "0", /*更新时间*/
                            "status": "1" /*状态:0-不显示,1-显示*/
                        },
						...
                    ]
                }
            }

* 贷款详情-流转标借款合同及打款记录图片 /loan/binfo_list/[lid] or ?lid=[lid] (只有当前标是流转标loan.is_flow=1时才需要调用这个接口)
    * 请求方式: GET | POST
    
        参数名      |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "public_url": "https://yiqihao.com/public", /*默图片地址前缀，当list.url是相对地址upload/的时候拼接*/
                    "list": [
                        {
                            "id": "126",
                            "no": "1", /*序号*/
                            "lid": "103018", /*贷款编号*/
                            "uid": "100844", /*用户ID*/
                            "url": "upload/loan/103018/binfo/52a521084ccf1_400x300.jpg", /*图片地址*/
                            "type": "借款合同", /*图片类型*/
                            "addtime": "1386553609", /*添加时间*/
                            "uptime": "0", /*更新时间*/
                            "status": "1" /*状态:0-不显示,1-显示*/
                        },
						...
                        {
                            "id": "129",
                            "no": "4",
                            "lid": "103018",
                            "uid": "100844",
                            "url": "upload/loan/103018/binfo/52a52108dfbd9_400x300.jpg",
                            "type": "打款记录",
                            "addtime": "1386553609",
                            "uptime": "0",
                            "status": "1"
                        }
                    ]
                }
            }


* 贷款详情-还款详情 /loan/repay_list/[lid] or ?lid=[lid]
    * 请求方式: GET | POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "lid": "103018", /*贷款编号*/
                            "no": 1, /*还款编号*/
                            "time": "1389283199", /*还款时间*/
                            "return_amount": "0.00", /*已还金额*/
                            "remain_amount": "37823.84", /*待还金额*/
                            "status": "11", /*状态:1-无效,11-还款中,21-还款成功,31-系统已代还,32-代还已回收*/
                            "date": "2014-01-09", /*还款日期*/
                            "statusname": "还款中" /*状态*/
                        },
						...
                    ]
                }
            }

* 贷款详情-获取投标信息 /loan/bidinfo/[lid] or ?lid=[lid]
    * 请求方式: GET | POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        lid         |   string  |   是      |   贷款编号
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "bid_money": 100, /*每投标bid_money元，可获得收益bid_interest*/
                    "bid_interest": "5.27", /*每投100元可以获取投标收益*/
                    "user_amount": "83092.97", /*用户可用余额*/
                    "user_avcredit": "0.00", /*用户可用授信额度*/
                    "need_amount": 994700, /*当前标可投金额*/
                    "need_captcha": '2', /*当need_catpcha为1的时候需要字母验证码，为2的时候需要数字验证码，为0时无需验证码*/
                }
            }

* 最新贷款列表 /loan/newlist
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        limit       |   int     |   否      |   默认为8
    
    * 返回结果：JSON | XML (参考三、2 贷款列表)
    
    
* 白金专区 /loan/list/vip8
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        size       |   int     |   否      |   默认为8
    
    * 返回结果：JSON | XML (参考三、2 贷款列表)
    
* 新手专区 /loan/list/
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        is_newbie       |   int     |   是      |  
        size       |   int     |   否      |   默认为8
    
    * 返回结果：JSON | XML (参考三、2 贷款列表)

* 推荐贷款列表 /loan/hotlist
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        limit       |   int     |   否      |   默认为3
    
    * 返回结果：JSON | XML (参考三、2 贷款列表)


* 贷款分组列表 /loan/grouplist/[type]
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        limit       |   int     |   否      |   默认为5
        type        |   string  |   否      |   默认为all，biding-招标中,bidok-招标成功,repayok-还款完成
    
    * 返回结果：JSON | XML (参考三、2 贷款列表)

        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "biding": {"list":[]},
                    "bidok": {"list":[]},
                    "repayok": {"list":[]}
                }
            }
 
---
**四、债权转让相关**

* 债权转让列表 /transfer/list
    * 请求方式: POST | GET
   
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        type        |   string  |   否      |   债权转让类别，all-全部(默认),new-最新,newok-最近成功
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        sort        |   string  |   否      |   排序：[type]-[asc|desc],如:apr-asc，type可以是：trans_money,trans_num,apr,exptime
        keyword     |   string  |   否      |   搜索关键词, 暂时只搜索：贷款标题
        apr         |   string  |   否      |   收益率，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:12-表示12以上
        exptime     |   string  |   否      |   剩余时间，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:-1表示1天内
        trans_num   |   string  |   否      |   剩余期限，格式：a-b: 表示在a和b之间, a-表示>a,-a表示<a, 如:-1表示1个月内
    
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "2394",
                            "tid": "87228", /*投标ID*/
                            "uid": "105137", /*转让用户ID*/
                            "tgroup": "default",/*项目分组：default-默认*/
                            "ruid": "101204",/*承接用户ID*/
                            "luid": "108679",/*贷款用户ID*/
                            "lid": "102793", /*贷款ID*/
                            "title": "补充流动资金100万第一标25万",
                            "img": "/public/upload/loanimg/29/108679_mvignf513611_100x100.jpg",
                            "trans_money": "50.00",/*转让本金*/
                            "trans_amount": "49.96",/*转让价格*/
                            "trans_interest": "0.27",/*利息总额*/
                            "trans_num": "5",/*剩余期数*/
                            "transpwd": "", /*承接密码*/
                            "status": "21",/*状态:1-转让失败,2-已取消,3-已过期,4-自动取消,11-转让中,12-待审核,21-转让成功*/
                            "exptime": "1386818858", /*过期时间*/
                            "addtime": "1386559658", /*创建时间*/
                            "uptime": "1386559684", /*更新时间*/
                            "oktime": "1386559684", /*成功时间*/
                            "tstatus": "21", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "tender_status": "31", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                            "deadline": "6", /*贷款期限*/
                            "repay_num": "6", /*还款期数*/
                            "money": "50", /*投标金额*/
                            "remain_money": "0.00", /*剩余本金*/
                            "remain_amount": "0.00", /*剩余总额*/
                            "amount": "250000", /*总额*/
                            "apr": "22.40", /*年利率*/
                            "repay_method": "i", /*还款方式*/
                            "begintime": "1383187142", /*开始时间*/
                            "trans_date": "2013-12-09 11:28", /*转让时间*/
                            "add_date": "2013-12-09 11:27", /*创建时间*/
                            "statusname": "转让成功", /*状态名称*/
                            "days": "0", /*天数*/
                            "end_interest": "5.80", /*承接收益*/
							/*转让用户*/
                            "user": {
                                "uname": "gaoxin198521",
                                "credit": "0",
                                "province": "北京"
                            },
							/*贷款用户*/
                            "luser": {
                                "uname": "yuanshundi",
                                "credit": "5",
                                "province": "湖北"
                            },
							/*承接用户 承接成功后才有此数据*/
                            "ruser": {
                                "uname": "happywind",
                                "credit": "0",
                                "province": "北京"
                            }
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 2097,
                        "total": 2097,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7,
                            8,
                            9,
                            10
                        ]
                    }
                }
            }


* 最新债权转让列表 /transfer/newlist
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        limit       |   int     |   否      |   默认为8
    
    * 返回结果：JSON | XML (参考四、1 债权转让列表)

* 推荐债权转让列表 /transfer/hotlist
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        limit       |   int     |   否      |   默认为3
    
    * 返回结果：JSON | XML (参考四、1 债权转让列表)

    
* 发布债权转让 /user/transfer/post/[id] or /user/transfer/post?id=[id]
    * 请求方式: POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        id          |   string  |   是      |   投标id
        paypwd      |   string  |   是      |   支付密码
        transpwd    |   string  |   否      |   承接密码，为空表示不设密码。
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "债权转让发布成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "可用积分不足，无法进行债权转让",
            }

* 获取债权转让详情 /user/transfer/detail/[id] or /user/transfer/detail?id=[id]
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        id          |   string  |   是      |   债权转让ID
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "transfer": {
                        "tid": "29049", /*投标ID*/
                        "tno": "0", /*投标订单号*/
                        "tgroup": "default", /*项目分组*/
                        "ptid": "0", /*源投标ID*/
                        "lid": "101573", /*贷款ID*/
                        "slid": "20131120", /*子贷款ID*/
                        "scontract": "0", /*是否发送借款协议*/
                        "uid": "100008", /*转让用户ID*/
                        "loan_money": "1700", /*贷款总金额*/
                        "loan_apr": "21.08", /*年利率*/
                        "loan_method": "e", /*还款方式*/
                        "loan_time": "1384876800", /*还款起始时间*/
                        "money": "250", /*投标金额*/
                        "auto_money": "0", /*自动投标金额*/
                        "return_money": "0.00", /*已还本金*/
                        "remain_money": "250.00", /*剩余本金*/
                        "repay_amount": "263.17", /*应还总额*/
                        "return_amount": "0.00", /*已还总额*/
                        "remain_amount": "263.17", /*待还总额*/
                        "num": "3", /*还款期数*/
                        "repay_num": "0", /*已还期数*/
                        "start_num": "0", /*起始期数*/
                        "status": "11", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                        "tstatus": "11", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                        "auto": "0", /*是否为自动投标*/
                        "addtime": "1387202907", /*创建时间*/
                        "bidtime": "1384937846", /*投标时间*/
                        "uptime": "0", /*更新时间*/
                        "paytime": "0", /*支付时间*/
                        "addip": "127.0.0.1",
                        "pay_money": "250.00", /*支付金额*/
                        "is_flow": "1", /*是否是流转标1-是,0-否*/
                        "loan_status": "21", /*贷款状态*/
                        "amount": "1000000", /*贷款总额*/
                        "begintime": "1384937756", /*还款开始时间*/
                        "repay_method": "e", /*还款方式*/
                        "deadline": "3", /*贷款期限*/
                        "apr": 21.08, /*年利率*/
                        "reward_apr": "0.00", /*奖励年利率*/
                        "title": "流转标100万测试6",
                        "img": "upload/loanimg/8/101108_mewf9o573075_[size].jpg",
                        "luid": "101108", /*贷款用户ID*/
                        "now_days": 26, /*还款开始距离今日的天数*/
                        "total_days": 30, /*还款完成总需要天数*/
                        "remain_days": 66, /*剩余还款天数*/
                        "remain_num": 3,  /*剩余还款期数*/
                        "trans_interest": "3.80", /*待结算利息*/
                        "pay_interest": "2.53", 
                        "return_interest": "1.26", 
                        "wait_interest": "13.17", /*待收利息*/
                        "earn_interest": "1.26", /*承接收益*/
                        "loss_interest": "2.54", /*损失利息*/
                        "trans_return": "251.26",
                        "trans_amount": "252.53", /*转让价格*/
                        "id": "838", /*转让编号id*/
                        "ruid": "-1", /*承接人uid,为-1时表示没有被承接*/
                        "trans_money": "250.00", /*剩余本金*/
                        "trans_num": "3", /*剩余期数*/
                        "transpwd": "", /*当transpwd=1时，需要密码*/
                        "exptime": "1387462107", /*过期时间*/
                        "oktime": "0", /*成功时间*/
                        "tender_status": "21", /*状态*/
                        "remain_interest": "10.64", /*剩余待转让*/
                        "remain_time": "02天23时59分", /*剩余时间*/
                        "luser": { /*贷款人*/
                            "uname": "***",
                            "credit": "5",
                            "province": "湖北"
                        },
                        "user": { /*转让人*/
                            "uname": "oopos",
                            "credit": "0",
                            "province": "上海"
                        },
                        "add_date": "2013-12-16 22:08" /*发布日期*/
                    },
                    "uid": "100008", /*当前用户uid*/
                    "user_amount": "83092.97" /*当前用户余额*/
                }
            }
        
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "此债权不在可转让状态"
            }

* 承接债权转让 /user/transfer/pay/[id] or /user/transfer/pay?id=[id]
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        id          |   string  |   是      |   债权转让id
        money       |   string  |   是      |   债权转让价格，带上通过/user/transfer/detail获取的价格trans_amount
        paypwd      |   string  |   是      |   支付密码
        captcha     |   string  |   否      |   当/user/transfer/detail返回need_captcha='1'时，需带上通过/get/captcha获取的验证码
        transpwd    |   string  |   否      |   承接密码，当该债权转让需要密码上带上。
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "承接债权成功，支出：￥100.00"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "债权转让价格已变化，请刷新"
            }

* 转让的债权列表 /user/transfer/list
    * 请求方式: GET | POST
   
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        sort        |   string  |   否      |   排序：[type]-[asc|desc],如:apr-asc，type可以是：trans_money,trans_num,apr,exptime
    
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "2394",
                            "tid": "87228", /*投标ID*/
                            "uid": "105137", /*转让用户ID*/
                            "tgroup": "default",/*项目分组：default-默认*/
                            "ruid": "101204",/*承接用户ID*/
                            "luid": "108679",/*贷款用户ID*/
                            "lid": "102793", /*贷款ID*/
                            "title": "补充流动资金100万第一标25万",
                            "img": "/public/upload/loanimg/29/108679_mvignf513611_100x100.jpg",
                            "trans_money": "50.00",/*转让本金*/
                            "trans_amount": "49.96",/*转让价格*/
                            "trans_interest": "0.27",/*利息总额*/
                            "trans_num": "5",/*剩余期数*/
                            "transpwd": "", /*承接密码*/
                            "status": "21",/*状态:1-转让失败,2-已取消,3-已过期,4-自动取消,11-转让中,12-待审核,21-转让成功*/
                            "exptime": "1386818858", /*过期时间*/
                            "addtime": "1386559658", /*创建时间*/
                            "uptime": "1386559684", /*更新时间*/
                            "oktime": "1386559684", /*成功时间*/
                            "tstatus": "21", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "tender_status": "31", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                            "deadline": "6", /*贷款期限*/
                            "repay_num": "6", /*还款期数*/
                            "money": "50", /*投标金额*/
                            "remain_money": "0.00", /*剩余本金*/
                            "remain_amount": "0.00", /*剩余总额*/
                            "amount": "250000", /*总额*/
                            "apr": "22.40", /*年利率*/
                            "repay_method": "i", /*还款方式*/
                            "begintime": "1383187142", /*开始时间*/
                            "trans_date": "2013-12-09 11:28", /*转让时间*/
                            "add_date": "2013-12-09 11:27", /*创建时间*/
                            "statusname": "转让成功", /*状态名称*/
                            "days": "0", /*天数*/
                            "end_interest": "5.80", /*承接收益*/
							/*转让用户*/
                            "user": {
                                "uname": "gaoxin198521",
                                "credit": "0",
                                "province": "北京"
                            },
							/*贷款用户*/
                            "luser": {
                                "uname": "yuanshundi",
                                "credit": "5",
                                "province": "湖北"
                            },
							/*承接用户 承接成功后才有此数据*/
                            "ruser": {
                                "uname": "happywind",
                                "credit": "0",
                                "province": "北京"
                            }
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 12,
                        "total": 12,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
							...
                        ]
                    }
                }
            }

* 承接的债权列表 /user/transfer/ok
    * 请求方式: GET | POST
   
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        size        |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p           |   int     |   否      |   页码，默认为：1 
        sort        |   string  |   否      |   排序：[type]-[asc|desc],如:apr-asc，type可以是：trans_money,trans_num,apr,exptime
    
    * 返回结果：JSON | XML (参考四、7 转让的债权结果注释)

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "2394",
                            "tid": "87228", /*投标ID*/
                            "uid": "105137", /*转让用户ID*/
                            "tgroup": "default",/*项目分组：default-默认*/
                            "ruid": "101204",/*承接用户ID*/
                            "luid": "108679",/*贷款用户ID*/
                            "lid": "102793", /*贷款ID*/
                            "title": "补充流动资金100万第一标25万",
                            "img": "/public/upload/loanimg/29/108679_mvignf513611_100x100.jpg",
                            "trans_money": "50.00",/*转让本金*/
                            "trans_amount": "49.96",/*转让价格*/
                            "trans_interest": "0.27",/*利息总额*/
                            "trans_num": "5",/*剩余期数*/
                            "transpwd": "", /*承接密码*/
                            "status": "21",/*状态:1-转让失败,2-已取消,3-已过期,4-自动取消,11-转让中,12-待审核,21-转让成功*/
                            "exptime": "1386818858", /*过期时间*/
                            "addtime": "1386559658", /*创建时间*/
                            "uptime": "1386559684", /*更新时间*/
                            "oktime": "1386559684", /*成功时间*/
                            "tstatus": "21", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "tender_status": "31", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                            "deadline": "6", /*贷款期限*/
                            "repay_num": "6", /*还款期数*/
                            "money": "50", /*投标金额*/
                            "remain_money": "0.00", /*剩余本金*/
                            "remain_amount": "0.00", /*剩余总额*/
                            "amount": "250000", /*总额*/
                            "apr": "22.40", /*年利率*/
                            "repay_method": "i", /*还款方式*/
                            "begintime": "1383187142", /*开始时间*/
                            "trans_date": "2013-12-09 11:28", /*转让时间*/
                            "add_date": "2013-12-09 11:27", /*创建时间*/
                            "statusname": "转让成功", /*状态名称*/
                            "days": "0", /*天数*/
                            "end_interest": "5.80", /*承接收益*/
							/*转让用户*/
                            "user": {
                                "uname": "gaoxin198521",
                                "credit": "0",
                                "province": "北京"
                            },
							/*贷款用户*/
                            "luser": {
                                "uname": "yuanshundi",
                                "credit": "5",
                                "province": "湖北"
                            },
							/*承接用户 承接成功后才有此数据*/
                            "ruser": {
                                "uname": "happywind",
                                "credit": "0",
                                "province": "北京"
                            }
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 20,
                        "total": 20,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
							...
                        ]
                    }
                }
            }

---
**五、实时财务**

* 财务信息 /caiwu/info
    * 请求方式: GET | POST
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "advance_amount": "1283174.56",/*垫付准备金余额*/
                    "advance_wait": "45139.38",/*未收回垫付金额*/
                    "advance_return": "0.00",/*已收回垫付金额*/
                    "capital_unrepay": "27915159.31",/*待回收本金总额*/
                    "capital_total": "58423800.00",/*交易总额*/
                    "capital_return": "177920690.46",/*已经回收本金总额*/
                    "funds_amount": "6722.77"/*慈善基金余额*/
                    "invest_interest": "6674133.25", /*累计为理财人赚取收益*/
                    "overdue_rate": "28.3", /*逾期率*/
                    "overdue_money": "124401135.78",/*逾期总额 */
                    "baddebt_rate": "2.8" /*坏账率*/
                    "baddebt_money": "123209369.96",/*坏账总额*/
                    "loan_times": 1520, /*贷款次数*/
                    "avg_rate": "21.43", /*平均年利率*/
                    "today_amount": "0", /*今日成交量*/
                    "yesterday_amount": "0", /*昨日成交量*/
                    "thismonth_amount": "511000", /*本月成交量*/
                    "prevmonth_amount": "0", /*上月成交量*/
                    "thisyear_amount": "511000", /*本年度成交量*/                          
                    "overdue_unrepay": "907700.26",/*逾期未归还*/
                }
            }   

* 还款列表 /caiwu/list
    * 请求方式: GET | POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        type        |   string  |   是      |   lt7days: 一周内应回收欠款列表
                    |           |           |   lt30days: 逾期30天内未归还列表
                    |           |           |   gt30days: 逾期30天以上未归还列表
                    |           |           |   laterepay: 逾期已归还列表
        date        |   string  |   否      |   返回指定日期date(格式:2013-03-03)数据

    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "amount": "2263860.64", /*应归还总额*/
                    "return_amount": "0.00", /*已归还总额*/
                    "remain_amount": "2263860.64", /*待归还总额*/
                    "list": [
                        {
                            "rid": "2225", /*还款编号*/
                            "lid": "101115", /*贷款编号*/
                            "uid": "104101", /*用户ID*/
                            "no": "5", /*序号*/
                            "time": "1383753599", /*还款时间*/
                            "amount": "14183.94", /*应归还金额*/
                            "picurl": "", /*还款截图url*/
                            "lateurl": "", /*逾期链接*/
                            "status": "11", /*状态:1-无效,11-还款中,21-还款成功,31-系统已代还,32-代还已回收*/
                            "oktime": "0", /*完成时间*/
                            "paytime": "0", /*还款时间*/
                            "uname": "wangjunjun", /*贷款人*/
                            "date": "2013-11-06", /*应归还日期*/
                            "remark": "" /*备注*/
                        },
                        /*...*/
                    ],
                    "page": {
                        "size": 10,
                        "count": 14,
                        "total": 2,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 2,
                        "list": [
                            1,
                            2
                        ]
                    }
                }
            }


---
**六、理财管理**

* 我投标的贷款 /user/invest/loan/[status], [status]为空表示全部投标贷款，为tendering表示投标中的贷款，为waiting表示等待放款中的贷款
    * 请求方式: GET | POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "tender_remain_amount": "105.27", /*剩余待收*/
                            "tender_repay_amount": "105.27", /*应还本息*/
                            "tender_addtime": "1382796941", /*投标时间*/
                            "tender_money": "100", /*投标金额*/
                            "tender_uptime": "0",
                            "tender_status": "21", /*投标状态：0-失败,2-无效,3-流标,10-待支付,11-成功,21-还款中,31-还款完成*/
                            "tender_id": "29046", /*投标编号*/
                            "tender_interest": "5.27" /*预期收益*/
                            "lid": "100209",
                            "plid": "100206",
                            "uid": "100707",
                            "lgroup": "default", /*项目分组：default-默认*/
                            "buid": "0", /*实际借款人ID*/
                            "auid": "1", /*所属机构ID*/
                            "title": "资金周转续借25万",
                            "img": "/public/upload/loanimg/7/100707_mf0mre494026_100x100.jpg",
                            "type": "4", /*标类型*/
                            "is_flow": "1", /*是否为流转标*/
                            "is_syncday": "0",  /*流转标是否同步债权还款日*/
                            "is_field": "1",    /*是否为实地认证*/
                            "is_plan": "1", /*是否保障计划*/
                            "is_okout": "0",    /*是否自动放款*/
                            "is_newbie": "0",   /*是否为新手专享*/
                            "is_vip": "0",  /*是否为VIP会员专享投标：0-无，3-金牌会员，8-白金会员*/
                            "no_captcha": "0",  /*无需验证码*/
                            "is_mobile": "0",   /*是否为手机客户端专享投标*/
                            "is_carloan": "0",  /*是否为车标*/
                            "use_type": "1", /*贷款用户*/
                            "amount": "20000", /*贷款金额*/
                            "remain_amount": "0.00", /*剩余本金*/
                            "return_amount": "0.00", /*已还总额*/
                            "repay_num": "0", /*已还期数*/
                            "late_fee": "0.00", /*逾期费用*/
                            "early_fee": "0.00", /*违约金*/
                            "mfee_rate": "0.50", /*管理费用*/
                            "field_fee": "0.00", /*实地考察费*/
                            "credit_fee": "0.00", /*征信待察费*/
                            "other_fee": "0.00", /*其它服务费*/
                            "tender_amount": "20000", /*已投标总额*/
                            "flow_amount": "3500",/*已流转金额*/
                            "repo_amount": "0",/*已回购金额*/
                            "flow_date": "20140703",/*流转处理日期*/
                            "tender_min": "0", /*最低投标金额*/
                            "tender_max": "0", /*最高投标金额*/
                            "tender_limit_times": "0", /*投标次数限制*/
                            "tender_count": "1", /*已投标次数*/
                            "tender_begin": "1357816862", /*招标开始时间*/
                            "tender_end": "1357816881", /*招标截止时间*/
                            "deadline": "1", /*贷款期限*/
                            "deadline_type": "m", /*贷款期限单位：m-月、d-天*/
                            "apr": "20.00", /*年利率*/
                            "reward_apr": "3.00", /*奖励年利率*/
                            "reward_money": "0", /*投标奖励金额*/
                            "repay_method": "m", /*还款方式:m-按月分期,i-按月付息,到期还本,e-到期还本息*/
                            "progress": "100", /*贷款进度*/
                            "exptime": "1358076062", /*贷款过期时间*/
                            "begintime": "1357816862", /*还款起始时间*/
                            "endtime": "0", /*贷款结束时间*/
                            "status": "32", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
                            "ostatus": "1", /*状态: 1-草稿,2-无效,3-审核失败,11-待审核,12-待发布,21-招标中,31-已流标,32-满标待审,41-还款中,51-还款>     成功*/
                            "auto": "0", /*是否进行过自动投标*/
                            "safestr": "",/*安全保障*/
                            "lrealname": "王小五",/*流转债权人真实姓名*/
                            "lidcard": "11010119800101779X",/*流转债权人身份证号*/
                            "lno": "100001",/*流转借款合同编号*/
                            "lstime": "0",/*流转标借款合同生效时间*/
                            "letime": "0",/*流转标借款合同结束时间*/
                            "addtime": "1357816856", /*创建时间*/
                            "uptime": "1357816881", /*更新时间*/
                            "paytime": "0", /*还款时间*/
                            "uname": "wangsongquan", /*贷款人账号*/
                            "credit": "0", /*贷款人信用等级*/
                            "score": "0.0", /*贷款人积分*/
                            "province": "湖北",
                            "month_reward_apr": "0.25",
                            "remaintime": "-9天-21时-6分",
                            "credit_star": 0,
                            "reward_amount": "0", /*奖励现金红包*/
                            "reward_coupon": "0", /*奖励代金券*/
                            "reward_redbag": "0", /*奖励理财红包*/
                            "repay_method_name": "按月等额本息",
                            "use_type_name": "短期周转",
                            "flow_unit": 35,/*已流份额*/
                            "repo_unit": 0,/*已回购份额*/
                            "remain_unit": 65, /*剩余份数*/
                            "only_mobile": "0", /*手机专享*/
                        }
                    ],
                    "page": {},/*参考一、公共参数里的page字段*/
                    "count": 80,
                    "amount": "21950.92"
                }
            }

* 回收中的投资 /user/invest/repay
    * 请求方式: GET | POST
        
        参数名  |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---
        lid     |   string  |   否      |   指定贷款编号查询
        sdate   |   string  |   否      |   起始日期，格式：2013-03-03
        edate   |   string  |   否      |   结束日期，格式：2013-03-03
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "count": {
                        "remain_amount": "156718.12", /*待收本息总额*/
                        "remain_money": "153171.64", /*待收本金总额*/
                        "remain_interest": "3546.49" /*待收利息总额*/
                    },
                    "list": [
                        {
                            "tid": "27616", /*投标编号*/
                            "tno": "0", /*投标订单号*/
                            "ptid": "23190", /*源投标ID*/
                            "lid": "101258", /*贷款编号*/
                            "slid": "0", /*子贷款ID*/
                            "scontract": "0", /*是否发送借款协议*/
                            "uid": "100008", /*用户ID*/
                            "loan_money": "200000", /*贷款总金额*/
                            "loan_apr": "21.60", /*贷款年利率*/
                            "loan_method": "i", /*还款方式*/
                            "loan_time": "1372041009", /*贷款时间*/
                            "money": "102", /*投标金额*/
                            "auto_money": "0", /*自动投标金额*/
                            "return_money": "0.00", /*已还本金*/
                            "remain_money": "102.00", /*剩余本金*/
                            "repay_amount": "107.50", /*应还总额*/
                            "return_amount": "0.00", /*已还总额*/
                            "remain_amount": "107.50", /*剩余总额*/
                            "num": "3", /*还款期数*/
                            "repay_num": "0", /*已还期数*/
                            "start_num": "1", /*起始期数*/
                            "status": "21", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                            "tstatus": "0", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "auto": "0", /*是否为自动投标*/
							"bidrank": "0", /*投标排名*/
                            "addtime": "1372039201", /*创建时间*/
                            "bidtime": "1372039201", /*投标时间*/
                            "uptime": "1372041009", /*更新时间*/
                            "paytime": "0", /*还款时间*/
                            "addip": "125.88.122.103",
                            "pay_money": "102.86", /*实际本金*/
                            "amount": "3600.00", /*总额*/
                            "time": "1374681599", 
                            "no": "1", /*编号*/
                            "uname": "liujianhong", /*贷款人*/
                            "credit": "5", /*贷款人信用等级*/
                            "province": "河北", /*贷款人所在地区*/
                            "now_amount": "1.83", /*本期回收本息*/
                            "now_remain": "105.67", /*剩余本息*/
                            "remain_num": 3, /*剩余期数*/
                            "repay_date": "2013-07-24", /*下一还款日*/
                            "out_days": 105, /*逾期天数*/
                            "out_interest": "1.54", /*逾期罚息*/
                            "cantrans": 0, /*能否债权转让*/
                            "title": "测试标二", /*贷款标题*/
                            "bid_date": "2013-06-24 10:00:01" /*投标时间*/
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 47,
                        "total": 47,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
							...
                        ]
                    }
                }
            }

* 已回收的投资 /user/invest/return
    * 请求方式: GET | POST
        
        参数名  |   类型        |   必需        |   说明
        :---        |   :---        |   :---:   |   :---
        lid     |   string  |   否      |   指定贷款编号查询
        sdate   |   string  |   否      |   起始日期，格式：2013-03-03
        edate   |   string  |   否      |   结束日期，格式：2013-03-03
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "count": {
                        "return_amount": "727681.97", /*本息总额*/
                        "return_money": "707956.00", /*本金总额*/
                        "return_interest": "19725.97" /*利息总额*/
                    },
                    "list": [
                        {
                            "tid": "27616", /*投标编号*/
                            "tno": "0", /*投标订单号*/
                            "ptid": "23190", /*源投标ID*/
                            "lid": "101258", /*贷款编号*/
                            "slid": "0", /*子贷款ID*/
                            "scontract": "0", /*是否发送借款协议*/
                            "uid": "100008", /*用户ID*/
                            "loan_money": "200000", /*贷款总金额*/
                            "loan_apr": "21.60", /*贷款年利率*/
                            "loan_method": "i", /*还款方式*/
                            "loan_time": "1372041009", /*贷款时间*/
                            "money": "102", /*投标金额*/
                            "auto_money": "0", /*自动投标金额*/
                            "return_money": "0.00", /*已还本金*/
                            "remain_money": "102.00", /*剩余本金*/
                            "repay_amount": "107.50", /*应还总额*/
                            "return_amount": "0.00", /*已还总额*/
                            "remain_amount": "107.50", /*剩余总额*/
                            "num": "3", /*还款期数*/
                            "repay_num": "0", /*已还期数*/
                            "start_num": "1", /*起始期数*/
                            "status": "21", /*状态:1-失败,2-无效,3-流标,11-成功,21-还款中,31-还款完成*/
                            "tstatus": "0", /*状态:0-初始状态,1-转让失败,2-转让取消,11-转让中,21-转让成功*/
                            "auto": "0", /*是否为自动投标*/
							"bidrank": "0", /*投标排名*/
                            "addtime": "1372039201", /*创建时间*/
                            "bidtime": "1372039201", /*投标时间*/
                            "uptime": "1372041009", /*更新时间*/
                            "paytime": "0", /*还款时间*/
                            "addip": "125.88.122.103",
                            "pay_money": "102.86", /*实际本金*/
                            "amount": "3600.00", /*总额*/
                            "time": "1374681599", 
                            "no": "1", /*编号*/
                            "uname": "liujianhong", /*贷款人*/
                            "credit": "5", /*贷款人信用等级*/
                            "province": "河北", /*贷款人所在地区*/
                            "begin_date": "2013-07-23", /*还款开始日期*/
                            "end_date": "2013-07-23", /*结束日期*/
							"tender_date": "2014-05-07 10:12:21", /*投标时间*/
							"bid_date": "2014-05-07 10:12:21", /*投标时间*/
                            "title": "测试标一", /*贷款标题*/
                            "end_earn": "36.21", /*最终收益*/
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 63,
                        "total": 63,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
							...
                        ]
                    }
                }
            }

* 债权转让 (参考：四、债权转让相关/user/transfer)

* 获取自动投标设置 /user/autobid/info
    * 请求方式: GET | POST
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "uid": "100008",
                    "total": "-1", /*自动投标总额*/
                    "money": "50000", /*单次投标金额*/
                    "retain": "5000000", /*保留可用余额*/
                    "apr_min": "21.0", /*最低利率*/
                    "apr_max": "24.0", /*最高利率*/
                    "month_min": "1", /*最低期限*/
                    "month_max": "3", /*最高期限*/
                    "repay_method": "", /*还款方式：m-按月等额本息;i-按月付息，到期还本;为空表示不限*/
                    "credit_min": "1", /*最低信用等级*/
                    "credit_max": "5", /*最高信用等级*/
                    "status": "1", /*1-已开启,2-已暂停,0-已关闭*/
                    "nodays": "0", /*自动不投天标，1-表示不投,0-表示投*/
                    "addtime": "0",
                    "uptime": "1382796343239630",
                    "rank": {
                        "no": 8 /*自动投标排名*/
                    },
                    "amount": "2045.14", /*您前面的自动排队资金总额*/
                    "user_amount": "83092.97" /*用户可用余额*/
                }
            }

* 自动投标设置 /user/autobid/[do] or do=[do] (详细见web版)
    * 请求方式: POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        do          |   string  |   是      |   操作类型：close-关闭,save-保存,enable-开启
        total       |   int     |   是      |   自动投标总额：需为-1或不少于50的整数 
        money       |   int     |   是      |   单次投标金额：需为-1或不小于50且不大于自动投标总额的整数
        apr_min     |   int     |   是      |   最低年利率：建议设置为12~24
        apr_max     |   int     |   是      |   最高年利率：建议设置为12~24 
        month_min   |   int     |   是      |   最低贷款期限：有效值是1~36
        month_max   |   int     |   是      |   最高贷款期限：有效值是1~36
        repay_method|   string  |   是      |   还款方式：""-不限,m-按月等额本息,i-按月付息
        credit_min  |   int     |   是      |   最低信用等级：有效值是1~5
        credit_max  |   int     |   是      |   最高信用等级：有效值是1~5
        retain      |   int     |   是      |   保留可用余额：需为不小于0的整数
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            /*注：返回的rank,amount是为了即时刷新排名和排队总额数据*/
            {
                "return": 1,
                "msg": "开启成功",
                "rank": {
                    "no": 8 /*自动投标排名*/
                },
                "amount": "2045.14" /*您前面的自动排队资金总额*/
            }


* 理财统计 /user/invest/stat

    * 请求方式： POST|GET
    * 返回结果： JSON

        JSON:
            
            --- 成功 --- 
            {
                "return": 1,
                "data": {
					"lent_times": "105", /*总借出笔数*/
					"lent_amount": "1543739.33", /*总借出金额*/
					"return_amount": "642525.35", /*已回收本息*/
					"return_money": "616417.00", /*已回收本金*/
					"remain_amount": "981130.07", /*剩余本息总额*/
					"remain_money": "924012.00", /*剩余本金*/
					"return_times": "73", /*已回收笔数*/
					"remain_times": "32", /*待回收笔数*/
					"return_interest": "26108.35", /*已回收收益*/
					"remain_interest": "57118.07", /*待回收利息*/
					"user_wait_amount": "981130.07", /*待回收本息*/
					"user_interest": "24951.66", /*累计赚取收益*/
					"user_wait_money": "924012.00", /*待收本金*/
					"user_wait_interest": "57118.07", /*待收利息*/
					"user_amount": "29646998.85", /*可用余额*/
					"user_freeze": "210892.00", /*冻结金额*/
					"user_total": "30839020.92", /*资产总额*/
					"interest_fee": "1156.69", /*利息管理费*/
					"day_wait": "0.00", /*日均待收*/
					"preday_wait": "0.00" /*上月日均待收*/
                }
            }


* 资金统计历史列表 /user/invest/count

    * 请求方式： POST|GET

        参数名          |   类型        |   必需        |   说明
        :---            |   :---:   |   :---:   |   :---
        sdate       |   string  |   否      |   开始日期
        edate       |   string  |   否      |   截止日期

    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "483635",
                            "uid": "100001", /*用户ID*/
                            "time": "1375200000", /*日期*/
                            "total": "0.00", /*资金总额*/
                            "remain": "0.00", /*资金余额*/
                            "amount": "0.00", /*可用余额*/
                            "wait": "0.00", /*待收总额*/
                            "addtime": "1375286401",
                            "datetime": "2013-07-31"
                        },
                        ...
                    ],
                    "page": {
                        "size": 10,
                        "count": 122,
                        "total": 13,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            ...
                        ]
                    }
                }
            }   

* 获取用户积分记录 /user/score/record
    * 请求方式: GET | POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        type    |   string  |   否      |   空或0代表所有记录类型
        sdate   |   string  |   否      |   起始日期，格式：2013-03-03
        edate   |   string  |   否      |   结束日期，格式：2013-03-03
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "88953",
                            "type": "积分提现", /*积分记录类型*/
                            "uid": "100008",
                            "rid": "14045",
                            "lid": "0",
                            "ruid": "0",
                            "points": "-160.0", /*操作积分*/
                            "avlscore": "8667.2", /*可用积分*/
                            "score": "13947.2", /*总积分*/
                            "remark": "",
                            "addtime": "1385710726",
                            "uptime": "0",
                            "status": "1",
                            "datetime": "2013-11-29 15:38:46" /*操作日期*/
                        },
                        {
                            "id": "86103",
                            "type": "积分提现",
                            "uid": "100008",
                            "rid": "13719",
                            "lid": "0",
                            "ruid": "0",
                            "points": "-160.0",
                            "avlscore": "8827.2",
                            "score": "13947.2",
                            "remark": "",
                            "addtime": "1385261574",
                            "uptime": "0",
                            "status": "1",
                            "datetime": "2013-11-24 10:52:54"
                        }
                    ],
                    "page": {
                        "size": 2,
                        "count": 114,
                        "total": 57,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7,
                            8,
                            9,
                            10
                        ]
                    }
                }
            }

* 新增或编辑收货地址 /user/address/save

    * 请求方式： POST

        参数名  |   类型    |   必需    |   说明
        :---   |   :---:   |   :---:   |   :---
        aid     |   int     |   否      |   地址ID，当编辑地址时必需
        name    |   string  |   是      |   收货人姓名
        province|   int     |   是      |   省份ID
        city    |   int     |   是      |   城市ID
        address |   string  |   是      |   收货地址
        mobile  |   string  |   是      |   联系电话
        phone   |   string  |   否      |   固话
        email   |   string  |   否      |   邮箱
        postcode|   string  |   否      |   邮政编码

    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "address": {
                        "name": "杨华",
                        "province": "110000",
                        "city": "110100",
                        "address": "北京市海淀区",
                        "mobile": "13333333333",
                        "phone": "",
                        "email": "",
                        "postcode": "",
                        "uid": "100001",
                        "uptime": 1387512957,
                        "addtime": 1387512957,
                        "id": 46
                    }
                }
            }
        
* 收货地址列表 /user/address/list

    * 请求方式： GET | POST
    * 返回结果： JSON

        JSON:
            
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "1",
                            "uid": "100001",
                            "name": "祁守艳",
                            "province": "420000",
                            "city": "420100",
                            "address": "泰合广场802室",
                            "mobile": "18611102888",
                            "phone": "",
                            "email": "",
                            "postcode": "",
                            "addtime": "1357354971",
                            "uptime": "1357354980",
                            "status": "2"
                        },
                        ...
                    ]
                }
            }

* 设置默认收货地址

    * 请求方式： POST

        参数名  |   类型    |   必需    |   说明
        :---   |   :---:   |   :---:   |   :---
        id      |   int     |   是      |   地址ID

    * 返回结果： JSON

        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg" : "设置成功"
            }


* 积分兑换：申请、列表  /user/exchane  (undo)
    * 请求方式： GET | POST
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
 
---
**六、资金管理**

* 获取用户资金信息 /user/funds/count
    * 请求方式: GET | POST
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
                {
                    "return": 1,
                    "data": {
                        "total": "260849.86", /*资金总额*/
                        "remain": "100341.97", /*资金余额*/
                        "amount": "85292.97", /*可用余额*/
                        "freeze": "15049.00", /*冻结金额*/
                        "wait_repay": "160507.89", /*待收总额*/
                        "recharge": "690485.23", /*充值总额*/
                        "avcredit": "100000.00" /*可用授信*/
                    }
                }

* 获取用户资金记录 /user/funds/record
    * 请求方式: GET | POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        type    |   string  |   否      |   空或0代表所有记录类型
        sdate   |   string  |   否      |   起始日期，格式：2013-03-03
        edate   |   string  |   否      |   结束日期，格式：2013-03-03
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "fid": "207388",
                            "type": "提现冻结",
                            "uid": "100008",
                            "rid": "6158",
                            "lid": "0",
                            "tid": "0",
                            "ruid": "0",
                            "money": "-2000.00",
                            "amount": "85292.97",
                            "freeze": "15049.00",
                            "remark": "",
                            "addtime": "1383626469",
                            "uptime": "0",
                            "sync": "0",
                            "pflag": "0",
                            "status": "1",
                            "datetime": "2013-11-05 12:41:09"
                        }
                    ],
                    "page": {
                        "size": 1,
                        "count": 675,
                        "total": 675,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 11,
                        "list": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6,
                            7,
                            8,
                            9,
                            10
                        ]
                    },
                    "in": "1482873.89",
                    "out": "1320772.87"
                }
            }

* 获取充值用户信息及配置 /user/recharge/info (可用余额、充值方式、充值银行列表等)
    
    * 请求方式：GET | POST
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "allow_offline": 1, /*是否有线下充值的权限,1-有,0-无*/
                    "user": {
                        "amount": "82992.97", /*可用余额*/
                        "avlscore": "8411.7" /*可用积分*/
                    },
                    "recharge": {
                        "fee_rate": "0.000" /*线上充值手续费率，默认为0*/
                    },
                    "offlinebank": { /*线下收款银行列表*/
                        "1": {
                            "type": "线下工行",
                            "code": "icbc",
                            "bank": "武汉泰合支行 行号:829628",
                            "name": "祁守艳",
                            "account": "6222 0832 0200 5164 955"
                        },
                        "2": {
                            "type": "线下建行",
                            "code": "ccb",
                            "bank": "武汉顺道街支行 行号:853011",
                            "name": "祁守艳",
                            "account": "6217 0028 7000 3895 966"
                        },
                        "3": {
                            "type": "线下农行",
                            "code": "abc",
                            "bank": "武汉农业银行利济路分理处",
                            "name": "祁守艳",
                            "account": "6228 4800 5225 6325 318"
                        }
                    },
                    "banklist": { /*线上充值银行列表*/
                        "tenpay": "财付通账户",
                        "ccb": "建设银行",
                        "cmb": "招商银行",
                        "boc": "中国银行",
                        "comm": "交通银行",
                        "spdb": "浦发银行",
                        "cmbc": "民生银行",
                        "gdb": "广发银行",
                        "ceb": "光大银行",
                        "cib": "兴业银行",
                        "pab": "平安银行",
                        "bob": "北京银行",
                        "bea": "东亚银行"
                    },
                    "onlineypay": [
                        {
                            "type": 2,
                            "code": "tenpay",
                            "name": "财付通"
                        }
                    ]
                }
            }

* 线上充值 /user/recharge/online

    * 请求方式：POST

        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        type        |   int     |   否      |   第三方平台充值渠道，获取recharge/info上的onlinepay值，默认为3(财付通)
        money       |   string  |   是      |   充值金额
        bankid      |   string  |   是      |   充值银行，使用recharge/info返回的banklist值，如：icbc-工商银行,cmb-招商银行等
        method      |   string  |   否      |   预留字段，充值方式，如：mobile、wap、web 等，默认为系统自动判断
        paymethod   |   string  |   否      |   预留字段，如财付通账户支付等，默认为空
    
    
    * 返回结果：JSON | XML

            JSON：
                
                --- 成功 ---
                {
                    "return": 1,
                    "payurl": "/pay/online/tenpay?amount=100&client=mobile",/*支付url，如果是相对url需要拼接*/
                    "msg": "请转到第三方支付平台继续下一步充值操作！"
                }

* 线下充值 /user/recharge/offline

    * 请求方式：POST

        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        bankid      |   int     |   是      |   线下收款银行ID
        money       |   string  |   是      |   充值金额
        name        |   string  |   是      |   汇款户名
        no          |   string  |   是      |   汇款流水号
        account     |   string  |   是      |   汇款账号
        desc        |   string  |   是      |   汇款说明
    
    
    * 返回结果：JSON | XML

            JSON：
                
                --- 成功 ---
                {
                    "return": 1,
                    "msg": "汇款提交成功，请等待后台确认!"
                }

                --- 失败 ---
                {
                    "return": 0,
                    "errmsg": "汇款提交失败"
                }


* 充值记录 /user/recharge/record

    * 请求方式
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        status  |   int     |   否      |   状态： 0-所有，1-失败，2-无效，11-充值中，12-待确认，21-充值成功，默认为0。
        sdate   |   string  |   否      |   开始日期
        edate   |   string  |   否      |   截止日期

    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "58998", /*充值编号*/
                            "uid": "100001",
                            "aid": "0",
                            "type": "财付通", /*充值渠道*/
                            "trade_no": "", /*交易号:银行易流水号*/
                            "trade_account": "南京银行",/*充值银行，可以显示为：充值渠道-充值银行*/
                            "money": "111.00", /*
                            "fee": "0.00",
                            "remark": "", /*备注*/
                            "addtime": "1384070564", /*充值时间*/
                            "oktime": "0", /*充值成功时间*/
                            "addip": "111.174.172.44", /*充值ip*/
                            "uptime": "0",
                            "upip": "",
                            "status": "11", /*状态值*/
                            "statusname": "充值失败", /*状态*/
                            "payurl": "/pay/online/tenpay?no=1888080800054649&client=mobile", /*充值失败时没有此字段，支付url，如果是相对url需要拼接*/
                            "oplist": [ /*如果oplist不为空，需显示操作按扭,点击在webview打开相应的网址，url若是相对的需拼接，并带session_key和client参数*/
                                {
                                    "name": "支付", /*操作按扭名*/
                                    "url": "/pay/online/tenpay?no=1888080800054650&bankid=icbc" /*操作url*/
                                }
                            ],

                            "no": "1888080800058998", /*充值订单号*/
                            "datetime": "2013-11-10 16:02:44" /*充值日期，可以直接取这个值显示*/
                        },
                        /*...*/
                    ]
                }
            }

* 获取提现用户信息及配置 /user/drawcash/info (提现方式、手机费率、可提现金额等)

    * 请求方式：GET | POST
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "allow_quick": 1, /*是否有预约提现的权限，1-有,0-无*/
                    "methods": [/*提现方式*/
                        {
                            "1": "汇付"
                        },
                        {
                            "3": "财付通"
                        },
                        {
                            "2": "预约"
                        }
                    ],
                    "fee_rate": { /*提现费率,method=>rate，当值为对象{}时，要解析金额范围，取得手续费*/
                        "3": 2, /*手续费都是2元*/
                        "1": 2, /*手续费都是2元*/
                        "2": {
                            "0-20000": 2, /*0到2w之间不含2w，手续费是2元*/
                            "20000-50000": 3, /*2w到5w之间不含5w，手续费是3元*/
                            "50000-0": 5 /*5w以上手续费是5元*/
                        },
                        "0": 2, /*手续费都是2元*/
                    },
                    "sfee_rate": 0.01, /*服务费费率，0.01即为1%，服务费=sfee_rate*(money-nofeedraw)*/
                    "user": {
                        "amount": "83092.97", /*可用余额*/
                        "feedraw": "83092.97", /*需收取服务费部分金额*/
                        "nofeedraw": "0.00", /*无需收取服务费部分金额*/
                        "okdraw": "83092.97", /*可提现总金额，包括收取服务费部分金额*/
                        "nodraw": "0.00" /*不可提现金额*/
                    },
                    "userbank": [ /*用户提现银行卡信息,isdef=1表示为默认，请参考银行卡管理*/
                        {
                            id": "392",
                            "isdef": "0",/*是否为默认银行1-是,0或空-否*/
                            "uid": "100008",
                            "name": "",/*开户名为空，表示是本人，目前只能绑定本人银行卡，所以不用管此字段*/
                            "bank": "中国工商银行",/*开户银行*/
                            "area": "0",/*开户省份*/
                            "city": "0",/*开户城市*/
                            "branch": "",/*开户支行名称*/
                            "code": "icbc",/*银行标识码*/
                            "card": "5201351451****1311",/*银行卡号*/
                            "status": "11",
                            "addtime": "1379079707",
                            "uptime": "1379258161"
                        },
                    ],
                    "defbank": { /*默认提现银行卡，同上*/
                        "id": "393",
                        "isdef": "1",
                        "uid": "100008",
                        "name": "",
                        "bank": "招商银行",
                        "area": "0",
                        "city": "0",
                        "branch": "",
                        "code": "cmb",
                        "card": "52013****1234",
                        "status": "11",
                        "addtime": "1379125790",
                        "uptime": "1379258161"
                    },
                    "banklist": {
                        "icbc": "中国工商银行",
                        "ccb": "中国建设银行",
                        "cmb": "招商银行",
                        "abc": "中国农业银行",
                        "boc": "中国银行",
                        "comm": "中国交通银行",
                        "spdb": "上海浦东发展银行",
                        "cib": "兴业银行",
                        "bob": "北京银行",
                        "ceb": "中国光大银行",
                        "cmbc": "中国民生银行",
                        "citic": "中信实业银行",
                        "gdb": "广东发展银行",
                        "pab": "平安银行",
                        "sdb": "深圳发展银行",
                        "other": "其它银行"
                    }
                }
            }

* 计算提现申请信息 /user/drawcash/applyinfo (手续费、服务费、实际到账金额等)

    * 特别说明：此接口建议在用户填写完提现申请表单后再请求并显示，最后点击确认提现后再调用提现申请接口drawcash/apply进行提现
    
    * 请求方式：GET | POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        money       |   string  |   是      |   提现金额
        method      |   int     |   否      |   提现方式，0-系统默认,1-汇付,2-预约,3-财付通，默认为0。
       
    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "fee": "0.00", /*提现手续费*/
                    "sfee": "1.00", /*提现服务费*/
                    "feedraw": "100.00", /*收取服务费提现金额*/
                    "realmoney": "99.00", /*实际到账金额*/
                    "avlscore": "8411.7", /*可用积分*/
                    "usescore": 160, /*需使用多少积分，如果此值为0，则不显示积分提现界面*/
                    "amount": "1000.00", /*用户可用余额*/
                }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "可用积分不足，无法使用积分提现"
            }

* 提现申请 /user/drawcash/apply

    * 请求方式：POST

        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        method      |   int     |   否      |   提现方式，0-系统默认,1-汇付,2-预约,3-财付通，默认为0。
        money       |   string  |   是      |   提现金额
        paypwd      |   string  |   是      |   支付密码
        usescore    |   string  |   否      |   当用户选择使用积分提现时需设置参数值为1
        bankid      |   int     |   是      |   提现银行卡ID
        smscode     |   string  |   是      |   短信验证码，带上money参数通过/send/smscode/drawcash获取。


    * 返回结果：JSON | XML

        JSON：
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "提现申请成功，请等待处理"
            }

            {
                "return": 1,
                "msg": "点击确定后，将跳转到汇付天下进行下一步取现授权操作，如果取现授权操作失败，请于次日到一起好提现记录里再次进行汇付提现授权！",
                "url": "/user/drawcash/pnr?id=6161" /*如果返回结果中含有url字段(url以/开头时，需拼接并带上session_key和client作为url参数)，则应alert(msg)，然后通过webview打开url，进行下一步操作*/
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "短信校验码不正确"
            }
            
            {
                "return": 0,
                "errmsg": "汇付新账户未激活",
                "url": "/user/pnr" /*如果返回结果中含有url字段(url以/开头时，需拼接并带上session_key和client作为url参数)，则应alert(errmsg)，然后通过webview打开url，进行下一步操作*/
            }

             
* 提现记录 /user/drawcash/record

    * 请求方式：GET | POST
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
        status  |   int     |   否      |   状态： 0-所有，1-失败，2-无效，3-已取消，11-等待处理，21-提现处理中，31-提现成功 （默认为0）
        sdate   |   string  |   否      |   开始日期
        edate   |   string  |   否      |   截止日期

    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "6663",/*编号*/
                            "uid": "100001",
                            "method": "2",
                            "money": "111.00",/*提现金额*/
                            "feedraw": "0.00",/*收取服务费部分金额*/
                            "fee": "2.00",/*提现手续费*/
                            "sfee": "0.00",/*提现服务费*/
                            "score": "0.0",
                            "name": "祁守艳",/*开户名*/
                            "bank": "中国建设银行",/*提现银行*/
                            "code": "ccb",/*提现银行标识码*/
                            "area": "0",
                            "city": "0",
                            "branch": "",
                            "card": "6217***********5966",/*提现银行卡号*/
                            "addtime": "1387505461",
                            "oktime": "0",
                            "uptime": "0",
                            "addip": "111.174.210.103",
                            "upip": "",
                            "remark": "",
                            "aremark": "",
                            "status": "11",
                            "opurl": "/user/drawcash/pnr?id=6161",
                            "oplist": [  /*如果oplist不为空，需显示操作按扭,点击在webview打开相应的网址，url若是相对的需拼接，并带session_key和client参数*/
                                { 
                                    "name": "授权", /*操作按扭名*/
                                    "url": "/user/drawcash/pnr?id=6161" /*操作url*/
                                }
                            ],
                            "datetime": "2013-12-20 10:11:01", /*提现时间*/
                            "statusname": "等待处理" /*提现状态*/
                        },
                        /*...*/
                    ]
                }
            }

   
* 银行卡管理-获取银行卡信息 /user/drawcash/bank/info

    * 请求方式：GET

    * 返回结果：JSON | XML

        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "needbranch": [
                        "gdb",
                        "boc",
                        "ceb",
                        "cib",
                        "other"
                    ],
                    "list": [
                        {
                            "id": "392",
                            "isdef": "0",/*是否为默认银行1-是,0或空-否*/
                            "uid": "100008",
                            "name": "",/*开户名为空，表示是本人，目前只能绑定本人银行卡，所以不用管此字段*/
                            "bank": "",
                            "area": "0",/*开户省份*/
                            "city": "0",/*开户城市*/
                            "branch": "",/*开户支行名称*/
                            "code": "icbc",/*银行标识码*/
                            "card": "5201351451****1311",/*银行卡号*/
                            "status": "11",
                            "addtime": "1379079707",
                            "uptime": "1379258161"
                        }
                    ]
                }
            }

* 银行卡管理-搜索支行名称 /user/drawcash/bank/search

    * 请求方式：POST

        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        city    |   int     |   是      |   城市ID
        bank    |   string  |   是      |   银行标识

    * 返回结果：JSON | XML

        JSON:
            
            {
                "return": 1,
                "data": [
                    {
                        "no": "309100001194",
                        "branch": "兴业银行股份有限公司北京花园路支行"
                    },
                    /*...*/
                ]
            }

* 银行卡管理-新增银行卡 /user/drawcash/bank/add

    * 请求方式：POST

        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        code    |   string  |   是      |   银行标识码
        card    |   string  |   是      |   银行卡号
        province|   int     |   否      |   支行省份ID，当银行标识码在bank/info返回的needbranch里面时，需要
        city    |   int     |   否      |   支行城市ID，同上
        bankname|   string  |   否      |   银行支行名称，同上
        smscode |   string  |   是      |   短信验证码，通过/send/smscode/bankcard获取

    * 返回结果：JSON | XML

        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg" : "添加银行卡成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "短信校验码不正确"
                /*
                "errmsg": "银行卡号不正确"
                */
            }

* 银行卡管理-编辑银行卡 /user/drawcash/bank/edit

    * 请求方式：POST

        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        bankid  |   int     |   是      |   银行ID
        code    |   string  |   是      |   银行标识码
        card    |   string  |   是      |   银行卡号
        province|   int     |   否      |   支行省份ID，当银行标识码在bank/info返回的needbranch里面时，需要
        city    |   int     |   否      |   支行城市ID，同上
        bankname|   string  |   否      |   银行支行名称，同上
        smscode |   string  |   是      |   短信验证码，通过/send/smscode/bankcard获取

    * 返回结果：JSON | XML

        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg" : "银行卡编辑成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "短信校验码不正确"
                /*
                "errmsg": "银行卡号不正确"
                */
            }


* 银行卡管理-设置默认银行卡 /user/drawcash/bank/setdef

    * 请求方式：POST
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        bankid  |   int     |   是      |   银行卡ID

    * 返回结果：JSON | XML
    
        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg"   : "设置成功"    
            } 

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "参数错误"
            }

* 银行卡管理-删除银行卡 /user/drawcash/bank/del

    * 请求方式：POST
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        bankid  |   int     |   是      |   银行卡ID

    * 返回结果：JSON | XML
    
        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg"   : "银行卡删除成功"  
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "参数错误"
            }

---
**七、个人中心**

* 获取用户基本资料 /user/info
    * 请求方式: GET
  
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "gender": "1", /*性别：1-男,2-女,0-未知*/
                    "birthdate": "1988-12-09", /*生日*/
                    "province": "310000", /*所在省份，格式参考：http://www.yiqihao.com/public/hao/js/data/tdist.js*/
                    "city": "310100", /*所在城市，格式参考：http://www.yiqihao.com/public/hao/js/data/tdist.js*/
                    "family_name": "张东", /*紧急联系人姓名*/
                    "family_phone": "1862118****", /*紧急联系人手机*/
                    "realname": "张旭", /*真实姓名*/
                    "avatar": "/public/upload/avatar/8/100008_avatar_200x200.jpg", /*头像地址*/
                    "idcard": "36072*********5251" /*身份证号码*/
                }
            }


* 修改用户基本资料 /user/info/edit (注：身份证号码idcard不在这里填写)
    * 请求方式: POST
    
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        realname    |   string  |   是      |   真实姓名
        gender      |   string  |   是      |   性别：1-男,2-女
        birthdate   |   string  |   是      |   生日，格式：1988-08-08
        province    |   string  |   是      |   省份格式，参考：http://www.yiqihao.com/public/hao/js/data/tdist.js 
        city        |   string  |   是      |   城市格式，参考：http://www.yiqihao.com/public/hao/js/data/tdist.js 
        family_name |   string  |   是      |   紧急联系人姓名
        family_phone|   string  |   是      |   紧急联系人手机号码
  
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "保存失败",
            } 

* 修改用户头像 
    1. 直接上传裁剪后的头像 /user/avatar
        * 请求方式： POST (type=file, name=avatar)

    或者

    1. 上传头像图片 /upload/avatar
        * 请求方式： POST (type=file, name=avatar_file)
        * 返回结果： JSON
        
            JSON:

                --- 成功 ---
                {
                    "return": 1,
                    "name": "Desert.jpg",
                    "type": "jpeg",
                    "size": 845941,
                    "extension": "jpg",
                    "savename": "105342_tmp_avatar.jpg",
                    "width": 1024,
                    "height": 768,
                    "mime": "image/jpeg",
                    "saveurl": "/public/upload/tmp/avatar/105342_tmp_avatar.jpg"
                }

    2. 保存头像 /user/profile/edit/avatar
        * 请求方式： POST
        
            参数名      |   类型    |   必需    |   说明
            :---        |   :---:   |   :---:   |   :---
            avatar      |   string  |   是      |   上一步返回的saveurl值 和 裁剪的坐标值如（/public/upload/tmp/avatar/105342_tmp_avatar.jpg:0,0,250,250,500,350）坐标值说明：avatar.jpg:0,0,250,250,500,350 对应：x,y,w,h,src_w,src_h， 其中x,y是当前裁剪的坐标值，w,h是裁剪后的图片大小，src_w,src_h是当前图片实际显示的大小，可能比原图要小(比如缩略显示，1920x1280的图片在iphone5下实际显示大小为：960x640))。

        
        * 返回结果： JSON
                
            JSON:

                --- 成功 ---
                {
                    "return": 1,
                    "msg": "保存成功"
                }


* 获取认证信息 /user/pauth/info
    * 请求方式： GET | POST
    
    * 返回结果： JSON
        
        JSON:

            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "idcard": "43020*********0038",
                    "auth_idcard": "1", /*auth_idcard为1表示身份已认证，为0表示未认证*/
                    "realname": "王俊钧",
                    "idcard_img": "", /*idcard_img不为空，且auth_idcard=0表示上传身份证正在审核认证中；auth_idcard=0表示认证失败*/
                    "umobile": "", /*手机号不为空表示已认证*/
                    "msg_bid_sms": "1", /*是否接收放款短信: 1-接收*/
                    "msg_repay_sms": "1", /*是否接收还款短信: 1-接收*/
                    "msg_push_sms": "1", /*是否接收推送短信：1-接收*/
                    "uemail": "***gjunjun558@163.com", /*邮箱不为空表示已认证*/
                    "use_auto_audit": "1" /*是否能使用自动认证，无需上传身份证照片*/
                }
            }


* 身份认证 /user/pauth/realname
    * 请求方式： POST
    
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        method  |   int     |   是      |   认证方式（0：人工， 1：自动）
        realname|   string  |   是      |   真实姓名
        idcard  |   string  |   是      |   身份证号
        idcard2 |   string  |   是      |   确认身份证号
        说明： 人工认证需要上传身份证正反面

    * 返回结果： JSON
    
        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }
    
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "身份证已存在"            
                /*
                "errmsg": "身份证不正确"
                */
            }

* 手机认证    /user/pauth/mobile 
    
    第一步:

    * 请求方式： POST

        参数名  |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---
        mobile  |   string  |   是      |   认证手机号
        captcha |   string  |   是      |   图形验证码

    * 返回结果：JSON | XML

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": 'xxxxxx'
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "手机号已存在"
                /*
                "errmsg": "验证码不正确"    
                */
            }

    第二步：

    * 请求方式： POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        mobile  |   string  |   是      |   第一步中的手机号
        smscode |   string  |   是      |   第一步发送的手机验证码

    * 返回结果：JSON | XML

        JSON:
        
            --- 成功 ----
            {
                "return": 1,
                "msg": "认证成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "短信校验码不正确"
            }
        

* 手机接受消息类型设置 /user/setmsg/mobile    
    * 说明： 只有在手机已认证的情况下才有效
    
    * 请求方式： POST
    
        参数名          |   类型        |   必需        |   说明
        :---                |   :---:   |   :---:   |   :---
        msg_bid_sms     |   int     |   否      |   放款短信（为空时则表示不接收，1表示接收）   
        msg_repay_sms   |   int     |   否      |   回款短信（同上）
        msg_push_sms    |   int     |   否      |   推送短信（同上）

    * 返回结果： JSON
    
        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg": "设置成功"
            }
    

* 邮箱认证 /user/pauth/email

    第一步：
    * 请求方式：POST

        参数名  |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---
        email   |   string  |   是      |   邮箱
        captcha |   string  |   是      |   图形验证码

    * 返回结果：JSON | XML

        JSON:
    
            --- 成功 ---
            {
                "return": 1,
                "msg": "发送认证邮件成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "邮箱不正确"
                /*
                "errmsg": "邮箱已存在"
                "errmsg": "验证码不正确"
                */
            }

    第二步：

    * 请求方式： POST

        参数名  |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---
        email   |   string  |   是      |   上一步填的邮箱
        code    |   string  |   是      |   邮箱验证码

    * 返回结果： JSON

        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg": "认证成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "邮箱验证码错误"
            }


* 消息中心    /user/msg/ [history-历史消息 | doread-已读 | unread-未读]

    * 请求方式： POST|GET
    
    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "list": [
                        {
                            "id": "100",
                            "uid": "0",
                            "touid": "105342",
                            "ctype": "0",
                            "type": "回款",
                            "title": "title",
                            "msg": "msg",
                            "status": "4",
                            "tostatus": "6",
                            "addtime": "1382882775",
                            "uptime": "0",
                            "datetime": "2013-10-27 22:06"
                        },
                        /*...*/
                    ],
                    "page": {},/*参考一、公共参数里的page字段*/
                }
            }


* 登录日志 /user/loginlog/list

    * 请求方式： POST|GET

        参数名  |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---    
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
        sdate   |   string  |   否      |   开始日期
        edate   |   string  |   否      |   截止日期    

    * 返回结果： JSON

        JSON:
    
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "page": {
                        "size": 10,
                        "count": 11,
                        "total": 2,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 2,
                        "list": [
                            1,
                            2
                        ]
                    },
                    "list": [
                        {
                            "id": "211256",
                            "uid": "105342",
                            "login_time": "1387510695",
                            "login_ip": "111.173.9.13",
                            "logout_time": "0",
                            "status": "1",
                            "login_date": "2013-12-20 11:38:15",
                            "logout_date": "",
                            "login_area": "湖北省武汉市 "
                        },
                        ...
                    ]
                }
            }




---
**八、贷款管理**

*  我的贷款 /user/loan/all

    * 请求方式： POST|GET
        
        参数名  |   类型        |   必需        |   说明
        :---   |   :---:   |   :---:   |   :---
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "page": {
                        "size": 10,
                        "count": 13,
                        "total": 2,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 2,
                        "list": [
                            1,
                            2
                        ]
                    },
                    "list": [
                        {
                            "lid": "101719",
                            "plid": "101689",
                            "uid": "100001",
                            "aid": "16",
                            "title": "普通标测试2",
                            "img": "/public/hao/themes/default/images/loan/8.jpg",
                            "type": "1",
                            "is_flow": "0",
                            "is_field": "1",
                            "is_plan": "1",
                            "is_okout": "0",
                            "is_newbie": "0",
                            "no_captcha": "0",
                            "use_type": "1",
                            "amount": "10000000",
                            "remain_amount": "0.00",
                            "return_amount": "0.00",
                            "repay_num": "0",
                            "late_fee": "0.00",
                            "early_fee": "0.00",
                            "fee_rate": "0.0",
                            "mfee_rate": "0.50",
                            "field_fee": "0.00",
                            "credit_fee": "0.00",
                            "other_fee": "0.00",
                            "tender_amount": "0",
                            "flow_amount": "0",
                            "repo_amount": "0",
                            "flow_date": "20130807",
                            "tender_min": "100",
                            "tender_max": "0",
                            "tender_limit_times": "0",
                            "tender_count": "0",
                            "tender_begin": "1391758200",
                            "tender_end": "0",
                            "deadline": "6",
                            "deadline_type": "m",
                            "days": "0",
                            "apr": "22.40",
                            "reward_apr": "0.00",
                            "reward_money": "0",
                            "repay_method": "e",
                            "progress": "0",
                            "exptime": "3",
                            "begintime": "0",
                            "endtime": "0",
                            "status": "35",
                            "ostatus": "1",
                            "auto": "0",
                            "description": "流转1000万测试",
                            "remark": "",
                            "lrealname": "王小五",
                            "lidcard": "11010119800101779X",
                            "lno": "",
                            "addtime": "1387174341",
                            "uptime": "1387174564",
                            "paytime": "0",
                            "fulldate": "1970-01-01 08:00",
                            "begindate": "1970-01-01 08:00:00",
                            "tender_begindate": "2014-02-07 15:30",
                            "remaintime": "",
                            "credit_star": 0,
                            "repay_method_name": "到期还本息",
                            "use_type_name": "短期周转",
                            "statusname": "待发布"
                        },
                        ...
                    ]
                }
            }

*  已还清贷款 /user/repay/ok

    * 请求方式： POST|GET

        参数名  |   类型        |   必需        |   说明
        :---   |   :---:   |   :---:   |   :---
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "page": {
                        "size": 10,
                        "count": 13,
                        "total": 2,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 2,
                        "list": [
                            1,
                            2
                        ]
                    },
                    "list": [
                        {
                            "lid": "100575",
                            "plid": "100443",
                            "uid": "100001",
                            "aid": "8",
                            "title": "短期站内周转25万",
                            "img": "8",
                            "type": "1",
                            "is_flow": "0",
                            "is_field": "1",
                            "is_plan": "1",
                            "is_okout": "0",
                            "is_newbie": "0",
                            "no_captcha": "0",
                            "use_type": "1",
                            "amount": "250000",
                            "remain_amount": "0.00",
                            "return_amount": "261375.00",
                            "repay_num": "2",
                            "late_fee": "0.00",
                            "early_fee": "0.00",
                            "fee_rate": "0.0",
                            "mfee_rate": "0.50",
                            "field_fee": "0.00",
                            "credit_fee": "0.00",
                            "other_fee": "0.00",
                            "tender_amount": "250000",
                            "flow_amount": "0",
                            "repo_amount": "0",
                            "flow_date": "0",
                            "tender_min": "0",
                            "tender_max": "0",
                            "tender_limit_times": "0",
                            "tender_count": "35",
                            "tender_begin": "1362294003",
                            "tender_end": "1362294017",
                            "deadline": "2",
                            "deadline_type": "m",
                            "days": "0",
                            "apr": "21.30",
                            "reward_apr": "0.00",
                            "reward_money": "0",
                            "repay_method": "i",
                            "progress": "100",
                            "exptime": "1362553203",
                            "begintime": "1362294035",
                            "endtime": "1367549310",
                            "status": "51",
                            "ostatus": "1",
                            "auto": "1",
                            "description": "站内周转，已投标25万：<a href=\"https://www.yiqihao.com/loan/detail/100440\">https://www.yiqihao.com/loan/detail/100440</a>",
                            "remark": "",
                            "lrealname": "",
                            "lidcard": "",
                            "lno": "",
                            "addtime": "1362284504",
                            "uptime": "1362294017",
                            "paytime": "1367549310",
                            "okdate": "2013-05-03",
                            "statusname": "准时还清"
                        },
                        ...
                    ]
                }
            }

*  待偿还贷款 /user/repay/list

    * 请求方式： POST|GET

        参数名  |   类型        |   必需        |   说明
        :---   |   :---:   |   :---:   |   :---
        size    |   int     |   否      |   分页大小, 默认为：10，取值：1~50
        p       |   int     |   否      |   页码，默认为：1 
    
    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "page": {
                        "size": 10,
                        "count": 13,
                        "total": 2,
                        "now": 1,
                        "prev": 0,
                        "next": 2,
                        "up": 1,
                        "down": 2,
                        "list": [
                            1,
                            2
                        ]
                    },
                    "list": [
                        {
                            "lid": "101709",
                            "plid": "101691",
                            "uid": "100001",
                            "aid": "16",
                            "title": "流转1000万测试四",
                            "img": "8",
                            "type": "34",
                            "is_flow": "1",
                            "is_field": "1",
                            "is_plan": "1",
                            "is_okout": "0",
                            "is_newbie": "0",
                            "no_captcha": "0",
                            "use_type": "1",
                            "amount": "10000",
                            "remain_amount": "0.00",
                            "return_amount": "0.00",
                            "repay_num": "0",
                            "late_fee": "0.00",
                            "early_fee": "0.00",
                            "fee_rate": "0.0",
                            "mfee_rate": "0.50",
                            "field_fee": "0.00",
                            "credit_fee": "0.00",
                            "other_fee": "0.00",
                            "tender_amount": "0",
                            "flow_amount": "0",
                            "repo_amount": "0",
                            "flow_date": "20131203",
                            "tender_min": "100",
                            "tender_max": "0",
                            "tender_limit_times": "0",
                            "tender_count": "0",
                            "tender_begin": "1387693620",
                            "tender_end": "0",
                            "deadline": "6",
                            "deadline_type": "m",
                            "days": "0",
                            "apr": "22.40",
                            "reward_apr": "0.00",
                            "reward_money": "0",
                            "repay_method": "e",
                            "progress": "0",
                            "exptime": "3",
                            "begintime": "0",
                            "endtime": "0",
                            "status": "35",
                            "ostatus": "1",
                            "auto": "0",
                            "description": "流转1000万测试",
                            "remark": "",
                            "lrealname": "王小五",
                            "lidcard": "11010119800101779X",
                            "lno": "",
                            "addtime": "1386039298",
                            "uptime": "1386039690",
                            "paytime": "0",
                            "repay_amount": 11120,
                            "manage_fee": "50.00",
                            "repay_date": "2014-01-03"
                        },
                        ...
                    ]
                }
            }

* 贷款统计 /user/loan/stat

    * 请求方式： POST|GET
    * 返回结果： JSON

        JSON:

            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "post_times": "13",
                    "borrow_amount": "520000.00",
                    "borrow_times": "4",
                    "return_amount": "524386.67",
                    "remain_amount": "33716033.71",
                    "loan_fee": "1800600.00",
                    "return_times": "3",
                    "remain_times": "1",
                    "system_times": "0"
                }
            }

* 个人详细信息 /user/profile

    * 请求方式： POST|GET
    * 返回结果： JSON

        JSON:

            {
                "return": 1,
                "data": {
                    "uid": "100001",
                    "auth_realname": "0",
                    "auth_mobile": "1",
                    "auth_email": "1",
                    "auth_avatar": "0",
                    "gender": "1",
                    "auth_gender": "0",
                    "birthdate": "1979-04-07",
                    "auth_birthdate": "0",
                    "idcard_province": "420000",
                    "idcard_city": "420900",
                    "province": "420000",
                    "city": "420100",
                    "district": "0",
                    "address": "泰合广场802室",
                    "auth_address": "0",
                    "address_phone": "027-6666****",
                    "auth_address_phone": "0",
                    "education": "3",
                    "auth_education": "0",
                    "graduated_year": "0",
                    "auth_graduated_year": "0",
                    "graduated_school": "",
                    "auth_graduated_school": "0",
                    "marriage": "1",
                    "auth_marriage": "0",
                    "have_child": "1",
                    "auth_have_child": "0",
                    "have_house": "1",
                    "auth_have_house": "1",
                    "house_loan": "2",
                    "auth_house_loan": "0",
                    "have_car": "1",
                    "auth_have_car": "0",
                    "car_brand": "",
                    "auth_car_brand": "0",
                    "car_year": "0",
                    "auth_car_year": "0",
                    "car_loan": "2",
                    "auth_car_loan": "0",
                    "job_company": "武汉一起好",
                    "auth_job_company": "0",
                    "job_type": "2",
                    "auth_job_type": "0",
                    "job_company_type": "8",
                    "auth_job_company_type": "0",
                    "job_company_scale": "2",
                    "auth_job_company_scale": "0",
                    "job_industry": "2",
                    "auth_job_industry": "0",
                    "job_title": "CEO",
                    "auth_job_title": "0",
                    "job_salary": "4",
                    "auth_job_salary": "0",
                    "job_years": "1",
                    "auth_job_years": "0",
                    "job_email": "qishouyan@qq.com",
                    "auth_job_email": "0",
                    "job_province": "420000",
                    "auth_job_province": "0",
                    "job_city": "420100",
                    "auth_job_city": "0",
                    "job_company_address": "泰合广场",
                    "auth_job_company_address": "0",
                    "job_company_phone": "027-8557****",
                    "auth_job_company_phone": "0",
                    "family_name": "祁守津",
                    "auth_family_name": "0",
                    "family_who": "兄弟",
                    "auth_family_who": "0",
                    "family_phone": "1867403****",
                    "auth_family_phone": "0",
                    "other_name": "张东",
                    "auth_other_name": "0",
                    "other_who": "好友",
                    "auth_other_who": "0",
                    "other_phone": "1861233****",
                    "auth_other_phone": "0",
                    "addtime": "1348796075",
                    "uptime": "1350743687",
                    "status": "11",
                    "realname": "祁守艳",
                    "avatar": "/public/upload/avatar/1/100001_avatar_200x200.jpg",
                    "idcard": "42098*********7518"
                }
            }

* 个人详细资料修改 /user/profile/edit/info 
    * 说明： 相关下拉列表的值请参考网页版
    * 请求方式： POST

        参数名      |   类型        |   必需        |   说明
        :---       |   :---:   |   :---:   |   :---
        gender      |   int     |   是      |   性别
        idcard      |   string  |   是      |   身份证号
        birthdate   |   string  |   是      |   出生日期
        education   |   int     |   是      |   学历，1-高中及一下，2-大专，3-本科，4-研究生及以上
        graduated_year  |   string  |   否  |   毕业年份
        graduated_school|   string  |   否  |   毕业学校
        marriage    |   int     |   是      |   婚姻状况，1-已婚，2-离异，3-未婚
        have_child  |   int     |   是      |   有无子女，1-有，2-无
        have_house  |   int     |   是      |   是否有房，1-有，2-无
        house_loan  |   int     |   是      |   有无房贷，1-有，2-无
        have_car    |   int     |   是      |   是否有车，1-有，2-无
        car_loan    |   int     |   是      |   有无车贷，1-有，2-无    
        idcard_province |   int |   是      |   户籍省份
        idcard_city     |   int |   是      |   户籍城市    
        province    |   int |   是      |   居住省份
        city        |   int |   是      |   居住城市
        address     |   string  |   是      |   住宅地址
        address_phone|  string  |   是      |   住宅电话
        avatar      |   string  |   否      |   头像
        avatar_file |   string  |   否      |   头像文件
            
    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "身份证已存在"
                /*
                "errmsg": "XX不正确"                
                */
            }

* 工作信息修改 /user/profile/edit/job
    * 说明： 相关下拉列表的值请参考网页版
    * 请求方式： POST

        参数名      |   类型        |   必需        |   说明
        :---        |   :---:   |   :---:   |   :---
        job_company |   string  |   是      |   公司名称
        job_type    |   int     |   是      |   职业类型
        job_province|   int     |   是      |   工作省份
        job_city    |   int     |   是      |   工作城市
        job_company_type    |   int     |   是      |   公司类别
        job_industry        |   int     |   是      |   公司行业
        job_company_scale   |   int     |   是      |   公司规模
        job_title   |   string  |   是      |   职位
        job_salary  |   int     |   是      |   月收入
        job_years   |   int     |   是      |   工作年限
        job_company_phone   |   string  |   是  |   公司电话
        job_email           |   string  |   是  |   工作邮箱
        job_company_address |   string  |   是  |   公司地址

    * 返回结果： JSON

        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "XX不正确"                
            }

* 联系人信息修改  /user/profile/edit/contact

    * 请求方式： POST
    
        参数名      |   类型    |   必需    |   说明        
        :---        |   :---:   |   :---:   |   :---
        family_name |   string  |   是      |   联系人
        family_who  |   string  |   是      |   关系
        family_phone|   string  |   是      |   电话
        other_name  |   string  |   是      |   其它联系人
        other_who   |   string  |   是      |   关系
        other_phone |   string  |   是      |   电话

    * 返回结果： JSON

        JSON:

            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "XX不正确"                
            }
    
* 修改登录密码    /user/password/edit/login

    * 请求方式： POST

        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        password    |   string  |   是      |   原登录密码
        newpassword |   string  |   是      |   新密码
        newpassword2|   string  |   否      |   重复新密码

    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "修改成功"
            }
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "原登录密码不正确"
                /*
                "errmsg": "新登录密码和旧密码不能相同"
                */
            }

* 修改支付密码  /user/password/edit/pay

    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        login_password  |   string  |   是      |   登录密码
        password        |   string  |   是      |   原支付密码
        newpassword     |   string  |   是      |   新支付密码
        newpassword2    |   string  |   否      |   重复新支付密码

    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "修改成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "登录密码不正确"
                /*
                "errmsg": "原支付密码不正确"            
                "errmsg": "新支付密码和旧支付密码不能相同"
                "errmsg": "支付密码必须和登录密码不一样"
                */
            }

* 设置密保  /user/safe/qa/save

    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        question  |   string  |   是      |   密保问题
        answer        |   string  |   是      |   密保答案


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "设置成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "密保问题不能为空"                
            }

* 密保修改  /user/safe/qa/edit

    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        old_answer        |   string  |   是      |   旧密保答案
        question  |   string  |   是      |   密保问题
        answer        |   string  |   是      |   密保答案


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "修改成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "登录密码不正确"                
            }
 
 ** 修改手机（邮箱）
 
 1， 获取旧手机或邮箱验证码 
 
     /send/smscode/change [手机验证码] 
          
     /send/emailcode/change [邮箱验证码]   

    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        mobile[email]  |   string  |   是      |  旧手机[旧邮箱]
        idcard        |   string  |   否（如果已验证身份证，必需）      |   身份证号
        answer  |   string  |   是      |   密保答案


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "发送成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "身份证号不正确"                
            } 
                      
2，验证第一步里面的旧邮箱或手机

    /send/check/smscode/change  [验证旧手机]
    
    /send/check/emailcode/changemobile [验证旧邮箱]
    
    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        mobile[email]  |   string  |   是      |  旧手机[旧邮箱]
        code        |   string  |   是      |   手机或邮箱验证码


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "手机验证码发送成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "验证码不正确"                
            } 

3，验证新手机或邮箱

    /user/pauth/mobile/change  [手机]
    
    /user/pauth/email/change [邮箱]
    
    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        mobile[email]  |   string  |   是      |  新手机[新邮箱]
        code        |   string  |   是      |   手机或邮箱验证码


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "变更成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "验证码不正确"                
            }

附加，获取新手机或邮箱验证码

    /send/smscode/newauth
    
    /send/emailcode/newauth
    
    * 请求方式： POST

        参数名          |   类型    |   必需    |   说明
        :---            |   :---:   |   :---:   |   :---
        mobile[email]  |   string  |   是      |  新手机[新邮箱]


    * 返回结果： JSON

        JSON:
            
            --- 成功 ---
            {
                "return": 1,
                "msg": "发送成功"
            }

            --- 失败 ---
            {
                "return": 0,
                "errmsg": "手机不正确"                
            }

---
**九、客户端相关**

* 获取移动端图片广告 /get/mbanner
    * 请求方式: GET

    * 返回结果：JSON | XML
        
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": [
                    {
                        "img": "http://yiqihao.com/public/img/mobile/banner/1.jpg", /*广告图片地址*/
                        "url": "http://bbs.yiqihao.com" /*广告链接*/
                    },
                    {
                        "img": "http://yiqihao.com/public/img/mobile/banner/1.jpg",
                        "url": "http://bbs.yiqihao.com"
                    },
                    {
                        "img": "http://yiqihao.com/public/img/mobile/banner/1.jpg",
                        "url": "http://bbs.yiqihao.com"
                    }
                ],
                "mtime": 1387200975 /*更新时间，可以在客户端保存此时间，如果时间一样，则不用更新广告*/
            }
     

*  获取客户端好评网址 /mobile/review
    * 请求方式: GET | POST (需带上公共的client参数)
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "url": "http://www.yiqihao.com" /*当url不为空的时候，表示要跳转好评url*/
            }
 
*  客户端反馈 /mobile/feedback
    * 请求方式: POST (需带上公共的client参数)
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        content     |   string  |   是      |   反馈内容
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "反馈成功"
            }

*  客户端检查版本更新 /mobile/version
    * 请求方式: GET | POST (需带上公共的client参数)
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "version": "1.0.0", /*当返回的版本号和客户端现有版本号不一样时需要提示有新版本更新*/
                "url": "" /*当url不为空时，表示有新版本更新,ios可以转到appstore，android可以直接通过url下载apk*/
            }

*  客户端设备标识记录 /mobile/device/[platform] platform可以是ios,android等
    * 请求方式: GET | POST (需带上公共的client参数)
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        token       |   string  |   是      |   客户端设备令牌，如：ios的device_token
        platform    |   string  |   否      |   可以是：ios,android,winphone等
        

    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "保存成功"
            }


* 获取推送消息
    * 请求方式: GET
        
        msg_sub_url 通过/mobile/config获取，已登录的通过/user/getinfo获取
        如：http://notify.yiqihao.com:8808/sub?cname=notify&uid=100001
        
    * 返回结果：JSON | XML
        
        JSON:
        
            --- 成功 ---
            {
                "type": "hao", /*hao-通用消息通知,act-活动消息,zhi-投标成功,shou-收到回款,biao-新标发布,noop-无消息*/
                "title": "msg title", /*消息标题*/
                "content": "msg content", /*消息内容*/
                "url": "http://url", /*要跳转的url*/
                "lid": "10001", /*贷款编号，如果存在的话*/
            }
 
            --- 失败 ---
            {
                "type": "noop" /*无消息*/
            }


*  分享赚积分接口 /share/addscore
    * 请求方式: POST
        
        参数名      |   类型    |   必需    |   说明
        :---        |   :---:   |   :---:   |   :---
        key         |   string  |   是      |   校验串，生成规则邮件答复
        type        |   string  |   是      |   可以是：weixin,weibo等
        time        |   string  |   是      |   客户端分享时间精确到毫秒，如：20140610143826000
        points      |   int     |   否      |   增加的积分点数，暂由服务端控制。
        

    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "msg": "您已成功赚取2个积分"
            }

* 扫码登录接口 /qrcode/login

        www.yiqihao.com/qrcode/login/1aabac6d068eef6a7bad3fdf50a05cc8?client=&session_key=
        如果扫描的结果是一个url并且url里的host包含.yiqihao.com/qrcode/login 就像微信登录网页版本那样，
        提示用户确认登录(如果用户没有登录要先跳到登录页面登录再提示)
        用户确认登录一起好网页后，就带参数client和session_key来请求一次这个url就行了。


* 安全支付接口-获取安全支付信息(即获取绑定银行卡) /user/authpay/info
    * 请求方式: GET
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        money   |   string  |   否      |   支付金额，绑卡时不需要带，默认为0.01
        blid    |   string  |   否      |   贷款编号，只有投标时才需要带上
        bmoney  |   string  |   否      |   投标金额，只有投标时才需要带上
    
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功：已绑卡，直接将支付请求参数传入sdk进行支付请求 ---
            {
                "return": 1, /*详细见下面的补填信息接口*/
                "data": {
                    "url":"", /*支付网关地址*/
                    "query":{}, /*支付请求参数*/
                    "agreeno":"", /*签约协议号*/
                }
            }
       
            --- 成功：需要补填实名银行卡信息 ---
            {
                "return": 2,
                "data": {
                    "mobile": "18903059288", /*手机号*/
                    "uid": "111825", /*uid*/
                    "realname": "张东", /*姓名*/
                    "idcard": "110101201401011770", /*身份证号*/
                    "auth_idcard": "0", /*1-已实名时姓名、身份证号禁止修改，也无需提交*/
                    "regtime": "1391508964", /*注册时间*/
                    "amount": "0.01", /*支付金额*/
                    "blid": 0, /*贷款编号*/
                    "bmoney": 0, /*投标金额*/
                    "cardno": "622202100103002" /*银行卡号*/
                }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "系统繁忙",
            }


* 安全支付接口-补填并获取安全支付信息(即绑定银行卡) /user/authpay/info
    * 请求方式: POST
        
        参数名  |   类型    |   必需    |   说明
        :---    |   :---:   |   :---:   |   :---
        realname|   string  |   否      |   已实名的无需带上，否则必须带上
        idcard  |   string  |   否      |   已实名的无需带上，否则必须带上
        bankcard|   string  |   是      |   必须带上
        amount  |   string  |   否      |   支付金额，注册绑卡时不需要带，默认为0.01
        blid    |   int     |   否      |   贷款编号，只有投标时才需要带上
        bmoney  |   int     |   否      |   投标金额，只有投标时才需要带上
    
    * 返回结果：JSON | XML
    
        JSON:
            
            --- 成功：直接将支付请求参数传入sdk进行支付请求 ---
            {
                "return": 1,
                "data": {
                    "backurl": "/user/authpay/callback", /*客户端回调地址*/
                    "url": "https://yintong.com.cn/llpayh5/authpay.htm", /*支付网关地址，预留*/
                    "query": { /*支付请求参数列表，见相关文档*/
                        "version": "1.0",
                        "oid_partner": "201411121000096507",
                        "sign_type": "MD5",
                        "userreq_ip": "127.0.0.1",
                        "id_type": "0",
                        "valid_order": "1440",
                        "user_id": "111825",
                        "timestamp": "20141212133439",
                        "busi_partner": "101001",
                        "no_order": "1888080800204753",
                        "dt_order": "20141212133439",
                        "name_goods": "一起好账户充值",
                        "info_order": "用户充值:111825:0.01:5byg5pet5LicOjM2MDcyMTE5ODgxMjA5NTI1MTo.",
                        "money_order": "0.01",
                        "notify_url": "http://beta.yiqihao.com/pay/notify/authpay",
                        "url_order": "http://beta.yiqihao.com",
                        "risk_item": "{\"user_info_mercht_userno\":\"111825\",\"user_info_full_name\":\"\\u5f20\\u65ed\\u4e1c\",\"user_info_dt_register\":\"20140204181604\",\"frms_ware_category\":\"2009\",\"user_info_identify_state\":\"0\"}",
                        "acct_name": "张旭东",
                        "id_no": "360721198812125252",
                        "card_no": "6228480605892807222",
                        "sign": "aff6c85bc2cfe483941c212824c91793"
                    },
                    "agreeno": ""
                }
            }
            
            --- 失败 ---
            {
                "return": 0,
                "errmsg": "身份证不正确",
            }


* 安全支付接口-支付成功主动回调通知 /user/authpay/callback

    * 请求方式: POST
    * 请求参数: 此数据参数由支付sdk返回，支持以标准表单或JSON数据格式请求，如下所示
       
            --- JSON 数据格式: ret_code=0000 && result_pay == SUCCESS 才表示支付成功 ---
            {
                "ret_code": "0000",
                "ret_msg": "交易成功",
                "oid_partner": "201411121000096507",
                "dt_order": "20141212195518",
                "no_order": "1888080800204760",
                "oid_paybill": "2014121299451110",
                "money_order": "2000.0",
                "result_pay": "SUCCESS",
                "settle_date": "20141212",
                "sign_type": "MD5",
                "sign": "b6cd4d7bf2015881fe5423c68eec4bf1"
            }

            --- 表单数据格式 ---
            ret_code=0000&ret_msg=%E4%BA%A4%E6%98%93%E6%88%90%E5%8A%9F&oid_partner=201411121000096507&dt_order=20141212195518&no_order=1888080800204760&oid_paybill=2014121299451110&money_order=2000.0&result_pay=SUCCESS&settle_date=20141212&sign_type=MD5&sign=b6cd4d7bf2015881fe5423c68eec4bf1


    * 返回结果：JSON | XML
    
        JSON:
        
            --- 支付或绑卡成功 ---
            {
                "return": 1,
                "msg": "操作成功"
            }

            --- 支付并投标成功 ---
            {
                "return": 1,
                "msg": "支付并投标成功"
            }

            --- 支付成功但投标失败，有可能已满标 ---
            {
                "return": 1,
                "msg": "支付成功，但投标失败，请手动尝试！"
            }


*  获取投资详情 /user/invest/detail?[tid|id]=
    * 请求方式: GET | POST
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "tid": "8",
                    "tno": "0",
                    "paytype": "0",
                    "ptid": "0",
                    "lid": "100001",
                    "slid": "0",
                    "scontract": "0",
                    "uid": "100008",
                    "loan_money": "30000",
                    "loan_apr": "24.00",
                    "loan_method": "m",
                    "loan_time": "1349084581",
                    "money": "1000",
                    "auto_money": "0",
                    "return_money": "1000.00",
                    "remain_money": "0.00",
                    "repay_amount": "1134.72",
                    "return_amount": "1039.05",
                    "remain_amount": "0.00",
                    "num": "12",
                    "repay_num": "12",
                    "start_num": "0",
                    "status": "31",
                    "tstatus": "21",
                    "auto": "0",
                    "bidrank": "0",
                    "addtime": "1348887097",
                    "bidtime": "1348887097",
                    "uptime": "1349084581",
                    "paytime": "1354601921",
                    "addip": "61.184.205.36",
                    "pay_money": "1000.00",
                    "is_flow": "0",
                    "loan_status": "51",
                    "amount": "30000",
                    "begintime": "1349084581",
                    "repay_method": "m",
                    "deadline": "12",
                    "days": "0",
                    "apr": "24.00",
                    "reward_apr": "0.00",
                    "title": "开张",
                    "img": "0",
                    "luid": "100014",
                    "bid_date": "2012-09-29 10:51:37",
                    "contract_url": "/loan/contract/100001?output=pdf&tid=8"
                }
            }


*  获取推荐有奖列表接口 /user/invite/list
    * 请求方式: GET | POST
        
    * 返回结果：JSON | XML
    
        JSON:
        
            --- 成功 ---
            {
                "return": 1,
                "data": {
                    "page": {
                        "size": 10,
                        "count": 2,
                        "total": 1,
                        "now": 1,
                        "prev": 0,
                        "next": 0,
                        "up": 1,
                        "down": 1,
                        "list": [
                            1
                        ]
                    },
                    "list": [
                        {
                            "uid": "102922",
                            "uname": "征01", /*用户名*/
                            "money": "100.00", /*获得奖励金额*/
                            "addtime": "1365218044", /*注册时间*/
                            "datetime": "2013-04-06 11:14:04" /*格式化后的注册时间*/
                        }
                    ],
                    "total": "2", /*当page.now=1的时候才会返回total=推荐总人数,oknum=成功人数,money=推荐奖励总额*/
                    "oknum": "2",
                    "money": "200.00"
                }
            }

---
**附录一、贷款相关计算公式**

* 投标多少元可获得多少收益

            money  = 100; // 投标金额
            apr = 24; // 年利率%
            deadline = 12; // 贷款期限

            monthApr = apr/12/100; // 月利率
            当repay_method=m(等额本息)时，
            interest = money * monthApr * pow((1+monthApr), deadline) / (i-1) * deadline - money;

            当repay_method=i(按月付息，到期还本)或e(到期还本息)时,
            interest = money * monthApr * deadline;
    

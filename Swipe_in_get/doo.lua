env_ = 0  -- 设置一个变量 env_，初始值为 0

function _https(post, by, version, logi, debug)
    -- 定义一个名为 _https 的函数，接受五个参数：post、by、version、logi 和 debug

    -- 获取服务器地址 URL 和登录服务器
    URL = Config.getServe(nil)  -- 获取服务器地址
    Server = login_sever  -- 设置 Server 变量为登录服务器

    -- 根据登录服务器不同，设置不同的 User Agent
    if Server == sh.SERVE[1] then
        Agent = "Sky-Live-com.tgc.sky.android.test.goldwr"
    else
        Agent = "Sky-Test-com.tgc.sky.android.test.goldwr"
    end

    -- 构建 POST 请求的完整 URL
    POST = "https://" .. URL .. post

    -- 如果 version 为 nil，将其设置为默认值 "999999"
    if version == nil then
        version = "999999"
    end

    -- 构建请求头部信息
    header = {}
    header["Host"] = URL
    header["user-id"] = env.getPref("user")
    header["session"] = env.getPref("session")
    header["trace-id"] = sh.trace()
    header["Content-Type"] = 'application/json'
    header["x-sky-level-id"] = "3526133726"
    header["x-sky-install-source"] = "com.android.vending"
    header["X-Session-ID"] = "7fe4734f-d5e6-476d-acb5-16471a370e69"
    header["User-Agent"] = "Sky-Test-com.tgc.sky.android.test.gold/0.21.0."..version.." (OnePlus KB2000; android 31.0.0; zh)"

    -- 获取用户信息
    user = header["user-id"]
    sess = header["session"]

    -- 判断 by 的类型并构建请求数据 Data
    if type(by) ~= "string" then
        -- 如果 by 不是字符串类型

        if next(by) == nil then
            Data = '{"user":"' .. user .. '","session":"' .. sess .. '"}'
        else
            if post == "/account/auth/create" then
                Json_def = json.encode(by):gsub("{", "", 1)
            else
                Json_def = '{"user":"' .. user .. '","session":"' .. sess .. "\"," .. json.encode(by):gsub("{", "", 1)
            end

            -- 根据 logi 的值构建 Data
            if logi ~= nil then
                Data = Json_sort(Json_def, logi)
                Number = 1
            else
                Data = Json_def:gsub(",}", "}"):gsub("\n", ""):gsub("	", "")
            end
        end

        -- 判断 Number 变量并修正 Data
        if Number == 1 then
            if post == "/account/auth/create" then
                header["User-Agent"] = "Sky-Live-com.tgc.sky.android.test.gold/0.21.0."..version.." (OnePlus KB2000; android 31.0.0; zh)"
                Data = "{" .. Data .. "}"
            else
                Data = '{"user":"' .. user .. '","session":"' .. sess .. '",' .. Data .. "}"
            end
            Data = Data:gsub(",}", "}")
        end
    else
        Data = by
    end

    -- 发起 HTTPS 请求并获取响应内容
    Content = gg.makeRequest(POST, header, Data).content

    -- 如果 debug 不为 nil，则输出调试信息
    if debug ~= nil then
        print(post)
        obj = require("json")
        obj.parse(Content)
        print(obj.format().."\n")
    end
end

function test(a, b)
    -- 定义一个名为 test 的函数，接受两个参数：a 和 b
    return _https(a, b, nil, nil, 0)  -- 调用 _https 函数并返回结果
end

function main()
    -- 定义主函数 main

    -- 调用 _https 函数来执行不同的请求操作
    _https("/account/get_latest_build_version", {}, nil, nil, 0)
    _https("/account/get_vars", {}, nil, nil, 0)
    _https("/account/get_motd", {}, nil, nil, 0)
    _https("/account/get_friends", {["players"] = {}}, nil, nil, 0)
    -- ... 还有其他类似的请求

    return true  -- 返回 true 表示执行完成
end

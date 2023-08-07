env_ = 0

function _https(post, by, version, logi,debug)
    URL = Config.getServe(nil)
    Server = login_sever
    if Server == sh.SERVE[1] then
        Agent = "Sky-Live-com.tgc.sky.android.test.goldwr"
    else
        Agent = "Sky-Test-com.tgc.sky.android.test.goldwr"
    end

    --[[  if version ~= nil then
          login(Server, "/account/auth/login", version)
      end  ]]
    POST = "https://" .. URL .. post
    if version == nil then
        version = "999999"
    end
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
--    "Sky-Test-com.tgc.sky.android.test.gold/0.21.0.999999 (OnePlus KB2000; android 31.0.0; zh)"

    user = header["user-id"]
    sess = header["session"]
   -- import("string")
    if type(by) ~= "string" then
        if next(by) == nil then
            Data = '{"user":"' .. user .. '","session":"' .. sess .. '"}'
        else
            if post == "/account/auth/create" then
                Json_def = json.encode(by):gsub("{", "", 1)
            else
                Json_def = '{"user":"' .. user .. '","session":"' .. sess .. "\"," .. json.encode(by):gsub("{", "", 1)
            end
            if logi ~= nil then
                Data = Json_sort(Json_def, logi)
                Number = 1
            else
                Data = Json_def:gsub(",}", "}"):gsub("\n", ""):gsub("	", "")
            end
        end
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
    Content = gg.makeRequest(POST, header, Data).content
    if debug~=nil then
    print(post)
        obj = require("json")
        obj.parse(Content)
        print(obj.format().."\n")
 --       print(Data)
    end
  --  Json = Content:gsub('%[(.-)%]', '{%1}'):gsub('%[(.-)%]', '{%1}'):gsub('([%a%d_"]+):([^:])', '[%1]:%2'):gsub(
   --         "([^:]):([^:])", "%1=%2") -- table.json([[]]..Content..[[]])
 --   return load("return " .. Json)()
end
function test(a,b)
    return _https(a,b,nil,nil,0)
end

function main()
--    env_ = envv
    _https("/account/get_latest_build_version",{},nil,nil,0)
    _https("/account/get_vars",{},nil,nil,0) --{"vars":{}}
    _https("/account/get_motd",{},nil,nil,0)
    _https("/account/get_friends",{["players"] = {}},nil,nil,0)
    _https("/account/get_friend_statues",{["max"]=150,["sort_ver"]=1},nil,nil,0)
    _https("/account/get_online_friends",{},nil,nil,0)
    _https("/account/get_rank",{},nil,nil,0)
    _https("/account/get_currency",{},nil,nil,0)
    _https("/account/get_forge_rates",{},nil,nil,0)
    _https("/account/get_achievement_stats",{},nil,nil,0)
    _https("/account/get_relationship_abilities",{},nil,nil,0)
    _https("/account/get_achievements",{ ["platform"] = ""},nil,nil,0)
    _https("/account/get_surveys",{},nil,nil,0)
    _https("/account/iaplist",{["platform"] = "fake",["country"] = "US"},nil,nil,0)
    _https("/account/get_event_schedule",{},nil,nil,0)
    test("/account/get_account_world_quests",{})
    test("/account/get_invites",{ })
    test("/account/get_unlocks",{ })
    test("/account/get_shop",{ })
    test("/account/get_spirit_shops",{["l"] = 1000,["o"] = 0,["v"] = 0 })
    test("/account/get_collectibles",{ })
    test("/account/wing_buffs/get",{ })
    test("/account/get_pending_messages",{["exclude_free_gifts"] = true})
    test("/account/get_app_badge_number",{ })
    test("/account/consumable/get_consumable_defs",{ })
    test("/account/buff/get_buff_defs",{ })
    test("/account/buff/get_buffs1",{ })
    test("/account/lootboxes/get",{ })
    test("/account/get_checkpoints",{ })
    test("/account/get_generic_shops",{ })
    test("/account/get_external_friends",{ ["max_count"] = 64})
    test("/account/serendipity/get",{ ["max_count"] = 4})
    test("/account/star/get",{ })
    test("/service/status/api/v1/get_unlocks",{ ["max_count"] = 32})
    test("/service/relationship/api/v1/free_gifts/get_pending",{})
    test("/account/get_level_pickups",{ ["level"] = 3526133726  })
  --  test("/account/get_outfit", {})
    
    return true
end
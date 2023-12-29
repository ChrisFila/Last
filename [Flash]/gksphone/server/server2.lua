



	ESX.RegisterServerCallback('gksphone:blocknumber', function(source, cb)
		local e=ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM gksphone_blockednumber WHERE identifier = @identifier',{["@identifier"]=e.identifier},function(result)
			local bnumber = {}
			for i=1, #result, 1 do
				table.insert(bnumber, {id = result[i].id, number = result[i].number}) 
			end
			cb(bnumber)
		end)
	end)
	


ESX.RegisterServerCallback('gksphone:getgps', function(source, cb)
	local e=ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM gksphone_gps WHERE hex = @identifier ORDER BY id DESC',{["@identifier"]=e.identifier},function(result)
		local gps = {}
		for i=1, #result, 1 do
			table.insert(gps, {id = result[i].id,	nott=result[i].nott, gps=result[i].gps}) 
		end
		cb(gps)
	end)
end)


RegisterServerEvent('gksphone:newwgps')
AddEventHandler('gksphone:newwgps', function(a, b)

local src = source
local e = ESX.GetPlayerFromId(src)
if e then
	MySQL.Async.insert('INSERT INTO gksphone_gps (`hex`, `nott`, `gps`) VALUES(@identifier, @nott, @gps);', {
		['@identifier'] = e.identifier,
		['@nott'] = a,
		['@gps'] = b,
	}, function (result)
	
		TriggerClientEvent('updategps', e.source,a,b)

	end)
end
end)

RegisterServerEvent('gksphone:deltblknumber')
AddEventHandler('gksphone:deltblknumber', function(a, b)

local src = source
local e = ESX.GetPlayerFromId(src)
if e then
	MySQL.Async.insert('DELETE FROM gksphone_blockednumber WHERE id = @id AND number = @number', {
		['@number'] = b,
		['@id'] = a
	}, function (result)
	
		TriggerClientEvent('yenNumber', -1)

	end)
end
end)

RegisterServerEvent('gksphone:delettegps')
AddEventHandler('gksphone:delettegps', function(a, b)

local src = source
local e = ESX.GetPlayerFromId(src)
if e then
	MySQL.Async.insert('DELETE FROM gksphone_gps WHERE id = @id AND hex = @identifier', {
		['@identifier'] = e.identifier,
		['@id'] = a
	}, function (result)
	
		TriggerClientEvent('updategps', e.source,a)

	end)
end
end)




ESX.RegisterServerCallback("gksphone:getsCrypto",function(a,b)
    local d=ESX.GetPlayerFromId(a)
    if not d then 
        return 
    end;
    MySQL.Async.fetchAll("SELECT crypto FROM gksphone_settings WHERE identifier = @identifier",{["@identifier"]=d.identifier},function(e)
		b(json.decode(e[1].crypto))
    end)
end)


RegisterServerEvent("gksphone:alCrypto")
AddEventHandler("gksphone:alCrypto",function(a,b,c,d)
	local _source = source
	local e=ESX.GetPlayerFromId(source)
	local name = GetPlayerName(_source)
    if not e then
         return 
        end
         local g={}
         MySQL.Async.fetchAll("SELECT * FROM gksphone_settings WHERE identifier = @identifier",{["@identifier"]=e.identifier},function(h)
			g=json.decode(h[1].crypto)
            if a==1 then 	

                if e.getAccount("bank").money>= d then 

					if (g[b] == nil) then

						g[b] = c
						
					else
						g[b]=g[b]+(c);
					end
	
					MySQL.Async.execute("UPDATE gksphone_settings SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=e.identifier,["@crypto"]=json.encode(g)})
                    e.removeAccountMoney("bank",d)


					MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
						["@type"] = 2,
						["@identifier"] = e.identifier,
						["@price"] = d,
						["@name"] = 'buy ' ..c ..' ' ..b 
					})
					TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = _U('cyrpto_buy') ..c ..' ' .. b , img= '/html/static/img/icons/bourse1.png' })
                    TriggerClientEvent("yenCrypto",e.source,b)
					TriggerEvent('gksphone:cryptobuysellwebhook', 'purchased', d, e.identifier, c, b, 1942002, name)
                else 
					TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = _U('not_enough_money'), img= '/html/static/img/icons/bourse1.png' })
					TriggerClientEvent("yenCrypto",_source)
                end 
            elseif a==2 then 
				if (g[b] ~= nil) then
					if g[b]>= c then 
						
							
						
							g[b]=g[b]-(c);
						
						
						MySQL.Async.execute("UPDATE gksphone_settings SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=e.identifier,["@crypto"]=json.encode(g)})
						e.addAccountMoney("bank",d)
						MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
							["@type"] = 1,
							["@identifier"] = e.identifier,
							["@price"] = d,
							["@name"] = c.. ' ' ..b ..' sale'
						})
						TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = _U('cyrpto_sell') ..c .. b , img= '/html/static/img/icons/bourse1.png' })
						TriggerClientEvent("yenCrypto",e.source,b)
						TriggerEvent('gksphone:cryptobuysellwebhook', 'sold', d, e.identifier, c, b, 15158332, name)
					else 
						TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = _U('not_enough_coin'), img= '/html/static/img/icons/bourse1.png' })
						TriggerClientEvent("yenCrypto",_source)
	
					end 
				else 

					TriggerClientEvent("yenCrypto",_source)
					TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = b .._U('not_crypto'), img= '/html/static/img/icons/bourse1.png' })
			

				end
			end
	end)
end)

RegisterServerEvent("gksphone:transferCrypto")
AddEventHandler("gksphone:transferCrypto",function(number,adet, id)
	local _source = source
	local e=ESX.GetPlayerFromId(source)
	local transferto = getIdentifierByPhoneNumber(number)

	if (transferto ~= nil) then
    if not e then
         return 
        end
         local g={}
         MySQL.Async.fetchAll("SELECT * FROM gksphone_settings WHERE identifier = @identifier",{["@identifier"]=e.identifier},function(h)
			g=json.decode(h[1].crypto)


					if (g[id] == nil or g[id] == 0 or g[id] < adet) then

						TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = id.. _U('cyrpto_check') , img= '/html/static/img/icons/bourse1.png' })
						TriggerClientEvent("yenCrypto",_source)
						
					else

						g[id]=g[id]-(adet);
					
	
					MySQL.Async.execute("UPDATE gksphone_settings SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=e.identifier,["@crypto"]=json.encode(g)})
                
						Citizen.Wait(500)

					TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = adet .. ' ' ..id .. _U('cyrpto_transfer'), img= '/html/static/img/icons/bourse1.png' })
                    TriggerClientEvent("yenCrypto",e.source,id)
					

						MySQL.Async.fetchAll("SELECT * FROM gksphone_settings WHERE identifier = @identifier",{["@identifier"]=transferto},function(nebula)
							funda=json.decode(nebula[1].crypto)
				
				
				
									if (funda[id] == nil) then
				
										funda[id] = adet
										
									else

										funda[id]=funda[id]+(adet);

									end
					
									MySQL.Async.execute("UPDATE gksphone_settings SET crypto = @crypto WHERE identifier = @identifier",{["@identifier"]=transferto,["@crypto"]=json.encode(funda)})


									local name = getFirstname(e.identifier)  .. " " .. getLastname(e.identifier)

									local name2 = getFirstname(transferto)  .. " " .. getLastname(transferto)

									TriggerEvent('gksphone:cryptotranwebhook', name, adet, id, name2, transferto, e.identifier)
								
				
									getSourceFromIdentifier(transferto, function (osou)
										if tonumber(osou) ~= nil then 
										
										
											TriggerClientEvent('gksphone:notifi', tonumber(osou), {title = 'Bourse', message = adet.. ' ' .. id ..  _U('cyrpto_transfer2'), img= '/html/static/img/icons/bourse1.png' })
											TriggerClientEvent("yenCrypto",tonumber(osou),id)
											
										end
					
									end)
				
				
						end)
					end			

			end)




	else

		TriggerClientEvent('gksphone:notifi', _source, {title = 'Bourse', message = _U('cyrpto_notplayer'), img= '/html/static/img/icons/stocks.png' })
		TriggerClientEvent("yenCrypto",_source)

	end

end)


local sayac = 0


ESX.RegisterServerCallback('gksphone:checkSpam', function(source, cb)
    if sayac == 0  then
        cb(0)
        sayac = sayac + 1
        Citizen.Wait(1000)
        sayac = 0
    else
        cb(1)
    end
end)



-- Haber

ESX.RegisterServerCallback('haberci:getNewsForHaber', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM gksphone_news',{},function(result)
		local haberler = {}
		for i=1, #result, 1 do
			table.insert(haberler, {id = result[i].id,haber=result[i].haber, baslik = result[i].baslik, resim = result[i].resim, video = result[i].video, zaman = result[i].zaman}) 
		end
		cb(haberler)
	end)
end)

function NewsPost(haber, baslik, resim, video, sourcePlayer, cb)
    MySQL.Async.insert("INSERT INTO gksphone_news (`haber`, `baslik`, `resim`, `video`) VALUES(@haber, @baslik, @resim, @video);", {
	  ['@haber'] = haber,
	  ['@baslik'] = baslik,
	  ['@resim'] = resim,
      ['@video'] = video
    }, function (id)
      MySQL.Async.fetchAll('SELECT * from gksphone_news WHERE id = @id', {
        ['@id'] = id
      }, function (news)
        newsh = news[1]
        TriggerClientEvent('haberci:news_newBildirim', -1, newsh)
      end)
    end)
end

RegisterServerEvent('haberci:news_postWzn')
AddEventHandler('haberci:news_postWzn', function(haber, baslik, resim, video)
  local sourcePlayer = tonumber(source)
  NewsPost(haber, baslik, resim, video, sourcePlayer)
end)



function HaberSil (id, sourcePlayer)
    MySQL.Async.execute('DELETE FROM gksphone_news WHERE id = @id', {
      ['@id'] = id
    }, function ()
		TriggerClientEvent('haberci:news_newBildirim', -1, newsh)
	end)
end

RegisterServerEvent('haberci:haberisil')
AddEventHandler('haberci:haberisil', function(id)
  local sourcePlayer = tonumber(source)
  HaberSil(id, sourcePlayer)
end)


-- 2. El

ESX.RegisterServerCallback('gksphone:carsellers', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
	MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales ORDER BY TIME DESC', {}, function (tweets)

		cb(tweets)

	end)
end)

ESX.RegisterServerCallback('gksphone:namenumber', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
	local water = {}
	MySQL.Async.fetchAll('SELECT phone_number from gksphone_settings WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function (testt)


		table.insert(water, testt[1])
		
	end)

	Citizen.Wait(500)

	MySQL.Async.fetchAll('SELECT firstname, lastname from users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function (dneemeya)



		table.insert(water, dneemeya[1])

		cb(water)
		
	end)
	
	
end)


RegisterServerEvent('gksphone:cardel')
AddEventHandler('gksphone:cardel', function(id, plate)
    MySQL.Async.execute('DELETE FROM gksphone_vehicle_sales WHERE id = @id', {
      ['@id'] = id
    }, function ()
		MySQL.Async.execute('UPDATE owned_vehicles SET `carseller` = @carseller WHERE `plate` = @plate', {
			['@plate'] = plate,
			['@carseller'] = 0,
		})
		MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales', {}, function (tweets)

			TriggerClientEvent('gksphone:vehiclearac', -1, tweets)

		  end)
	end)
end)

RegisterServerEvent('gksphone:newaracsale')
AddEventHandler('gksphone:newaracsale', function(a, b, c, d, f)

local src = source
local e = ESX.GetPlayerFromId(src)
local identifier = e.identifier


    if e then
        MySQL.Async.insert('INSERT INTO gksphone_vehicle_sales (`owner`, `ownerphone`, `plate`, `model`, `price`, `image`) VALUES(@owner, @ownerphone, @plate, @model, @price, @image);', {
            ['@owner'] = identifier,
            ['@ownerphone'] = a,
            ['@plate'] = b,
            ['@model'] = c,
			['@price'] = d,
            ['@image'] = f,
        }, function(result)
			MySQL.Async.execute('UPDATE owned_vehicles SET `carseller` = @carseller WHERE `plate` = @plate', {
				['@plate'] = b,
				['@carseller'] = 1,
			})
			MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales', {}, function (tweets)

				TriggerClientEvent('gksphone:vehiclearac', -1, tweets)

			  end)
        end)

    end
end)


local timing = 0

ESX.RegisterServerCallback('gksphone:vehiclecheckSpam', function(source, cb)
    if timing == 0  then
        cb(0)
        timing = timing + 1
        Citizen.Wait(1000)
        timing = 0
    else
        cb(1)
    end
end)





RegisterNetEvent("gksphone:ChangeVolume")
AddEventHandler("gksphone:ChangeVolume", function(muzikAdi, volume)
    TriggerClientEvent("gksphone:ChangeVolume",-1,muzikAdi,volume)
end)

Taxi = {}

RegisterNetEvent("gksphone:taxicall")
AddEventHandler("gksphone:taxicall", function(price, loca, curloca, phone, gps, GPStogo, distance, csrc)
	local PedID = GetPlayerPed(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then

		if xPlayer.getAccount("bank").money > price then
			local test = getSource('taxi')

			if (json.encode(test) ~= '[]') then


				Taxi[phone] = {
					price = price,
					loca = loca,
					curloca = curloca,
					phone = phone,
					gps = gps,
					GPStogo = GPStogo,
					distance = distance,
					csrc = csrc,
					Durum = 'TaxiCall'
				}

				
				for i=1, #test, 1 do

					TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Taxi', message = _U('taxi_customer'), img= '/html/static/img/icons/taxijob.png' })
					TriggerClientEvent('gksphone:taxijob', test[i].id, Taxi)

				end

            else
                TriggerClientEvent('gksphone:notifi', src, {title = 'Taxi', message = _U('taxi_noemployees'), img= '/html/static/img/icons/taxijob.png' })
            end

		else
			TriggerClientEvent('gksphone:notifi', src, {title = 'Taxi', message = _U('taxi_nomoney'), img= '/html/static/img/icons/taxijob.png' })
		end


	end

end)

RegisterNetEvent("gksphone:taxiaccept")
AddEventHandler("gksphone:taxiaccept", function(phone)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then

			local test = getSource('taxi')
				local name = getFirstname(xPlayer.identifier)  .. " " .. getLastname(xPlayer.identifier)
				local taxiphone = getNumberPhone(xPlayer.identifier)
				local iden = getIdentifierByPhoneNumber(phone)

				
				Taxi[phone] = {
					price = Taxi[phone].price,
					loca = Taxi[phone].loca,
					curloca = Taxi[phone].curloca,
					phone = Taxi[phone].phone,
					gps = Taxi[phone].gps,
					GPStogo = Taxi[phone].GPStogo,
					distance = Taxi[phone].distance,
					csrc = Taxi[phone].csrc,
					Durum = 'TaxiAceept',
					TaxiName = name,
					TaxiPhone = taxiphone
				}

				
				for i=1, #test, 1 do

					TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Taxi', message = name .._U('taxi_gotjob') , img= '/html/static/img/icons/taxijob.png' })
					TriggerClientEvent('gksphone:taxijob', test[i].id, Taxi)

				end

				getSourceFromIdentifier(iden, function (osou)
					if tonumber(osou) ~= nil then 
						TriggerClientEvent('gksphone:notifi', tonumber(osou), {title = 'Taxi', message = _U('taxi_driverway'), img= '/html/static/img/icons/taxijob.png' })
						TriggerClientEvent('gksphone:taxiuser', tonumber(osou), Taxi[phone])
						
					end

				end)
	end

end)


RegisterNetEvent("gksphone:taximusteri")
AddEventHandler("gksphone:taximusteri", function(a, b, c, d)

TriggerClientEvent('gksphone:taximusteri', d, a,b,c, source)

end)

RegisterNetEvent("gksphone:taximusteria")
AddEventHandler("gksphone:taximusteria", function(phone, Gps, taxiplate, myplate, taxisource)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if (taxiplate ~= nil) then
		if (myplate ~= nil) then
			if (taxiplate == myplate) then
					if xPlayer ~= nil then
								TriggerClientEvent('gksphone:taximusterigps', src, Gps)
								local test = getSource('taxi')
								local iden = getIdentifierByPhoneNumber(phone)



								
								Taxi[phone] = {
									price = Taxi[phone].price,
									loca = Taxi[phone].loca,
									curloca = Taxi[phone].curloca,
									phone = Taxi[phone].phone,
									gps = Taxi[phone].gps,
									GPStogo = Taxi[phone].GPStogo,
									distance = Taxi[phone].distance,
									csrc = Taxi[phone].csrc,
									Durum = 'TaxiCustomer',
									TaxiName = Taxi[phone].TaxiName,
									TaxiPhone = Taxi[phone].TaxiPhone
								}

								
								for i=1, #test, 1 do

									TriggerClientEvent('gksphone:taxijob', test[i].id, Taxi)

								end

								getSourceFromIdentifier(iden, function (osou)
									if tonumber(osou) ~= nil then 
										TriggerClientEvent('gksphone:notifi', tonumber(osou), {title = 'Taxi', message = _U('taxi_driverpicked'), img= '/html/static/img/icons/taxijob.png' })
										TriggerClientEvent('gksphone:taxiuser', tonumber(osou), Taxi[phone])
										
									end

								end)
					end
				else
					TriggerClientEvent('gksphone:notifi', taxisource, {title = 'Taxi', message = _U('taxi_customernotveh') , img= '/html/static/img/icons/taxijob.png' })
				end
		else
			TriggerClientEvent('gksphone:notifi', taxisource, {title = 'Taxi', message = _U('taxi_customernotveh2'), img= '/html/static/img/icons/taxijob.png' })
		end
	else
		TriggerClientEvent('gksphone:notifi', taxisource, {title = 'Taxi', message = _U('taxi_notcar'), img= '/html/static/img/icons/taxijob.png' })
	end

end)

RegisterNetEvent("gksphone:taxikonum")
AddEventHandler("gksphone:taxikonum", function(phone, price)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then

				local test = getSource('taxi')
				local iden = getIdentifierByPhoneNumber(phone)

				
				xPlayer.addAccountMoney('bank', tonumber(price))
				TriggerClientEvent('gksphone:notifi', src, {title = 'Taxi', message = _U('taxi_customerloc'), img= '/html/static/img/icons/taxijob.png' })
				
				Taxi[phone] = null

				for i=1, #test, 1 do

					TriggerClientEvent('gksphone:taxijob', test[i].id, Taxi)

				end

				MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
					["@type"] = 2,
					["@identifier"] = xPlayer.identifier,
					["@price"] = tonumber(price),
					["@name"] = _U('taxi_earnings')
				})



				getSourceFromIdentifier(iden, function (osou)
					if tonumber(osou) ~= nil then 

						local musteri = ESX.GetPlayerFromId(osou)

						musteri.removeAccountMoney('bank', tonumber(price))
						TriggerClientEvent('gksphone:notifi', tonumber(osou), {title = 'Taxi', message = _U('taxi_customerleft'), img= '/html/static/img/icons/taxijob.png' })
						TriggerClientEvent('gksphone:taxiuser', tonumber(osou), json.encode(Taxi[phone]))

						MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
							["@type"] = 1,
							["@identifier"] = musteri.identifier,
							["@price"] = tonumber(price),
							["@name"] = _U('taxi_payment')
						})
						
					end

				end)
	end

end)

RegisterNetEvent("gksphone:taxiiptal")
AddEventHandler("gksphone:taxiiptal", function(phone)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer ~= nil then

				local test = getSource('taxi')
				local iden = getIdentifierByPhoneNumber(phone)

				

				Taxi[phone] = null

				for i=1, #test, 1 do

					TriggerClientEvent('gksphone:taxijob', test[i].id, Taxi)
					

				end

				getSourceFromIdentifier(iden, function (osou)
					if tonumber(osou) ~= nil then 

						TriggerClientEvent('gksphone:notifi', tonumber(osou), {title = 'Taxi', message = _U('taxi_cancel'), img= '/html/static/img/icons/taxijob.png' })
						
						TriggerClientEvent('gksphone:taxiuser', tonumber(osou), json.encode(Taxi[phone]))
						
					end

				end)
	end

end)


RegisterNetEvent("gksphone:facetimejoin")
AddEventHandler("gksphone:facetimejoin", function(id, xid, yid)
	local src = source

	if (yid ~= nil) then
		TriggerClientEvent('gksphone:sendRTCOffer', xid, id)
		TriggerClientEvent('gksphone:sendRTCOffer', yid, id)
	end
end)

function getRandomInt(mini, maxx)
	min = math.ceil(mini);
	max = math.floor(maxx);
	return math.floor(math.random() * (max - min)) + min;
end

local water = {
	ExtraSunny = {90, 110},
	Clear = {80, 95},
	Neutral = {80, 95},
	Smog = {90, 95},
	Foggy = {80, 90},
	Clouds = {80, 90},
	Overcast = {80, 80},
	Clearing = {75, 85},
	Raining = {75, 90},
	ThunderStorm = {75, 90},
	Blizzard = {-15, 10},
	Snowing = {0, 32},
	Snowlight = {0, 32},
	Christmas = {-5, 15},
	Halloween = {50, 80}
}

function temperatureRanges (birincihava)
	
	local deneyasd = getRandomInt(water[birincihava][1], water[birincihava][2])

	if not Config.Fahrenheit then
		deneyasd = (deneyasd - 32) * (5/9)
	end

	local temp_conv_str = string.format('%.0f', deneyasd)

	if Config.Fahrenheit then
		return temp_conv_str ..' °F'
	else
		return temp_conv_str ..' °C'
	end

end

RegisterNetEvent("gksphone:weathercontrol")
AddEventHandler("gksphone:weathercontrol", function(birincihava, ikincihava)
	local weatherg = {}
	local temperature = temperatureRanges(birincihava)
	local temperatureto = temperatureRanges(ikincihava)

	table.insert(weatherg, {weatersi = birincihava, waterso = ikincihava, tempsi = temperature, tempso = temperatureto})
	
	TriggerClientEvent('gksphone:weathers', -1, weatherg)
	
end)

function getTinder(username)
	local result = MySQL.Sync.fetchAll("SELECT id FROM gksphone_tinderacc WHERE username = @username", {['@username'] = username})
    
	if result[1] ~= nil then
        return result[1].id
    end
    return nil	
  	
end

ESX.RegisterServerCallback("gksphone:tinderfetch",function(a,b)
	local d = ESX.GetPlayerFromId(a)
    if not d then 
        return 
    end;
    MySQL.Async.fetchAll("SELECT * FROM gksphone_tinderacc",{},function(e)

		local gps = {}
		for i=1, #e, 1 do
			table.insert(gps, {id = e[i].id, TinderUsername = e[i].username, TinderName = e[i].name, TinderAvatarUrl = e[i].image, TinderDate = e[i].date, TinderGender = e[i].gender}) 
		end
		b(gps)

    end)
end)

ESX.RegisterServerCallback("gksphone:tinderMatchex",function(a,b)
    local d = ESX.GetPlayerFromId(a)
    if not d then 
        return 
    end;
    MySQL.Async.fetchAll("SELECT A.user_id AS userA, B.user_id AS userB FROM gksphone_tindermatch A JOIN gksphone_tindermatch B ON A.user_id = B.friend_id AND A.friend_id = B.user_id AND A.id <> B.id WHERE A.is_match = 1 AND B.is_match = 1",{},function(e)

		local testtaa = {}
		for i=1, #e, 1 do
			table.insert(testtaa, {userA = e[i].userA, userB = e[i].userB}) 
		end
		b(testtaa)

    end)
end)

ESX.RegisterServerCallback("gksphone:tinderMess",function(a,b)
    local d = ESX.GetPlayerFromId(a)
    if not d then 
        return 
    end;
    MySQL.Async.fetchAll("SELECT * FROM gksphone_tindermessage",{},function(e)

		local testtaa = {}
		for i=1, #e, 1 do
			table.insert(testtaa, {id = e[i].id, message = e[i].message, tinderes = json.decode(e[i].tinderes), owner = e[i].owner, time = e[i].time}) 
		end
		b(testtaa)
    end)
end)

RegisterNetEvent("gksphone:tinderlogin")
AddEventHandler("gksphone:tinderlogin", function(username, passaword)
	local _source = source
	local sourcePlayer = tonumber(_source)

	MySQL.Async.fetchAll("SELECT * FROM gksphone_tinderacc WHERE username = @username AND passaword = @passaword", {['@username'] = username, ['@passaword'] = passaword},
	function(result)
	
		if (result[1] ~= nil) then
			TriggerClientEvent('gksphone:tinder_setAcc', sourcePlayer, result[1].name, result[1].username, result[1].passaword, result[1].date, result[1].image, result[1].gender)
			TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_login'), img= '/html/static/img/icons/tinder2.png' })
		else
			TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_notlogin'), img= '/html/static/img/icons/tinder2.png' })
		end

	
	end)
	
end)

RegisterNetEvent("gksphone:tindernewacc")
AddEventHandler("gksphone:tindernewacc", function(name, username, passaword, date, image, gender)
	local _source = source
	local sourcePlayer = tonumber(_source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	local Usercik = getTinder(username)


	if Usercik == nil then

		MySQL.Async.insert("INSERT INTO gksphone_tinderacc (name, username, passaword, date, image, gender, identifier) VALUES (@name, @username, @passaword, @date, @image, @gender, @identifier)", {
			["@name"] = name,
			["@username"] = username,
			["@passaword"] = passaword,
			["@date"] = date,
			["@image"] = image,
			["@gender"] = gender,
			["@identifier"] = xPlayer.identifier
		})

		TriggerClientEvent('gksphone:tinder_setAcc', sourcePlayer, name, username, passaword, date, image, gender)
		TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_sucess'), img= '/html/static/img/icons/tinder2.png' })

	else

		TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_notusername'), img= '/html/static/img/icons/tinder2.png' })

	end

end)

RegisterNetEvent("gksphone:tindermatch")
AddEventHandler("gksphone:tindermatch", function(user_id, friend_id, is_match)
	local _source = source
	local sourcePlayer = tonumber(_source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

	local matc = MySQL.Sync.fetchAll("SELECT is_match FROM gksphone_tindermatch WHERE user_id = @user_id AND friend_id = @friend_id", {['@user_id'] = user_id, ['@friend_id'] = friend_id})

	if matc[1] == nil then
		MySQL.Async.insert("INSERT INTO gksphone_tindermatch (user_id, friend_id, is_match) VALUES (@user_id, @friend_id, @is_match)", {
			["@user_id"] = user_id,
			["@friend_id"] = friend_id,
			["@is_match"] = is_match
		})

				Citizen.Wait(1000)

				local result = MySQL.Sync.fetchAll("SELECT is_match FROM gksphone_tindermatch WHERE user_id = @user_id AND friend_id = @friend_id AND is_match = 1", {['@user_id'] = user_id, ['@friend_id'] = friend_id})

				Citizen.Wait(1000)

				local result2 = MySQL.Sync.fetchAll("SELECT is_match FROM gksphone_tindermatch WHERE user_id = @user_id AND friend_id = @friend_id AND is_match = 1", {['@user_id'] = friend_id, ['@friend_id'] = user_id})
				
				Citizen.Wait(1000)


		if	result[1] ~= nil then
			if	result2[1] ~= nil then
				if result[1].is_match == result2[1].is_match then
					TriggerClientEvent('gksphone:refreshMatchEx', sourcePlayer)
					TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_matched'), img= '/html/static/img/icons/tinder2.png' })
				end
			end
		end

	elseif matc[1].is_match == 0 then
		MySQL.Async.execute("UPDATE gksphone_tindermatch SET is_match = @is_match WHERE user_id = @user_id AND friend_id = @friend_id", {
			["@user_id"] = user_id,
			["@friend_id"] = friend_id,
			["@is_match"] = is_match
		})

			

				Citizen.Wait(1000)

				local result = MySQL.Sync.fetchAll("SELECT is_match FROM gksphone_tindermatch WHERE user_id = @user_id AND friend_id = @friend_id AND is_match = 1", {['@user_id'] = user_id, ['@friend_id'] = friend_id})

				Citizen.Wait(1000)

				local result2 = MySQL.Sync.fetchAll("SELECT is_match FROM gksphone_tindermatch WHERE user_id = @user_id AND friend_id = @friend_id AND is_match = 1", {['@user_id'] = friend_id, ['@friend_id'] = user_id})
				
				Citizen.Wait(1000)

				if	result[1] ~= nil then
					if	result2[1] ~= nil then
						if result[1].is_match == result2[1].is_match then
							TriggerClientEvent('gksphone:refreshMatchEx', sourcePlayer)
							TriggerClientEvent('gksphone:notifi', sourcePlayer, {title = 'Tinder', message = _U('tinder_matched'), img= '/html/static/img/icons/tinder2.png' })
						end
					end
				end
	end

end)

RegisterNetEvent("gksphone:tinderimagechange")
AddEventHandler("gksphone:tinderimagechange", function(id, image)
	local _source = source
	local sourcePlayer = tonumber(_source)


		MySQL.Async.execute("UPDATE gksphone_tinderacc SET image = @image WHERE id = @id", {
			["@id"] = id,
			["@image"] = image
		})

end)

RegisterNetEvent("gksphone:tinderacdel")
AddEventHandler("gksphone:tinderacdel", function(id)
	local _source = source
	local sourcePlayer = tonumber(_source)

	if id ~= nil then

		MySQL.Async.execute("DELETE FROM gksphone_tinderacc WHERE id = @id", {
			["@id"] = id
		})

		MySQL.Async.execute("DELETE FROM gksphone_tindermatch WHERE user_id = @id OR friend_id = @id", {
			["@id"] = id
		})

	end
end)

RegisterNetEvent("gksphone:tindermessageg")
AddEventHandler("gksphone:tindermessageg", function(message, tinderes, owner)
	local _source = source
	local sourcePlayer = tonumber(_source)


	MySQL.Async.insert("INSERT INTO gksphone_tindermessage (message, tinderes, owner) VALUES (@message, @tinderes, @owner)", {
		["@message"] = message,
		["@tinderes"] = tinderes,
		["@owner"] = owner
	})

	TriggerClientEvent('gksphone:tinderMessage', -1)

end)

-- ## MAIL


RegisterCommand("NewMailTest",function(source, args, rawCommand)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('gksphone:NewMail', xPlayer.identifier, {
		sender = 'GKSHOP',
		image = '/html/static/img/icons/mail.png',
		subject = "GKSPHONE",
		message = 'TEST'
  	})

end)


RegisterNetEvent("gksphone:mailallfetch")
AddEventHandler("gksphone:mailallfetch", function(source)

	local Player = ESX.GetPlayerFromId(source)

    local mails = MySQL.Sync.fetchAll("SELECT * FROM gksphone_mails WHERE citizenid = @citizenid ORDER BY time DESC", {
        ['@citizenid'] = Player.identifier
    })

	TriggerClientEvent('gksphone:UpdateMails', source, mails)
end)

RegisterNetEvent("gksphone:MailDelete")
AddEventHandler("gksphone:MailDelete", function(id)

	local src = source
	local e = ESX.GetPlayerFromId(src)
	if e then
		MySQL.Async.execute('DELETE FROM gksphone_mails WHERE id = @id', {
			['@id'] = id
		}, function ()
		
			SetTimeout(200, function()
				TriggerEvent('gksphone:mailallfetch', src)
			end)
	
		end)
	end
end)

RegisterServerEvent('gksphone:NewMail')
AddEventHandler('gksphone:NewMail', function(citizenid, mailData)
    local Player = ESX.GetPlayerFromIdentifier(citizenid)

    if Player then
        local src = Player.source

		MySQL.Async.insert("INSERT INTO gksphone_mails (citizenid, sender, subject, image, message) VALUES (@citizenid, @sender, @subject, @image, @message)", {
			["@citizenid"] = citizenid,
			["@sender"] = mailData.sender,
			["@subject"] = mailData.subject,
			["@image"] = mailData.image,
			["@message"] = mailData.message
		})

		TriggerClientEvent('gksphone:notifi', src, {title = 'Mail', message = mailData.sender .._U('email_received') , img= '/html/static/img/icons/mail.png' })


        SetTimeout(200, function()
            TriggerEvent('gksphone:mailallfetch', src)
        end)

    end
end)

-- Gallery

ESX.RegisterServerCallback('gksphone:getphonegallery', function(source, cb)
	local e=ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM gksphone_gallery WHERE hex = @identifier ORDER BY TIME DESC',{["@identifier"]=e.identifier},function(result)
		local gallery = {}
		for i=1, #result, 1 do
			table.insert(gallery, {id = result[i].id,	image=result[i].image}) 
		end
		cb(gallery)
	end)
end)


RegisterServerEvent('gksphone:gallerimage')
AddEventHandler('gksphone:gallerimage', function(a)
local src = source
local e = ESX.GetPlayerFromId(src)
if e then
	MySQL.Async.insert('INSERT INTO gksphone_gallery (`hex`, `image`) VALUES(@identifier, @image);', {
		['@identifier'] = e.identifier,
		['@image'] = a
	}, function (result)
	
		TriggerClientEvent('updategallery', e.source,a)

	end)
end
end)

RegisterServerEvent('gksphone:imagedelete')
AddEventHandler('gksphone:imagedelete', function(a, b)

local src = source
local e = ESX.GetPlayerFromId(src)
if e then
	MySQL.Async.insert('DELETE FROM gksphone_gallery WHERE id = @id AND hex = @identifier', {
		['@identifier'] = e.identifier,
		['@id'] = a
	}, function (result)
	
		TriggerClientEvent('updategallery', e.source,a)

	end)
end
end)

AddEventHandler('gksphone:cryptobuysellwebhook', function (test, test2, identifier, adet, coin, color, name)
	local discord_webhook = Config.Crypto
	if discord_webhook == '' then
	  return
	end

	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = 'Stock Market',
	  ["avatar_url"] = 'https://media.discordapp.net/attachments/722981093455822958/882974778334523392/stock-market.png?width=480&height=480',
	  ["embeds"] = {{
		["color"] = color
	  }}
	}
	
		data['embeds'][1]['title'] = '[' .. name ..'] has ' .. test .. ' x' .. ESX.Math.GroupDigits(tonumber(adet)) .. ' of ' .. coin .. '! Worth: $' .. ESX.Math.GroupDigits(tonumber(test2)) ..'!' 
		data['embeds'][1]['description'] = '[' .. name ..'] [' ..identifier .. ']'
	
  
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)

AddEventHandler('gksphone:cryptotranwebhook', function (name, test2, coin, name2, transferto, identifier)
	local discord_webhook = Config.Crypto
	if discord_webhook == '' then
	  return
	end

	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = 'Stock Market',
	  ["avatar_url"] = 'https://seeklogo.com/images/C/cryptocurrency-blockchain-logo-249415523F-seeklogo.com.png',
	  ["embeds"] = {{
		["color"] = color
	  }}
	}


		data['embeds'][1]['title'] = '[' .. name ..'] transferred  x' .. test2 .. ' ' .. coin .. ' to ' .. name2 ..' ['.. transferto ..']'
		data['embeds'][1]['description'] = '[' .. name ..'] [' ..identifier .. ']'

  
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)



AddEventHandler('gksphone:carsellernew', function (a, name2, bidentifier, name, b, c)
 
	local discord_webhook = Config.Carseller
	if discord_webhook == '' then
	  return
	end

	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = 'Car Seller',
	  ["avatar_url"] = 'https://media.discordapp.net/attachments/722981093455822958/882974778334523392/stock-market.png?width=480&height=480',
	  ["embeds"] = {{
		["color"] = 15258703
	  }}
	}


	data['embeds'][1]['title'] = '[' .. name ..']' ..bidentifier ..' Sold Vehicle' 
	data['embeds'][1]['description'] = 'Car license plate : ' ..b .. ' Sale price : ' ..c
    data['embeds'][1]['footer']  = { ['text'] = 'The person who bought the vehicle : [' ..name2 ..', identifier : ' ..a .. ']'}


	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)


--[[
	SPIDER V13.9 · TODO EL SISTEMA EN UN SOLO SCRIPT COMBINADO
	Servidor + Cliente en el mismo archivo. Se adapta solo.

	LO NUEVO DE V13.9:
	  - TU CUERPO ORIGINAL VA ABAJO DEL CADAVER: al poseer, el
	    cadaver se levanta y camina, y tu cuerpo real queda tumbado
	    13 studs DEBAJO de el (desmayado, tieso, con noclip para no
	    trabarse). Ya NO va pegado al costado: parece que el muerto
	    camina solo. Todos lo ven asi porque los CFrame de tu cuerpo
	    tambien se replican (el weld de carga se apaga en tu cliente).
	  - TOOL "ARRANCAR" (nuevo): agarra al herido del brazo o de la
	    pierna, equipa Arrancar y haz clic: ESA extremidad se separa
	    de su cuerpo y cae. El herido sigue siendo un cadaver y puede
	    caminar (poseido o no) ya sin ese brazo/pierna. En modo
	    servidor el joint se destruye de verdad (permanente); en
	    executor se apaga en tu cliente y la caida se replica por la
	    propiedad de red que te dio el Helper al cargar.
	  - BLINDAJE AL DESPOSEER: si algo sale mal (error interno,
	    respawn), la posesion se corta sola y tu cuerpo vuelve
	    SIEMPRE arriba, a un piso seguro (raycast). Se corrige el bug
	    "a veces me quedaba abajo/invisible".
	  - Se guarda la tecnica del "clic que arranco la pierna en Da
	    Hood real y todos la vieron": separar joints con la propiedad
	    de red del Helper (base del tool Arrancar).

LO NUEVO DE V13.8 (SIMPLE, como lo pediste):
	  Ya NO se detecta nada del juego. Derribas a tu amigo, te
	  agachas, lo agarras de la pierna, equipas el tool Control y
	  haces clic: se posee directamente el cuerpo DERRIBADO mas
	  cercano (a menos de 18 studs). Rapido y sin comprobaciones
	  que puedan fallar.
	  - SOLO cuerpos derrribados: K.O., muerto, en ragdoll, con
	    PlatformStand, HRP anclado o vida baja. Un jugador sano
	    y de pie NUNCA se posee.
	  - Si no hay ningun derrribado cerca, avisa "No hay ningun
	    cuerpo derrribado cerca".
	  - La posesion termina con Z, si el cuerpo desaparece o
	    respawnea, o si el herido se levanta y se mueve solo mas
	    de 2 segundos (no se arrastra a un jugador vivo).
	  - REPLICA A TODOS (probado): cuando cargas a alguien, el Helper
	    del juego le da a TU cliente la propiedad de red de las partes
	    del herido. Con esa propiedad, los CFrame que escribe tu
	    cliente SE REPLICAN AL SERVIDOR Y A TODOS: no es visual. Para
	    que el cuerpo no pelee se apagan sus ball sockets de ragdoll y
	    su Humanoid se pone en estado Physics (PlatformStanding lo
	    dejaria anclado en el sitio).
	  - EL CADAVER SE LEVANTA: al poseerlo, el cuerpo se endereza
	    solo durante 0.6 s (de acostado a de pie) y TODOS lo ven
	    levantarse. Luego camina/corre/salta con WASD + Shift +
	    Espacio y hace sus animaciones idle/walk/run/jump.
	  - EL CADAVER NO TIENE NOCLIP: solo TU cuerpo original (el de
	    abajo del mapa) atraviesa piso y paredes. El cadaver respeta
	    paredes (se detiene ante un obstaculo, sin trabarse: el
	    movimiento bloqueado no se acumula) y sigue el piso real
	    (terreno, escaleras y rampas).
	  Nota: el error de consola "Failed to load sound rbxassetid://..."
	  es un asset del PROPIO Da Hood, no de este script.

	LO NUEVO DE V13.8 (posesion real del cuerpo cargado):
	  Derriban a alguien y lo cargas con el sistema de carga del
	  juego. Equipa el tool Control (lo entrega este script junto
	  con Spider) y hazle clic. Si estas cargando de verdad, tu
	  cuerpo original se va debajo del mapa, mirando para arriba y
	  totalmente tieso. La camara pasa al cuerpo real cargado y
	  ese cuerpo responde a WASD. Sin mover, usa su animacion de
	  estar parado; al caminar, usa su animacion de caminar.
	  Para desposeer se pulsa Z: NO se vuelve a hacer clic en Control
	  y NO se usa G (G soltaria al herido). Al desposeer sigues
	  cargando el cuerpo con la pierna, listo para caminar o soltarlo.
	  Ya no usa G y ya no crea muñecos ni clones para fingir el
	  control.

	EL HERIDO SIGUE SIENDO UN CADAVER (V13.3 y V13.8):
	  El herido NO se pone de pie. Sigue tirado e inmovilizado y
	  solo hace sus propias animaciones de caminar, correr y
	  saltar mientras tu lo controlas. Si el tiene animaciones de
	  zombi, se usan las de zombi. Tu cuerpo original queda debajo
	  de el, mirando para arriba, y se mueve con el como un iman.
	  Shift = correr, Espacio = saltar. G suelta la carga del juego
	  y te devuelve arriba automaticamente.

	V13.8 (modo con servidor):
	  El servidor hace exactamente lo mismo que el modo local:
	  mantiene al herido tirado (PlatformStand, AutoRotate false,
	  WalkSpeed 0), lo mueve por CFrame y usa sus animaciones
	  idle/walk/run/jump. Shift y Espacio tambien funcionan.
	  Al desposeer se reactiva el Animate propio del herido.

	CORRECCIONES V13.2 / V13.3 (Da Hood / executor):
	  Se corrigio el fallo que impedia controlar al herido cuando se
	  juega sin servidor propio:
	   - "seguirBajoMapa" se llamaba antes de existir y lanzaba nil.
	   - Al iniciar la posesion local se borraban Part0/Part1 del weld,
	     asi que la siguiente validacion creia que ya no cargabas.
	   - Ahora se conservan Part0/Part1 y solo se desactiva el weld.
	   - Se devuelve al jugador arriba antes de reenganchar el weld,
	     para que el herido no caiga al vacio.
	   - Se acepta K.O. con Health = 0.5 (o 0) si Dead = false.
	   - Si haces clic justo al agarrar, espera hasta 0.6 s a que
	     replique el GRABBING_CONSTRAINT.
	   - Si el juego quita la carga, el weld queda desactivado y no
	     se reproduce la animacion de cargado.

	LO NUEVO DE V11.7 (sigue igual):
	  ARMAS NUEVAS (REVOLVER Y ESCOPETAS): el juego las dispara en
	          TU CLIENTE con GunHandler.getAim(), que usa el mouse
	          real. V11.7 reemplaza SOLO esa funcion: con alguien
	          lockeado devuelve la CABEZA (o el TORSO si hay
	          escopeta), asi que el rayo, el daño y la bala visible
	          van al objetivo aunque dispares al piso, a una pared o
	          al aire. Sin lock todo queda exactamente como el juego.
	  ARMAS VIEJAS: Da Hood deja que tu cliente le diga donde apunta
	          (manda MainRemoteEvent "DEAHOODMOUSEPOSx3^3" con la
	          posicion del mouse) y el servidor lo copia SIN validar.
	          Con alguien lockeado, el script manda por ESE MISMO
	          remoto la posicion de la CABEZA del objetivo, en cada
	          frame y en cada disparo: las balas le dan a la cabeza o
	          al torso aunque dispares al piso o al aire.
	  NOTA:   las escopetas mantienen su dispersion (la agrega el
	          propio juego). Si hay una pared de por medio, la bala
	          da en la pared (normal, no atraviesa).
	  Q       LOCK: contorno blanco en el objetivo y en ti + linea
	          blanca entre los dos, EN CUALQUIER JUEGO (Da Hood
	          incluido). Tu camara NO se mueve y tu personaje gira
	          hacia el. Q otra vez lo quita; sin nadie bajo el mouse
	          no hace nada; sin lock, balas normales.
	  X+pared  TREPAR (antes era Shift). Shift queda libre.
	  Control  TOOL: clic para poseer el cuerpo que ya estas
	          cargando. No hace nada si no hay carga.
	  Z        DESPOSEER: suelta el control pero SIGUES cargando al
	          herido por la pierna. No lo tira al suelo.
	  J       ESP: contorno blanco + nombre de usuario encima de TODOS
	          los jugadores, visible a traves de las paredes. El texto
	          es un poco mas pequeno que en V11. J otra vez lo apaga.

	DOS MODOS (importante):
	  * EN TU JUEGO (con servidor): el servidor valida la carga y la
	    posesion, mueve el cuerpo real y reproduce SUS animaciones de
	    idle/walk. El cliente controlador envia las ordenes de WASD y
	    monta camara/HUD. Todos ven el mismo cuerpo y el LOCK apunta
	    por RE_Lock (servidor propio), solo dueno.
	  * EN DA HOOD / JUEGOS AJENOS (executor): no hay servidor propio.
	    El cliente mueve el cuerpo real usando la propiedad de red que
	    la carga ya le dio. Funciona para ti; que los demas lo vean
	    depende de que el juego mantenga esa propiedad de red. Si el
	    juego no esta cargando por la pierna, el tool Control no hace
	    nada. La posesion fiable necesita el servidor de tu juego.

	INSTALACION PARA REPLICAR (tu juego):
	  1) ServerScriptService > Insert Object > "Script" (NO LocalScript)
	     llamado SpideyV11 y pega ESTE archivo completo.
	  2) StarterPlayer > StarterPlayerScripts > "LocalScript"
	     llamado SpideyClienteV11 y pega ESTE MISMO archivo.
	  3) Publica. El servidor crea RE_Cuerpo y RE_Lock. El control se
	     replica y el LOCK del dueño dirige las balas. TODOS ven el
	     cuerpo controlado; el LOCK solo lo usa el dueño del place.
	  Si falta el Script de servidor, el cliente entra en MODO LOCAL
	  automaticamente (Da Hood / executor) y no rompe nada.

	QUE HACE V10 (viene incluido):
	  Las animaciones solo se replican por el Animator, y Roblox solo
	  deja cargar animaciones del DUEÑO del juego (o de Roblox).
	  Comprobado en vivo: las animaciones de otros usuarios dan
	  Length = 0 y no se ven aunque las ejecute el mejor executor.
	  Por eso V10 usa 3 capas para que TODOS te vean:
	   1) ANIM_IDS     tus animaciones subidas: cargan en TUS juegos
	                   (tu copia de Da Hood, tus places). Todos las ven.
	   2) ANIM_ROBLOX  emotes de Roblox: cargan en CUALQUIER juego.
	                   A usa "Point" (apuntar) y B usa "Fall" (pose aerea).
	   3) GIRO_FISICO  el backflip de B gira el cuerpo con fisica REAL:
	                   la fisica de tu personaje si se replica a todos,
	                   asi que todos ven el giro en Da Hood y en
	                   cualquier juego, sin instalar nada.
	  Las poses finas de brazos/piernas son locales por limite del
	  motor: un executor no puede subir animaciones ni crear scripts
	  de servidor (el servidor no existe en el cliente).

	ANIMACIONES:
	  A (1.833 s): disparo arriba + tiron + cuclillas + recupero
	  B (5.333 s): mira + backflip + cuclillas + 2o backflip + cuclillas
	  A/B alternan por lanzamiento valido; reinician a los 4 s sin clic.

	JUGABILIDAD: equipa SPIDER · clic izq = telarana · mantener = balanceo
	  WASD = control · Espacio = soltar y saltar · X+pared = trepar.
	  Carga un cuerpo derribado y usa el tool Control para poseerlo.

	PRUEBAS (consola): LocalPlayer:SetAttribute("SpideyTest", "A")
	  "B:1.8" congela · "STOP" "INFO" "EQUIP" "CLICK" "RELEASE"
	  "POSE" "UNPOSE" "LOCK" "UNLOCK" "ESP" "ESPTEST"
	  "SIMULARA"/"SIMULARB" clonan tu personaje y le aplican la
	  secuencia para ver EXACTAMENTE lo que ven los demas.
	  "LOCK" lockea el modelo con Humanoid mas cercano (util para
	  probar el aim sin mover el mouse). "UNLOCK" lo quita.
	  "POSE" hace lo mismo que el clic del tool Control.
]]

--=================================================================
-- UTILIDADES COMPARTIDAS (servidor y cliente): deteccion del agarre
-- real de Da Hood. Van ANTES del if IsServer para que las dos mitades
-- del archivo las vean.
--=================================================================
local function valorBody(modelo, nombre)
	local be = modelo and modelo:FindFirstChild("BodyEffects")
	return be and be:FindFirstChild(nombre)
end

-- V13.8: clases de union que cuentan como carga fisica. Se excluyen las
-- NoCollisionConstraint (el juego crea 16 entre el herido y el que carga
-- solo para evitar choques: NO son carga).
local function esUnionDeCarga(obj)
	if obj:IsA("JointInstance") then return true end
	if obj:IsA("NoCollisionConstraint") then return false end
	return obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") or obj:IsA("BallSocketConstraint")
end

local function extremosDe(obj)
	local ok, p0, p1 = pcall(function()
		if obj:IsA("JointInstance") then
			return obj.Part0, obj.Part1
		end
		if obj:IsA("Constraint") then
			local a0, a1 = obj.Attachment0, obj.Attachment1
			return a0 and a0.Parent, a1 and a1.Parent
		end
		return nil, nil
	end)
	if ok then return p0, p1 end
	return nil, nil
end

-- V13.9: permite pasar un Player O un Model a las busquedas de union.
-- En el servidor, e.controlador es el Player: sin esto, el weld de
-- carga NUNCA se encontraba (no se apagaba) y el herido quedaba
-- colgado del cuerpo del jugador en vez de caminar.
local function comoModelo(x)
	if typeof(x) == "Instance" and x:IsA("Player") then
		return x.Character
	end
	return x
end

local function weldCargaEntre(a, b)
	a = comoModelo(a)
	b = comoModelo(b)
	if not a or not b or not a.Parent or not b.Parent then return nil end
	for _, contenedor in ipairs({ a, b }) do
		for _, obj in ipairs(contenedor:GetDescendants()) do
			if esUnionDeCarga(obj) then
				local p0, p1 = extremosDe(obj)
				if p0 and p1 then
					local cruza = (p0:IsDescendantOf(a) and p1:IsDescendantOf(b))
						or (p1:IsDescendantOf(a) and p0:IsDescendantOf(b))
					if cruza then return obj end
				end
			end
		end
	end
	return nil
end

-- Cualquier union de carga (mismo criterio que weldCargaEntre) que exista
-- en el controlador o en la victima, aunque este desactivada. Sirve para
-- apagar las que el juego recree durante la posesion.
local function weldsCargaDe(controlador, victima)
	local lista, vistos = {}, {}
	controlador = comoModelo(controlador)
	victima = comoModelo(victima)
	if not controlador or not victima then return lista end
	for _, contenedor in ipairs({ controlador, victima }) do
		if contenedor and contenedor.Parent then
			for _, obj in ipairs(contenedor:GetDescendants()) do
				if not vistos[obj] and esUnionDeCarga(obj) then
					local p0, p1 = extremosDe(obj)
					if p0 and p1 then
						local cruza = (p0:IsDescendantOf(controlador) and p1:IsDescendantOf(victima))
							or (p1:IsDescendantOf(controlador) and p0:IsDescendantOf(victima))
						if cruza then
							vistos[obj] = true
							table.insert(lista, obj)
						end
					end
				end
			end
		end
	end
	return lista
end

-- Apaga cualquier union de carga que aparezca durante la posesion. El
-- cuerpo se mueve por CFrame; si la union sigue activa, el juego tiraria
-- del cuerpo hacia el jugador original. Se revisa cada 0.1 s para no
-- escanear los dos personajes en cada fotograma.
local function apagarWeldsCarga(controlador, victima, datos)
	if not datos then return end
	local ahora = os.clock()
	if datos.ultimoWeldCheck and (ahora - datos.ultimoWeldCheck) < 0.1 then return end
	datos.ultimoWeldCheck = ahora
	datos.weldsExtra = datos.weldsExtra or {}
	for _, w in ipairs(weldsCargaDe(controlador, victima)) do
		if w.Enabled then w.Enabled = false end
		if not table.find(datos.weldsExtra, w) then
			table.insert(datos.weldsExtra, w)
		end
	end
end

-- El Helper pone todas las partes de la victima con network owner del que
-- la carga. Es una prueba fuerte de agarre aunque el weld no haya
-- replicado todavia al cliente.
local function esDuenoRedDe(modelo, dueno)
	if not modelo or not modelo.Parent or not dueno then return false end
	for _, p in ipairs(modelo:GetDescendants()) do
		if p:IsA("BasePart") then
			local ok, actual = pcall(function() return p:GetNetworkOwner() end)
			if ok and actual == dueno then return true end
		end
	end
	return false
end

-- V13.8: el Helper deja TODAS las partes del herido en Massless = true al
-- agarrarlo y las devuelve a false al soltarlo (tambien el CarrySystem).
-- Es una senal de carga que se replica al cliente y no depende del weld.
local function mayoriaMassless(modelo)
	if not modelo or not modelo.Parent then return false end
	local total, ligeros = 0, 0
	for _, p in ipairs(modelo:GetChildren()) do
		if p:IsA("BasePart") then
			total = total + 1
			if p.Massless then ligeros = ligeros + 1 end
		end
	end
	return total >= 4 and ligeros > total / 2
end

if game:GetService("RunService"):IsServer() then
--=================================================================
--  MITAD SERVIDOR: validacion + difusion + instalacion del cliente
--=================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPack = game:GetService("StarterPack")

local Remotos = ReplicatedStorage:FindFirstChild("SpideyRemotos")
if not Remotos then
	Remotos = Instance.new("Folder")
	Remotos.Name = "SpideyRemotos"
	Remotos.Parent = ReplicatedStorage
end

local function remoto(nombre)
	local r = Remotos:FindFirstChild(nombre)
	if not r then
		r = Instance.new("RemoteEvent")
		r.Name = nombre
		r.Parent = Remotos
	end
	return r
end

local RE_Web = remoto("RE_Web")
local RE_Efecto = remoto("RE_Efecto")
local RE_Anim = remoto("RE_Anim")
local RE_Cuerpo = remoto("RE_Cuerpo")
local RE_Lock = remoto("RE_Lock")

-----------------------------------------------------------------
-- V11.7 Â· LOCK (Q) DEL DUEÃO
-- El cliente manda el modelo objetivo. El servidor sobreescribe
-- BodyEffects.MousePos: las armas de Da Hood disparan a ese punto,
-- aunque el dueÃ±o apunte al piso. Solo lo puede usar el dueÃ±o del
-- place (o el nombre/ID configurado abajo).
-----------------------------------------------------------------
local PROPIETARIOS_NOMBRES = { ["jlozadac"] = true }
local PROPIETARIOS_IDS = {}
local MAX_LOCK = 600
local bloqueos = {} -- [player] = { modelo, conexiones, latido, ... }

local function esPropietarioLock(pl)
	if not pl then return false end
	if PROPIETARIOS_NOMBRES[pl.Name] or PROPIETARIOS_IDS[pl.UserId] then return true end
	if game.CreatorType == Enum.CreatorType.User and game.CreatorId ~= 0 and pl.UserId == game.CreatorId then
		return true
	end
	if game.CreatorType == Enum.CreatorType.Group and game.CreatorId ~= 0 then
		local ok, rango = pcall(function()
			return pl:GetRankInGroup(game.CreatorId)
		end)
		if ok and rango >= 250 then return true end
	end
	return false
end

-- Con escopeta se apunta al TORSO: la dispersion del juego reparte los
-- perdigones y un objetivo grande hace que casi todos impacten.
-- Con las demas armas se apunta a la CABEZA.
local function esArmaEscopeta(pl)
	local c = pl and pl.Character
	local t = c and c:FindFirstChildOfClass("Tool")
	if not t then return false end
	local n = string.lower(t.Name)
	return string.find(n, "shotgun", 1, true) ~= nil
		or string.find(n, "double-barrel", 1, true) ~= nil
		or string.find(n, "escopeta", 1, true) ~= nil
end

local function puntoDeModeloLock(pl, modelo)
	if not modelo or not modelo.Parent then return nil end
	local p
	if esArmaEscopeta(pl) then
		p = modelo:FindFirstChild("UpperTorso")
			or modelo:FindFirstChild("Torso")
			or modelo:FindFirstChild("HumanoidRootPart")
			or modelo:FindFirstChild("Head")
	else
		p = modelo:FindFirstChild("Head")
			or modelo:FindFirstChild("UpperTorso")
			or modelo:FindFirstChild("Torso")
			or modelo:FindFirstChild("HumanoidRootPart")
	end
	return p and p.Position or nil
end

local function mousePosDeLock(pl)
	local c = pl and pl.Character
	local be = c and c:FindFirstChild("BodyEffects")
	return be and be:FindFirstChild("MousePos") or nil
end

local function limpiarBloqueo(pl, avisar)
	local b = bloqueos[pl]
	if not b then return end
	bloqueos[pl] = nil
	if b.latido then b.latido:Disconnect() end
	for _, c in ipairs(b.conexiones or {}) do
		if c and c.Disconnect then c:Disconnect() end
	end
	if avisar and pl and pl.Parent then
		RE_Lock:FireClient(pl, "OFF")
	end
end

local function aplicarBloqueo(pl, b)
	if bloqueos[pl] ~= b then return end
	local pos = puntoDeModeloLock(pl, b.modelo)
	if not pos then
		limpiarBloqueo(pl, true)
		return
	end
	local mp = mousePosDeLock(pl)
	if not mp then return end -- BodyEffects puede tardar en crearse
	if (mp.Value - pos).Magnitude > 0.01 then
		mp.Value = pos
	end
end

local function colocarBloqueo(pl, modelo)
	if not esPropietarioLock(pl) then return false end
	if not modelo or not modelo.Parent or modelo == pl.Character then return false end
	local h = modelo:FindFirstChildOfClass("Humanoid")
	local r = modelo:FindFirstChild("HumanoidRootPart")
	local c = pl.Character
	local cr = c and c:FindFirstChild("HumanoidRootPart")
	if not h or not r or h.Health <= 0 or not cr then return false end
	if (r.Position - cr.Position).Magnitude > MAX_LOCK then return false end

	limpiarBloqueo(pl, true)
	local b = { modelo = modelo, conexiones = {} }
	bloqueos[pl] = b

	table.insert(b.conexiones, h.Died:Connect(function()
		if bloqueos[pl] == b then limpiarBloqueo(pl, true) end
	end))
	table.insert(b.conexiones, modelo.AncestryChanged:Connect(function(_, padre)
		if not padre and bloqueos[pl] == b then limpiarBloqueo(pl, true) end
	end))
	table.insert(b.conexiones, pl.CharacterRemoving:Connect(function()
		if bloqueos[pl] == b then limpiarBloqueo(pl, false) end
	end))

	-- BodyEffects.MousePos puede tardar en aparecer tras respawnear.
	task.spawn(function()
		local c0 = pl.Character
		local be = c0 and c0:WaitForChild("BodyEffects", 8)
		local mp = be and be:WaitForChild("MousePos", 8)
		if bloqueos[pl] ~= b then return end
		if not mp then
			limpiarBloqueo(pl, true)
			return
		end
		b.mp = mp
		table.insert(b.conexiones, mp:GetPropertyChangedSignal("Value"):Connect(function()
			if bloqueos[pl] == b then
				local pos = puntoDeModeloLock(pl, b.modelo)
				if pos and (mp.Value - pos).Magnitude > 0.01 then
					mp.Value = pos
				end
			end
		end))
		aplicarBloqueo(pl, b)
	end)

	b.latido = RunService.Heartbeat:Connect(function()
		if bloqueos[pl] ~= b then return end
		if not pl.Parent or not pl.Character or pl.Character ~= c then
			limpiarBloqueo(pl, true)
			return
		end
		local hh = pl.Character:FindFirstChildOfClass("Humanoid")
		if not hh or hh.Health <= 0 then
			limpiarBloqueo(pl, true)
			return
		end
		if not modelo.Parent then
			limpiarBloqueo(pl, true)
			return
		end
		aplicarBloqueo(pl, b)
	end)

	aplicarBloqueo(pl, b)
	return true
end

RE_Lock.OnServerEvent:Connect(function(pl, accion, modelo)
	if not esPropietarioLock(pl) then return end
	if accion == "SET" then
		colocarBloqueo(pl, modelo)
	elseif accion == "CLEAR" then
		limpiarBloqueo(pl, true)
	end
end)

-- Da Hood manda el mouse por MainRemoteEvent. El Helper del juego se
-- conecta antes que nosotros; esta conexion corre despues y deja el
-- MousePos en el objetivo. El task.defer cubre el orden inverso.
local MainRemotes = ReplicatedStorage:FindFirstChild("MainRemotes")
local MainRemoteEvent = MainRemotes and MainRemotes:FindFirstChild("MainRemoteEvent")
if MainRemoteEvent then
	MainRemoteEvent.OnServerEvent:Connect(function(pl, asunto)
		local b = bloqueos[pl]
		if b and asunto == "DEAHOODMOUSEPOSx3^3" then
			aplicarBloqueo(pl, b)
			task.defer(function()
				if bloqueos[pl] == b then aplicarBloqueo(pl, b) end
			end)
		end
	end)
end

Players.PlayerRemoving:Connect(function(pl)
	limpiarBloqueo(pl, false)
end)

-- La mitad cliente de ESTE MISMO archivo debe estar en
-- StarterPlayer.StarterPlayerScripts.SpideyClienteV11 (LocalScript).
-- Un Script de servidor no puede crear codigo cliente en runtime.
if not game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("SpideyClienteV11") then
	warn("[Spidey V13.9] Falta el LocalScript SpideyClienteV11 (pegar este mismo archivo en StarterPlayerScripts)")
end

local CFG = {
	-- El cliente dispara desde la camara (hasta ~165 + desvio de la
	-- tercera persona), el servidor mide desde el personaje: dejar margen.
	MAX_DIST = 205,
	MIN_DIST = 4,
	COOLDOWN = 0.12,
	ANIM_COOLDOWN = 0.12,
	VEL_MAX = 150,
	VEL_HARD = 165,
	DURACION_MAX = 30, -- si el cliente no manda STOP, se limpia la telaraÃ±a
	TOLERANCIA_SUPERFICIE = 5.5,
}

local ultimoWeb = {}
local activo = {} -- [player] = { nombre, inicio, creado, punto }

----------------------------------------------------------------
-- TOOL
----------------------------------------------------------------
local function configurarTool(tool)
	tool.Name = "Spider"
	tool.ToolTip = "EquÃ­palo y mantÃ©n clic izquierdo para lanzar la telaraÃ±a"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ManualActivationOnly = true
end

local function configurarToolControl(tool)
	tool.Name = "Control"
	tool.ToolTip = "Clic: controlar / soltar el cuerpo que estas cargando"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ManualActivationOnly = false
end

local function configurarToolArrancar(tool)
	tool.Name = "Arrancar"
	tool.ToolTip = "Clic: arrancar el brazo/pierna que estas agarrando"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ManualActivationOnly = false
end

local function crearToolSiFalta(player, nombre, configurar)
	-- Si StarterPack ya tiene el Tool, el motor lo copia al Backpack al
	-- reaparecer. No creamos otro para no duplicar.
	if StarterPack:FindFirstChild(nombre) then return end

	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then return end
	local character = player.Character
	if backpack:FindFirstChild(nombre) then return end
	if character and character:FindFirstChild(nombre) then return end

	local tool = Instance.new("Tool")
	configurar(tool)
	tool.Parent = backpack
end

local function crearToolsSiFalta(player)
	crearToolSiFalta(player, "Spider", configurarTool)
	crearToolSiFalta(player, "Control", configurarToolControl)
	crearToolSiFalta(player, "Arrancar", configurarToolArrancar)
end

local function prepararJugador(player)
	crearToolsSiFalta(player)
	player.CharacterAdded:Connect(function()
		task.defer(crearToolsSiFalta, player)
	end)
end

Players.PlayerAdded:Connect(prepararJugador)
for _, player in ipairs(Players:GetPlayers()) do
	prepararJugador(player)
end

----------------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------------
local function limitarVelocidad(hrp)
	local velocidad = hrp.AssemblyLinearVelocity
	if velocidad.Magnitude > CFG.VEL_MAX then
		hrp.AssemblyLinearVelocity = velocidad.Unit * CFG.VEL_MAX
	end
end

local function toolEnMano(player)
	local character = player.Character
	local tool = character and character:FindFirstChild("Spider")
	return tool ~= nil and tool:IsA("Tool") and tool.Parent == character
end

local function denegar(player)
	RE_Anim:FireClient(player, "DENIED", player)
end

local function pararActivo(player, difundir)
	if not activo[player] then return end
	activo[player] = nil
	if difundir then
		RE_Anim:FireAllClients("STOP", player, nil, workspace:GetServerTimeNow())
	end
end

----------------------------------------------------------------
-- LANZAMIENTO
----------------------------------------------------------------
RE_Web.OnServerEvent:Connect(function(player, accion, punto, normal, solido, nombre)
	if accion ~= "START" then return end
	if typeof(punto) ~= "Vector3" or typeof(normal) ~= "Vector3" then return end
	if normal.Magnitude < 0.5 then return end
	if nombre ~= "A" and nombre ~= "B" then return end

	local ahora = os.clock()
	local previo = ultimoWeb[player]
	if previo and ahora - previo < CFG.COOLDOWN then return end
	ultimoWeb[player] = ahora

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not hrp then
		denegar(player)
		return
	end
	if not toolEnMano(player) then
		denegar(player)
		return
	end
	if activo[player] then
		-- Un jugador no puede tener dos telaraÃ±as a la vez.
		denegar(player)
		return
	end

	local dir = punto - hrp.Position
	local distancia = dir.Magnitude
	if distancia < CFG.MIN_DIST or distancia > CFG.MAX_DIST then
		denegar(player)
		return
	end

	normal = normal.Unit
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { character }
	params.IgnoreWater = true

	local ok, hit = pcall(function()
		return workspace:Raycast(hrp.Position, dir.Unit * distancia, params)
	end)
	if not ok then
		denegar(player)
		return
	end

	if hit then
		-- El cliente apunta 1.3 studs fuera de la superficie; se tolera
		-- esa diferencia. Si el punto estÃ¡ lejos del impacto, se rechaza.
		if (hit.Position - punto).Magnitude > CFG.TOLERANCIA_SUPERFICIE then
			denegar(player)
			return
		end
		punto = hit.Position + hit.Normal * 1.3
		normal = hit.Normal
	end
	-- Si el servidor no ve la superficie que vio la cÃ¡mara del cliente
	-- (los orÃ­genes del rayo son distintos), se acepta el punto del
	-- cliente: la distancia ya quedÃ³ validada arriba.

	limitarVelocidad(hrp)

	local inicio = workspace:GetServerTimeNow()
	activo[player] = {
		nombre = nombre,
		inicio = inicio,
		creado = ahora,
		punto = punto,
	}

	RE_Anim:FireAllClients("PLAY", player, nombre, inicio, punto)
	RE_Efecto:FireAllClients(player, punto)
end)

RE_Anim.OnServerEvent:Connect(function(player, accion)
	if accion == "STOP" then
		pararActivo(player, true)
	end
end)

----------------------------------------------------------------
-- LÃMITES Y LIMPIEZA
----------------------------------------------------------------
local acumulador = 0
RunService.Heartbeat:Connect(function(dt)
	acumulador += dt
	if acumulador >= 0.25 then
		acumulador = 0
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if hrp and humanoid and humanoid.Health > 0 then
				local velocidad = hrp.AssemblyLinearVelocity
				if velocidad.Magnitude > CFG.VEL_HARD then
					hrp.AssemblyLinearVelocity = velocidad.Unit * CFG.VEL_HARD
				end
			end
		end
	end

	-- Auto-limpieza de telaraÃ±as huÃ©rfanas.
	local ahora = os.clock()
	for player, datos in pairs(activo) do
		if not player.Parent or not player.Character then
			activo[player] = nil
			RE_Anim:FireAllClients("STOP", player, nil, workspace:GetServerTimeNow())
		elseif ahora - datos.creado > CFG.DURACION_MAX then
			pararActivo(player, true)
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	ultimoWeb[player] = nil
	if activo[player] then
		activo[player] = nil
		RE_Anim:FireAllClients("STOP", player, nil, workspace:GetServerTimeNow())
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterRemoving:Connect(function()
		if activo[player] then
			pararActivo(player, true)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterRemoving:Connect(function()
		if activo[player] then
			pararActivo(player, true)
		end
	end)
end)

-----------------------------------------------------------------
-- V13.8 · POSESION REAL DEL CUERPO CARGADO (tool Control)
-- Ya NO se crea un muñeco nuevo. La posesion se activa SOLO si ya
-- estas cargando a un cuerpo derribado con el sistema de carga del
-- juego (GRABBING_CONSTRAINT + BodyEffects.Grabbed). El cuerpo
-- controlado es el cuerpo real que tenias agarrado.
-----------------------------------------------------------------
local poseyendo = {}      -- [player controlador] = datos
local poseidoPor = {}     -- [modelo victima] = player controlador
local ultimoPoseIntento = {}
local DIST_ABAJO = 13

local function valorBody(modelo, nombre)
	local be = modelo and modelo:FindFirstChild("BodyEffects")
	return be and be:FindFirstChild(nombre)
end

-- El juego guarda BodyEffects.Grabbed.Value como Player en el sistema
-- de carga real (CarrySystem), pero otras variantes guardan el Model.
-- Aceptamos las dos formas y devolvemos siempre el personaje (Model).
local function personajeDe(valor)
	if typeof(valor) ~= "Instance" then return nil end
	if valor:IsA("Player") then return valor.Character end
	if valor:IsA("Model") then return valor end
	return nil
end

local function humDe(modelo)
	return modelo and modelo:FindFirstChildOfClass("Humanoid")
end

local function hrpDe(modelo)
	return modelo and modelo:FindFirstChild("HumanoidRootPart")
end

-- V13.8: cargar de verdad = CUALQUIERA de las senales reales del juego:
-- Grabbed del que carga, Grabbed inverso (CarrySystem), weld
-- GRABBING_CONSTRAINT en cualquier direccion, o network owner del que
-- carga. No se exige el weld porque puede tardar en replicar y no se
-- exige Dead=false/Health>0: el cuerpo puede ser un cadaver y seguir
-- cargado. Tampoco basta con estar cerca: hace falta una senal.
-- V13.8: cuerpo "tirado" segun las reglas del propio juego: K.O., muerto,
-- PlatformStand, vida por debajo de 45 (el Helper suelta al herido al
-- llegar a 45), estado ragdoll o HRP anclado (el ragdoll ancla el HRP).
local function cuerpoTiradoJuego(victima)
	local vh = humDe(victima)
	if not vh then return false end
	local ko = valorBody(victima, "K.O")
	if ko and ko.Value then return true end
	local dead = valorBody(victima, "Dead")
	if dead and dead.Value then return true end
	if vh.PlatformStand then return true end
	if vh.Health < 45 then return true end
	local ok, estado = pcall(function() return vh:GetState() end)
	if ok and (estado == Enum.HumanoidStateType.FallingDown
		or estado == Enum.HumanoidStateType.Physics
		or estado == Enum.HumanoidStateType.PlatformStanding
		or estado == Enum.HumanoidStateType.Dead
		or estado == Enum.HumanoidStateType.Ragdoll) then
		return true
	end
	local vr = hrpDe(victima)
	if vr and vr.Anchored then return true end
	return false
end

-- V13.8: SIN deteccion. La posesion se mantiene mientras la victima
-- exista y no se haya ido por su cuenta (ver el Heartbeat).
local function victimaValida(victima)
	if not victima or not victima.Parent then return false end
	if not humDe(victima) or not hrpDe(victima) then return false end
	return true
end

-----------------------------------------------------------------
-- Guardar / preparar / restaurar el cuerpo real
-----------------------------------------------------------------
local function guardarVictima(victima, controlador)
	local vh = humDe(victima)
	local vr = hrpDe(victima)
	local d = {
		victima = victima,
		hum = vh,
		hrp = vr,
		platform = vh and vh.PlatformStand,
		auto = vh and vh.AutoRotate,
		walk = vh and vh.WalkSpeed,
		jump = vh and vh.JumpPower,
		use = vh and vh.UseJumpPower,
		hrpAnclado = vr and vr.Anchored,
		dueno = nil,
		partes = {},
		sockets = {},
		ncs = {},
	}
	d.startCF = vr and vr.CFrame
	d.animate = victima:FindFirstChild("Animate")
	d.animateEnabled = d.animate and d.animate.Enabled or false
	pcall(function() d.dueno = vr and vr:GetNetworkOwner() end)

	for _, p in ipairs(victima:GetDescendants()) do
		if p:IsA("BasePart") then
			table.insert(d.partes, { p = p, m = p.Massless })
		end
	end

	local rc = victima:FindFirstChild("RagdollConstraints")
	if rc then
		for _, c in ipairs(rc:GetChildren()) do
			if c:IsA("BallSocketConstraint") then
				table.insert(d.sockets, { c = c, e = c.Enabled })
			end
		end
	end
	for _, c in ipairs(victima:GetDescendants()) do
		if c:IsA("BallSocketConstraint") and not rc then
			table.insert(d.sockets, { c = c, e = c.Enabled })
		elseif c:IsA("NoCollisionConstraint") and c.Name == "NoCollisionConstraint_HOLD" then
			table.insert(d.ncs, { c = c, e = c.Enabled })
		end
	end

	local cw = weldCargaEntre(controlador, victima)
	if cw then
		d.carry = { c = cw, e = cw.Enabled, p0 = cw.Part0, p1 = cw.Part1 }
		if cw:IsA("Weld") then
			d.carry.c0 = cw.C0
			d.carry.c1 = cw.C1
		end
	end

	return d
end

local function prepararVictima(d)
	local victima = d.victima
	local vh = d.hum
	local vr = d.hrp
	if not victima or not victima.Parent or not vh or not vr then return end

	local carry = d.carry
	if carry and carry.c and carry.c.Parent then
		-- Solo se desactiva. Se conservan Part0/Part1: son la prueba
		-- de que el cuerpo sigue cargado y hacen falta para restaurar.
		carry.c.Enabled = false
	end
	for _, item in ipairs(d.sockets) do
		if item.c and item.c.Parent then item.c.Enabled = false end
	end
	for _, item in ipairs(d.ncs) do
		if item.c and item.c.Parent then item.c.Enabled = false end
	end
	-- V13.8: ya NO se toca Massless. El Helper deja las partes en
	-- Massless=true mientras cargas al herido y en false al soltarlo:
	-- es una senal de carga que debe seguir visible para la validacion.

	-- V13.8: el herido sigue siendo un cadaver. No se levanta.
	if d.animate and d.animate.Parent then
		d.animate.Enabled = false
	end
	vh.PlatformStand = true
	vh.AutoRotate = false
	vh.WalkSpeed = 0
	vh.JumpPower = 0
	vh.UseJumpPower = true
	vr.Anchored = false
	pcall(function() vh:ChangeState(Enum.HumanoidStateType.PlatformStanding) end)
	vh:Move(Vector3.zero, false)
end

local function detenerTracksServer(animator)
	for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
		pcall(function() tr:Stop(0.12) end)
	end
end

local function normalizarIdAnimacionServer(valor)
	if type(valor) ~= "string" then return nil end
	return string.match(valor, "^rbxassetid://(%d+)$")
		or string.match(valor, "id=(%d+)")
		or string.match(valor, "^(%d+)$")
end

local function idsDeAnimateServer(victima, nombre)
	local ids = {}
	local animate = victima:FindFirstChild("Animate")
	local seccion = animate and animate:FindFirstChild(nombre)
	if seccion then
		for _, a in ipairs(seccion:GetChildren()) do
			if a:IsA("Animation") then
				local id = normalizarIdAnimacionServer(a.AnimationId)
				if id then table.insert(ids, id) end
			end
		end
	end
	return ids
end

local function idsRespaldoServer(rig, nombre)
	if rig == Enum.HumanoidRigType.R6 then
		if nombre == "idle" then return { "180435571" } end
		if nombre == "walk" then return { "180426354" } end
		if nombre == "run" then return { "180426354" } end
		if nombre == "jump" then return { "125750702" } end
		if nombre == "fall" then return { "180436148" } end
		return { "180426354" }
	end
	if nombre == "idle" then return { "507766666" } end
	if nombre == "walk" then return { "507777826" } end
	if nombre == "run" then return { "507767714" } end
	if nombre == "jump" then return { "507765000" } end
	if nombre == "fall" then return { "507770583" } end
	return { "507777826" }
end

local function cargarTrackServer(animator, victima, nombre)
	local vh = victima:FindFirstChildOfClass("Humanoid")
	if not vh then return nil end

	local function intentar(ids, esPropia)
		local primero = nil
		for _, id in ipairs(ids) do
			local a = Instance.new("Animation")
			a.Name = "SpideyPose_" .. nombre
			a.AnimationId = "rbxassetid://" .. id
			local ok, tr = pcall(function()
				return animator:LoadAnimation(a)
			end)
			if ok and tr then
				if not primero then primero = tr end
				tr.Looped = (nombre ~= "jump")
				tr.Priority = (nombre == "idle") and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Movement
				tr:Play(0.1)
				-- Las animaciones que trae el cuerpo original tienen prioridad
				-- absoluta: si existen, no se cambian por las de respaldo.
				if esPropia then return tr end
				task.wait(0.2)
				if tr.Length > 0.01 then return tr end
				pcall(function() tr:Stop(0) end)
			end
		end
		return nil, primero
	end

	local propias = idsDeAnimateServer(victima, nombre)
	if #propias > 0 then
		local tr = intentar(propias, true)
		if tr then return tr end
	end

	local trRespaldo, primeroRespaldo = intentar(idsRespaldoServer(vh.RigType, nombre), false)
	if trRespaldo then return trRespaldo end
	-- Si el asset de respaldo aun no ha cargado, devolvemos el primero
	-- igual: al reproducirlo otra vez, Roblox termina de cargarlo.
	return primeroRespaldo
end

local function prepararAnimacionesServer(e)
	local vh = e.victimaHum
	local animator = vh and vh:FindFirstChildOfClass("Animator")
	if not animator then return end
	e.animator = animator
	detenerTracksServer(animator)
	e.trackIdle = cargarTrackServer(animator, e.victima, "idle")
	e.trackWalk = cargarTrackServer(animator, e.victima, "walk")
	e.trackRun = cargarTrackServer(animator, e.victima, "run")
	e.trackJump = cargarTrackServer(animator, e.victima, "jump")
	e.trackFall = cargarTrackServer(animator, e.victima, "fall")
	detenerTracksServer(animator)
	e.animActual = nil
	if e.trackIdle then
		e.trackIdle:Play(0.15)
		e.animActual = "idle"
	end
end

local function actualizarAnimacionesServer(e)
	local mov = e.mov or Vector3.zero
	local moviendo = mov.Magnitude > 0.05
	local objetivo = "idle"
	if e.jump and e.trackJump then
		objetivo = "jump"
	elseif moviendo and e.sprint and e.trackRun then
		objetivo = "run"
	elseif moviendo and e.trackWalk then
		objetivo = "walk"
	elseif moviendo and e.trackRun then
		objetivo = "run"
	end
	if e.animActual ~= objetivo then
		if e.trackIdle then pcall(function() e.trackIdle:Stop(0.15) end) end
		if e.trackWalk then pcall(function() e.trackWalk:Stop(0.15) end) end
		if e.trackRun then pcall(function() e.trackRun:Stop(0.15) end) end
		if e.trackJump then pcall(function() e.trackJump:Stop(0.15) end) end
		local tr = nil
		if objetivo == "idle" then
			tr = e.trackIdle
		elseif objetivo == "walk" then
			tr = e.trackWalk
		elseif objetivo == "run" then
			tr = e.trackRun
		elseif objetivo == "jump" then
			tr = e.trackJump
		end
		if tr then pcall(function() tr:Play(0.15) end) end
		e.animActual = objetivo
	elseif objetivo == "jump" and e.trackJump and not e.trackJump.IsPlaying then
		pcall(function() e.trackJump:Play(0.1) end)
	end
end

local function restaurarVictima(e)
	local d = e.datosV
	if not d then return end
	local victima = d.victima
	local vh = d.hum
	local vr = d.hrp
	if not victima or not victima.Parent or not vh or not vr or not vh.Parent or not vr.Parent then return end

	if e.animator then detenerTracksServer(e.animator) end
	for _, item in ipairs(d.sockets) do
		if item.c and item.c.Parent then item.c.Enabled = item.e end
	end
	for _, item in ipairs(d.ncs) do
		if item.c and item.c.Parent then item.c.Enabled = item.e end
	end
	for _, item in ipairs(d.partes) do
		if item.p and item.p.Parent then item.p.Massless = item.m end
	end
	-- Si el juego ya solto el cuerpo (Grabbed = nil), no se vuelve a
	-- enganchar el weld. Al desposeer con Z, Grabbed sigue apuntando a la
	-- victima y por eso SI se restaura la carga.
	local cbe = e.datosG and e.datosG.char and e.datosG.char:FindFirstChild("BodyEffects")
	local g = cbe and cbe:FindFirstChild("Grabbed")
	local vg = valorBody(victima, "Grabbed")
	local sigueCargando = (g and personajeDe(g.Value) == victima)
		or (vg and personajeDe(vg.Value) == e.controlador)
		or (weldCargaEntre(e.controlador, victima) ~= nil)

	local carry = d.carry
	if carry and carry.c and carry.c.Parent then
		-- Al desposeer con Z SI se reengancha la carga. Si el juego
		-- ya la solto, se queda desactivado.
		carry.c.Enabled = sigueCargando == true
		if carry.c:IsA("Weld") then
			carry.c.Part0 = carry.p0
			carry.c.Part1 = carry.p1
			carry.c.C0 = carry.c0
			carry.c.C1 = carry.c1
		end
	end
	-- V13.8: los welds que el juego recreo durante la posesion tambien
	-- vuelven a activarse si seguimos cargando.
	for _, w in ipairs(d.weldsExtra or {}) do
		if w and w.Parent then w.Enabled = sigueCargando == true end
	end

	-- V13.8: se reactiva el Animate propio del herido al desposeer.
	if d.animate and d.animate.Parent then
		d.animate.Enabled = d.animateEnabled
	end

	vh.PlatformStand = d.platform
	vh.AutoRotate = d.auto
	vh.WalkSpeed = d.walk
	vh.JumpPower = d.jump
	vh.UseJumpPower = d.use
	vr.Anchored = d.hrpAnclado
	vh:Move(Vector3.zero, false)
	pcall(function() vh:ChangeState(Enum.HumanoidStateType.PlatformStanding) end)
	pcall(function()
		local objetivo = d.dueno
		if objetivo == nil and d.victima then
			objetivo = Players:GetPlayerFromCharacter(d.victima)
		end
		for _, p in ipairs(d.partes) do
			if p.p and p.p.Parent then pcall(function() p.p:SetNetworkOwner(objetivo) end) end
		end
	end)

	-- Vuelve la animacion de cargado del juego solo si sigue cargando.
	local animator = vh:FindFirstChildOfClass("Animator")
	if animator and sigueCargando then
		local a = Instance.new("Animation")
		a.Name = "SpideyPose_Cargado"
		a.AnimationId = "rbxassetid://88134065149760"
		local ok, tr = pcall(function() return animator:LoadAnimation(a) end)
		if ok and tr then
			tr.Priority = Enum.AnimationPriority.Action
			tr:Play(0.15)
		end
	end
end

-----------------------------------------------------------------
-- Tu cuerpo original: debajo del mapa, tieso, mirando arriba
-----------------------------------------------------------------
local function seguirBajoControlador(e)
	local d = e.datosG
	local vr = e.victimaHRP
	if not d or not d.hrp or not d.hrp.Parent or not vr or not vr.Parent then return end
	local vpos = vr.Position
	local abajo = Vector3.new(vpos.X, vpos.Y - DIST_ABAJO, vpos.Z)
	local look = vr.CFrame.LookVector
	local forward = Vector3.new(look.X, 0, look.Z)
	if forward.Magnitude < 0.01 then forward = Vector3.zAxis else forward = forward.Unit end
	d.hrp.CFrame = CFrame.lookAt(abajo, abajo + Vector3.yAxis, forward)
	d.hrp.Anchored = true
	-- V13.8 NOCLIP: el cuerpo original atraviesa el piso y las paredes
	-- para que nunca se note ni se atasque. El Humanoid puede reactivar
	-- la colision de los miembros, asi que se refuerza cada fotograma.
	for _, item in ipairs(d.partes or {}) do
		if item.p and item.p.Parent and item.p.CanCollide then
			item.p.CanCollide = false
		end
	end
end

local function guardarControlador(pl)
	local c = pl.Character
	local h = humDe(c)
	local r = hrpDe(c)
	if not c or not h or not r then return nil end
	local partes = {}
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") then
			table.insert(partes, { p = p, cc = p.CanCollide })
		end
	end
	return {
		char = c,
		hum = h,
		hrp = r,
		anclado = r.Anchored,
		cframe = r.CFrame,
		walk = h.WalkSpeed,
		jump = h.JumpPower,
		use = h.UseJumpPower,
		platform = h.PlatformStand,
		auto = h.AutoRotate,
		partes = partes,
	}
end

local function ocultarControlador(e)
	local d = e.datosG
	if not d then return end
	d.hrp.Anchored = true
	d.hum.WalkSpeed = 0
	d.hum.JumpPower = 0
	d.hum.UseJumpPower = true
	d.hum.PlatformStand = true
	d.hum.AutoRotate = false
	seguirBajoControlador(e)
end

local function restaurarControlador(e)
	local d = e.datosG
	if not d then return end
	local c = pl0 and pl0.Character
	local dChar = d.char
	if not dChar or not dChar.Parent or not d.hrp or not d.hrp.Parent or not d.hum or not d.hum.Parent then return end

	local destino
	local yaw = 0
	local vr = e.victimaHRP
	if vr and vr.Parent then
		local cf = vr.CFrame * CFrame.new(0, 0, 4.5)
		destino = cf.Position + Vector3.new(0, 1.5, 0)
		local l = vr.CFrame.LookVector
		local plano = Vector3.new(l.X, 0, l.Z)
		if plano.Magnitude > 0.01 then yaw = math.atan2(plano.X, plano.Z) end
	else
		destino = (d.cframe and d.cframe.Position or Vector3.zero) + Vector3.new(0, 3, 0)
	end

	d.hrp.CFrame = CFrame.new(destino) * CFrame.Angles(0, yaw, 0)
	d.hrp.Anchored = d.anclado
	d.hum.WalkSpeed = d.walk
	d.hum.JumpPower = d.jump
	d.hum.UseJumpPower = d.use
	d.hum.PlatformStand = d.platform
	d.hum.AutoRotate = d.auto
	-- V13.8: se devuelve la colision original del cuerpo del jugador.
	for _, item in ipairs(d.partes or {}) do
		if item.p and item.p.Parent then
			item.p.CanCollide = item.cc
		end
	end
	if not d.anclado then
		pcall(function() d.hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
	end
end

-----------------------------------------------------------------
-- Activar / soltar posesion
-----------------------------------------------------------------
local function ponerDueno(victima, pl)
	for _, p in ipairs(victima:GetDescendants()) do
		if p:IsA("BasePart") then
			pcall(function() p:SetNetworkOwner(pl) end)
		end
	end
end

local function limpiarPoseyendo(pl, motivo)
	local e = poseyendo[pl]
	if not e then return end
	poseyendo[pl] = nil
	if e.victima and e.victima.Parent then
		poseidoPor[e.victima] = nil
		e.victima:SetAttribute("SpideyPoseidoPor", nil)
	end
	pl:SetAttribute("SpideyPoseyendo", nil)

	-- Primero devolvemos al jugador a la superficie. Si se reactiva el
	-- weld antes, el herido se engancha al cuerpo original que aun esta
	-- debajo del mapa y los dos caen al vacio.
	restaurarControlador(e)
	restaurarVictima(e)
	RE_Cuerpo:FireClient(pl, "POSE_STOP", motivo)
	print("[Spidey V13.9] posesion terminada: " .. tostring(e.victima and e.victima.Name) .. " (" .. tostring(motivo or "manual") .. ")")
end

-- V13.8: SIN deteccion de carga. Devuelve el cuerpo DERRIBADO (tirado:
-- K.O., muerto, ragdoll, PlatformStand, HRP anclado o vida baja) mas
-- cercano al que carga, dentro de 18 studs. Un jugador sano y de pie
-- nunca se posee. El jugador sabe cuando esta cargando a alguien:
-- derriba, agarra de la pierna, equipa el Control y hace clic.
local function resolverVictimaCarga(pl)
	local c = pl and pl.Character
	if not c then return nil end
	local cr = hrpDe(c)
	if not cr then return nil end

	local mejor, mejorDist = nil, 18
	local function probar(modelo)
		if not modelo or not modelo:IsA("Model") or modelo == c or not modelo.Parent then return end
		local vr = hrpDe(modelo)
		local vh = humDe(modelo)
		if not vr or not vh then return end
		if not cuerpoTiradoJuego(modelo) then return end
		local d = (vr.Position - cr.Position).Magnitude
		if d <= mejorDist then
			mejor, mejorDist = modelo, d
		end
	end
	for _, modelo in ipairs(workspace:GetChildren()) do
		if modelo:IsA("Model") then
			probar(modelo)
		elseif modelo:IsA("Folder") then
			for _, sub in ipairs(modelo:GetChildren()) do probar(sub) end
		end
	end
	for _, otro in ipairs(Players:GetPlayers()) do
		probar(otro.Character)
	end
	return mejor
end

local function iniciarPoseyendo(pl)
	if poseyendo[pl] then return false end

	local c = pl.Character
	local tool = c and c:FindFirstChild("Control")
	if not tool or not tool:IsA("Tool") then
		print("[Spidey V13.9] POSE_NO: falta el tool Control equipado")
		RE_Cuerpo:FireClient(pl, "POSE_NO", "Equipa el tool Control")
		return false
	end

	-- V13.8: SIN deteccion. Se toma el cuerpo mas cercano (el jugador
	-- sabe cuando esta cargando a alguien).
	local victima = resolverVictimaCarga(pl)
	if not victima or not victima.Parent then
		print("[Spidey V13.9] POSE_NO: ningun cuerpo derrribado a menos de 18 studs")
		RE_Cuerpo:FireClient(pl, "POSE_NO", "No hay ningun cuerpo derrribado cerca")
		return false
	end

	if poseidoPor[victima] then
		RE_Cuerpo:FireClient(pl, "POSE_NO", "Ese cuerpo ya esta controlado")
		return false
	end

	local vh = humDe(victima)
	local vr = hrpDe(victima)
	if not vh or not vr then
		RE_Cuerpo:FireClient(pl, "POSE_NO", "El cuerpo no es valido")
		return false
	end

	local e = {
		controlador = pl,
		victima = victima,
		victimaHum = vh,
		victimaHRP = vr,
		victimaPlayer = Players:GetPlayerFromCharacter(victima),
		mov = Vector3.zero,
		animator = vh:FindFirstChildOfClass("Animator"),
		moviendoSoloDesde = nil,
		datosG = guardarControlador(pl),
	}
	if not e.datosG then
		RE_Cuerpo:FireClient(pl, "POSE_NO", "Tu cuerpo no es valido")
		return false
	end

	e.datosV = guardarVictima(victima, pl)
	prepararVictima(e.datosV)
	prepararAnimacionesServer(e)
	ocultarControlador(e)
	ponerDueno(victima, nil)

	poseyendo[pl] = e
	poseidoPor[victima] = pl
	pl:SetAttribute("SpideyPoseyendo", victima.Name)
	victima:SetAttribute("SpideyPoseidoPor", pl.Name)
	RE_Cuerpo:FireClient(pl, "POSE_START", victima)
	print("[Spidey V13.9] posesion real: " .. victima.Name .. " (por " .. pl.Name .. ")")
	return true
end

-- V13.9 ARRANCAR (servidor): separa de verdad la extremidad que el
-- jugador tiene agarrada. Se destruye el Motor6D de hombro/cadera y
-- la extremidad cae con fisica real: TODOS la ven y no vuelve.
local ultimoRasgado = {}
local CADENAS_RASGAR = {
	{ "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg" },
	{ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg" },
	{ "RightUpperArm", "RightLowerArm", "RightHand", "Right Arm" },
	{ "LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm" },
}

local function rasgarVictima(pl, victima)
	local c = pl and pl.Character
	local cr = c and hrpDe(c)
	if not victima or not victima.Parent or not victima:IsA("Model") then return false end
	local vh = humDe(victima)
	local vr = hrpDe(victima)
	if not vh or not vr then return false end
	if not cr or (cr.Position - vr.Position).Magnitude > 22 then return false end

	-- La extremidad mas cercana al torso = la que esta agarrando.
	local ref = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or cr
	local mejorCadena, mejorDist = nil, math.huge
	for _, cadena in ipairs(CADENAS_RASGAR) do
		local raiz = victima:FindFirstChild(cadena[1]) or victima:FindFirstChild(cadena[4])
		if raiz and raiz:IsA("BasePart") then
			local d = (raiz.Position - ref.Position).Magnitude
			if d < mejorDist then
				mejorDist, mejorCadena = d, cadena
			end
		end
	end
	if not mejorCadena then return false end

	local partes = {}
	for _, nombre in ipairs(mejorCadena) do
		local p = victima:FindFirstChild(nombre)
		if p and p:IsA("BasePart") then table.insert(partes, p) end
	end
	if #partes == 0 then return false end

	local raiz = partes[1]
	local enCadena = {}
	for _, p in ipairs(partes) do enCadena[p] = true end
	local joints = {}
	for _, j in ipairs(victima:GetDescendants()) do
		local ok, p0, p1 = pcall(function() return j.Part0, j.Part1 end)
		if ok and typeof(p0) == "Instance" and typeof(p1) == "Instance"
			and p0:IsA("BasePart") and p1:IsA("BasePart")
			and enCadena[p0] ~= enCadena[p1]
			and p0.Name ~= p1.Name then
			if j.ClassName == "AnimationConstraint" or j.ClassName == "Motor6D" then
				table.insert(joints, 1, j)
			else
				table.insert(joints, j)
			end
		end
	end
	if #joints == 0 then return false end

	-- Separacion REAL: se destruyen TODOS los joints de esa extremidad
	-- (AnimationConstraint en Da Hood, Motor6D en rigs normales) y cae
	-- con fisica real. El herido sigue siendo un cadaver y podra
	-- caminar sin esa parte.
	for _, j in ipairs(joints) do
		pcall(function() j:Destroy() end)
	end
	for _, p in ipairs(partes) do
		if p.Parent then
			p.CanCollide = true
			p.Massless = false
			-- Empujon hacia fuera + caida: se ve desprenderse.
			local dir = Vector3.new(math.random(-6, 6), -12, math.random(-6, 6))
			local f = p.Position - vr.Position
			f = Vector3.new(f.X, 0, f.Z)
			if f.Magnitude > 0.5 then dir = f.Unit * 8 + Vector3.new(0, -12, 0) end
			p.AssemblyLinearVelocity = dir
			p.AssemblyAngularVelocity = Vector3.new(
				math.random(-6, 6), math.random(-6, 6), math.random(-6, 6))
		end
	end
	print("[Spidey V13.9] extremidad arrancada de " .. victima.Name .. " (por " .. pl.Name .. ")")
	return true
end

RE_Cuerpo.OnServerEvent:Connect(function(pl, accion, a, b, c)
	if accion == "POSE_START" then
		local ahora = os.clock()
		if ultimoPoseIntento[pl] and ahora - ultimoPoseIntento[pl] < 0.25 then return end
		ultimoPoseIntento[pl] = ahora
		iniciarPoseyendo(pl)
	elseif accion == "POSE_STOP" then
		limpiarPoseyendo(pl, "manual")
	elseif accion == "RASGAR" then
		local ahora = os.clock()
		if ultimoRasgado[pl] and ahora - ultimoRasgado[pl] < 0.75 then return end
		ultimoRasgado[pl] = ahora
		if typeof(a) == "Instance" and a:IsA("Model") then
			rasgarVictima(pl, a)
		end
	elseif accion == "POSE_MOVE" then
		local e = poseyendo[pl]
		if e and typeof(a) == "Vector3" then
			local v = Vector3.new(a.X, 0, a.Z)
			if v.Magnitude > 1 then v = v.Unit end
			e.mov = v
			e.sprint = b == true
			e.jump = c == true
		end
	end
end)

-- El servidor aplica el movimiento y mantiene animaciones y cuerpo
-- original. Asi todos ven lo mismo y el cliente no pelea con el juego.
RunService.Heartbeat:Connect(function()
	for pl, e in pairs(poseyendo) do
		local victimaNaceOtra = e.victimaPlayer and e.victimaPlayer.Character ~= e.victima
		local sigueValida = victimaValida(e.victima)

		-- V13.8: si el herido se levanta y se mueve por su cuenta mas de
		-- 2 s, la posesion termina (no se arrastra a un jugador vivo).
		if sigueValida and e.victimaHum then
			if e.victimaHum.MoveDirection.Magnitude > 0.15 then
				if not e.moviendoSoloDesde then
					e.moviendoSoloDesde = os.clock()
				elseif os.clock() - e.moviendoSoloDesde > 2 then
					sigueValida = false
				end
			else
				e.moviendoSoloDesde = nil
			end
		end

		if not sigueValida or victimaNaceOtra then
			limpiarPoseyendo(pl, victimaNaceOtra and "la victima respawneo" or "el herido se levanto o desaparecio")
		else
			-- V13.8: si el juego vuelve a crear el weld de carga mientras
			-- controlamos, se apaga para que no arrastre al herido.
			apagarWeldsCarga(e.controlador, e.victima, e.datosV)

			-- V13.8: el herido NO se levanta. Se mueve por CFrame como un
			-- cadaver inmovilizado y hace sus propias animaciones.
			local vh = e.victimaHum
			local vr = e.victimaHRP
			vh.PlatformStand = true
			vh.AutoRotate = false
			vh.WalkSpeed = 0
			vh.JumpPower = 0
			vh.UseJumpPower = true

			local ahora = os.clock()
			if not e.ultimoUpdate then
				e.ultimoUpdate = ahora
				e.offset = Vector3.zero
				e.startCF = (e.datosV and e.datosV.startCF) or vr.CFrame
				e.ultimaPos = e.startCF.Position
				e.inicioT = ahora
				if not e.rayParams then
					local rp = RaycastParams.new()
					rp.FilterType = Enum.RaycastFilterType.Exclude
					rp.FilterDescendantsInstances = { e.victima, e.controlador.Character }
					e.rayParams = rp
				end
				local hit0 = workspace:Raycast(e.startCF.Position, Vector3.new(0, -10, 0), e.rayParams)
				local suelo = hit0 and hit0.Position.Y or (e.startCF.Position.Y - 1)
				e.pisoY = suelo + vh.HipHeight + vr.Size.Y / 2 + 0.1
				if e.pisoY < e.startCF.Position.Y - 0.5 then
					e.pisoY = e.startCF.Position.Y
				end
			end
			local dt = math.clamp(ahora - e.ultimoUpdate, 0, 0.1)
			e.ultimoUpdate = ahora
			local velocidad = e.sprint and 24 or 16

			-- V13.9: el CADAVER respeta paredes y piso (NO tiene
			-- noclip; solo el cuerpo original del controlador lo
			-- tiene). El offset no se acumula al chocar: no se traba.
			local mov = e.mov or Vector3.zero
			local nuevoOffset = e.offset + mov * velocidad * dt
			if mov.Magnitude > 0.01 then
				local pasoX = (e.startCF.Position.X + nuevoOffset.X) - e.ultimaPos.X
				local pasoZ = (e.startCF.Position.Z + nuevoOffset.Z) - e.ultimaPos.Z
				local largo = math.sqrt(pasoX * pasoX + pasoZ * pasoZ)
				if largo > 0.01 then
					local dir = Vector3.new(pasoX / largo, 0, pasoZ / largo)
					local origen = Vector3.new(e.ultimaPos.X, e.pisoY or e.ultimaPos.Y, e.ultimaPos.Z)
					local hit = workspace:Raycast(origen, dir * (largo + 1.2), e.rayParams)
					if hit then
						local espacio = (hit.Position - origen).Magnitude - 1.2
						if espacio > 0.25 then
							nuevoOffset = Vector3.new(
								e.ultimaPos.X + dir.X * espacio - e.startCF.Position.X,
								nuevoOffset.Y,
								e.ultimaPos.Z + dir.Z * espacio - e.startCF.Position.Z
							)
						elseif largo > 0.6 then
							nuevoOffset = e.offset
						end
					end
				end
			end
			e.offset = nuevoOffset

			-- Piso releido bajo la posicion nueva (terreno/escaleras).
			if (ahora - (e.ultimoPiso or 0)) > 0.1 then
				e.ultimoPiso = ahora
				local px = e.startCF.Position.X + e.offset.X
				local pz = e.startCF.Position.Z + e.offset.Z
				local hit = workspace:Raycast(
					Vector3.new(px, (e.pisoY or e.startCF.Position.Y) + 3, pz),
					Vector3.new(0, -14, 0), e.rayParams)
				if hit then
					e.pisoY = hit.Position.Y + vh.HipHeight + vr.Size.Y / 2 + 0.1
				end
			end

			-- Levantada (0.6 s), orientacion de pie mirando al
			-- movimiento y salto simple.
			local tRise = math.clamp((ahora - e.inicioT) / 0.6, 0, 1)
			if tRise >= 1 then
				e.vy = e.vy or 0
				e.altura = e.altura or 0
				if e.jump and e.altura <= 0.05 and math.abs(e.vy) < 1 then
					e.vy = 42
				end
				e.vy = e.vy - 100 * dt
				e.altura = math.max(0, e.altura + e.vy * dt)
				if e.altura <= 0 then e.vy = 0 end
			end
			if mov.Magnitude > 0.01 then
				e.mirando = Vector3.new(mov.X, 0, mov.Z).Unit
			end
			local yAcostado = e.startCF.Position.Y
			local posY = yAcostado + (((e.pisoY or yAcostado) + (e.altura or 0)) - yAcostado) * tRise
			local pos = Vector3.new(
				e.startCF.Position.X + e.offset.X,
				posY,
				e.startCF.Position.Z + e.offset.Z
			)
			local look = e.mirando or Vector3.new(0, 0, -1)
			local dePie = CFrame.lookAt(pos, pos + look)
			if tRise < 1 then
				vr.CFrame = CFrame.new(pos) * (e.startCF.Rotation:Lerp(dePie.Rotation, tRise))
			else
				vr.CFrame = dePie
			end
			e.ultimaPos = pos
			vr.AssemblyLinearVelocity = Vector3.zero
			vr.AssemblyAngularVelocity = Vector3.zero
			seguirBajoControlador(e)
			actualizarAnimacionesServer(e)
		end
	end
end)

local function conectarPoseJugador(pl)
	pl.CharacterAdded:Connect(function()
		if poseyendo[pl] then limpiarPoseyendo(pl, "respawn del controlador") end
	end)
	pl.CharacterRemoving:Connect(function()
		if poseyendo[pl] then limpiarPoseyendo(pl, "salio el controlador") end
	end)
end

Players.PlayerAdded:Connect(conectarPoseJugador)
for _, pl in ipairs(Players:GetPlayers()) do
	conectarPoseJugador(pl)
end

Players.PlayerRemoving:Connect(function(pl)
	if poseyendo[pl] then limpiarPoseyendo(pl, "salio del juego") end
end)

local function infoPose()
	if next(poseyendo) == nil then return "sin posesiones" end
	local t = {}
	for pl, e in pairs(poseyendo) do
		table.insert(t, pl.Name .. " -> " .. tostring(e.victima and e.victima.Name))
	end
	return table.concat(t, " | ")
end

_G.SpideyV13Servidor = {
	info = infoPose,
	soltar = function(pl)
		if pl then
			limpiarPoseyendo(pl, "api")
		else
			for p in pairs(poseyendo) do
				limpiarPoseyendo(p, "api")
			end
		end
	end,
}

print("[Spidey V13.9] servidor listo: tool Control posee el cuerpo que estas cargando")

print("[Spidey V13.9] Servidor listo; valida telaranas y difunde animaciones por RE_Anim")

else
--=================================================================
--  MITAD CLIENTE: telarana, fisica y animaciones A/B procedurales
--=================================================================
-- Candado V13 (PROPIO de esta version): el V8/V12 usaba el mismo
-- candado (_G.__SPIDEY_V11_ACTIVO); si lo habias ejecutado antes en
-- la misma partida, esta version salia SIN DECIR NADA y parecia que
-- "no ejecutaba". Ahora el candado es propio de V13: SIEMPRE carga.
if _G.__SPIDEY_V13_ACTIVO then
	print("[Spidey V13.9] ya esta cargado en esta sesion: haz rejoin para recargarlo")
	return
end
_G.__SPIDEY_V13_ACTIVO = true
if _G.__SPIDEY_V11_ACTIVO then
	print("[Spidey V13.9] habia una version vieja (V8/V12) activa: esta NUEVA funciona igual; haz rejoin para quitar la vieja del todo")
end
print("[Spidey V13.9] cargando...")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- REMOTOS: primero espera unos segundos al servidor V8 (para que TODOS
-- vean las animaciones via RE_Anim). Si no aparece ningun servidor
-- (juego ajeno o modo executor/LocalScript), crea todo en local y
-- funciona en modo solitario.
local RE = nil
local sinServidor = false
local tEspera = os.clock()
while not RS:FindFirstChild("SpideyRemotos") and os.clock() - tEspera < 3 do
	task.wait(0.1)
end
RE = RS:FindFirstChild("SpideyRemotos")
if not RE then
	sinServidor = true
	print("[Spidey V13.9] sin servidor: MODO UNIVERSAL (giros visibles para todos por fisica)")
	RE = Instance.new("Folder")
	RE.Name = "SpideyRemotos"
	RE.Parent = RS
end

local function asegurarRemoto(nombre)
	local r
	if sinServidor then
		r = RE:FindFirstChild(nombre)
	else
		r = RE:WaitForChild(nombre, 6)
	end
	if not r then
		sinServidor = true
		r = Instance.new("RemoteEvent")
		r.Name = nombre
		r.Parent = RE
	end
	return r
end

local RE_Web = asegurarRemoto("RE_Web")
local RE_Efecto = asegurarRemoto("RE_Efecto")
local RE_Anim = asegurarRemoto("RE_Anim")
local RE_Cuerpo = asegurarRemoto("RE_Cuerpo")
local RE_Lock = asegurarRemoto("RE_Lock")

-- Sonidos opcionales: si SpideyAssets no existe, sigue sin audio.
local Assets = RS:FindFirstChild("SpideyAssets")
local Sonidos = Assets and Assets:FindFirstChild("Sonidos")

-- ============================================================
-- MÃDULO POSE (incrustado; antes ReplicatedStorage.SpideyMod.Pose)
-- ============================================================
local Pose = (function()
local Pose = {}

local rad = math.rad
local clamp = math.clamp

local ORDEN = {
	"Root", "Waist", "Neck",
	"RSh", "REl", "RHa", "LSh", "LEl", "LHa",
	"RHip", "RKne", "RAnk", "LHip", "LKne", "LAnk",
}

-- Nombres en el rig. Se busca AnimationConstraint primero y Motor6D despuÃ©s.
local NOMBRES = {
	Root = { "Root" },
	Waist = { "Waist", "Torso" },
	Neck = { "Neck" },
	RSh = { "RightShoulder", "Right Shoulder" },
	REl = { "RightElbow" },
	RHa = { "RightWrist" },
	LSh = { "LeftShoulder", "Left Shoulder" },
	LEl = { "LeftElbow" },
	LHa = { "LeftWrist" },
	RHip = { "RightHip", "Right Hip" },
	RKne = { "RightKnee" },
	RAnk = { "RightAnkle" },
	LHip = { "LeftHip", "Left Hip" },
	LKne = { "LeftKnee" },
	LAnk = { "LeftAnkle" },
}

local cache = {}         -- [modelo] = rig
local aditivo = nil      -- rig que recibe Pose.Objetivo/Aplicar
local objetivo = {}      -- [clave] = {x,y,z}
local actual = {}        -- [clave] = {x,y,z}

local function cero()
	local t = {}
	for _, k in ipairs(ORDEN) do t[k] = { x = 0, y = 0, z = 0 } end
	return t
end

objetivo = cero()
actual = cero()

local function esAC(obj)
	return obj and obj.ClassName == "AnimationConstraint"
end

local function esM6D(obj)
	return obj and obj.ClassName == "Motor6D"
end

local function buscarPorNombre(modelo, nombre)
	if not modelo then return nil end
	local ac, m6 = nil, nil
	for _, d in ipairs(modelo:GetDescendants()) do
		if d.Name == nombre then
			if esAC(d) then
				ac = d
			elseif esM6D(d) then
				m6 = m6 or d
			end
		end
	end
	return ac or m6, ac and "AC" or (m6 and "M6D" or nil)
end

local function construir(modelo)
	local rig = {
		modelo = modelo,
		juntas = {},
		tipos = {},
		tipo = "M6D",
		ok = false,
	}
	local cuentaAC, cuentaM6 = 0, 0

	for _, clave in ipairs(ORDEN) do
		local junta, tipo
		for _, nombre in ipairs(NOMBRES[clave]) do
			junta, tipo = buscarPorNombre(modelo, nombre)
			if junta then break end
		end
		if junta then
			rig.juntas[clave] = junta
			rig.tipos[clave] = tipo
			if tipo == "AC" then
				cuentaAC += 1
			elseif tipo == "M6D" then
				cuentaM6 += 1
			end
		end
	end

	rig.tipo = (cuentaAC >= cuentaM6) and "AC" or "M6D"
	rig.ok = rig.juntas.RSh ~= nil and rig.juntas.LSh ~= nil
		and (rig.juntas.RHip ~= nil or rig.tipo == "M6D")
	return rig
end

local function rotacionC0(junta)
	local ok, c0 = pcall(function() return junta.C0 end)
	if ok and typeof(c0) == "CFrame" then return c0.Rotation end
	-- Fallback para AnimationConstraint sin alias C0.
	local ok2, att = pcall(function() return junta.Attachment0 end)
	if ok2 and att then return att.CFrame.Rotation end
	return CFrame.identity
end

local function deltaRoot(junta, x, y, z, pos)
	local r = rotacionC0(junta)
	local rot = r:Inverse() * CFrame.Angles(rad(x), rad(y), rad(z)) * r
	if pos then
		local v = Vector3.new(pos.x or 0, pos.y or 0, pos.z or 0)
		return CFrame.new(r:Inverse() * v) * rot
	end
	return rot
end

local function deltaNormal(x, y, z)
	return CFrame.Angles(rad(x), rad(y), rad(z))
end

-- Las poses normales (Pose.Despegue, Caida, etc.) estÃ¡n escritas para un
-- rig en T: 0 = brazos horizontales. En AnimationConstraint los brazos
-- cuelgan, asÃ­ que hay que convertir el Ã¡ngulo.
--   Derecho: +Z sube el brazo hasta la T; T-convenciÃ³n negativa = bajar.
--   Izquierdo: -Z sube el brazo hasta la T; T-convenciÃ³n positiva = bajar.
local function convertirAditivo(tipo, clave, x, y, z)
	if tipo == "AC" then
		if clave == "RSh" then
			z = 90 + z
		elseif clave == "LSh" then
			z = z - 90
		end
	end
	return x, y, z
end

-- Las secuencias A/B estÃ¡n escritas con 0 = brazos abajo. En Motor6D/R6
-- el reposo es T, asÃ­ que se les resta la diferencia.
local function convertirExacto(tipo, clave, x, y, z)
	if tipo ~= "AC" then
		if clave == "RSh" then
			z = z - 90
		elseif clave == "LSh" then
			z = 90 - z
		end
	end
	return x, y, z
end

local function escribirExacto(rig, clave, x, y, z, peso, pos)
	local junta = rig.juntas[clave]
	if not junta or not junta.Parent then return end

	x, y, z = convertirExacto(rig.tipos[clave] or rig.tipo, clave, x, y, z)
	local delta = (clave == "Root") and deltaRoot(junta, x, y, z, pos) or deltaNormal(x, y, z)

	if peso and peso < 0.999 then
		local base = junta.Transform
		junta.Transform = base:Lerp(delta, clamp(peso, 0, 1))
	else
		junta.Transform = delta
	end
end

local function escribirAditivo(rig, clave, x, y, z)
	local junta = rig.juntas[clave]
	if not junta or not junta.Parent then return end

	x, y, z = convertirAditivo(rig.tipos[clave] or rig.tipo, clave, x, y, z)
	local delta = (clave == "Root") and deltaRoot(junta, x, y, z) or deltaNormal(x, y, z)
	junta.Transform = delta * junta.Transform
end

-----------------------------------------------------------------
-- API de rigs
-----------------------------------------------------------------
function Pose.Cachear(modelo)
	if not modelo then return false end
	local rig = cache[modelo]
	if rig and rig.modelo == modelo and rig.ok then
		if not aditivo then aditivo = rig end
		return true
	end

	rig = construir(modelo)
	cache[modelo] = rig
	if not aditivo and rig.ok then aditivo = rig end
	return rig.ok
end

function Pose.Liberar(modelo)
	cache[modelo] = nil
	if aditivo and aditivo.modelo == modelo then aditivo = nil end
end

function Pose.UsarAditivo(modelo)
	local rig = cache[modelo]
	if not rig then
		Pose.Cachear(modelo)
		rig = cache[modelo]
	end
	if rig and rig.ok then aditivo = rig end
	return rig ~= nil and rig.ok
end

function Pose.Tipo(modelo)
	local rig = cache[modelo]
	return rig and rig.tipo or nil
end

function Pose.Info(modelo)
	local rig = cache[modelo]
	if not rig then return {} end
	local t = { tipo = rig.tipo, ok = rig.ok }
	for _, k in ipairs(ORDEN) do
		local j = rig.juntas[k]
		t[k] = j and (j.Name .. "/" .. tostring(rig.tipos[k])) or "nil"
	end
	return t
end

-----------------------------------------------------------------
-- Capa aditiva (poses normales del balanceo, caÃ­da, trepa...)
-----------------------------------------------------------------
function Pose.Objetivo(tabla, modelo)
	if modelo then Pose.UsarAditivo(modelo) end
	for _, k in ipairs(ORDEN) do
		local d = objetivo[k]
		local v = tabla and tabla[k]
		if v then
			d.x = v.x or 0
			d.y = v.y or 0
			d.z = v.z or 0
		else
			d.x, d.y, d.z = 0, 0, 0
		end
	end
end

function Pose.Update(dt)
	local k = 1 - math.exp(-(dt or 0) * 14)
	for _, n in ipairs(ORDEN) do
		local a, d = actual[n], objetivo[n]
		a.x += (d.x - a.x) * k
		a.y += (d.y - a.y) * k
		a.z += (d.z - a.z) * k
	end
end

function Pose.Aplicar()
	if not aditivo or not aditivo.ok then return end
	for _, n in ipairs(ORDEN) do
		local a = actual[n]
		if math.abs(a.x) + math.abs(a.y) + math.abs(a.z) > 0.001 then
			escribirAditivo(aditivo, n, a.x, a.y, a.z)
		end
	end
end

function Pose.AplicarExacto(modelo, tabla, peso)
	local rig = cache[modelo]
	if not rig then
		Pose.Cachear(modelo)
		rig = cache[modelo]
	end
	if not rig or not rig.ok then return false end

	peso = peso or 1
	local raizPos = tabla and tabla.RootPos
	for _, n in ipairs(ORDEN) do
		local v = tabla and tabla[n]
		if v then
			escribirExacto(rig, n, v.x or 0, v.y or 0, v.z or 0, peso, n == "Root" and raizPos or nil)
		else
			escribirExacto(rig, n, 0, 0, 0, peso, n == "Root" and raizPos or nil)
		end
	end
	return true
end

function Pose.Reposo(modelo)
	local rig = cache[modelo]
	if not rig or not rig.ok then return end
	for _, n in ipairs(ORDEN) do
		local j = rig.juntas[n]
		if j and j.Parent then
			j.Transform = CFrame.identity
		end
	end
end

function Pose.Limpiar(modelo)
	for _, k in ipairs(ORDEN) do
		local a, d = actual[k], objetivo[k]
		a.x, a.y, a.z = 0, 0, 0
		d.x, d.y, d.z = 0, 0, 0
	end
	if modelo then
		Pose.Reposo(modelo)
	end
end

-----------------------------------------------------------------
-- Constructores de poses (convenciÃ³n T para rigs Motor6D;
-- el mÃ³dulo las convierte a AnimationConstraint automÃ¡ticamente)
-----------------------------------------------------------------
local function ch(x, y, z)
	return { x = x, y = y, z = z }
end

Pose.CH = ch

Pose.Idle = function()
	return { RSh = ch(0, 0, -3), LSh = ch(0, 0, 3) }
end

Pose.Despegue = function(potencia)
	local p = clamp(potencia or 1, 0.4, 1.6)
	return {
		RSh = ch(-20 * p, 0, -52 * p),
		LSh = ch(-20 * p, 0, 52 * p),
		RHip = ch(-46 * p, 0, -6),
		LHip = ch(-18 * p, 0, 6),
		Waist = ch(-12 * p, 0, 0),
	}
end

Pose.Caida = function(vCaida, lateral)
	local v = clamp((vCaida or 0) / 70, 0, 1.4)
	local l = clamp(lateral or 0, -1, 1)
	return {
		RSh = ch(-56 * v - 22, 0, -66 - 44 * v),
		LSh = ch(-56 * v - 22, 0, 66 + 44 * v),
		RHip = ch(-28 - 20 * v, 0, -10 - l * 24),
		LHip = ch(-28 - 20 * v, 0, 10 + l * 24),
		Waist = ch(-16 - 10 * v, l * 8, 0),
	}
end

Pose.Enganche = function()
	return {
		RSh = ch(0, 0, -172),
		LSh = ch(0, 0, 46),
		RHip = ch(-10, 0, -4),
		LHip = ch(14, 0, 4),
		Waist = ch(-8, 0, 0),
	}
end

function Pose.Balanceo(up, vel, lat)
	local u = clamp(up or 0, -1, 1)
	local zB = -22 - 138 * ((u + 1) / 2)
	local v = clamp((vel or 0) / 90, 0, 1.3)
	local l = clamp(lat or 0, -1, 1)
	return {
		RSh = ch(-12 - 10 * v, 0, zB),
		LSh = ch(-12 - 10 * v, 0, -zB),
		RHip = ch(-46 - 30 * v, 0, -8 - l * 16),
		LHip = ch(-30 - 22 * v, 0, 8 + l * 16),
		Waist = ch(-16 - 16 * v, l * 12, 0),
	}
end

Pose.Liberacion = function()
	return {
		RSh = ch(-26, 0, -104),
		LSh = ch(-26, 0, 104),
		RHip = ch(-34, 0, -8),
		LHip = ch(-20, 0, 8),
		Waist = ch(-14, 0, 0),
	}
end

Pose.Aterrizaje = function(impacto)
	local i = clamp(impacto or 1, 0.3, 1.6)
	return {
		RSh = ch(24 * i, 0, -26 * i),
		LSh = ch(24 * i, 0, 26 * i),
		RHip = ch(-78 * i, 0, -10),
		LHip = ch(-78 * i, 0, 10),
		Waist = ch(26 * i, 0, 0),
	}
end

Pose.Trepa = function(fase)
	local flip = fase and 1 or 0
	local a, b = (1 - flip), flip
	return {
		RSh = ch(0, 0, -28 - 142 * a),
		LSh = ch(0, 0, -28 - 142 * b),
		RHip = ch(-32 - 30 * a, 0, -8),
		LHip = ch(-32 - 30 * b, 0, 8),
		Waist = ch(-6, 0, 0),
	}
end

	return Pose
end)()

-- ============================================================
-- MÃDULO CAMARA (incrustado; capa de efectos sobre la cÃ¡mara
-- por defecto de Roblox: FOV con la velocidad + sacudidas)
-- API: Camara.Iniciar(camara, humanoid) Â· Camara.Update(dt, vel, lat, enSuelo)
--      Camara.Sacudida(fuerza)
-- ============================================================
local Camara = (function()
	local C = {}
	local cam, hum
	local fovBase = 70
	local shake = 0

	function C.Iniciar(c, h)
		cam = c
		hum = h
		if cam then fovBase = cam.FieldOfView end
	end

	function C.Update(dt, vel, lat, enSuelo)
		if not cam or not cam.Parent then return end
		local velocidad = vel and vel.Magnitude or 0
		local objetivo = fovBase + math.clamp((velocidad - 24) * 0.22, 0, 16)
		cam.FieldOfView = cam.FieldOfView + (objetivo - cam.FieldOfView) * math.min((dt or 0) * 6, 1)

		if shake > 0 then
			shake = math.max(shake - (dt or 0) * 2.2, 0)
			local f = shake * shake
			cam.CFrame = cam.CFrame * CFrame.Angles(
				(math.random() - 0.5) * f * 0.06,
				(math.random() - 0.5) * f * 0.06,
				(math.random() - 0.5) * f * 0.08
			)
		end
	end

	function C.Sacudida(fuerza)
		shake = math.clamp(math.max(shake, fuerza or 0.3), 0, 1.4)
	end

	return C
end)()

local RESET_CLIC = 4

-- ============================================================
-- CAPA VISIBLE V11 (lo que TODOS los jugadores ven)
-- ============================================================
-- ANIM_IDS: tus animaciones subidas. Solo CARGAN en juegos cuyo
-- dueÃ±o seas tu (tu copia de Da Hood, tus places). Pega aqui los IDs.
--   Ejemplo:  local ANIM_IDS = { A = 88979567248071, B = 0 }
local ANIM_IDS = {
	A = 0,
	B = 0,
}
-- ANIM_ROBLOX: emotes de Roblox. Cargan en CUALQUIER juego y todos
-- los ven. "Point" (apuntar) encaja con el disparo hacia arriba de A.
-- B usa "Fall" (pose aerea) mientras el cuerpo gira con fisica.
local ANIM_ROBLOX = {
	A = 507770453,
	B = 507767968,
}
-- GIRO_FISICO: en juegos SIN servidor Spidey, el backflip de B se
-- gira con fisica real (se replica a todos los clientes).
local GIRO_FISICO = true
-- ANIM_LOOP: repetir la animacion visible si dura menos que A/B.
local ANIM_LOOP = { A = false, B = true }

local CFG = {
	ALCANCE = 165,
	CUERDA_MIN = 8,
	WEB_SUBIDA = 0.85,
	WEB_DIST_LIBRE = 125,
	STIFFNESS = 260,
	AMORT_RADIAL = 9,
	DAMPING = 0.7,
	REEL = 430,
	IMPULSO_INICIAL = 62,
	VEL_MAX = 150,
	ACEL_TANGENCIAL = 92,
	BOMBO = 26,
	TREPA_DIST = 7,
	TREPA_VEL = 44,
	TREPA_OFFSET = 2.7,
	TREPA_MAX_NORMAL_Y = 0.35,
	SALTO_PARED = 64,
	SALTO_COLGADO = 56,
	CORDURA_GROSOR = 0.13,
	SONIDO_VOL = 0.55,
	RAYO_FRONTAL = 4.5,
}

local E = {
	Suelo = "Suelo", Jumping = "Jumping", Falling = "Falling",
	Attaching = "Attaching", Swinging = "Swinging", Releasing = "Releasing",
	Landing = "Landing", WallClimb = "WallClimb", Dead = "Dead",
}

local ORDEN = {
	"Root", "Waist", "Neck",
	"RSh", "REl", "RHa", "LSh", "LEl", "LHa",
	"RHip", "RKne", "RAnk", "LHip", "LKne", "LAnk",
}

-----------------------------------------------------------------
-- SECUENCIAS A/B
-- Unidades: grados. ConvenciÃ³n: 0 = brazos abajo, piernas abajo.
--   Root: X = cabeceo (negativo = giro hacia delante), Y = giro, Z = alabeo
--   Waist/Neck: X negativo = inclinarse/ mirar abajo
--   Hombro X positivo = brazo adelante
--   Hombro Z: derecho positivo sube; izquierdo negativo sube
--   Cadera X positivo = pierna adelante; Z derecho + / izquierdo - = abrir
--   Rodilla X negativo = flexionar
--   Tobillo X negativo = punta abajo
-----------------------------------------------------------------
local SEC = {}

SEC.A = {
	duracion = 1.833,
	frames = {
		-- A1: carga, el brazo derecho arranca desde atrÃ¡s
		{ t = 0.000, e = "quadOut", p = {
			Root = { 6, 0, -4 }, Waist = { -8, -6, 0 }, Neck = { 4, -8, 0 },
			RSh = { -20, 0, 15 }, REl = { 45, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { -10, 0, -30 }, LEl = { 60, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 18, 0, 4 }, RKne = { -32, 0, 0 }, RAnk = { -12, 0, 0 },
			LHip = { -8, 0, -4 }, LKne = { -16, 0, 0 }, LAnk = { -6, 0, 0 },
		}, RootPos = { x = 0, y = -0.12, z = 0 } },
		-- A2: el brazo derecho sube a disparar
		{ t = 0.160, e = "sineOut", p = {
			Root = { -2, 0, -2 }, Waist = { -6, -4, 0 }, Neck = { 8, -6, 0 },
			RSh = { 25, 0, 145 }, REl = { 12, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 5, 0, -55 }, LEl = { 80, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 14, 0, 4 }, RKne = { -28, 0, 0 }, RAnk = { -10, 0, 0 },
			LHip = { -6, 0, -4 }, LKne = { -14, 0, 0 }, LAnk = { -4, 0, 0 },
		}, RootPos = { x = 0, y = -0.05, z = 0 } },
		-- A3: extensiÃ³n completa hacia arriba
		{ t = 0.320, e = "sineInOut", p = {
			Root = { -5, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 10, 0, 0 },
			RSh = { 30, 0, 152 }, REl = { 8, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 10, 0, -60 }, LEl = { 85, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 12, 0, 4 }, RKne = { -24, 0, 0 }, RAnk = { -8, 0, 0 },
			LHip = { -4, 0, -4 }, LKne = { -12, 0, 0 }, LAnk = { -4, 0, 0 },
		}, RootPos = { x = 0, y = 0, z = 0 } },
		-- A4: el tirÃ³n dobla el cuerpo hacia delante
		{ t = 0.500, e = "quadIn", p = {
			Root = { 12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 },
			RSh = { 55, 0, 70 }, REl = { 70, 0, 0 }, RHa = { 5, 0, 0 },
			LSh = { 35, 0, -55 }, LEl = { 85, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 32, 0, 6 }, RKne = { -55, 0, 0 }, RAnk = { -14, 0, 0 },
			LHip = { 10, 0, -6 }, LKne = { -35, 0, 0 }, LAnk = { -8, 0, 0 },
		}, RootPos = { x = 0, y = -0.35, z = 0 } },
		-- A5: cuclillas profundas
		{ t = 0.700, e = "quadIn", p = {
			Root = { 18, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -16, 0, 0 },
			RSh = { 62, 0, 26 }, REl = { 118, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 52, 0, -30 }, LEl = { 112, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 92, 0, 8 }, RKne = { -130, 0, 0 }, RAnk = { 22, 0, 0 },
			LHip = { 58, 0, -8 }, LKne = { -112, 0, 0 }, LAnk = { 16, 0, 0 },
		}, RootPos = { x = 0, y = -1.05, z = 0 } },
		-- A6: asienta en el crouch
		{ t = 0.950, e = "sineInOut", p = {
			Root = { 13, 4, 0 }, Waist = { -27, 3, 0 }, Neck = { -12, 0, 0 },
			RSh = { 58, 0, 24 }, REl = { 114, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 50, 0, -28 }, LEl = { 108, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 96, 0, 8 }, RKne = { -134, 0, 0 }, RAnk = { 24, 0, 0 },
			LHip = { 62, 0, -8 }, LKne = { -116, 0, 0 }, LAnk = { 18, 0, 0 },
		}, RootPos = { x = 0, y = -1.12, z = 0 } },
		-- A7: mantiene con micro-balanceo
		{ t = 1.250, e = "sineInOut", p = {
			Root = { 12, 2, 0 }, Waist = { -26, 2, 0 }, Neck = { -11, 2, 0 },
			RSh = { 57, 0, 25 }, REl = { 113, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 49, 0, -27 }, LEl = { 107, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 94, 0, 8 }, RKne = { -132, 0, 0 }, RAnk = { 23, 0, 0 },
			LHip = { 60, 0, -8 }, LKne = { -114, 0, 0 }, LAnk = { 17, 0, 0 },
		}, RootPos = { x = 0, y = -1.10, z = 0 } },
		-- A8: empieza a incorporarse
		{ t = 1.550, e = "sineInOut", p = {
			Root = { 7, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -4, 0, 0 },
			RSh = { 30, 0, 15 }, REl = { 60, 0, 0 }, RHa = { 5, 0, 0 },
			LSh = { 26, 0, -16 }, LEl = { 55, 0, 0 }, LHa = { 5, 0, 0 },
			RHip = { 55, 0, 6 }, RKne = { -85, 0, 0 }, RAnk = { 14, 0, 0 },
			LHip = { 35, 0, -6 }, LKne = { -70, 0, 0 }, LAnk = { 10, 0, 0 },
		}, RootPos = { x = 0, y = -0.70, z = 0 } },
		-- A9: casi de pie
		{ t = 1.833, e = "sineOut", p = {
			Root = { 2, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 },
			RSh = { 8, 0, 6 }, REl = { 18, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 6, 0, -6 }, LEl = { 16, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 18, 0, 3 }, RKne = { -30, 0, 0 }, RAnk = { 6, 0, 0 },
			LHip = { 12, 0, -3 }, LKne = { -24, 0, 0 }, LAnk = { 5, 0, 0 },
		}, RootPos = { x = 0, y = -0.22, z = 0 } },
	},
}

SEC.B = {
	duracion = 5.333,
	frames = {
		-- B1: pose de mira, brazo izquierdo cargado junto a la cabeza
		{ t = 0.000, e = "sineOut", p = {
			Root = { 4, 0, 6 }, Waist = { -6, 10, 0 }, Neck = { 6, -12, 0 },
			RSh = { -12, 0, 18 }, REl = { 30, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 28, 0, -98 }, LEl = { 92, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 16, 0, 5 }, RKne = { -30, 0, 0 }, RAnk = { -10, 0, 0 },
			LHip = { -10, 0, -6 }, LKne = { -20, 0, 0 }, LAnk = { -6, 0, 0 },
		}, RootPos = { x = 0, y = -0.08, z = 0 } },
		{ t = 0.450, e = "sineInOut", p = {
			Root = { 6, 0, 8 }, Waist = { -10, 12, 0 }, Neck = { 4, -14, 0 },
			RSh = { -16, 0, 22 }, REl = { 36, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 32, 0, -102 }, LEl = { 96, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 20, 0, 6 }, RKne = { -38, 0, 0 }, RAnk = { -12, 0, 0 },
			LHip = { -12, 0, -6 }, LKne = { -24, 0, 0 }, LAnk = { -8, 0, 0 },
		}, RootPos = { x = 0, y = -0.14, z = 0 } },
		-- B2: comprime para cargar el salto
		{ t = 0.850, e = "quadIn", p = {
			Root = { 14, 0, 4 }, Waist = { -22, 8, 0 }, Neck = { -4, -6, 0 },
			RSh = { -10, 0, 35 }, REl = { 55, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 22, 0, -90 }, LEl = { 85, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 45, 0, 8 }, RKne = { -70, 0, 0 }, RAnk = { -16, 0, 0 },
			LHip = { 20, 0, -8 }, LKne = { -50, 0, 0 }, LAnk = { -10, 0, 0 },
		}, RootPos = { x = 0, y = -0.45, z = 0 } },
		-- B3: despegue del backflip, cuerpo arqueado atrÃ¡s
		{ t = 1.100, e = "quadOut", p = {
			Root = { 55, -14, -10 }, Waist = { -8, -4, 0 }, Neck = { 14, 8, 0 },
			RSh = { 70, 0, 115 }, REl = { 25, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 70, 0, -115 }, LEl = { 25, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { -15, 0, 6 }, RKne = { -12, 0, 0 }, RAnk = { -30, 0, 0 },
			LHip = { -10, 0, -6 }, LKne = { -10, 0, 0 }, LAnk = { -28, 0, 0 },
		}, RootPos = { x = 0, y = 0.25, z = 0 } },
		-- B4: cuarto de giro, aÃºn abierto
		{ t = 1.450, e = "linear", p = {
			Root = { 150, -10, -8 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 },
			RSh = { 85, 0, 95 }, REl = { 40, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 85, 0, -95 }, LEl = { 40, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { 40, 0, 8 }, RKne = { -75, 0, 0 }, RAnk = { -20, 0, 0 },
			LHip = { 35, 0, -8 }, LKne = { -70, 0, 0 }, LAnk = { -18, 0, 0 },
		}, RootPos = { x = 0, y = 0.45, z = 0 } },
		-- B5: medio giro, invertido y agrupado
		{ t = 1.800, e = "linear", p = {
			Root = { 195, 0, -6 }, Waist = { 10, 0, 0 }, Neck = { -14, 0, 0 },
			RSh = { 45, 0, 45 }, REl = { 115, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 42, 0, -45 }, LEl = { 110, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 95, 0, 8 }, RKne = { -130, 0, 0 }, RAnk = { 15, 0, 0 },
			LHip = { 90, 0, -8 }, LKne = { -125, 0, 0 }, LAnk = { 12, 0, 0 },
		}, RootPos = { x = 0, y = 0.50, z = 0 } },
		-- B6: tres cuartos, abre para buscar el suelo
		{ t = 2.150, e = "linear", p = {
			Root = { 290, -8, -4 }, Waist = { 6, 0, 0 }, Neck = { 6, 0, 0 },
			RSh = { 60, 0, 80 }, REl = { 55, 0, 0 }, RHa = { 5, 0, 0 },
			LSh = { 58, 0, -80 }, LEl = { 52, 0, 0 }, LHa = { 5, 0, 0 },
			RHip = { 45, 0, 8 }, RKne = { -70, 0, 0 }, RAnk = { 12, 0, 0 },
			LHip = { 40, 0, -8 }, LKne = { -65, 0, 0 }, LAnk = { 10, 0, 0 },
		}, RootPos = { x = 0, y = 0.25, z = 0 } },
		-- B7: aterrizaje en cuclillas (giro completo)
		{ t = 2.450, e = "quadOut", p = {
			Root = { 360, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { -16, 0, 0 },
			RSh = { 55, 0, 24 }, REl = { 118, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 50, 0, -26 }, LEl = { 112, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 94, 0, 8 }, RKne = { -132, 0, 0 }, RAnk = { 24, 0, 0 },
			LHip = { 88, 0, -8 }, LKne = { -126, 0, 0 }, LAnk = { 22, 0, 0 },
		}, RootPos = { x = 0, y = -1.15, z = 0 } },
		{ t = 2.950, e = "sineInOut", p = {
			Root = { 360, 2, 0 }, Waist = { -24, 0, 0 }, Neck = { -13, 0, 0 },
			RSh = { 52, 0, 25 }, REl = { 114, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 48, 0, -25 }, LEl = { 108, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 92, 0, 8 }, RKne = { -130, 0, 0 }, RAnk = { 23, 0, 0 },
			LHip = { 86, 0, -8 }, LKne = { -124, 0, 0 }, LAnk = { 21, 0, 0 },
		}, RootPos = { x = 0, y = -1.12, z = 0 } },
		-- B8: recarga mÃ¡s hondo el segundo salto
		{ t = 3.200, e = "quadIn", p = {
			Root = { 360, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -18, 0, 0 },
			RSh = { 60, 0, 20 }, REl = { 120, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 54, 0, -22 }, LEl = { 115, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 100, 0, 8 }, RKne = { -138, 0, 0 }, RAnk = { 26, 0, 0 },
			LHip = { 94, 0, -8 }, LKne = { -132, 0, 0 }, LAnk = { 24, 0, 0 },
		}, RootPos = { x = 0, y = -1.22, z = 0 } },
		-- B9: segundo despegue hacia atrÃ¡s
		{ t = 3.500, e = "quadOut", p = {
			Root = { 415, -12, -8 }, Waist = { -6, 0, 0 }, Neck = { 12, 6, 0 },
			RSh = { 72, 0, 110 }, REl = { 28, 0, 0 }, RHa = { 0, 0, 0 },
			LSh = { 72, 0, -110 }, LEl = { 28, 0, 0 }, LHa = { 0, 0, 0 },
			RHip = { -12, 0, 6 }, RKne = { -14, 0, 0 }, RAnk = { -28, 0, 0 },
			LHip = { -8, 0, -6 }, LKne = { -12, 0, 0 }, LAnk = { -26, 0, 0 },
		}, RootPos = { x = 0, y = 0.30, z = 0 } },
		-- B10: medio giro 2, invertido agrupado
		{ t = 3.850, e = "linear", p = {
			Root = { 555, -6, -6 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 },
			RSh = { 48, 0, 48 }, REl = { 112, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 45, 0, -48 }, LEl = { 108, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 92, 0, 8 }, RKne = { -128, 0, 0 }, RAnk = { 14, 0, 0 },
			LHip = { 86, 0, -8 }, LKne = { -122, 0, 0 }, LAnk = { 12, 0, 0 },
		}, RootPos = { x = 0, y = 0.50, z = 0 } },
		-- B11: abre y busca el suelo
		{ t = 4.200, e = "linear", p = {
			Root = { 650, -4, -4 }, Waist = { 4, 0, 0 }, Neck = { 4, 0, 0 },
			RSh = { 62, 0, 80 }, REl = { 55, 0, 0 }, RHa = { 5, 0, 0 },
			LSh = { 60, 0, -80 }, LEl = { 52, 0, 0 }, LHa = { 5, 0, 0 },
			RHip = { 42, 0, 8 }, RKne = { -68, 0, 0 }, RAnk = { 12, 0, 0 },
			LHip = { 38, 0, -8 }, LKne = { -62, 0, 0 }, LAnk = { 10, 0, 0 },
		}, RootPos = { x = 0, y = 0.22, z = 0 } },
		-- B12: aterrizaje final en cuclillas (720 = giro doble completo)
		{ t = 4.500, e = "quadOut", p = {
			Root = { 720, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -17, 0, 0 },
			RSh = { 56, 0, 24 }, REl = { 118, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 50, 0, -26 }, LEl = { 112, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 96, 0, 8 }, RKne = { -134, 0, 0 }, RAnk = { 25, 0, 0 },
			LHip = { 90, 0, -8 }, LKne = { -128, 0, 0 }, LAnk = { 23, 0, 0 },
		}, RootPos = { x = 0, y = -1.18, z = 0 } },
		{ t = 4.850, e = "sineInOut", p = {
			Root = { 720, 2, 0 }, Waist = { -25, 0, 0 }, Neck = { -14, 0, 0 },
			RSh = { 54, 0, 25 }, REl = { 115, 0, 0 }, RHa = { 10, 0, 0 },
			LSh = { 48, 0, -25 }, LEl = { 110, 0, 0 }, LHa = { 10, 0, 0 },
			RHip = { 94, 0, 8 }, RKne = { -132, 0, 0 }, RAnk = { 24, 0, 0 },
			LHip = { 88, 0, -8 }, LKne = { -126, 0, 0 }, LAnk = { 22, 0, 0 },
		}, RootPos = { x = 0, y = -1.15, z = 0 } },
		{ t = 5.333, e = "sineOut", p = {
			Root = { 720, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -4, 0, 0 },
			RSh = { 28, 0, 12 }, REl = { 55, 0, 0 }, RHa = { 5, 0, 0 },
			LSh = { 24, 0, -12 }, LEl = { 50, 0, 0 }, LHa = { 5, 0, 0 },
			RHip = { 55, 0, 6 }, RKne = { -85, 0, 0 }, RAnk = { 14, 0, 0 },
			LHip = { 45, 0, -6 }, LKne = { -72, 0, 0 }, LAnk = { 12, 0, 0 },
		}, RootPos = { x = 0, y = -0.62, z = 0 } },
	},
}

local EASE = {
	linear = function(a) return a end,
	sine = function(a) return 0.5 - 0.5 * math.cos(a * math.pi) end,
	sineIn = function(a) return 1 - math.cos(a * math.pi / 2) end,
	sineOut = function(a) return math.sin(a * math.pi / 2) end,
	sineInOut = function(a) return 0.5 - 0.5 * math.cos(a * math.pi) end,
	quadIn = function(a) return a * a end,
	quadOut = function(a) return 1 - (1 - a) * (1 - a) end,
	quadInOut = function(a)
		if a < 0.5 then return 2 * a * a end
		return 1 - ((-2 * a + 2) ^ 2) / 2
	end,
	cubicInOut = function(a)
		if a < 0.5 then return 4 * a * a * a end
		return 1 - ((-2 * a + 2) ^ 3) / 2
	end,
}

local function ease(nombre, a)
	local f = EASE[nombre] or EASE.sineInOut
	return f(math.clamp(a, 0, 1))
end

local seqTmp = {}
for _, k in ipairs(ORDEN) do
	seqTmp[k] = { x = 0, y = 0, z = 0 }
end
seqTmp.RootPos = { x = 0, y = 0, z = 0 }
local CERO_POS = { x = 0, y = 0, z = 0 }

local function muestrear(datos, t)
	local frames = datos.frames
	t = math.clamp(t, 0, datos.duracion)

	local i = 1
	while i < #frames and t > frames[i + 1].t do
		i += 1
	end
	local a = frames[i]
	local b = frames[i + 1] or frames[i]

	local alpha = 1
	if b.t > a.t then
		alpha = (t - a.t) / (b.t - a.t)
	end
	alpha = ease(a.e, alpha)

	for _, k in ipairs(ORDEN) do
		local pa = a.p[k]
		local pb = b.p[k]
		local ax = pa and pa[1] or 0
		local ay = pa and pa[2] or 0
		local az = pa and pa[3] or 0
		local bx = pb and pb[1] or ax
		local by = pb and pb[2] or ay
		local bz = pb and pb[3] or az
		local v = seqTmp[k]
		v.x = ax + (bx - ax) * alpha
		v.y = ay + (by - ay) * alpha
		v.z = az + (bz - az) * alpha
	end

	local ra = a.RootPos or CERO_POS
	local rb = b.RootPos or CERO_POS
	local r = seqTmp.RootPos
	r.x = (ra.x or 0) + ((rb.x or 0) - (ra.x or 0)) * alpha
	r.y = (ra.y or 0) + ((rb.y or 0) - (ra.y or 0)) * alpha
	r.z = (ra.z or 0) + ((rb.z or 0) - (ra.z or 0)) * alpha

	return seqTmp
end

-----------------------------------------------------------------
-- ESTADO
-----------------------------------------------------------------
local estado = E.Suelo
local char, hrp, hum, torso
local spiderTool, toolConexion
local webInputHeld = false
local anclaPos = nil
local largoCuerda = 0
local tiempoEstado = 0
local velocidadAterrizaje = 0
local enSueloPrev = false
local ultimoSonido = 0
local webActiva = false

local contadorClicks = 0
local ultimoClick = 0
local poseSpideyActiva = true

local secuencias = {}     -- [modelo] = {nombre, datos, inicio, pausa, tFijo, jugador, esLocal}
local redPropia = nil
local redesAjenas = {}    -- [jugador] = {parte, beam, att, modelo}
local efectosVivos = {}
local conexionVigilancia = nil
local soltarRope
local giroFisicoActivo = false
local ultimoFisX, ultimoFisT = nil, nil
local tracksVisibles = {}
local animProbandose = false

-----------------------------------------------------------------
-- UTILIDADES
-----------------------------------------------------------------
local function reproducir(nombre, vol, pitch)
	if not Sonidos then return nil end
	local o = Sonidos and Sonidos:FindFirstChild(nombre)
	if not o then return nil end
	local s = o:Clone()
	s.Volume = vol or CFG.SONIDO_VOL
	s.PlaybackSpeed = pitch or 1
	s.Parent = SoundService
	s:Play()
	if not s.Looped then
		s.Ended:Connect(function() s:Destroy() end)
	end
	return s
end

local function shiftPulsado()
	-- V11.7: trepar con X (antes Shift).
	return UIS:IsKeyDown(Enum.KeyCode.X)
end

local function anguloY(a, b)
	local ax, az = a.X, a.Z
	local bx, bz = b.X, b.Z
	local na, nb = math.sqrt(ax * ax + az * az), math.sqrt(bx * bx + bz * bz)
	if na < 1e-5 or nb < 1e-5 then return 0 end
	local cosang = math.clamp((ax * bx + az * bz) / (na * nb), -1, 1)
	local ang = math.acos(cosang)
	if (ax * bz - az * bx) < 0 then ang = -ang end
	return ang
end

local function setEstado(nuevo)
	if estado == nuevo then return end
	estado = nuevo
	tiempoEstado = 0
	if hrp then hrp:SetAttribute("SpideyEstado", nuevo) end
end

local function restaurarHumano()
	if not hum then return end
	hum.UseJumpPower = true
	hum.JumpPower = 50
	hum.AutoRotate = true
	hum.PlatformStand = false
end

-----------------------------------------------------------------
-- TELARAÃA
-----------------------------------------------------------------
local function configurarBeam(beam, att0, att1)
	beam.Attachment0 = att0
	beam.Attachment1 = att1
	beam.Width0 = CFG.CORDURA_GROSOR
	beam.Width1 = CFG.CORDURA_GROSOR * 0.75
	beam.FaceCamera = true
	beam.LightEmission = 0.75
	beam.LightInfluence = 0
	beam.Transparency = NumberSequence.new(0.14)
end

local function crearRed(modelo, punto)
	local parte = Instance.new("Part")
	parte.Name = "AnclaSpidey"
	parte.Size = Vector3.new(0.4, 0.4, 0.4)
	parte.Transparency = 1
	parte.Anchored = true
	parte.CanCollide = false
	parte.CanTouch = false
	parte.CanQuery = false
	parte.CastShadow = false
	parte.Position = punto
	parte.Parent = workspace

	local attAncla = Instance.new("Attachment")
	attAncla.Name = "AttAncla"
	attAncla.Parent = parte

	local mano = modelo:FindFirstChild("RightHand")
		or modelo:FindFirstChild("RightLowerArm")
		or modelo:FindFirstChild("Torso")
		or modelo:FindFirstChild("UpperTorso")

	local attMano = Instance.new("Attachment")
	attMano.Name = "AttMano"
	if mano and (mano.Name == "RightHand" or mano.Name == "RightLowerArm") then
		attMano.Position = Vector3.new(0, -0.65, 0)
	elseif mano then
		attMano.Position = Vector3.new(1.2, 0.3, 0)
	else
		attMano.Position = Vector3.zero
	end
	attMano.Parent = mano or parte

	local beam = Instance.new("Beam")
	beam.Name = "TelaraÃ±a"
	configurarBeam(beam, attMano, attAncla)
	beam.Parent = parte

	return { parte = parte, attAncla = attAncla, attMano = attMano, beam = beam, modelo = modelo }
end

local function destruirRed(red)
	if not red then return end
	if red.parte and red.parte.Parent then red.parte:Destroy() end
	if red.attMano and red.attMano.Parent then red.attMano:Destroy() end
end

local function crearCuerda()
	if redPropia then destruirRed(redPropia) end
	redPropia = crearRed(char, anclaPos)
end

local function limpiarCuerda()
	if redPropia then
		destruirRed(redPropia)
		redPropia = nil
	end
	anclaPos = nil
	largoCuerda = 0
	webActiva = false
end

local function actualizarCuerda()
	if redPropia and redPropia.parte then
		redPropia.parte.Position = anclaPos
	end
end

local function quitarRedAjena(jugador)
	local red = redesAjenas[jugador]
	if red then
		destruirRed(red)
		redesAjenas[jugador] = nil
	end
end

local function crearRedAjena(jugador, modelo, punto)
	quitarRedAjena(jugador)
	local red = crearRed(modelo, punto)
	redesAjenas[jugador] = red
end

local function limpiarRedesAjenas()
	for jugador in pairs(redesAjenas) do
		quitarRedAjena(jugador)
	end
end

-----------------------------------------------------------------
-- EFECTOS
-----------------------------------------------------------------
local function destelloAncla(pos)
	local p = Instance.new("Part")
	p.Name = "Destello"
	p.Size = Vector3.new(0.9, 0.9, 0.9)
	p.Position = pos
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(240, 248, 255)
	p.Transparency = 0.3
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.CastShadow = false
	p.Parent = workspace

	local luz = Instance.new("PointLight")
	luz.Color = Color3.fromRGB(220, 236, 255)
	luz.Brightness = 2.4
	luz.Range = 16
	luz.Parent = p

	table.insert(efectosVivos, p)
	TweenService:Create(p, TweenInfo.new(0.28), {
		Transparency = 1, Size = Vector3.new(0.15, 0.15, 0.15),
	}):Play()
	TweenService:Create(luz, TweenInfo.new(0.28), { Brightness = 0 }):Play()
	task.delay(0.35, function()
		if p.Parent then p:Destroy() end
	end)
end

-----------------------------------------------------------------
-- SECUENCIAS
-----------------------------------------------------------------
-- CAPA VISIBLE: los AnimationTrack del Animator SI se replican a todos
-- los clientes (asi funcionan el Animate del juego y los emotes). Roblox
-- solo deja cargar animaciones del dueÃ±o del juego o de Roblox; por eso
-- se prueba cada ID y se usa el primero que cargue de verdad (Length > 0).
local function candidatosAnim(nombre)
	local lista = {}
	local propio = ANIM_IDS[nombre]
	if propio and propio > 0 then table.insert(lista, propio) end
	local roblox = ANIM_ROBLOX[nombre]
	if roblox and roblox > 0 then table.insert(lista, roblox) end
	return lista
end

local function pararTrackAnim(nombre)
	local t = tracksVisibles[nombre]
	if t then
		tracksVisibles[nombre] = nil
		pcall(function() t:Stop(0.1) end)
	end
end

local function limpiarTracksAnim()
	for nombre in pairs(tracksVisibles) do
		local t = tracksVisibles[nombre]
		tracksVisibles[nombre] = nil
		pcall(function() t:Stop(0.1) end)
		task.delay(0.2, function()
			pcall(function() t:Destroy() end)
		end)
	end
end

local function terminarGiroFisico()
	if not giroFisicoActivo then return end
	giroFisicoActivo = false
	ultimoFisX, ultimoFisT = nil, nil
	pcall(function()
		if hrp then hrp.AssemblyAngularVelocity = Vector3.zero end
		if hum then hum:ChangeState(Enum.HumanoidStateType.Freefall) end
	end)
end

local intentosAnim = 0
local function probarAnimaciones()
	if animProbandose or not hum or not char then return end
	if not sinServidor then
		-- aun no sabemos si hay servidor; reintenta unas veces
		intentosAnim = intentosAnim + 1
		if intentosAnim <= 6 then
			task.delay(1.5, probarAnimaciones)
		end
		return
	end
	animProbandose = true
	task.spawn(function()
		local an = hum:FindFirstChildOfClass("Animator")
		if not an then
			animProbandose = false
			return
		end
		for _, nombre in ipairs({ "A", "B" }) do
			pararTrackAnim(nombre)
			for _, id in ipairs(candidatosAnim(nombre)) do
				local ok, track = pcall(function()
					local a = Instance.new("Animation")
					a.AnimationId = "rbxassetid://" .. tostring(id)
					return an:LoadAnimation(a)
				end)
				if ok and track then
					track.Priority = Enum.AnimationPriority.Action
					track.Looped = (ANIM_LOOP[nombre] == true)
					-- Roblox carga el asset en segundo plano: esperar a que
					-- Length sea mayor que 0 (si no es del dueÃ±o, se queda en 0).
					local espera = 0
					while track.Length <= 0 and espera < 2.5 do
						task.wait(0.1)
						espera = espera + 0.1
					end
					if track.Length > 0 then
						tracksVisibles[nombre] = track
						print(string.format("[Spidey V13.9] %s visible para TODOS (id %d, %.2fs)", nombre, id, track.Length))
						break
					else
						pcall(function() track:Destroy() end)
					end
				end
			end
			if not tracksVisibles[nombre] and candidatosAnim(nombre)[1] then
				print("[Spidey V13.9] " .. nombre .. ": ninguna animacion visible carga en este juego (queda la fisica/poses locales)")
			end
		end
		animProbandose = false
	end)
end

local function reproducirTrackAnim(nombre)
	if not sinServidor then return end
	local t = tracksVisibles[nombre]
	if t then
		pcall(function() t:Play(0.05) end)
	end
end

local function detenerSecuencia(modelo)
	local s = secuencias[modelo]
	if not s then return end
	secuencias[modelo] = nil

	if modelo == char then
		poseSpideyActiva = true
		if hrp then hrp:SetAttribute("SpideyAnim", nil) end
		pararTrackAnim(s.nombre)
		terminarGiroFisico()
	end
	-- La telaraÃ±a NO se quita aquÃ­: puede seguir activa despuÃ©s de que la
	-- animaciÃ³n termine. Se quita al recibir STOP o al soltar.
end

local function iniciarSecuencia(modelo, nombre, inicio, jugador, esLocal)
	local datos = SEC[nombre]
	if not datos then return false end
	if not modelo then return false end

	detenerSecuencia(modelo)
	Pose.Cachear(modelo)
	-- Apaga la capa aditiva local mientras dure la pose exacta para que no
	-- haya un salto al terminar. No tocar la capa aditiva por personajes
	-- remotos: el mÃ³dulo Pose solo tiene una capa aditiva activa.
	if modelo == char then
		Pose.Objetivo({}, char)
	end
	secuencias[modelo] = {
		nombre = nombre,
		datos = datos,
		inicio = inicio or workspace:GetServerTimeNow(),
		jugador = jugador,
		esLocal = esLocal == true,
	}

	if modelo == char then
		poseSpideyActiva = false
		if hrp then hrp:SetAttribute("SpideyAnim", nombre) end
		reproducirTrackAnim(nombre)
	end
	return true
end

local function finalizarSecuencia(modelo)
	local s = secuencias[modelo]
	if not s then return end
	detenerSecuencia(modelo)

	-- Solo se detiene la pose. La telaraÃ±a y el balanceo siguen hasta que
	-- el jugador suelte o el servidor mande STOP.
end

local function siguienteNombre()
	local ahora = os.clock()
	if ahora - ultimoClick > RESET_CLIC then
		contadorClicks = 0
	end
	ultimoClick = ahora
	contadorClicks = (contadorClicks % 2) + 1
	return (contadorClicks % 2 == 1) and "A" or "B"
end

-----------------------------------------------------------------
-- RAYCASTS
-----------------------------------------------------------------
local function paramsRay()
	local p = RaycastParams.new()
	p.FilterType = Enum.RaycastFilterType.Exclude
	p.FilterDescendantsInstances = { char }
	p.IgnoreWater = true
	return p
end

local function puntoDeAncla()
	local unit = mouse.UnitRay
	local dir = unit.Direction + Vector3.new(0, CFG.WEB_SUBIDA, 0)
	if dir.Magnitude < 0.001 then dir = unit.Direction end
	dir = dir.Unit

	local ok, res = pcall(function()
		return workspace:Raycast(unit.Origin, dir * CFG.ALCANCE, paramsRay())
	end)
	if ok and res then
		return res.Position + res.Normal * 1.3, res.Normal, true
	end
	return unit.Origin + dir * CFG.WEB_DIST_LIBRE, -dir, false
end

local function detectarPared()
	if not hrp or not torso then return nil end
	local cam = workspace.CurrentCamera

	local dirs = {
		Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
	}
	if cam then
		local haciaCam = cam.CFrame.Position - hrp.Position
		if haciaCam.Magnitude > 0.5 then table.insert(dirs, haciaCam.Unit) end
	end
	table.insert(dirs, hrp.CFrame.LookVector)
	table.insert(dirs, -hrp.CFrame.LookVector)

	local p = paramsRay()
	local mejor, mejorDist = nil, CFG.TREPA_DIST
	for _, d in ipairs(dirs) do
		local ok, hit = pcall(function()
			return workspace:Raycast(hrp.Position, d * CFG.TREPA_DIST, p)
		end)
		if ok and hit and math.abs(hit.Normal.Y) < CFG.TREPA_MAX_NORMAL_Y then
			local dist = (hit.Position - hrp.Position).Magnitude
			if dist < mejorDist then
				mejor, mejorDist = hit, dist
			end
		end
	end
	return mejor
end

-----------------------------------------------------------------
-- FÃSICA
-----------------------------------------------------------------
local function fisicaColgado(dt)
	local d = anclaPos - hrp.Position
	local dist = d.Magnitude

	if dist < CFG.CUERDA_MIN then
		soltarRope(false)
		return
	end

	local dir = d.Unit
	local v = hrp.AssemblyLinearVelocity
	local acc = Vector3.zero

	if dist > largoCuerda then
		acc = acc + dir * (dist - largoCuerda) * CFG.STIFFNESS
		local vr = v:Dot(dir)
		if vr < 0 then
			acc = acc - dir * vr * CFG.AMORT_RADIAL
		end
	end

	if webInputHeld and spiderTool and spiderTool.Parent == char then
		acc = acc + dir * CFG.REEL
	end

	local cam = workspace.CurrentCamera
	if cam then
		local fwd = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
		if fwd.Magnitude > 0.01 then
			fwd = fwd.Unit
			local lat = Vector3.new(fwd.Z, 0, -fwd.X)
			local inp = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then inp = inp + fwd end
			if UIS:IsKeyDown(Enum.KeyCode.S) then inp = inp - fwd end
			if UIS:IsKeyDown(Enum.KeyCode.D) then inp = inp + lat end
			if UIS:IsKeyDown(Enum.KeyCode.A) then inp = inp - lat end
			if inp.Magnitude > 0.01 then
				local tang = inp - dir * inp:Dot(dir)
				if tang.Magnitude > 0.01 then
					local fuerza = CFG.ACEL_TANGENCIAL
					if dir.Y > 0.4 and v.Y < 0 then fuerza = fuerza + CFG.BOMBO end
					acc = acc + tang.Unit * fuerza
				end
			end
		end
	end

	local nueva = (v + acc * dt) * (1 - CFG.DAMPING * dt)
	if nueva.Magnitude > CFG.VEL_MAX then nueva = nueva.Unit * CFG.VEL_MAX end

	if nueva.Magnitude > 70 then
		local ok, hit = pcall(function()
			return workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * CFG.RAYO_FRONTAL, paramsRay())
		end)
		if ok and hit then nueva = nueva * 0.72 end
	end

	hrp.AssemblyLinearVelocity = nueva
	actualizarCuerda()

	local ang = anguloY(hrp.CFrame.LookVector, dir)
	if math.abs(ang) > 0.003 then
		local giro = math.clamp(ang, -1.2, 1.2) * math.min(dt * 4.5, 1)
		hrp.CFrame = hrp.CFrame * CFrame.Angles(0, giro, 0)
	end
end

local function fisicaTrepa(dt)
	local hit = shiftPulsado() and detectarPared() or nil
	if not hit then
		restaurarHumano()
		setEstado(E.Falling)
		if hrp then
			local lv = hrp.CFrame.LookVector
			hrp.AssemblyLinearVelocity = Vector3.new(lv.X * 8, 16, lv.Z * 8)
		end
		return false
	end

	local n = hit.Normal
	local objetivo = hit.Position + n * CFG.TREPA_OFFSET
	local vy = 0
	if UIS:IsKeyDown(Enum.KeyCode.W) then vy = CFG.TREPA_VEL end
	if UIS:IsKeyDown(Enum.KeyCode.S) then vy = -CFG.TREPA_VEL end

	local a = hrp.Position
	local k = math.min(dt * 14, 1)
	local nuevo = Vector3.new(
		a.X + (objetivo.X - a.X) * k,
		a.Y + vy * dt,
		a.Z + (objetivo.Z - a.Z) * k
	)
	local objetivoYaw = math.atan2(-n.X, -n.Z)
	local actualYaw = select(1, hrp.CFrame:ToEulerAnglesYXZ())
	local giroYaw = (objetivoYaw - actualYaw)
	hrp.CFrame = CFrame.new(nuevo) * CFrame.Angles(0, actualYaw + giroYaw * math.min(dt * 12, 1), 0)
	hrp.AssemblyLinearVelocity = Vector3.new(0, vy, 0)
	return true
end

-----------------------------------------------------------------
-- DISPARO / LIBERACIÃN
-----------------------------------------------------------------
local function lanzarWeb()
	if not spiderTool or spiderTool.Parent ~= char then return end
	if not hrp or not hum or hum.Health <= 0 then return end
	if estado == E.WallClimb then return end
	if webActiva then return end

	local punto, normal, solido = puntoDeAncla()
	local dir = punto - hrp.Position
	local dist = dir.Magnitude
	if dist > CFG.ALCANCE or dist < 4 then
		reproducir("SFX_Impacto", 0.18, 1.7)
		return
	end

	local nombre = siguienteNombre()

	anclaPos = punto
	largoCuerda = dist
	webActiva = true
	crearCuerda()
	setEstado(E.Attaching)
	actualizarCuerda()

	iniciarSecuencia(char, nombre, workspace:GetServerTimeNow(), player, true)
	destelloAncla(punto)
	reproducir("SFX_WebDisparo", CFG.SONIDO_VOL, 0.95 + math.random() * 0.15)
	reproducir("SFX_Magico", 0.3, 1.2)
	Camara.Sacudida(0.35)

	hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + dir.Unit * CFG.IMPULSO_INICIAL
	RE_Web:FireServer("START", punto, normal, solido, nombre)
end

soltarRope = function(desdeSecuencia)
	if estado ~= E.Attaching and estado ~= E.Swinging then return end
	webInputHeld = false
	setEstado(E.Releasing)

	if not desdeSecuencia then
		detenerSecuencia(char)
	end

	local estaba = webActiva
	limpiarCuerda()
	restaurarHumano()

	if estaba then
		RE_Anim:FireServer("STOP")
	end

	reproducir("SFX_Viento", 0.3, 1.1)
	Camara.Sacudida(0.18)
end

local function detenerTelarana()
	webInputHeld = false
	if (estado == E.Attaching or estado == E.Swinging) and anclaPos then
		soltarRope(false)
	end
end

-----------------------------------------------------------------
-- HERRAMIENTA
-----------------------------------------------------------------
local function configurarTool(t)
	if not t or not t:IsA("Tool") then return end
	t.ToolTip = "Equipa y mantÃ©n clic izquierdo para lanzar la telaraÃ±a"
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = true
end

local function engancharTool(t)
	if not t or not t:IsA("Tool") or t.Name ~= "Spider" then return end
	if spiderTool == t then
		configurarTool(t)
		return
	end
	if toolConexion then
		toolConexion:Disconnect()
		toolConexion = nil
	end
	spiderTool = t
	configurarTool(t)
	toolConexion = t.Unequipped:Connect(detenerTelarana)
end

local function buscarTool()
	spiderTool = nil
	if toolConexion then
		toolConexion:Disconnect()
		toolConexion = nil
	end
	if char then
		for _, c in ipairs(char:GetChildren()) do
			if c:IsA("Tool") and c.Name == "Spider" then
				engancharTool(c)
				return
			end
		end
	end
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, c in ipairs(backpack:GetChildren()) do
			if c:IsA("Tool") and c.Name == "Spider" then
				engancharTool(c)
				return
			end
		end
	end
end

-- Si nadie dio el Tool SPIDER, el script lo crea en el Backpack.
local function asegurarTool()
	if not char then return end
	local bp = player:FindFirstChild("Backpack")
	if not bp then return end
	local existe = char:FindFirstChild("Spider") or bp:FindFirstChild("Spider")
	if existe then
		configurarTool(existe)
		return
	end
	local t = Instance.new("Tool")
	t.Name = "Spider"
	t.ToolTip = "Equipa y mantÃ©n clic izquierdo para lanzar la telaraÃ±a"
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = true
	t.Parent = bp
end

-----------------------------------------------------------------
-- BUCLE PRINCIPAL
-----------------------------------------------------------------
local poseyendo = false
local poseyendoVictima = nil
local poseyendoDatos = nil
local function bucle(dt)
	if not hrp or not hum then return end
	-- V13.8: mientras controlas otro cuerpo, tu avatar queda quieto
	-- debajo del mapa; no ejecutes telarana/poses en el.
	if poseyendo then return end

	if hum.Health <= 0 then
		if estado ~= E.Dead then
			setEstado(E.Dead)
			detenerSecuencia(char)
			local estaba = webActiva
			limpiarCuerda()
			restaurarHumano()
			Pose.Limpiar(char)
			poseSpideyActiva = true
			if estaba then RE_Anim:FireServer("STOP") end
		end
		return
	end

	tiempoEstado = tiempoEstado + dt
	local v = hrp.AssemblyLinearVelocity
	local enSuelo = hum.FloorMaterial ~= Enum.Material.Air

	if not enSuelo then
		velocidadAterrizaje = math.max(velocidadAterrizaje * 0.985, -v.Y)
	else
		velocidadAterrizaje = 0
	end

	local lat = 0
	local cam = workspace.CurrentCamera
	if cam then
		local fwd = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
		local vv = Vector3.new(v.X, 0, v.Z)
		if fwd.Magnitude > 0.01 and vv.Magnitude > 1 then
			lat = fwd.Unit:Cross(vv.Unit).Y
		end
	end

	if (estado == E.Swinging or estado == E.Attaching) and anclaPos then
		if estado == E.Attaching and tiempoEstado >= 0.14 then
			setEstado(E.Swinging)
		end
		restaurarHumano()
	    fisicaColgado(dt)
		if anclaPos then
			local up = (anclaPos - hrp.Position).Unit.Y
			local hor = Vector3.new(v.X, 0, v.Z).Magnitude
			if poseSpideyActiva then
				Pose.Objetivo(Pose.Balanceo(up, hor, lat * 0.8), char)
			end
		end
		Camara.Update(dt, v, lat, false)
		if poseyendo and poseSpideyActiva and char and char.Parent then Pose.Objetivo(Pose.Aterrizaje(0.55), char) end
		Pose.Update(dt)
		return
	end

	if estado == E.WallClimb or shiftPulsado() then
		if estado ~= E.WallClimb then
			local hit = detectarPared()
			if hit then
				detenerSecuencia(char)
				setEstado(E.WallClimb)
				poseSpideyActiva = true
				hum.PlatformStand = true
				hum.AutoRotate = false
				hum.UseJumpPower = true
				hum.JumpPower = 0
				destelloAncla(hit.Position + hit.Normal * 0.3)
				reproducir("SFX_Impacto", 0.3, 1.5)
				Camara.Sacudida(0.25)
			end
		end
		if estado == E.WallClimb then
			if fisicaTrepa(dt) then
				Pose.Objetivo(Pose.Trepa((os.clock() / 0.34) % 1 < 0.5), char)
			end
			Camara.Update(dt, v, lat, false)
			if poseyendo and poseSpideyActiva and char and char.Parent then Pose.Objetivo(Pose.Aterrizaje(0.55), char) end
			Pose.Update(dt)
			return
		end
	end

	if estado == E.Releasing then
		if enSuelo then setEstado(E.Landing) else setEstado(E.Falling) end
	end

	restaurarHumano()

	if v.Magnitude > CFG.VEL_MAX and estado ~= E.Suelo then
		local limited = v.Unit * CFG.VEL_MAX
		hrp.AssemblyLinearVelocity = limited
		v = limited
	end

	if enSuelo then
		if estado == E.Landing then
			if tiempoEstado > 0.28 then setEstado(E.Suelo) end
		else
			setEstado(E.Suelo)
		end
	elseif estado == E.Suelo then
		setEstado(E.Jumping)
	elseif estado == E.Landing then
		setEstado(E.Falling)
	end

	if estado == E.Suelo then
		Pose.Objetivo({}, char)
	elseif estado == E.Jumping then
		local p = tiempoEstado / 0.22
		if p >= 1 then setEstado(E.Falling) end
		if poseSpideyActiva then
			Pose.Objetivo(Pose.Despegue(1 - p * 0.5), char)
		end
	elseif estado == E.Falling then
		if poseSpideyActiva then
			Pose.Objetivo(Pose.Caida(math.max(-v.Y, 0), lat), char)
		end
	elseif estado == E.Landing then
		local k = 1 - tiempoEstado / 0.28
		if poseSpideyActiva then
			Pose.Objetivo(Pose.Aterrizaje(velocidadAterrizaje / 45 * (0.5 + k)), char)
		end
	end

	Camara.Update(dt, v, lat, enSuelo)
	if poseyendo and poseSpideyActiva and char and char.Parent then Pose.Objetivo(Pose.Aterrizaje(0.55), char) end
	Pose.Update(dt)

	if v.Magnitude > 55 and not enSuelo and os.clock() - ultimoSonido > 0.55 then
		ultimoSonido = os.clock()
		reproducir("SFX_Viento", math.clamp(v.Magnitude / 150, 0.15, 0.45), 0.8 + v.Magnitude / 400)
	end
end

-----------------------------------------------------------------
-- APLICACIÃN DE SECUENCIAS (PreSimulation)
-----------------------------------------------------------------
RunService.PreSimulation:Connect(function()
	local ahora = workspace:GetServerTimeNow()
	local terminadas = {}

	for modelo, s in pairs(secuencias) do
		if not modelo.Parent then
			table.insert(terminadas, modelo)
		else
			local t
			if s.pausa then
				t = s.tFijo or 0
			else
				t = ahora - s.inicio
			end

			if not s.pausa and t >= s.datos.duracion then
				table.insert(terminadas, modelo)
			else
				local pose = muestrear(s.datos, math.min(t, s.datos.duracion))
				local peso = 1
				if not s.pausa then
					if t < 0.06 then peso = t / 0.06 end
					local queda = s.datos.duracion - t
					if queda < 0.12 then
						peso = math.min(peso, math.max(queda, 0) / 0.12)
					end
				end
				-- MODO UNIVERSAL: giro FISICO real (la fisica se replica a todos)
				if s.esLocal and sinServidor and GIRO_FISICO and hrp and hum and pose.Root then
					if math.abs(pose.Root.x) > 45 then
						local objetivoX = pose.Root.x
						local dtF = math.max(ahora - (ultimoFisT or (ahora - 0.016)), 0.001)
						local vel = (objetivoX - (ultimoFisX or objetivoX)) / dtF
						ultimoFisT, ultimoFisX = ahora, objetivoX
						if math.abs(vel) > 25 then
							pcall(function()
								hrp.AssemblyAngularVelocity = hrp.CFrame.RightVector * math.rad(vel)
							end)
							if not giroFisicoActivo then
								giroFisicoActivo = true
								pcall(function()
									hum:ChangeState(Enum.HumanoidStateType.Physics)
									hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, 42, 0)
								end)
							end
						elseif giroFisicoActivo then
							terminarGiroFisico()
						end
						seqTmp.Root.x = 0 -- anula la rotacion visual para no girar dos veces
					elseif giroFisicoActivo then
						terminarGiroFisico()
					end
				end
				Pose.AplicarExacto(modelo, pose, peso)
			end
		end
	end

	for _, modelo in ipairs(terminadas) do
		finalizarSecuencia(modelo)
	end

	if char and not secuencias[char] then
		Pose.Aplicar()
	end
end)

-----------------------------------------------------------------
-- ATERRIZAJE
-----------------------------------------------------------------
local function vigilarAterrizaje()
	return RunService.Heartbeat:Connect(function()
		if not hum or not hrp or hum.Health <= 0 then return end
		local enSuelo = hum.FloorMaterial ~= Enum.Material.Air
		if enSuelo and not enSueloPrev then
			local imp = velocidadAterrizaje
			if imp > 18 then
				reproducir("SFX_Aterrizar", math.clamp(imp / 90, 0.15, 0.7), 1)
				Camara.Sacudida(math.clamp(imp / 160, 0.1, 0.75))
			end
		end
		enSueloPrev = enSuelo
	end)
end

-----------------------------------------------------------------
-- INPUT
-----------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
	if gpe or UIS:GetFocusedTextBox() then return end
	if not hrp or not hum or hum.Health <= 0 then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if spiderTool and spiderTool.Parent == char and not webInputHeld then
			webInputHeld = true
			lanzarWeb()
		end

	elseif input.KeyCode == Enum.KeyCode.Space then
		if estado == E.Swinging or estado == E.Attaching then
			webInputHeld = false
			soltarRope(false)
			hum.Jump = true
			hrp.AssemblyLinearVelocity =
				hrp.AssemblyLinearVelocity + Vector3.new(0, CFG.SALTO_COLGADO, 0)
			if poseSpideyActiva then
				Pose.Objetivo(Pose.Liberacion(), char)
			end
			reproducir("SFX_Viento", 0.4, 0.9)
		elseif estado == E.WallClimb then
			local salida = hrp.CFrame.LookVector * 34
			restaurarHumano()
			setEstado(E.Falling)
			hrp.AssemblyLinearVelocity = salida + Vector3.new(0, CFG.SALTO_PARED, 0)
			Pose.Objetivo(Pose.Liberacion(), char)
			Camara.Sacudida(0.3)
			reproducir("SFX_Viento", 0.45, 0.85)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and webInputHeld then
		detenerTelarana()
	end
end)

-----------------------------------------------------------------
-- EVENTOS DEL SERVIDOR
-----------------------------------------------------------------
RE_Anim.OnClientEvent:Connect(function(accion, jugador, nombre, inicio, ancla)
	if accion == "PLAY" then
		if jugador == player then return end
		if not (jugador and jugador.Character) then return end
		if nombre ~= "A" and nombre ~= "B" then return end
		local modelo = jugador.Character
		if typeof(ancla) == "Vector3" then
			crearRedAjena(jugador, modelo, ancla)
		end
		iniciarSecuencia(modelo, nombre, inicio, jugador, false)

	elseif accion == "STOP" or accion == "CANCEL" then
		if jugador == player then
			detenerSecuencia(char)
			if estado == E.Attaching or estado == E.Swinging then
				webInputHeld = false
				setEstado(E.Releasing)
				limpiarCuerda()
				restaurarHumano()
			end
		else
			local modelo = jugador and jugador.Character
			if modelo then detenerSecuencia(modelo) end
			if jugador then quitarRedAjena(jugador) end
		end

	elseif accion == "DENIED" then
		if jugador == player then
			detenerSecuencia(char)
			if estado == E.Attaching or estado == E.Swinging then
				webInputHeld = false
				setEstado(E.Releasing)
				limpiarCuerda()
				restaurarHumano()
			end
		end
	end
end)

RE_Efecto.OnClientEvent:Connect(function(jugador, punto)
	if jugador == player or not hrp then return end
	if typeof(punto) == "Vector3" and (punto - hrp.Position).Magnitude > 260 then return end
	reproducir("SFX_WebDisparo", CFG.SONIDO_VOL * 0.55, 1)
end)

Players.PlayerRemoving:Connect(function(jugador)
	quitarRedAjena(jugador)
	if jugador.Character then
		detenerSecuencia(jugador.Character)
	end
end)

-----------------------------------------------------------------
-- GUI
-----------------------------------------------------------------
local function crearGUI()
	local pg = player:WaitForChild("PlayerGui")
	if pg:FindFirstChild("SpideyHUD") then return end
	local gui = Instance.new("ScreenGui")
	gui.Name = "SpideyHUD"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = pg

	local panel = Instance.new("Frame")
	panel.AnchorPoint = Vector2.new(0.5, 1)
	panel.Position = UDim2.new(0.5, 0, 1, -28)
	panel.Size = UDim2.new(0, 760, 0, 58)
	panel.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
	panel.BackgroundTransparency = 0.3
	panel.BorderSizePixel = 0
	panel.Parent = gui

	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0, 14)
	uic.Parent = panel

	local borde = Instance.new("UIStroke")
	borde.Color = Color3.fromRGB(120, 180, 255)
	borde.Thickness = 1.4
	borde.Transparency = 0.55
	borde.Parent = panel

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -16, 1, 0)
	txt.Position = UDim2.new(0, 8, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Font = Enum.Font.GothamMedium
	txt.TextColor3 = Color3.fromRGB(228, 238, 255)
	txt.TextScaled = true
	txt.Text = "SPIDER: CLIC IZQ = TELARAÃA (A/B) Â· MANTÃN = BALANCEO Â· X+PARED = TREPAR Â· ESPACIO = SALTAR Â· TOOL CONTROL = POSESION Â· Q = LOCK (DUEÃO) Â· J = ESP"
	txt.Parent = panel

	task.delay(10, function()
		if not panel.Parent then return end
		TweenService:Create(panel, TweenInfo.new(1.2), { BackgroundTransparency = 0.9 }):Play()
		TweenService:Create(borde, TweenInfo.new(1.2), { Transparency = 1 }):Play()
		TweenService:Create(txt, TweenInfo.new(1.2), { TextTransparency = 1 }):Play()
	end)
	task.delay(12, function()
		if gui.Parent then gui:Destroy() end
	end)
end

-----------------------------------------------------------------
-- LIMPIEZA / ARRANQUE
-----------------------------------------------------------------
local function limpiarTodo()
	webInputHeld = false
	if char then
		detenerSecuencia(char)
	end
	local estaba = webActiva
	limpiarCuerda()
	if estaba then
		RE_Anim:FireServer("STOP")
	end

	for _, p in ipairs(efectosVivos) do
		if p.Parent then p:Destroy() end
	end
	table.clear(efectosVivos)
	limpiarTracksAnim()
	limpiarRedesAjenas()

	if char then
		Pose.Liberar(char)
	end
	if hum then
		restaurarHumano()
	end
	if conexionVigilancia then
		conexionVigilancia:Disconnect()
		conexionVigilancia = nil
	end
end

local function alNacer(c)
	limpiarTodo()
	char = c
	hrp = c:WaitForChild("HumanoidRootPart", 10)
	hum = c:WaitForChild("Humanoid", 10)
	if not hrp or not hum then return end
	torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")

	Pose.Cachear(char)
	Pose.UsarAditivo(char)
	Pose.Limpiar(char)
	restaurarHumano()
	setEstado(E.Suelo)
	hrp:SetAttribute("SpideyEstado", E.Suelo)
	hrp:SetAttribute("SpideyAnim", nil)
	Camara.Iniciar(workspace.CurrentCamera, hum)
	conexionVigilancia = vigilarAterrizaje()
	probarAnimaciones()

	asegurarTool()
	buscarTool()
	if c:FindFirstChild("Spider") then
		engancharTool(c:FindFirstChild("Spider"))
	end
	c.ChildAdded:Connect(function(obj)
		if obj:IsA("Tool") and obj.Name == "Spider" then
			engancharTool(obj)
		end
	end)
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		backpack.ChildAdded:Connect(function(obj)
			if obj:IsA("Tool") and obj.Name == "Spider" then
				engancharTool(obj)
			end
		end)
	end

	hum.Died:Connect(function()
		if player.Character == c then
			setEstado(E.Dead)
			detenerSecuencia(char)
			local estaba = webActiva
			limpiarCuerda()
			restaurarHumano()
			Pose.Limpiar(char)
			poseSpideyActiva = true
			if estaba then RE_Anim:FireServer("STOP") end
		end
	end)

	hum.StateChanged:Connect(function(_, nuevo)
		if nuevo == Enum.HumanoidStateType.Dead and player.Character == c then
			setEstado(E.Dead)
			detenerSecuencia(char)
			limpiarCuerda()
			restaurarHumano()
			Pose.Limpiar(char)
			poseSpideyActiva = true
		end
	end)

	task.wait(1)
	if player.Character == c then
		crearGUI()
		print("[Spidey V13.9] cliente listo | rig=" .. tostring(Pose.Tipo(char)) .. " | A/B procedurales")
	end
end

player.CharacterAdded:Connect(function(c)
	task.spawn(alNacer, c)
end)
player.CharacterRemoving:Connect(function()
	limpiarTodo()
end)

if player.Character then
	task.spawn(alNacer, player.Character)
end

RunService.Heartbeat:Connect(bucle)
-----------------------------------------------------------------
-- V13.8 · POSESION REAL (tool Control), LOCK (Q) y ESP (J)
-- El control ya no usa G ni crea clones: se activa con el tool
-- Control SOLO cuando ya estas cargando a un cuerpo derribado.
-----------------------------------------------------------------
local V11 = {}
local espActivo = false
local espDatos = {}

local poseyendo = false
local poseyendoVictima = nil
local poseyendoDatos = nil
local controlTool = nil
local controlConexiones = {}
local ultimoPoseIntento = 0

-- Estas funciones se asignan mas abajo, despues de la camara y del
-- movimiento. Las guardo aqui para que el tool Control pueda usarlas.
local intentarPoseyendo
local terminarPoseyendoLocal
local arrancarPoseyendoLocal

-- Aviso pequeno abajo en pantalla (no reemplaza el HUD del juego).
local hudTexto = nil
local function mostrarHUD(texto)
	if not hudTexto then
		local pg = player:FindFirstChild("PlayerGui")
		if not pg then return end
		local gui = pg:FindFirstChild("SpideyV13HUD")
		if not gui then
			gui = Instance.new("ScreenGui")
			gui.Name = "SpideyV13HUD"
			gui.ResetOnSpawn = false
			gui.IgnoreGuiInset = true
			gui.Parent = pg
		end
		hudTexto = gui:FindFirstChild("Texto")
		if not hudTexto then
			hudTexto = Instance.new("TextLabel")
			hudTexto.Name = "Texto"
			hudTexto.AnchorPoint = Vector2.new(0.5, 1)
			hudTexto.Position = UDim2.new(0.5, 0, 1, -96)
			hudTexto.Size = UDim2.new(0, 520, 0, 28)
			hudTexto.BackgroundTransparency = 1
			hudTexto.Font = Enum.Font.GothamBold
			hudTexto.TextScaled = true
			hudTexto.TextColor3 = Color3.new(1, 1, 1)
			hudTexto.TextStrokeColor3 = Color3.new(0, 0, 0)
			hudTexto.TextStrokeTransparency = 0
			hudTexto.Visible = false
			hudTexto.Parent = gui
		end
	end
	hudTexto.Text = texto or ""
	hudTexto.Visible = texto ~= nil
end

local function valorKO(modelo)
	local be = modelo and modelo:FindFirstChild("BodyEffects")
	local ko = be and be:FindFirstChild("K.O")
	if ko and ko:IsA("BoolValue") then return ko end
	return nil
end

-- El juego guarda BodyEffects.Grabbed.Value como Player en el sistema
-- de carga real (CarrySystem), pero otras variantes guardan el Model.
local function personajeDe(valor)
	if typeof(valor) ~= "Instance" then return nil end
	if valor:IsA("Player") then return valor.Character end
	if valor:IsA("Model") then return valor end
	return nil
end

-- V13.8: comprueba que ESTAS CARGANDO a ese cuerpo con cualquiera de las
-- senales reales del juego. En el juego real el cuerpo puede estar
-- Dead=true / Health=0 (es un cadaver) y el weld puede tardar en
-- replicarse, asi que ninguna de las dos cosas bloquea la deteccion.
-- El Helper ademas deja TODAS las partes del herido en Massless=true
-- mientras lo cargas y las devuelve a false al soltarlo: esa senal si
-- se ve desde el cliente y no depende de replicacion del weld.
local function senalesCarga(victima)
	local senales = {}

	local g = valorBody(char, "Grabbed")
	if personajeDe(g and g.Value) == victima then
		table.insert(senales, "Grabbed")
	end

	local vg = valorBody(victima, "Grabbed")
	local vgv = personajeDe(vg and vg.Value)
	if vgv == char then
		table.insert(senales, "Grabbed inverso")
	end

	if weldCargaEntre(char, victima) then
		table.insert(senales, "weld")
	end

	if mayoriaMassless(victima) then
		table.insert(senales, "massless")
	end

	return senales, vgv
end

-- Un cuerpo "tirado" a tus pies: K.O., muerto, PlatformStand, vida baja,
-- en estado ragdoll (FallingDown/Physics/Dead) o con el HRP anclado (el
-- ragdoll del juego ancla el HRP). El Helper suelta al herido cuando su
-- vida llega a 45, asi que vida < 45 tambien cuenta.
local function estaTirado(victima)
	local vh = victima and victima:FindFirstChildOfClass("Humanoid")
	if not vh then return false end
	local ko = valorKO(victima)
	if ko and ko.Value then return true end
	local dead = valorBody(victima, "Dead")
	if dead and dead.Value then return true end
	if vh.PlatformStand then return true end
	if vh.Health < 45 then return true end
	local ok, estado = pcall(function() return vh:GetState() end)
	if ok and (estado == Enum.HumanoidStateType.FallingDown
		or estado == Enum.HumanoidStateType.Physics
		or estado == Enum.HumanoidStateType.PlatformStanding
		or estado == Enum.HumanoidStateType.Dead
		or estado == Enum.HumanoidStateType.Ragdoll) then
		return true
	end
	local vr = victima:FindFirstChild("HumanoidRootPart")
	if vr and vr.Anchored then return true end
	return false
end

local function distanciaCarga(victima)
	local a = char and char:FindFirstChild("HumanoidRootPart")
	local b = victima and victima:FindFirstChild("HumanoidRootPart")
	if not a or not b then return math.huge end
	return (a.Position - b.Position).Magnitude
end

local function victimaCerca(victima)
	return distanciaCarga(victima) <= 16
end

-- Diagnostico completo: si la deteccion falla, se imprime en consola el
-- estado de cada cuerpo cercano para saber EXACTAMENTE que ve el juego.
local function diagnosticarCarga()
	local hrpPropio = char and char:FindFirstChild("HumanoidRootPart")
	if not hrpPropio then return end
	local g = valorBody(char, "Grabbed")
	local koPropio = valorKO(char)
	print(("[Spidey V13.9] diagnostico | mi Grabbed=%s | mi K.O=%s | tool=%s | hrp=%s"):format(
		tostring(g and g.Value),
		tostring(koPropio and koPropio.Value),
		tostring(char:FindFirstChildOfClass("Tool")),
		tostring(hrpPropio.Anchored)))
	local mostrados = 0
	local function revisar(modelo)
		if mostrados >= 8 then return end
		if not modelo or not modelo:IsA("Model") or modelo == char then return end
		local vh = modelo:FindFirstChildOfClass("Humanoid")
		local vr = modelo:FindFirstChild("HumanoidRootPart")
		if not vh or not vr then return end
		local d = (vr.Position - hrpPropio.Position).Magnitude
		if d > 40 then return end
		mostrados = mostrados + 1
		local vg = valorBody(modelo, "Grabbed")
		local w = weldCargaEntre(char, modelo)
		local okEstado, estado = pcall(function() return vh:GetState() end)
		print(("[Spidey V13.9]   %s | dist=%.1f | KO=%s Dead=%s PS=%s vida=%.1f | estado=%s | HRPanc=%s | su Grabbed=%s | union=%s(%s) | massless=%s"):format(
			modelo.Name, d,
			tostring(valorKO(modelo) and valorKO(modelo).Value),
			tostring((valorBody(modelo, "Dead") and valorBody(modelo, "Dead").Value)),
			tostring(vh.PlatformStand), vh.Health,
			tostring(okEstado and estado or "?"),
			tostring(vr.Anchored),
			tostring(vg and vg.Value),
			tostring(w and w.Name), tostring(w and w.ClassName),
			tostring(mayoriaMassless(modelo))))
	end
	for _, modelo in ipairs(workspace:GetChildren()) do
		revisar(modelo)
		if modelo:IsA("Folder") or modelo:IsA("Model") then
			for _, sub in ipairs(modelo:GetChildren()) do
				revisar(sub)
			end
		end
	end
	for _, pl in ipairs(Players:GetPlayers()) do
		revisar(pl.Character)
	end
	if mostrados == 0 then
		print("[Spidey V13.9]   ningun cuerpo con Humanoid a menos de 40 studs")
	end
end

-- V13.8: SIN deteccion de carga. El clic del tool Control posee
-- directamente el cuerpo DERRIBADO mas cercano a ti (el que tenga
-- Humanoid y HumanoidRootPart y este tirado: K.O., muerto, en ragdoll,
-- PlatformStand, HRP anclado o vida baja). Tu sabes cuando estas
-- cargando a alguien: derriba a tu amigo, agarralo de la pierna,
-- equipa Control y haz clic. Un jugador sano y de pie NUNCA se posee.
local function detectarCarga()
	if not char or not char.Parent then return nil, "sin personaje" end
	local hrpPropio = char:FindFirstChild("HumanoidRootPart")
	if not hrpPropio then return nil, "sin HumanoidRootPart" end

	local mejor, mejorDist = nil, 18
	local function probar(modelo)
		if not modelo or not modelo:IsA("Model") or modelo == char or not modelo.Parent then return end
		local vr = modelo:FindFirstChild("HumanoidRootPart")
		local vh = modelo:FindFirstChildOfClass("Humanoid")
		if not vr or not vh then return end
		if not estaTirado(modelo) then return end
		local d = (vr.Position - hrpPropio.Position).Magnitude
		if d <= mejorDist then
			mejor, mejorDist = modelo, d
		end
	end
	for _, modelo in ipairs(workspace:GetChildren()) do
		if modelo:IsA("Model") then
			probar(modelo)
		elseif modelo:IsA("Folder") then
			for _, sub in ipairs(modelo:GetChildren()) do probar(sub) end
		end
	end
	for _, pl in ipairs(Players:GetPlayers()) do
		probar(pl.Character)
	end

	if not mejor then
		return nil, "no hay ningun cuerpo derrribado cerca"
	end
	return mejor, string.format("cuerpo derrribado (%.1f studs)", mejorDist)
end

local function toolControlEnMano()
	return char and char:FindFirstChild("Control") ~= nil
end

-----------------------------------------------------------------
-- Tool CONTROL: se entrega junto con Spider. En modo servidor lo
-- crea el servidor; en modo executor/Da Hood lo crea este cliente.
-- El clic hace dos cosas: poseer y soltar.
-----------------------------------------------------------------
local function engancharControlTool(t)
	if not t or not t:IsA("Tool") or t.Name ~= "Control" then return end
	if controlTool == t then return end
	for _, c in ipairs(controlConexiones) do
		c:Disconnect()
	end
	table.clear(controlConexiones)
	controlTool = t
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = false
	t.ToolTip = "Clic: controlar / soltar el cuerpo que estas cargando"
	table.insert(controlConexiones, t.Activated:Connect(function()
		-- El clic SOLO activa la posesion. Para desposeer se usa Z,
		-- porque G suelta al herido y ya no lo estarias cargando.
		if poseyendo then
			mostrarHUD("Para desposeer usa Z (sigues cargando al herido)")
			task.delay(1.5, function()
				if poseyendo then
					mostrarHUD("CONTROLANDO: " .. tostring(poseyendoVictima and poseyendoVictima.Name) .. "   |   Z = desposeer")
				end
			end)
		elseif intentarPoseyendo then
			intentarPoseyendo()
		end
	end))
end

local function buscarControlTool()
	controlTool = nil
	for _, c in ipairs(controlConexiones) do
		c:Disconnect()
	end
	table.clear(controlConexiones)
	local lugares = {}
	if char then table.insert(lugares, char) end
	local bp = player:FindFirstChild("Backpack")
	if bp then table.insert(lugares, bp) end
	for _, lugar in ipairs(lugares) do
		for _, c in ipairs(lugar:GetChildren()) do
			if c:IsA("Tool") and c.Name == "Control" then
				engancharControlTool(c)
				return
			end
		end
	end
end

local function asegurarControlTool()
	if not sinServidor then return end
	local bp = player:FindFirstChild("Backpack")
	if not bp then return end
	if bp:FindFirstChild("Control") or (char and char:FindFirstChild("Control")) then return end
	local t = Instance.new("Tool")
	t.Name = "Control"
	t.ToolTip = "Clic: controlar / soltar el cuerpo que estas cargando"
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = false
	t.Parent = bp
end

-----------------------------------------------------------------
-- V13.9 TOOL ARRANCAR: con el herido agarrado del brazo o de la
-- pierna, un clic SEPARA esa extremidad de su cuerpo. Todos ven
-- caer la extremidad; el herido sigue siendo un cadaver y podra
-- caminar (poseido o no) ya sin ese brazo/pierna.
-----------------------------------------------------------------
local arrancarTool = nil
local arrancarConexiones = {}
local ultimoArranque = 0
local extremidadesReforzadas = {}

-- Cadenas de extremidades R15 y R6 (raiz primero, respaldo R6 al final).
local CADENAS_EXTREMIDAD = {
	{ "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg" },
	{ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg" },
	{ "RightUpperArm", "RightLowerArm", "RightHand", "Right Arm" },
	{ "LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm" },
}

local function partesDeCadena(victima, cadena)
	local partes = {}
	for _, nombre in ipairs(cadena) do
		local p = victima:FindFirstChild(nombre)
		if p and p:IsA("BasePart") then table.insert(partes, p) end
	end
	return partes
end

-- La extremidad que estoy agarrando: la mas cercana a mi torso.
local function extremidadAgarrada(victima)
	if not char or not victima or not victima.Parent then return nil, nil end
	local ref = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
	if not ref then return nil, nil end
	local mejorCadena, mejorDist = nil, math.huge
	for _, cadena in ipairs(CADENAS_EXTREMIDAD) do
		local raiz = victima:FindFirstChild(cadena[1]) or victima:FindFirstChild(cadena[4])
		if raiz and raiz:IsA("BasePart") then
			local d = (raiz.Position - ref.Position).Magnitude
			if d < mejorDist then
				mejorDist, mejorCadena = d, cadena
			end
		end
	end
	if not mejorCadena then return nil, nil end
	local partes = partesDeCadena(victima, mejorCadena)
	if #partes == 0 then return nil, nil end
	local esBrazo = string.find(mejorCadena[1], "Arm", 1, true) ~= nil
	return partes, esBrazo
end

-- TODOS los joints que unen la extremidad con el resto del cuerpo.
-- Da Hood usa AnimationConstraint (15) + welds internos de hitbox:
-- se apagan TODOS los que crucen la extremidad hacia fuera, menos
-- los welds internos de hitbox (Part0 y Part1 con el mismo nombre).
-- Los AnimationConstraint/Motor6D van primero en la lista.
local function jointsExtremidad(victima, partes)
	local enCadena = {}
	for _, p in ipairs(partes) do enCadena[p] = true end
	local lista = {}
	for _, j in ipairs(victima:GetDescendants()) do
		local ok, p0, p1 = pcall(function() return j.Part0, j.Part1 end)
		if ok and typeof(p0) == "Instance" and typeof(p1) == "Instance"
			and p0:IsA("BasePart") and p1:IsA("BasePart")
			and enCadena[p0] ~= enCadena[p1]
			and p0.Name ~= p1.Name then
			if j.ClassName == "AnimationConstraint" or j.ClassName == "Motor6D" then
				table.insert(lista, 1, j)
			else
				table.insert(lista, j)
			end
		end
	end
	return lista
end

local function soltarExtremidadFisica(partes, victima)
	local centro = nil
	local vr = victima and victima:FindFirstChild("HumanoidRootPart")
	if vr then centro = vr.Position end
	for _, p in ipairs(partes) do
		if p.Parent then
			p.CanCollide = true
			p.Massless = false
			-- Empujon hacia FUERA del cuerpo + caida: se ve desprenderse.
			local dir = Vector3.new(math.random(-6, 6), -10, math.random(-6, 6))
			if centro then
				local f = p.Position - centro
				f = Vector3.new(f.X, 0, f.Z)
				if f.Magnitude > 0.5 then dir = f.Unit * 7 + Vector3.new(0, -10, 0) end
			end
			p.AssemblyLinearVelocity = dir
			p.AssemblyAngularVelocity = Vector3.new(
				math.random(-6, 6), math.random(-6, 6), math.random(-6, 6))
		end
	end
end

local function arrancarExtremidadAhora()
	local ahora = os.clock()
	if ahora - ultimoArranque < 1 then return false end
	ultimoArranque = ahora

	-- Si estamos poseyendo, se arranca del cuerpo controlado; si no,
	-- del cuerpo derrribado que tenemos agarrado.
	local victima = poseyendo and poseyendoVictima or nil
	if not victima then
		victima = detectarCarga()
	end
	if not victima then
		mostrarHUD("Agarra a alguien del brazo o de la pierna primero")
		task.delay(1.6, function()
			if not poseyendo then mostrarHUD(nil) end
		end)
		return false
	end

	local partes, esBrazo = extremidadAgarrada(victima)
	if not partes then
		mostrarHUD("No encuentro el brazo/pierna agarrado")
		task.delay(1.6, function()
			if not poseyendo then mostrarHUD(nil) end
		end)
		return false
	end
	local joints = jointsExtremidad(victima, partes)
	if #joints == 0 then
		mostrarHUD("Ese cuerpo no tiene articulacion en la extremidad")
		return false
	end

	local nombreExt = esBrazo and "BRAZO" or "PIERNA"
	local nombreVict = victima.Name

	-- Local (inmediato): mientras cargas al herido, el Helper te dio
	-- la propiedad de red de sus partes. DESTRUYENDO los joints aqui,
	-- la extremidad queda suelta en la fisica que TU simulas y su
	-- caida se replica: TODOS la ven desprenderse y caer (igual que
	-- la vez que el clic arranco la pierna en Da Hood real).
	-- OJO: en Da Hood el rig usa AnimationConstraint: apagar Enabled
	-- SOLO quita la animacion, NO separa la union fisica. Hay que
	-- destruir el joint para que la extremidad caera de verdad.
	for _, j in ipairs(joints) do
		pcall(function() j:Destroy() end)
	end
	soltarExtremidadFisica(partes, victima)
	table.insert(extremidadesReforzadas, { js = joints, p = partes, t = os.clock() })

	if not sinServidor then
		-- Modo servidor: ademas se destruye de verdad (permanente).
		RE_Cuerpo:FireServer("RASGAR", victima)
	end
	print("[Spidey V13.9] " .. nombreExt .. " separado de " .. nombreVict)

	mostrarHUD(nombreExt .. " ARRANCADO a " .. nombreVict)
	task.delay(2.2, function()
		if not poseyendo then mostrarHUD(nil) end
	end)
	return true
end

-- Refuerzo: mantiene la extremidad separada unos segundos aunque el
-- servidor intente re-simularla al recuperar la propiedad de red.
task.spawn(function()
	while true do
		local ahora = os.clock()
		for i = #extremidadesReforzadas, 1, -1 do
			local it = extremidadesReforzadas[i]
			local vivos = 0
			for _, j in ipairs(it.js or {}) do
				if j.Parent then vivos = vivos + 1 end
			end
			if vivos == 0 then
				table.remove(extremidadesReforzadas, i)
			elseif ahora - it.t < 30 then
				-- Si el juego RECREA el joint (CheckingKOED puede
				-- recrear joints), se vuelve a destruir para que la
				-- extremidad siga suelta.
				for _, j in ipairs(it.js or {}) do
					if j.Parent then
						pcall(function() j:Destroy() end)
					end
				end
				for _, p in ipairs(it.p) do
					if p.Parent and not p.Anchored and p.AssemblyLinearVelocity.Magnitude < 1 then
						p.AssemblyLinearVelocity = Vector3.new(0, -4, 0)
					end
				end
			else
				table.remove(extremidadesReforzadas, i)
			end
		end
		task.wait(0.4)
	end
end)

local function engancharArrancarTool(t)
	if not t or not t:IsA("Tool") or t.Name ~= "Arrancar" then return end
	if arrancarTool == t then return end
	for _, c in ipairs(arrancarConexiones) do c:Disconnect() end
	table.clear(arrancarConexiones)
	arrancarTool = t
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = false
	t.ToolTip = "Clic: arrancar el brazo/pierna que estas agarrando"
	table.insert(arrancarConexiones, t.Activated:Connect(function()
		arrancarExtremidadAhora()
	end))
end

local function buscarArrancarTool()
	arrancarTool = nil
	for _, c in ipairs(arrancarConexiones) do c:Disconnect() end
	table.clear(arrancarConexiones)
	local lugares = {}
	if char then table.insert(lugares, char) end
	local bp = player:FindFirstChild("Backpack")
	if bp then table.insert(lugares, bp) end
	for _, lugar in ipairs(lugares) do
		for _, c in ipairs(lugar:GetChildren()) do
			if c:IsA("Tool") and c.Name == "Arrancar" then
				engancharArrancarTool(c)
				return
			end
		end
	end
end

local function asegurarArrancarTool()
	if not sinServidor then return end
	local bp = player:FindFirstChild("Backpack")
	if not bp then return end
	if bp:FindFirstChild("Arrancar") or (char and char:FindFirstChild("Arrancar")) then return end
	local t = Instance.new("Tool")
	t.Name = "Arrancar"
	t.ToolTip = "Clic: arrancar el brazo/pierna que estas agarrando"
	t.RequiresHandle = false
	t.CanBeDropped = false
	t.ManualActivationOnly = false
	t.Parent = bp
end

task.spawn(function()
	while true do
		asegurarControlTool()
		buscarControlTool()
		asegurarArrancarTool()
		buscarArrancarTool()
		task.wait(0.5)
	end
end)
-----------------------------------------------------------------
-- ESP (J): contorno blanco + nombre del usuario encima.
-- Highlight con AlwaysOnTop = se ve a traves de las paredes.
-- El texto es un poco mas pequeno que en V11 (200x28 en vez de 220x34).
-----------------------------------------------------------------
local function quitarESP()
	for _, datos in pairs(espDatos) do
		if datos.hl then datos.hl:Destroy() end
		if datos.bb then datos.bb:Destroy() end
	end
	table.clear(espDatos)
end

local function crearESPVisual(modelo, nombre)
	if not modelo or not modelo.Parent then return nil end
	local hl = Instance.new("Highlight")
	hl.Name = "SpideyESP"
	hl.FillTransparency = 1
	hl.OutlineColor = Color3.new(1, 1, 1)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = modelo
	hl.Parent = modelo

	local ancla = modelo:FindFirstChild("Head") or modelo:FindFirstChild("HumanoidRootPart") or modelo:FindFirstChildOfClass("BasePart")
	if not ancla then
		hl:Destroy()
		return nil
	end
	local bb = Instance.new("BillboardGui")
	bb.Name = "SpideyESP_Nombre"
	bb.Size = UDim2.fromOffset(200, 28)
	bb.StudsOffset = Vector3.new(0, 2.9, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 5000
	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1
	txt.Size = UDim2.fromScale(1, 1)
	txt.Font = Enum.Font.GothamBold
	txt.TextScaled = true
	txt.TextColor3 = Color3.new(1, 1, 1)
	txt.TextStrokeColor3 = Color3.new(0, 0, 0)
	txt.TextStrokeTransparency = 0
	txt.Text = nombre
	txt.Parent = bb
	bb.Adornee = ancla
	bb.Parent = ancla
	return { hl = hl, bb = bb, modelo = modelo }
end

local function aplicarESPPJugador(p)
	if not espActivo or p == player then return end
	local c = p.Character
	if not c then return end
	-- Si estas cargando a esta persona, su cuerpo real esta oculto:
	-- el ESP se le pondria en el sitio equivocado. Se le devuelve al soltar.
	if poseyendo and poseyendoVictima == c then return end
	local datos = espDatos[p]
	if datos and datos.modelo == c and datos.hl and datos.hl.Parent then return end
	if datos then
		if datos.hl then datos.hl:Destroy() end
		if datos.bb then datos.bb:Destroy() end
		espDatos[p] = nil
	end
	local creado = crearESPVisual(c, p.Name)
	if creado then espDatos[p] = creado end
end

local function ocultarESPDe(jugador)
	local datos = jugador and espDatos[jugador]
	if not datos then return nil end
	if datos.hl then datos.hl.Enabled = false end
	if datos.bb then datos.bb.Enabled = false end
	return datos
end

local function restaurarESPDe(jugador, datos)
	if not datos then return end
	if datos.hl and datos.hl.Parent then datos.hl.Enabled = true end
	if datos.bb and datos.bb.Parent then datos.bb.Enabled = true end
end

function V11.AlternarESP()
	espActivo = not espActivo
	quitarESP()
	if espActivo then
		for _, p in ipairs(Players:GetPlayers()) do
			aplicarESPPJugador(p)
		end
		print("[Spidey V13.9] ESP ACTIVADO: contorno blanco + nombres (atraviesa paredes)")
		mostrarHUD("ESP ACTIVADO (J para apagar)")
	else
		print("[Spidey V13.9] ESP DESACTIVADO")
		mostrarHUD("ESP DESACTIVADO")
	end
	task.delay(2, function()
		if not poseyendo then mostrarHUD(nil) end
	end)
	return espActivo
end

-- Solo para pruebas: aplica el ESP a tu propio personaje.
function V11.ESPPrueba()
	local datos = espDatos["prueba"]
	if datos then
		if datos.hl then datos.hl:Destroy() end
		if datos.bb then datos.bb:Destroy() end
		espDatos["prueba"] = nil
		return false
	end
	if char then
		local creado = crearESPVisual(char, player.Name .. " (test)")
		if creado then espDatos["prueba"] = creado end
	end
	return true
end

local function conectarESPJugador(p)
	if p == player then return end
	p.CharacterAdded:Connect(function()
		if not espActivo then return end
		task.wait(0.4)
		aplicarESPPJugador(p)
	end)
	if espActivo then
		aplicarESPPJugador(p)
	end
end
for _, p in ipairs(Players:GetPlayers()) do
	conectarESPJugador(p)
end
Players.PlayerAdded:Connect(conectarESPJugador)
Players.PlayerRemoving:Connect(function(p)
	local datos = espDatos[p]
	if datos then
		if datos.hl then datos.hl:Destroy() end
		if datos.bb then datos.bb:Destroy() end
		espDatos[p] = nil
	end
end)

-----------------------------------------------------------------
-- V11.7 Â· LOCK (Q): contorno y linea EN CUALQUIER JUEGO.
-- Pones el mouse sobre una persona, pulsas Q y:
--   * se le pone un contorno blanco a ella y a ti;
--   * una linea blanca une a los dos (dice donde esta);
--   * tu camara no se mueve, pero tu personaje gira hacia el;
--   * Q otra vez lo quita, este el mouse encima o no.
-- ESTO FUNCIONA EN DA HOOD Y EN CUALQUIER JUEGO: los visuales
-- son de tu propia pantalla (Highlight + Beam locales).
-- El APUNTADO de las balas (que lleguen aunque dispares al piso)
-- solo funciona en TU juego siendo el dueÃ±o: el servidor dirige
-- BodyEffects.MousePos. En un juego ajeno no hay tal servidor.
-----------------------------------------------------------------
local PROPIETARIOS_NOMBRES = { ["jlozadac"] = true }
local PROPIETARIOS_IDS = {}
local MAX_LOCK = 600
local GIRAR_PERSONAJE_LOCK = true

local function esPropietarioLock(pl)
	if not pl then return false end
	if PROPIETARIOS_NOMBRES[pl.Name] or PROPIETARIOS_IDS[pl.UserId] then return true end
	if game.CreatorType == Enum.CreatorType.User and game.CreatorId ~= 0 and pl.UserId == game.CreatorId then
		return true
	end
	if game.CreatorType == Enum.CreatorType.Group and game.CreatorId ~= 0 then
		local ok, rango = pcall(function()
			return pl:GetRankInGroup(game.CreatorId)
		end)
		if ok and rango >= 250 then return true end
	end
	return false
end

local esDuenoLock = esPropietarioLock(player)
local bloqueado = nil
local hlYoLock, hlElLock, lineaBeam, atYoLock, atElLock

local function quitarVisualLock()
	local b = bloqueado
	bloqueado = nil
	if b and b.conexApuntado then
		for _, c in ipairs(b.conexApuntado) do
			if c and c.Disconnect then c:Disconnect() end
		end
	end
	if hlYoLock then hlYoLock:Destroy(); hlYoLock = nil end
	if hlElLock then hlElLock:Destroy(); hlElLock = nil end
	if lineaBeam then lineaBeam:Destroy(); lineaBeam = nil end
	if atYoLock then atYoLock:Destroy(); atYoLock = nil end
	if atElLock then atElLock:Destroy(); atElLock = nil end
	if b and b.char == char and hum and b.autoRotate ~= nil then
		hum.AutoRotate = b.autoRotate
	end
end

local function crearHighlightLock(modelo)
	if not modelo or not modelo.Parent then return nil end
	local hl = Instance.new("Highlight")
	hl.Name = "SpideyLock"
	hl.FillTransparency = 1
	hl.OutlineColor = Color3.new(1, 1, 1)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = modelo
	hl.Parent = modelo
	return hl
end

local function crearLineaLock(modelo, c)
	if not c or not c.Parent or not modelo or not modelo.Parent then return nil end
	local a = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
	local b = modelo:FindFirstChild("Head") or modelo:FindFirstChild("HumanoidRootPart")
	if not a or not b then return nil end
	local at1 = Instance.new("Attachment")
	at1.Name = "SpideyLockYo"
	at1.Parent = a
	local at2 = Instance.new("Attachment")
	at2.Name = "SpideyLockEl"
	at2.Parent = b
	local beam = Instance.new("Beam")
	beam.Name = "SpideyLockLinea"
	beam.Attachment0 = at1
	beam.Attachment1 = at2
	beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
	beam.Transparency = NumberSequence.new(0.12)
	beam.Width0 = 0.08
	beam.Width1 = 0.08
	beam.FaceCamera = true
	beam.LightEmission = 0.7
	beam.Segments = 1
	beam.Parent = workspace
	return beam, at1, at2
end

-- Punto al que apuntar: CABEZA primero; con ESCOPETA, TORSO (objetivo
-- grande: la dispersion del juego reparte perdigones y casi todos
-- impactan). Cae a otras partes si la primera no existe.
local function esArmaEscopetaCliente()
	if not char then return false end
	local t = char:FindFirstChildOfClass("Tool")
	if not t then return false end
	local n = string.lower(t.Name)
	return string.find(n, "shotgun", 1, true) ~= nil
		or string.find(n, "double-barrel", 1, true) ~= nil
		or string.find(n, "escopeta", 1, true) ~= nil
end

local function puntoLockCliente(modelo)
	if not modelo or not modelo.Parent then return nil end
	local p
	if esArmaEscopetaCliente() then
		p = modelo:FindFirstChild("UpperTorso")
			or modelo:FindFirstChild("Torso")
			or modelo:FindFirstChild("HumanoidRootPart")
			or modelo:FindFirstChild("Head")
	else
		p = modelo:FindFirstChild("Head")
			or modelo:FindFirstChild("UpperTorso")
			or modelo:FindFirstChild("Torso")
			or modelo:FindFirstChild("HumanoidRootPart")
	end
	return p and p.Position or nil
end

-- ARMAS NUEVAS DE DA HOOD (Revolver, TacticalShotgun, Double-Barrel SG):
-- disparan en TU CLIENTE y calculan la direccion con
-- GunHandler.getAim(), que usa Mouse.Hit.p (el mouse real). NO usan
-- BodyEffects.MousePos, asi que el remoto de mas abajo no las toca.
-- El modulo se comparte por cache entre todos los LocalScripts del
-- cliente: si reemplazamos su getAim, las armas nuevas piden la
-- direccion a NUESTRA funcion. Con lock devuelve la CABEZA (o el
-- TORSO si hay escopeta); sin lock llama al original y todo queda
-- igual. Funciona en Studio y en el ejecutor, sin APIs especiales.
local gunHandlerParcheado = false
local gunHandlerParcheando = false
local function parchearGunHandler()
	-- Evita que dos hilos lo envuelvan a la vez (doble parche).
	if gunHandlerParcheado or gunHandlerParcheando then return true end
	gunHandlerParcheando = true
	local mods = RS:FindFirstChild("Modules")
	local gh = mods and mods:FindFirstChild("GunHandler")
	if not gh or not gh:IsA("ModuleScript") then
		-- Por si el juego lo movio de sitio: buscar por nombre en RS.
		for _, d in ipairs(RS:GetDescendants()) do
			if d:IsA("ModuleScript") and d.Name == "GunHandler" then
				gh = d
				break
			end
		end
	end
	if not gh then
		gunHandlerParcheando = false
		return false
	end
	local ok, modulo = pcall(require, gh)
	if not ok or type(modulo) ~= "table" then
		gunHandlerParcheando = false
		return false
	end
	local original = modulo.getAim
	if type(original) ~= "function" then
		gunHandlerParcheando = false
		return false
	end
	modulo.getAim = function(origen)
		local b = bloqueado
		if b and origen then
			local pos = puntoLockCliente(b.modelo)
			if pos then
				local dir = pos - origen
				if dir.Magnitude > 0.001 then
					return dir.Unit
				end
			end
		end
		return original(origen)
	end
	gunHandlerParcheado = true
	gunHandlerParcheando = false
	print("[Spidey V13.9] armas nuevas (Revolver/escopetas): getAim dirigido al lock")
	return true
end
-- El require de un modulo del juego puede CEDER (esperando el
-- personaje, animaciones, etc.). Por eso se lanza en un hilo aparte:
-- si el juego tarda, el lock y el resto del script siguen funcionando.
task.spawn(parchearGunHandler)
task.spawn(function()
	-- Si el juego carga el modulo mas tarde, reintentar sin romper nada.
	for _ = 1, 20 do
		if gunHandlerParcheado then return end
		task.wait(0.5)
		parchearGunHandler()
	end
end)

-- Remoto del sistema de armas de Da Hood (si el juego lo usa).
-- Es el MISMO remoto que el juego usa para decirle al servidor
-- donde apunta el mouse; el servidor lo copia sin validar.
local function resolverRemotoDH()
	local mr = RS:FindFirstChild("MainRemotes")
	local directo = mr and mr:FindFirstChild("MainRemoteEvent")
	if directo and directo:IsA("RemoteEvent") then return directo end
	-- Algunos clones mueven el remoto: buscarlo por nombre en RS.
	for _, d in ipairs(RS:GetDescendants()) do
		if d:IsA("RemoteEvent") and d.Name == "MainRemoteEvent" then
			return d
		end
	end
	return nil
end

local function modeloBajoMouseLock()
	if not mouse then return nil end
	local t = mouse.Target
	if not t then return nil end
	local atual = t
	while atual and atual ~= workspace do
		if atual:IsA("Model") then
			local h = atual:FindFirstChildOfClass("Humanoid")
			local r = atual:FindFirstChild("HumanoidRootPart")
			if h and r and atual ~= char and h.Health > 0 then
				return atual
			end
		end
		atual = atual.Parent
	end
	return nil
end

local function desbloquearLock(avisar)
	if not sinServidor and avisar then RE_Lock:FireServer("CLEAR") end
	if not bloqueado then return false end
	quitarVisualLock()
	mostrarHUD(nil)
	return true
end

local function bloquearModeloLock(modelo)
	if not modelo or modelo == char or not modelo.Parent then return false end
	local h = modelo:FindFirstChildOfClass("Humanoid")
	local r = modelo:FindFirstChild("HumanoidRootPart")
	if not h or not r or h.Health <= 0 or not hrp or not hrp.Parent then return false end
	if (r.Position - hrp.Position).Magnitude > MAX_LOCK then
		mostrarHUD("LOCK: objetivo demasiado lejos")
		task.delay(1.5, function()
			if not bloqueado then mostrarHUD(nil) end
		end)
		return false
	end

	desbloquearLock(true)
	bloqueado = { modelo = modelo, char = char, autoRotate = hum and hum.AutoRotate }
	local b = bloqueado
	-- Visuales SIEMPRE, en cualquier juego (Da Hood incluido):
	-- Highlight y Beam creados en TU cliente; nadie mas los ve.
	hlElLock = crearHighlightLock(modelo)
	hlYoLock = crearHighlightLock(char)
	lineaBeam, atYoLock, atElLock = crearLineaLock(modelo, char)
	if hum then hum.AutoRotate = false end

	-- APUNTADO CAMINO 1: TU juego siendo dueÃ±o -> nuestro servidor
	-- fija BodyEffects.MousePos en cada frame (RE_Lock).
	local puedeApuntar = (not sinServidor) and esDuenoLock
	if puedeApuntar then
		RE_Lock:FireServer("SET", modelo)
	end

	-- APUNTADO CAMINO 2: Da Hood y juegos con sus mismas armas.
	-- El propio juego deja que el CLIENTE le diga donde apunta:
	-- en un Heartbeat manda MainRemoteEvent("DEAHOODMOUSEPOSx3^3",
	-- Mouse.Hit.p) y el servidor lo copia a MousePos SIN validar
	-- (comprobado en el Helper del juego). Mientras lockeamos,
	-- mandamos nosotros ese MISMO remoto con la CABEZA del objetivo
	-- (o el TORSO si hay escopeta equipada).
	-- Nuestra conexion al Heartbeat se crea DESPUES que la del
	-- juego, asi que nuestro valor es el ULTIMO en escribirse en
	-- cada frame. Ademas mandamos uno diferido: si el juego usa
	-- task.defer, el nuestro queda aun mas atras y gana igual.
	b.enviarApuntado = nil
	b.conexApuntado = nil
	if sinServidor then
		local remotoDH = resolverRemotoDH()
		if remotoDH then
			local function enviar()
				local pos = puntoLockCliente(b.modelo)
				if pos then
					pcall(function()
						remotoDH:FireServer("DEAHOODMOUSEPOSx3^3", pos)
					end)
				end
			end
			b.enviarApuntado = enviar
			local function enviarSiSigue()
				if bloqueado == b then enviar() end
			end
			b.conexApuntado = {
				RunService.RenderStepped:Connect(enviarSiSigue),
				RunService.Heartbeat:Connect(function()
					enviarSiSigue()
					-- Ultimo paquete del frame: le gana incluso a un
					-- envio diferido (task.defer) del propio juego.
					task.defer(enviarSiSigue)
				end),
			}
			enviar()
		end
	end

	local nombre = modelo.Name
	local p = Players:GetPlayerFromCharacter(modelo)
	if p then nombre = p.Name end
	if not gunHandlerParcheado then task.spawn(parchearGunHandler) end
	if puedeApuntar or b.enviarApuntado or gunHandlerParcheado then
		mostrarHUD("LOCK: " .. nombre .. "   |   Q = quitar")
	else
		mostrarHUD("LOCK: " .. nombre .. " (aqui solo visual)   |   Q = quitar")
	end
	local modo = "solo visual"
	if puedeApuntar then
		modo = "apuntado servidor"
	elseif b.enviarApuntado and gunHandlerParcheado then
		modo = "apuntado remoto + armas nuevas"
	elseif gunHandlerParcheado then
		modo = "apuntado armas nuevas"
	elseif b.enviarApuntado then
		modo = "apuntado remoto"
	end
	print("[Spidey V13.9] lock: " .. nombre .. " (" .. modo .. ")")
	return true
end

function V11.AlternarLock()
	if bloqueado then
		desbloquearLock(true)
		return false
	end
	local m = modeloBajoMouseLock()
	if not m then
		mostrarHUD("LOCK: pon el mouse sobre una persona")
		task.delay(1.5, function()
			if not bloqueado then mostrarHUD(nil) end
		end)
		return false
	end
	return bloquearModeloLock(m)
end

-- Para probar sin mover el mouse: lockea el modelo con Humanoid mas
-- cercano. Se usa con el atributo SpideyTest = "LOCK".
function V11.LockearCercano()
	if bloqueado then return false end
	local mejor, dist = nil, math.huge
	local p0 = hrp and hrp.Position or Vector3.zero
	for _, m in ipairs(workspace:GetChildren()) do
		if m ~= char and m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChildOfClass("Humanoid") then
			local d = (m.HumanoidRootPart.Position - p0).Magnitude
			if d <= MAX_LOCK and d < dist then
				mejor, dist = m, d
			end
		end
	end
	if not mejor then return false end
	return bloquearModeloLock(mejor)
end

function V11.QuitarLock()
	return desbloquearLock(true)
end

if not sinServidor then
	RE_Lock.OnClientEvent:Connect(function(accion)
		if accion == "OFF" then
			quitarVisualLock()
			mostrarHUD(nil)
		end
	end)
end

-- Validez + giro del personaje. La camara NO se toca: solo se gira el
-- HumanoidRootPart en tercera persona. En primera persona no se gira
-- para no moverte la vista.
RunService.RenderStepped:Connect(function()
	local b = bloqueado
	if not b then return end
	local m = b.modelo
	if not m or not m.Parent or not char or not char.Parent or not hrp or not hrp.Parent or player.Character ~= b.char then
		desbloquearLock(true)
		return
	end
	local h = m:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then
		desbloquearLock(true)
		return
	end
	local p = Players:GetPlayerFromCharacter(m)
	if p and p.Character ~= m then
		desbloquearLock(true)
		return
	end
	if hum and hum.Health <= 0 then
		desbloquearLock(true)
		return
	end
	if GIRAR_PERSONAJE_LOCK and not poseyendo
		and player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
		local r = m:FindFirstChild("HumanoidRootPart")
		if r then
			local d = Vector3.new(r.Position.X - hrp.Position.X, 0, r.Position.Z - hrp.Position.Z)
			if d.Magnitude > 0.25 then
				if hum and hum.AutoRotate then hum.AutoRotate = false end
				local actual = hrp.CFrame
				local mirar = CFrame.lookAt(Vector3.zero, d.Unit)
				hrp.CFrame = CFrame.new(actual.Position) * (mirar - mirar.Position)
			end
		end
	end
	-- Reflejo LOCAL del MousePos. Las armas viejas lo leen en el
	-- servidor (eso lo cubre el remoto), pero si algun juego lo lee en
	-- tu cliente, tenerlo aqui tambien ayuda. Solo en modo ajeno.
	if sinServidor then
		local be = b.char and b.char:FindFirstChild("BodyEffects")
		local mp = be and be:FindFirstChild("MousePos")
		if mp and mp:IsA("Vector3Value") then
			local pos = puntoLockCliente(m)
			if pos and (mp.Value - pos).Magnitude > 0.01 then
				mp.Value = pos
			end
		end
	end
end)

-----------------------------------------------------------------
-- V13.8 · CONTROL REAL: entradas, camara y limpieza del cliente
-- Con servidor: el servidor mueve el cuerpo real y anima. Este
-- cliente solo manda WASD, pone la camara y muestra el HUD.
-- Sin servidor: intento local directo (menos fiable, solo util si
-- tu cliente tiene propiedad de red del cuerpo).
-----------------------------------------------------------------
local ultimoEnvioPose = 0

local function vectorMovimiento()
	-- Solo para pruebas automaticas: permite forzar direccion sin
	-- teclado fisico. En el juego normal se usan WASD.
	local dbg = player:GetAttribute("SpideyTestMove")
	if typeof(dbg) == "Vector3" then
		local v = Vector3.new(dbg.X, 0, dbg.Z)
		if v.Magnitude > 1 then v = v.Unit end
		return v
	end
	local cam = workspace.CurrentCamera
	if not cam then return Vector3.zero end
	local f = cam.CFrame.LookVector
	local r = cam.CFrame.RightVector
	f = Vector3.new(f.X, 0, f.Z)
	r = Vector3.new(r.X, 0, r.Z)
	if f.Magnitude < 0.01 then f = Vector3.new(0, 0, -1) else f = f.Unit end
	if r.Magnitude < 0.01 then r = Vector3.new(1, 0, 0) else r = r.Unit end
	local adelante = (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
	local lado = (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
	local v = f * adelante + r * lado
	if v.Magnitude > 1 then v = v.Unit end
	return v
end

local function animatorDe(hum)
	local a = hum and hum:FindFirstChildOfClass("Animator")
	if not a and hum then
		a = Instance.new("Animator")
		a.Parent = hum
	end
	return a
end

local function normalizarIdAnimacion(valor)
	if type(valor) ~= "string" then return nil end
	return string.match(valor, "^rbxassetid://(%d+)$")
		or string.match(valor, "id=(%d+)")
		or string.match(valor, "^(%d+)$")
end

local function idsDeAnimate(victima, nombre)
	local ids = {}
	local animate = victima:FindFirstChild("Animate")
	local seccion = animate and animate:FindFirstChild(nombre)
	if seccion then
		for _, a in ipairs(seccion:GetChildren()) do
			if a:IsA("Animation") then
				local id = normalizarIdAnimacion(a.AnimationId)
				if id then table.insert(ids, id) end
			end
		end
	end
	return ids
end

local function idsRespaldo(rig, nombre)
	if rig == Enum.HumanoidRigType.R6 then
		if nombre == "idle" then return { "180435571" } end
		if nombre == "walk" then return { "180426354" } end
		if nombre == "run" then return { "180426354" } end
		if nombre == "jump" then return { "125750702" } end
		if nombre == "fall" then return { "180436148" } end
		return { "180426354" }
	end
	if nombre == "idle" then return { "507766666" } end
	if nombre == "walk" then return { "507777826" } end
	if nombre == "run" then return { "507767714" } end
	if nombre == "jump" then return { "507765000" } end
	if nombre == "fall" then return { "507770583" } end
	return { "507777826" }
end

local function cargarTrackPoseyendo(animator, victima, nombre)
	local vh = victima:FindFirstChildOfClass("Humanoid")
	if not vh then return nil end

	local function intentar(ids, esPropia)
		local primero = nil
		for _, id in ipairs(ids) do
			local a = Instance.new("Animation")
			a.Name = "SpideyPose_" .. nombre
			a.AnimationId = "rbxassetid://" .. id
			local ok, tr = pcall(function()
				return animator:LoadAnimation(a)
			end)
			if ok and tr then
				if not primero then primero = tr end
				tr.Looped = (nombre ~= "jump")
				tr.Priority = (nombre == "idle") and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Movement
				tr:Play(0.1)
				if esPropia then return tr end
				task.wait(0.2)
				if tr.Length > 0.01 then return tr end
				pcall(function() tr:Stop(0) end)
			end
		end
		return nil, primero
	end

	local propias = idsDeAnimate(victima, nombre)
	if #propias > 0 then
		local tr = intentar(propias, true)
		if tr then return tr end
	end

	local trRespaldo, primeroRespaldo = intentar(idsRespaldo(vh.RigType, nombre), false)
	if trRespaldo then return trRespaldo end
	return primeroRespaldo
end

local function detenerTracksPoseyendo(animator)
	for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
		pcall(function() tr:Stop(0.12) end)
	end
end

-- Declaracion adelantada: arrancarPoseyendoLocal la llama antes de que
-- exista la definicion de abajo. Sin esto, en modo sin servidor el
-- primer clic detectaba la carga pero fallaba con "nil value".
local seguirBajoMapa

arrancarPoseyendoLocal = function(victima, remoto)
	if poseyendo or not victima or not victima.Parent or poseyendoVictima then return false end
	local vh = victima:FindFirstChildOfClass("Humanoid")
	local vr = victima:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not vh or not vr or not cam then return false end
	-- NO se rechaza por Dead/Health: el herido que cargas puede ser un
	-- cadaver (Dead=true o Health=0) y aun asi controlarse.

	local datos = {
		victima = victima,
		victimaHum = vh,
		victimaHRP = vr,
		animActual = nil,
		remoto = remoto == true,
		inicioPose = os.clock(),
		moviendoSoloDesde = nil,
	}

	if not datos.remoto then
		local dead = victima:FindFirstChild("BodyEffects") and victima.BodyEffects:FindFirstChild("Dead")
		local ko = valorKO(victima)
		datos.victimaDead = dead and dead.Value or false
		datos.victimaKO = ko and ko.Value or false
		datos.victimaPlatform = vh.PlatformStand
		datos.victimaAuto = vh.AutoRotate
		datos.victimaWalk = vh.WalkSpeed
		datos.victimaJump = vh.JumpPower
		datos.victimaUse = vh.UseJumpPower
		datos.victimaHRPAnclado = vr.Anchored
		local animate = victima:FindFirstChild("Animate")
		datos.victimaAnimate = animate
		datos.victimaAnimateEnabled = animate and animate.Enabled or false
		datos.victimaStartCF = vr.CFrame
		datos.victimaOffset = Vector3.zero
		datos.ultimoUpdate = os.clock()
		datos.partes = {}
		for _, p in ipairs(victima:GetDescendants()) do
			if p:IsA("BasePart") then
				table.insert(datos.partes, { p = p, m = p.Massless })
			elseif p:IsA("BallSocketConstraint") then
				table.insert(datos, { socket = p, e = p.Enabled })
			elseif p:IsA("NoCollisionConstraint") and p.Name == "NoCollisionConstraint_HOLD" then
				table.insert(datos, { ncs = p, e = p.Enabled })
			end
		end
		local cw = weldCargaEntre(char, victima)
		if cw then
			datos.carry = { c = cw, e = cw.Enabled, p0 = cw.Part0, p1 = cw.Part1 }
			if cw:IsA("Weld") then
				datos.carry.c0 = cw.C0
				datos.carry.c1 = cw.C1
				-- V13.9 WELD-RIDE: relacion fija HRP->torso para ubicar
				-- el cuerpo original donde el weld del juego lo exige.
				if hrp and cw.Part0 and cw.Part0:IsDescendantOf(char) then
					datos.carry.rel = hrp.CFrame:Inverse() * cw.Part0.CFrame
				end
			end
		end
	end

	datos.propio = {
		hrp = hrp,
		hum = hum,
		anclado = hrp and hrp.Anchored,
		cframe = hrp and hrp.CFrame,
		walk = hum and hum.WalkSpeed,
		jump = hum and hum.JumpPower,
		use = hum and hum.UseJumpPower,
		platform = hum and hum.PlatformStand,
		auto = hum and hum.AutoRotate,
		camSubject = cam.CameraSubject,
		camType = cam.CameraType,
		partes = {},
	}
	do
		local c = char
		if c then
			for _, p in ipairs(c:GetDescendants()) do
				if p:IsA("BasePart") then
					table.insert(datos.propio.partes, { p = p, cc = p.CanCollide })
				end
			end
		end
	end

	if not datos.remoto then
		local cw = datos.carry and datos.carry.c
		if cw then
			-- Solo se desactiva. Part0/Part1 se conservan para que
			-- detectarCarga siga viendo la carga y para restaurar.
			cw.Enabled = false
		end
		for _, item in ipairs(datos) do
			if item.socket then item.socket.Enabled = false end
			if item.ncs then item.ncs.Enabled = false end
		end
		-- V13.8: ya NO se pone Massless=false durante la posesion: el
		-- juego lo deja en true mientras cargas al herido y esa senal
		-- sirve para saber si la carga sigue activa.

		if datos.victimaAnimate and datos.victimaAnimate.Parent then
			datos.victimaAnimate.Enabled = false
		end

		-- V13.9 (probado en Studio servidor+cliente): el Humanoid del
		-- herido se pone en estado Physics y se le apagan los estados
		-- que pelean. Si queda en PlatformStanding, su control interno
		-- "ancla" el cuerpo en el sitio y combate el movimiento.
		vh.PlatformStand = false
		vh.AutoRotate = false
		vh.WalkSpeed = 0
		vh.JumpPower = 0
		vh.UseJumpPower = true
		vr.Anchored = false
		pcall(function() vh:ChangeState(Enum.HumanoidStateType.Physics) end)
		datos.estadosApagados = {}
		for _, st in ipairs({
			Enum.HumanoidStateType.PlatformStanding,
			Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.GettingUp,
			Enum.HumanoidStateType.Running,
			Enum.HumanoidStateType.RunningNoPhysics,
			Enum.HumanoidStateType.Seated,
			Enum.HumanoidStateType.Climbing,
		}) do
			table.insert(datos.estadosApagados, st)
			pcall(function() vh:SetStateEnabled(st, false) end)
		end

		-- Altura de pie: al enderezarse (levantada), el HRP sube a la
		-- altura de cadera sobre el piso.
		do
			local rp = RaycastParams.new()
			rp.FilterType = Enum.RaycastFilterType.Exclude
			rp.FilterDescendantsInstances = { victima, char }
			local org = vr.Position
			local hit = workspace:Raycast(org, Vector3.new(0, -10, 0), rp)
			local suelo = hit and hit.Position.Y or (org.Y - 1)
			datos.victimaPisoY = suelo + vh.HipHeight + vr.Size.Y / 2 + 0.1
			if datos.victimaPisoY < org.Y - 0.5 then
				datos.victimaPisoY = org.Y
			end
		end
		datos.victimaVy = 0
		datos.victimaAltura = 0

		local animator = animatorDe(vh)
		detenerTracksPoseyendo(animator)
		datos.trackIdle = cargarTrackPoseyendo(animator, victima, "idle")
		datos.trackWalk = cargarTrackPoseyendo(animator, victima, "walk")
		datos.trackRun = cargarTrackPoseyendo(animator, victima, "run")
		datos.trackJump = cargarTrackPoseyendo(animator, victima, "jump")
		datos.trackFall = cargarTrackPoseyendo(animator, victima, "fall")
		detenerTracksPoseyendo(animator)
		datos.animator = animator
		if datos.trackIdle then datos.trackIdle:Play(0.15) datos.animActual = "idle" end
	end

	poseyendoDatos = datos
	poseyendoVictima = victima
	poseyendo = true

	local nombre = victima.Name
	mostrarHUD("CONTROLANDO: " .. nombre .. "   |   Z = desposeer (sigues cargando)")
	print("[Spidey V13.9] controlando cuerpo real: " .. nombre .. " | Z = desposeer")
	if not datos.remoto then
		seguirBajoMapa()
	end
	return true
end

local function actualizarAnimacionPoseyendo(vector)
	local d = poseyendoDatos
	if not d or d.remoto or not d.animator then return end
	local moviendo = vector.Magnitude > 0.05
	local corriendo = moviendo and (
		UIS:IsKeyDown(Enum.KeyCode.LeftShift)
		or UIS:IsKeyDown(Enum.KeyCode.RightShift)
	)
	local saltando = UIS:IsKeyDown(Enum.KeyCode.Space)

	local objetivo = "idle"
	if saltando and d.trackJump then
		objetivo = "jump"
	elseif moviendo and corriendo and d.trackRun then
		objetivo = "run"
	elseif moviendo and d.trackWalk then
		objetivo = "walk"
	elseif moviendo and d.trackRun then
		objetivo = "run"
	end

	if d.animActual ~= objetivo then
		if d.trackIdle then pcall(function() d.trackIdle:Stop(0.15) end) end
		if d.trackWalk then pcall(function() d.trackWalk:Stop(0.15) end) end
		if d.trackRun then pcall(function() d.trackRun:Stop(0.15) end) end
		if d.trackJump then pcall(function() d.trackJump:Stop(0.15) end) end

		local tr = nil
		if objetivo == "idle" then
			tr = d.trackIdle
		elseif objetivo == "walk" then
			tr = d.trackWalk
		elseif objetivo == "run" then
			tr = d.trackRun
		elseif objetivo == "jump" then
			tr = d.trackJump
		end
		if tr then pcall(function() tr:Play(0.15) end) end
		d.animActual = objetivo
	elseif objetivo == "jump" and d.trackJump and not d.trackJump.IsPlaying then
		pcall(function() d.trackJump:Play(0.1) end)
	end
end

-- Tu cuerpo original queda debajo del cuerpo controlado, mirando para
-- arriba y totalmente tieso. Con servidor lo hace el servidor; esta
-- funcion es el respaldo local.
seguirBajoMapa = function()
	if not poseyendo or not poseyendoDatos then return end
	local d = poseyendoDatos
	local vr = d.victimaHRP
	if not vr or not vr.Parent or not hrp or not hrp.Parent then return end

	-- V13.9 CUERPO ABAJO DEL CADAVER (como pidio el usuario): el weld
	-- de carga ya esta DESACTIVADO en este cliente (arrancarPoseyendo
	-- local), asi que el cliente es libre de colocar su cuerpo donde
	-- sea. Tu cuerpo real queda 13 studs DEBAJO del cadaver levantado,
	-- tumbado, tieso y desmayado: parece que el muerto camina solo.
	-- Como este cliente tiene la propiedad de red de las partes (la da
	-- el Helper al cargar), estos CFrame se replican: TODOS ven el
	-- cadaver arriba caminando y tu cuerpo abajo del mapa.
	local vpos = vr.Position
	local abajo = Vector3.new(vpos.X, vpos.Y - 13, vpos.Z)
	local look = vr.CFrame.LookVector
	local forward = Vector3.new(look.X, 0, look.Z)
	if forward.Magnitude < 0.01 then forward = Vector3.zAxis else forward = forward.Unit end
	hrp.CFrame = CFrame.lookAt(abajo, abajo + Vector3.yAxis, forward)
	-- V13.9: NO se ancla localmente. Un HRP anclado en el cliente
	-- detiene la replicacion de TODO el conjunto soldado (tu cuerpo +
	-- el herido) y el movimiento del cadaver se volvia SOLO VISUAL.
	-- Sin ancla, los CFrame de tu cuerpo se replican igual que los
	-- del cadaver: TODOS ven ambos cuerpos moverse. Se mantiene fijo
	-- escribiendo su CFrame y velocidad en cada fotograma.
	hrp.Anchored = false
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	-- V13.8 NOCLIP local: el cuerpo original atraviesa piso y paredes.
	if hum then
		hum.PlatformStand = true
		hum.AutoRotate = false
		hum.WalkSpeed = 0
		hum.JumpPower = 0
		hum.UseJumpPower = true
	end
	do
		local partes = d.propio and d.propio.partes
		if partes then
			for _, item in ipairs(partes) do
				if item.p and item.p.Parent and item.p.CanCollide then
					item.p.CanCollide = false
				end
			end
		end
	end
end

local function terminarPoseyendoInterno(motivo)
	local d = poseyendoDatos
	local victima = poseyendoVictima
	poseyendo = false
	poseyendoVictima = nil
	poseyendoDatos = nil

	if d and not d.remoto then
		if d.animator then detenerTracksPoseyendo(d.animator) end
		for _, item in ipairs(d) do
			if item.socket and item.socket.Parent then item.socket.Enabled = item.e end
			if item.ncs and item.ncs.Parent then item.ncs.Enabled = item.e end
		end
		for _, item in ipairs(d.partes or {}) do
			if item.p and item.p.Parent then item.p.Massless = item.m end
		end
		-- Si el juego ya solto la carga (Grabbed = nil), el weld debe
		-- quedar desactivado; si seguimos cargando (Z), se reengancha.
		local cbe = char and char:FindFirstChild("BodyEffects")
		local g = cbe and cbe:FindFirstChild("Grabbed")
		local vg = victima and victima:FindFirstChild("BodyEffects") and victima.BodyEffects:FindFirstChild("Grabbed")
		local sigueCargando = (g and personajeDe(g.Value) == victima)
			or (vg and personajeDe(vg.Value) == char)
			or (char and victima and weldCargaEntre(char, victima) ~= nil)
		local carry = d.carry
		if carry and carry.c and carry.c.Parent then
			-- Se queda desactivado hasta que el jugador vuelva arriba.
			-- Si se reengancha antes, el herido cae al vacio con el.
			carry.c.Enabled = false
			if carry.c:IsA("Weld") then
				carry.c.Part0 = carry.p0
				carry.c.Part1 = carry.p1
				carry.c.C0 = carry.c0
				carry.c.C1 = carry.c1
			end
		end
		-- V13.8: los welds recreados por el juego durante la posesion se
		-- reactivan si seguimos cargando, o se dejan apagados si el juego
		-- ya solto al herido.
		for _, w in ipairs(d.weldsExtra or {}) do
			if w and w.Parent then w.Enabled = sigueCargando == true end
		end
		if d.victimaAnimate and d.victimaAnimate.Parent then
			d.victimaAnimate.Enabled = d.victimaAnimateEnabled
		end

		local vh = d.victimaHum
		local vr = d.victimaHRP
		if vh and vh.Parent and vr and vr.Parent then
			vh.PlatformStand = d.victimaPlatform
			vh.AutoRotate = d.victimaAuto
			vh.WalkSpeed = d.victimaWalk
			vh.JumpPower = d.victimaJump
			vh.UseJumpPower = d.victimaUse
			vr.Anchored = d.victimaHRPAnclado
			-- V13.9: se reactivan los estados del Humanoid que se
			-- apagaron para que el cuerpo no peleara el movimiento.
			for _, st in ipairs(d.estadosApagados or {}) do
				pcall(function() vh:SetStateEnabled(st, true) end)
			end
			vh:Move(Vector3.zero, false)
			pcall(function() vh:ChangeState(Enum.HumanoidStateType.PlatformStanding) end)
			-- Evita que quede reproduciendose la animacion de cargado
			-- cuando el juego ya solto el cuerpo.
			for _, tr in ipairs(vh:GetPlayingAnimationTracks()) do
				if tr.Name == "SpideyPose_Cargado" then
					pcall(function() tr:Stop(0) end)
				end
			end
			if sigueCargando then
				local animator = animatorDe(vh)
				local a = Instance.new("Animation")
				a.Name = "SpideyPose_Cargado"
				a.AnimationId = "rbxassetid://88134065149760"
				local ok, tr = pcall(function() return animator:LoadAnimation(a) end)
				if ok and tr then
					tr.Priority = Enum.AnimationPriority.Action
					tr:Play(0.15)
				end
			end
		end

		local propio = d.propio
		-- V13.9 BLINDAJE (bug "me quedo abajo/invisible"): el hrp/hum
		-- guardados al poseer pueden estar VIEJOS si el personaje
		-- respawneo durante la posesion. Se usa el CUERPO ACTUAL como
		-- respaldo y SIEMPRE se escribe una posicion segura arriba.
		local hrpAhora = (propio and propio.hrp and propio.hrp.Parent and propio.hrp)
			or (char and char:FindFirstChild("HumanoidRootPart"))
		local humAhora = (propio and propio.hum and propio.hum.Parent and propio.hum)
			or (char and char:FindFirstChildOfClass("Humanoid"))
		if hrpAhora and hrpAhora.Parent then
			local destino
			local yaw = 0
			local vrFin = d.victimaHRP
			if vrFin and vrFin.Parent then
				local cf = vrFin.CFrame * CFrame.new(0, 0, 4.5)
				destino = cf.Position + Vector3.new(0, 1.5, 0)
				local l = vrFin.CFrame.LookVector
				local plano = Vector3.new(l.X, 0, l.Z)
				if plano.Magnitude > 0.01 then yaw = math.atan2(plano.X, plano.Z) end
			else
				destino = (propio and propio.cframe and propio.cframe.Position or Vector3.zero) + Vector3.new(0, 3, 0)
			end
			-- Piso seguro: si el destino cae dentro del suelo o de una
			-- pared (o debajo del mapa), se sube hasta 3 studs sobre el
			-- suelo real mas cercano hacia abajo.
			do
				local rp = RaycastParams.new()
				rp.FilterType = Enum.RaycastFilterType.Exclude
				rp.FilterDescendantsInstances = { char, d.victima }
				local hit = workspace:Raycast(destino + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), rp)
				if hit then
					local sueloY = hit.Position.Y + 3
					if destino.Y < sueloY then destino = Vector3.new(destino.X, sueloY, destino.Z) end
				end
			end
			hrpAhora.CFrame = CFrame.new(destino) * CFrame.Angles(0, yaw, 0)
			hrpAhora.Anchored = (propio and propio.anclado) or false
			hrpAhora.AssemblyLinearVelocity = Vector3.zero
			hrpAhora.AssemblyAngularVelocity = Vector3.zero
			local h = humAhora
			if h and h.Parent then
				h.WalkSpeed = (propio and propio.walk) or 16
				h.JumpPower = (propio and propio.jump) or 50
				h.UseJumpPower = (propio and propio.use) or true
				h.PlatformStand = (propio and propio.platform) or false
				h.AutoRotate = (propio and propio.auto) or true
				if not (propio and propio.anclado) then
					pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
				end
			end
			-- V13.8: se devuelve la colision original del cuerpo.
			for _, item in ipairs((propio and propio.partes) or {}) do
				if item.p and item.p.Parent then
					item.p.CanCollide = item.cc
				end
			end
			-- Si el personaje cambio, tambien se restauran las partes del
			-- cuerpo NUEVO (sus colisiones pueden haber quedado en false).
			if hrpAhora ~= (propio and propio.hrp) and char then
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = true end
				end
			end
		end

		-- Recien ahora, con el jugador ya fuera de debajo del mapa,
		-- se reengancha la carga si el juego aun la conserva.
		local carryFinal = d.carry
		if carryFinal and carryFinal.c and carryFinal.c.Parent then
			-- Al desposeer con Z SI se reengancha, aunque el cliente
			-- hubiera visto el weld desactivado por un ciclo anterior.
			carryFinal.c.Enabled = sigueCargando == true
		end
	end

	local cam = workspace.CurrentCamera
	if cam then
		cam.CameraSubject = (d and d.propio and d.propio.camSubject) or hum or (player.Character and player.Character:FindFirstChildOfClass("Humanoid"))
		cam.CameraType = (d and d.propio and d.propio.camType) or Enum.CameraType.Custom
	end

	player:SetAttribute("SpideyTestMove", nil)
	mostrarHUD(nil)
	print("[Spidey V13.9] posesion soltada (" .. tostring(motivo or "manual") .. ")")
	return true
end

terminarPoseyendoLocal = function(motivo, avisar)
	if not poseyendo then return false end
	if avisar and not sinServidor then
		RE_Cuerpo:FireServer("POSE_STOP")
	end
	return terminarPoseyendoInterno(motivo)
end

local function validarPoseyendoActual()
	local d = poseyendoDatos
	if not d then return false end
	local victima = d.victima
	local vh = d.victimaHum
	local vr = d.victimaHRP
	if not victima or not victima.Parent then return false, "el cuerpo desaparecio" end
	if not vh or not vh.Parent or not vr or not vr.Parent then return false, "el cuerpo desaparecio" end
	-- V13.8: SIN deteccion. La posesion sigue mientras el cuerpo exista.
	-- Se termina con Z, si el cuerpo desaparece/respawnea, o si el herido
	-- se levanta y se va corriendo por su cuenta (evita arrastrarlo).

	if vh.MoveDirection.Magnitude > 0.15 then
		if not d.moviendoSoloDesde then
			d.moviendoSoloDesde = os.clock()
		elseif os.clock() - d.moviendoSoloDesde > 2 then
			return false, "el herido se levanto y se fue"
		end
	else
		d.moviendoSoloDesde = nil
	end
	return true
end

local function actualizarPoseyendoLocal()
	local ok, motivo = validarPoseyendoActual()
	if not ok then
		terminarPoseyendoLocal(motivo, true)
		return
	end
	local d = poseyendoDatos
	local vector = vectorMovimiento()
	local cam = workspace.CurrentCamera

	if d.remoto then
		-- El servidor mueve y anima el cuerpo real. Aqui solo enviamos
		-- la orden y mantenemos la camara en el cuerpo.
		if (os.clock() - ultimoEnvioPose) >= 1 / 30 then
			ultimoEnvioPose = os.clock()
			local sprint = UIS:IsKeyDown(Enum.KeyCode.LeftShift)
				or UIS:IsKeyDown(Enum.KeyCode.RightShift)
			local salto = UIS:IsKeyDown(Enum.KeyCode.Space)
			RE_Cuerpo:FireServer("POSE_MOVE", vector, sprint, salto)
		end
	else
		local vh = d.victimaHum
		local vr = d.victimaHRP

		-- V13.8: el juego puede recrear el weld mientras controlamos.
		-- Se apaga en cada actualizacion para que no arrastre al herido.
		apagarWeldsCarga(char, d.victima, d)

		-- V13.9 (RECETA PROBADA): el Helper te da la propiedad de red
		-- de las partes del herido cuando lo cargas. Con esa propiedad,
		-- los CFrame que escribe TU cliente se REPLICAN A TODOS (no es
		-- visual). Para que el cuerpo no pelee:
		--   1) Humanoid en estado Physics (PlatformStanding lo ancla).
		--   2) Ball sockets del ragdoll apagados (se apagaron al inicio).
		--   3) Movimiento por CFrame en espacio MUNDO, cuerpo enderezado.
		vh.PlatformStand = false
		vh.AutoRotate = false
		vh.WalkSpeed = 0
		vh.JumpPower = 0
		vh.UseJumpPower = true
		vr.Anchored = false
		if vh:GetState() ~= Enum.HumanoidStateType.Physics then
			pcall(function() vh:ChangeState(Enum.HumanoidStateType.Physics) end)
		end

		local sprint = UIS:IsKeyDown(Enum.KeyCode.LeftShift)
			or UIS:IsKeyDown(Enum.KeyCode.RightShift)
		local saltando = UIS:IsKeyDown(Enum.KeyCode.Space)
		local velocidad = sprint and 24 or 16

		local ahora = os.clock()
		local dt = math.clamp(ahora - (d.ultimoUpdate or ahora), 0, 0.1)
		d.ultimoUpdate = ahora

		-- Levantada: el cadaver se endereza en los primeros 0.6 s.
		local tRise = math.clamp((ahora - (d.inicioPose or ahora)) / 0.6, 0, 1)

		-- Salto y gravedad simples (solo cuando ya esta de pie).
		if tRise >= 1 then
			d.victimaVy = d.victimaVy or 0
			d.victimaAltura = d.victimaAltura or 0
			if saltando and d.victimaAltura <= 0.05 and math.abs(d.victimaVy) < 1 then
				d.victimaVy = 42
			end
			d.victimaVy = d.victimaVy - 100 * dt
			d.victimaAltura = math.max(0, d.victimaAltura + d.victimaVy * dt)
			if d.victimaAltura <= 0 then d.victimaVy = 0 end
		end

		local base = d.victimaStartCF
		local actual = d.victimaUltimaPos or base.Position

		-- V13.9: el CADAVER NO TIENE NOCLIP. Solo tu cuerpo original
		-- (el de abajo) atraviesa piso y paredes. El movimiento del
		-- cadaver revisa paredes con raycast y se detiene ante un
		-- obstaculo. Si esta bloqueado, el offset NO se acumula, asi
		-- que nunca se traba: al soltar la tecla o girar, responde.
		local nuevoOffset = d.victimaOffset + vector * velocidad * dt
		if (vector.Magnitude > 0.01) then
			local pasoX = (base.Position.X + nuevoOffset.X) - actual.X
			local pasoZ = (base.Position.Z + nuevoOffset.Z) - actual.Z
			local largo = math.sqrt(pasoX * pasoX + pasoZ * pasoZ)
			if largo > 0.01 then
				local dir = Vector3.new(pasoX / largo, 0, pasoZ / largo)
				if not d.rayParamsPared then
					local rp = RaycastParams.new()
					rp.FilterType = Enum.RaycastFilterType.Exclude
					rp.FilterDescendantsInstances = { d.victima, char }
					d.rayParamsPared = rp
				end
				local origen = Vector3.new(actual.X, (d.victimaPisoY or actual.Y), actual.Z)
				local hit = workspace:Raycast(origen, dir * (largo + 1.2), d.rayParamsPared)
				if hit then
					local espacio = (hit.Position - origen).Magnitude - 1.2
					if espacio > 0.25 then
						-- Avanza solo hasta la pared.
						local llega = actual.X + dir.X * espacio - base.Position.X
						local llegaz = actual.Z + dir.Z * espacio - base.Position.Z
						nuevoOffset = Vector3.new(llega, nuevoOffset.Y, llegaz)
					elseif espacio <= 0.25 and largo > 0.6 then
						-- Bloqueado del todo: no acumula el offset (asi
						-- no se traba). Solo se ignora si el paso es
						-- largo (permite escapar si nacio dentro de algo).
						nuevoOffset = d.victimaOffset
					end
				end
			end
		end
		d.victimaOffset = nuevoOffset

		-- Piso: se relee el suelo bajo la posicion nueva (terreno,
		-- escaleras, rampas). El cadaver sube y baja con el mapa en
		-- vez de flotar o atravesar pisos.
		if not d.rayParamsPiso then
			local rp = RaycastParams.new()
			rp.FilterType = Enum.RaycastFilterType.Exclude
			rp.FilterDescendantsInstances = { d.victima, char }
			d.rayParamsPiso = rp
		end
		if (ahora - (d.ultimoPiso or 0)) > 0.1 then
			d.ultimoPiso = ahora
			local px = base.Position.X + d.victimaOffset.X
			local pz = base.Position.Z + d.victimaOffset.Z
			local desde = Vector3.new(px, (d.victimaPisoY or base.Position.Y) + 3, pz)
			local hit = workspace:Raycast(desde, Vector3.new(0, -14, 0), d.rayParamsPiso)
			if hit then
				d.victimaPisoY = hit.Position.Y + vh.HipHeight + vr.Size.Y / 2 + 0.1
			end
		end

		-- Posicion: XZ del offset, Y interpolada de acostado a de pie
		-- mas la altura del salto.
		local yAcostado = base.Position.Y
		local yDePie = (d.victimaPisoY or yAcostado) + (d.victimaAltura or 0)
		local posY = yAcostado + (yDePie - yAcostado) * tRise
		local pos = Vector3.new(
			base.Position.X + d.victimaOffset.X,
			posY,
			base.Position.Z + d.victimaOffset.Z
		)
		d.victimaUltimaPos = pos

		-- Orientacion: de pie, mirando hacia donde mira la camara.
		local look = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
		local plano = Vector3.new(look.X, 0, look.Z)
		if plano.Magnitude < 0.01 then plano = Vector3.new(0, 0, -1) end
		plano = plano.Unit
		local dePie = CFrame.lookAt(pos, pos + plano)
		if tRise < 1 then
			-- Mezcla de la rotacion acostada original a la de pie.
			vr.CFrame = CFrame.new(pos) * (base.Rotation:Lerp(dePie.Rotation, tRise))
		else
			vr.CFrame = dePie
		end
		vr.AssemblyLinearVelocity = Vector3.zero
		vr.AssemblyAngularVelocity = Vector3.zero

		actualizarAnimacionPoseyendo(vector)
		seguirBajoMapa()
	end

	if cam then
		if cam.CameraSubject ~= d.victimaHum then cam.CameraSubject = d.victimaHum end
		if cam.CameraType ~= Enum.CameraType.Custom then cam.CameraType = Enum.CameraType.Custom end
	end
end

intentarPoseyendo = function()
	local ahora = os.clock()
	if ahora - ultimoPoseIntento < 0.25 then return false end
	ultimoPoseIntento = ahora

	if poseyendo then
		mostrarHUD("Para desposeer usa Z (sigues cargando al herido)")
		task.delay(1.5, function()
			if poseyendo then
				mostrarHUD("CONTROLANDO: " .. tostring(poseyendoVictima and poseyendoVictima.Name) .. "   |   Z = desposeer")
			end
		end)
		return false
	end

	local victima, motivo = detectarCarga()
	if not victima then
		-- Pequena espera por si el clic fue justo al agarrar.
		for _ = 1, 10 do
			task.wait(0.05)
			victima, motivo = detectarCarga()
			if victima then break end
		end
	end
	if not victima then
		print("[Spidey V13.9] no se detecto carga: " .. tostring(motivo))
		diagnosticarCarga()
		mostrarHUD("No hay ningun cuerpo derrribado cerca")
		task.delay(1.5, function()
			if not poseyendo then mostrarHUD(nil) end
		end)
		return false
	end

	print("[Spidey V13.9] cuerpo objetivo: " .. victima.Name .. " [" .. tostring(motivo) .. "]")

	if not sinServidor then
		RE_Cuerpo:FireServer("POSE_START")
		return true
	end

	return arrancarPoseyendoLocal(victima, false)
end

function V11.Poseer()
	return intentarPoseyendo()
end

function V11.SoltarPose()
	return terminarPoseyendoLocal("manual", true)
end

RE_Cuerpo.OnClientEvent:Connect(function(accion, a, b)
	if accion == "POSE_START" then
		if typeof(a) == "Instance" and a:IsA("Model") then
			arrancarPoseyendoLocal(a, true)
		end
	elseif accion == "POSE_NO" then
		mostrarHUD(tostring(a or "No puedes controlar ahora"))
		task.delay(1.5, function()
			if not poseyendo then mostrarHUD(nil) end
		end)
	elseif accion == "POSE_STOP" then
		terminarPoseyendoLocal(tostring(a or "servidor"), false)
	end
end)

RunService.RenderStepped:Connect(function()
	if poseyendo then
		-- V13.9: si actualizar da un error, la posesion se termina y
		-- el cuerpo vuelve ARRIBA. Sin esto, un error dejaba al jugador
		-- tumbado debajo del mapa para siempre ("me quedo abajo").
		local ok, err = pcall(actualizarPoseyendoLocal)
		if not ok then
			warn("[Spidey V13.9] error en posesion: " .. tostring(err))
			terminarPoseyendoLocal("error interno", true)
		end
	end
end)

-----------------------------------------------------------------
-- Teclas: Q lock · J ESP. El control ya NO usa G ni Espacio.
-- La posesion se activa y se suelta con clic en el tool Control.
-----------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
	if UIS:GetFocusedTextBox() then return end
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Z then
		if poseyendo then
			terminarPoseyendoLocal("manual", true)
		end
		return
	end
	if kc == Enum.KeyCode.Q then
		V11.AlternarLock()
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and bloqueado and bloqueado.enviarApuntado then
		bloqueado.enviarApuntado()
	end
	if gpe then return end
	if kc == Enum.KeyCode.J then
		V11.AlternarESP()
	end
end)

player.CharacterAdded:Connect(function()
	if poseyendo then terminarPoseyendoLocal("reinicio local", true) end
end)

player.CharacterRemoving:Connect(function()
	if poseyendo then terminarPoseyendoLocal("reinicio local", true) end
	mostrarHUD(nil)
end)
-----------------------------------------------------------------
-- DEPURACIÃN
-----------------------------------------------------------------
function _G.SpideyProbar(nombre, t)
	nombre = tostring(nombre or "A"):upper()
	if not SEC[nombre] then return false, "secuencia inexistente" end
	if not char then return false, "sin personaje" end

	-- Usa la MISMA ruta que el juego real: activa la capa visible
	-- (Animator/fisica) ademas de las poses locales.
	local ok = iniciarSecuencia(char, nombre, workspace:GetServerTimeNow(), player, true)
	local s = secuencias[char]
	if ok and s and t ~= nil then
		s.pausa = true
		s.tFijo = math.clamp(tonumber(t) or 0, 0, SEC[nombre].duracion)
		s.inicio = s.inicio - s.tFijo
	end
	return ok
end

function _G.SpideySoltar()
	if char then
		detenerSecuencia(char)
		Pose.Limpiar(char)
	end
	poseSpideyActiva = true
	if hrp then hrp:SetAttribute("SpideyAnim", nil) end
end

function _G.SpideyInfo()
	local t = {
		"estado=" .. estado,
		"pose=" .. tostring(poseSpideyActiva),
		"contador=" .. contadorClicks,
		"rig=" .. tostring(Pose.Tipo(char)),
		"web=" .. tostring(webActiva),
		"tool=" .. tostring(spiderTool and spiderTool.Parent and spiderTool.Parent.Name),
		"ancla=" .. tostring(anclaPos),
		"esp=" .. tostring(espActivo),
		"poseyendo=" .. tostring(poseyendo),
		"victima=" .. tostring(poseyendoVictima and poseyendoVictima.Name),
		"controlTool=" .. tostring(controlTool and controlTool.Parent and controlTool.Parent.Name),
	}
	for modelo, s in pairs(secuencias) do
		local transcurrido = s.pausa and s.tFijo or (workspace:GetServerTimeNow() - s.inicio)
		table.insert(t, modelo.Name .. ":" .. s.nombre .. ":" .. string.format("%.2f", transcurrido))
	end
	return table.concat(t, " | ")
end

-- GANCHO DE PRUEBAS (dev): LocalPlayer:SetAttribute("SpideyTest", ...)
-- Valores: "A", "B", "A:0.5" (pausa en t), "STOP", "INFO", "EQUIP", "CLICK", "RELEASE", "GRAB", "LOCK", "UNLOCK", "ESP", "ESPTEST", "SIMULARA", "SIMULARB"
local ultimoCmd
player:GetAttributeChangedSignal("SpideyTest"):Connect(function()
	local v = player:GetAttribute("SpideyTest")
	if type(v) ~= "string" or v == ultimoCmd then return end
	ultimoCmd = v
	local c = string.upper((v:gsub("%s+", "")))
	if c == "STOP" then
		_G.SpideySoltar()
		print("[SpideyTest] STOP")
	elseif c == "POSE" then
		print("[SpideyTest] POSE", V11.Poseer())
	elseif c == "UNPOSE" then
		print("[SpideyTest] UNPOSE", V11.SoltarPose())
	elseif c == "LOCK" then
		print("[SpideyTest] LOCK", V11.LockearCercano())
	elseif c == "UNLOCK" then
		print("[SpideyTest] UNLOCK", V11.QuitarLock())
	elseif c == "ESP" then
		print("[SpideyTest] ESP", V11.AlternarESP())
	elseif c == "ESPTEST" then
		print("[SpideyTest] ESPTEST", V11.ESPPrueba())
	elseif c == "INFO" then
		print("[SpideyTest]", _G.SpideyInfo())
	elseif c == "EQUIP" then
		local bp = player:FindFirstChild("Backpack")
		local t = (char and char:FindFirstChild("Spider")) or (bp and bp:FindFirstChild("Spider"))
		if t and hum then hum:EquipTool(t) end
		print("[SpideyTest] equip |", _G.SpideyInfo())
	elseif c == "CLICK" then
		if spiderTool and spiderTool.Parent == char and not webInputHeld then
			webInputHeld = true
			lanzarWeb()
		end
		print("[SpideyTest] click |", _G.SpideyInfo())
	elseif c == "RELEASE" then
		webInputHeld = false
		detenerTelarana()
		print("[SpideyTest] release |", _G.SpideyInfo())
	elseif c == "SIMULARA" or c == "SIMULARB" then
		-- Clona tu personaje en el workspace y le aplica la secuencia:
		-- es EXACTAMENTE lo que ven los demas jugadores de ti.
		local nombre = (c == "SIMULARA") and "A" or "B"
		if char then
			char.Archivable = true
			local clon = char:Clone()
			clon.Name = "SpideySimulado"
			clon:PivotTo(char:GetPivot() * CFrame.new(5, 0, 0))
			clon.Parent = workspace
			iniciarSecuencia(clon, nombre, workspace:GetServerTimeNow(), player, false)
			task.delay((nombre == "A") and 3.5 or 7, function()
				if clon.Parent then clon:Destroy() end
			end)
			print("[SpideyTest] simulando " .. nombre .. " en un clon (lo que ven los demas)")
		end
	else
		local nombre, ts = string.match(c, "^([AB]):([%-%d%.]+)$")
		if not nombre then nombre = string.match(c, "^([AB])$") end
		if nombre then
			local ok, err = _G.SpideyProbar(nombre, ts and tonumber(ts) or nil)
			print("[SpideyTest]", c, ok, err or "", _G.SpideyInfo())
		else
			print("[SpideyTest] comando desconocido:", v)
		end
	end
end)

end

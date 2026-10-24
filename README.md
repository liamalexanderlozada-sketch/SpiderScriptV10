# Spiderscript V13.8 — posesion SIMPLE + TODOS ven el cadaver 🕷️

Sistema **Spider-Man completo** (telarana, fisica de pendulo, trepa, camara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESION REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

> **Novedad V13.8: clic y listo + replicacion verificada**
>
> - **SIN deteccion complicada**: derribas a tu amigo, te agachas, lo
>   agarras de la pierna, equipas el tool **Control** y haces **clic**.
>   Se posee el cuerpo **DERRIBADO** mas cercano (a menos de 18 studs).
>   Un jugador sano y de pie **nunca** se posee.
> - **NO ES VISUAL — TODOS LO VEN** (verificado con servidor y cliente a
>   la vez): el Helper del juego le da a TU cliente la propiedad de red
>   del herido mientras lo cargas; con ella, los CFrame que escribe tu
>   cliente se replican al servidor y a todos. Prueba: cliente movio el
>   cadaver 29.08 studs y el servidor leyo 29.0 exactos, de pie.
> - **EL CADAVER SE LEVANTA**: se endereza solo en 0.6 s (de acostado a
>   de pie) y todos lo ven levantarse, con sus animaciones
>   idle/walk/run/jump, WASD + Shift + Espacio.
> - **EL CADAVER NO TIENE NOCLIP**: respeta paredes (se detiene ante
>   obstaculos y el movimiento bloqueado no se acumula: nunca se traba)
>   y sigue el piso real (terreno, escaleras, rampas). El noclip es
>   SOLO de tu cuerpo original.
> - **WELD-RIDE**: mientras el juego te tenga soldado al herido, tu
>   cuerpo original se pone exactamente donde el weld quiere (~2 studs
>   del cadaver, como una carga normal). Cero pelea con el servidor:
>   todos ven lo mismo. Sin weld, tu cuerpo baja 13 studs como siempre.
> - **Causas raiz arregladas**: el ancla local del HRP propio congelaba
>   la replicacion de todo el conjunto (por eso antes era visual); el
>   PlatformStanding del herido lo dejaba anclado en el sitio (ahora
>   estado Physics); los ball sockets del ragdoll se apagan durante la
>   posesion y se restauran al desposeer.
> - **Z desposee** y sigues cargando al herido; la posesion termina
>   sola si el cuerpo desaparece/respawnea o el herido se mueve solo
>   mas de 2 s. Lock, ESP y telarana intactos.

# Spiderscript V13.4-V13.7 (historial)

Sistema **Spider-Man completo** (telaraña, física de péndulo, trepa, cámara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESIÓN REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

# Spiderscript V13.5 - deteccion permisiva del agarre + NOCLIP

Sistema **Spider-Man completo** (telarana, fisica de pendulo, trepa, camara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESION REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

# Spiderscript V13.6 - detecta el agarre de la pierna SI O SI

Sistema **Spider-Man completo** (telarana, fisica de pendulo, trepa, camara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESION REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

> **Novedad V13.6: senal Massless + cuerpo tirado cerca + diagnostico**
>
> - **Massless**: el Helper de Da Hood deja TODAS las partes del herido en
>   `Massless = true` mientras lo cargas y las devuelve a `false` al
>   soltarlo. Esa senal se replica SIEMPRE al cliente y no depende del
>   weld. V13.6 ya no toca Massless durante la posesion para que la senal
>   siga viva (y asi la posesion termina sola cuando el juego suelta).
> - **Ultimo recurso**: si el juego ya no crea weld ni `Grabbed`, con el
>   clic explicito del tool Control se acepta el cuerpo **herido**
>   (K.O. / muerto / vida < 45) que tengas pegado a ti. La posesion se
>   mantiene con las reglas del propio Helper (suelta al herido cuando su
>   vida llega a 45): al recuperar vida, la posesion termina sola.
> - **Resolver con puntuacion**: antes el servidor devolvia el PRIMER
>   modelo que coincidia y podia elegir un NPC cualquiera del mapa (p.ej.
>   un "BullCarnival" massless). Ahora puntua todas las candidatas
>   (Grabbed +3, weld +2, massless +1, tirado +1, cerca +1) y gana la de
>   mas puntos, con desempate por distancia. El cliente tambien desempata
>   por senales y distancia.
> - **Diagnostico completo**: si la deteccion falla en modo executor, la
>   consola imprime `[Spidey V13.6] no se detecto carga: <motivo>` y un
>   volcado de cada cuerpo cercano (distancia, K.O, Dead, PlatformStand,
>   vida, Grabbed, weld, massless) para revisarlo en F9.
> - Sigue todo lo de V13.5: cadaveres con `Dead=true`/`Health=0` validos,
>   weld en cualquier direccion, Grabbed inverso, motivo en el HUD,
>   apagado del weld recreado y **NOCLIP** del cuerpo original.
> **Novedad V13.5: detecta el agarre de la pierna SI O SI + noclip**
>
> - En el Da Hood real el cuerpo que cargas puede tener `Dead = true` o
>   `Health = 0` (es un cadaver) y el weld puede tardar en replicar.
>   V13.4 rechazaba eso y de ahi el "No estas cargando a nadie".
>   V13.5 acepta **cualquiera** de las senales reales del juego:
>   `Grabbed` del que carga, `Grabbed` inverso (CarrySystem), weld
>   `GRABBING_CONSTRAINT` en **cualquier direccion** o network owner.
> - Ya **no se rechaza** por `Dead`/`Health`: un cadaver sigue siendo
>   controlable mientras lo lleves agarrado.
> - Si no detecta, el **HUD dice el motivo** (sin Grabbed, sin weld, lo
>   carga otro jugador...) y la consola imprime `[Spidey V13.5]` para F9.
> - Mientras controlas, si el juego **recrea el weld** de carga se apaga
>   solo para que no arrastre al herido.
> - Tu cuerpo original ahora tiene **NOCLIP**: atraviesa el piso y las
>   paredes 13 studs mas abajo, mirando arriba y totalmente tieso. Al
>   terminar se le devuelve su colision original.
> - El servidor tambien resuelve la victima con cualquiera de las senales
>   (antes solo miraba su propio `Grabbed`).
> **Novedad V13.4: el modo con servidor también mantiene al herido como
> cadáver**
>
> - El servidor ya no pone de pie al herido: `PlatformStand = true`,
>   `AutoRotate = false`, `WalkSpeed = 0`, `JumpPower = 0`.
> - Lo mueve por **CFrame**, no con `Humanoid:Move`.
> - Usa **sus propias animaciones** (`idle`, `walk`, `run`, `jump`, `fall`).
> - **Shift** corre y **Espacio** salta también con servidor.
> - Al desposeer se reactiva el `Animate` del herido.
>
> **Novedad V13.3: el cuerpo controlado sigue siendo un cadáver**
>
> - El herido **no se pone de pie**. Sigue tirado e inmovilizado.
> - Solo hace **sus propias animaciones** de caminar, correr y saltar.
> - Si tiene animaciones de **zombi**, se usan las de zombi.
> - Tu cuerpo original queda **debajo** de él, mirando hacia arriba y
>   moviéndose con él como un imán.
> - **G** suelta la carga del juego y te devuelve arriba.
>
> **Corrección V13.2 (sigue incluida):**
> - La posesión local ya no borra `Part0/Part1` del weld.
> - Se espera hasta **0.6 s** a que replique el `GRABBING_CONSTRAINT`.
> - Se acepta K.O. con `Health = 0.5` o `0` si `Dead = false`.
> - Al desposeer con Z se reengancha el weld si la carga sigue.
> - Si el juego quita la carga, el weld queda desactivado y no se reproduce
>   la animación de cargado.
>
> **Novedad V13.1 (sigue incluida):**
> - El juego **no escribe** `BodyEffects.Grabbed` en la víctima cuando la
>   cargas por la pierna. Ahora se valida el weld real
>   `GRABBING_CONSTRAINT`: `Part0` en el cuerpo que carga y `Part1` en el
>   `HumanoidRootPart` del herido.
> - Se aceptan las dos formas del juego: `Grabbed = Player` y
>   `Grabbed = Model`.

## Loadstring (executor / potassium)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/main/Resources/Scripts/Main.lua"))()
```

Si tu ejecutor cachea la URL, usa la URL por commit:
`https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/01d848338048d9cc72919ac042b9302e0dc94860/Resources/Scripts/Main.lua`

> Si ya tenías una versión anterior cargada en la misma sesión, **rejoin**:
> el candado `_G.__SPIDEY_V11_ACTIVO` impide cargar dos veces el script.

## Teclas

| Tecla | Qué hace |
|---|---|
| **Clic con `Control`** | **POSEER:** solo funciona si estás cargando de verdad a un herido por la pierna. Equipa el tool `Control` y haz clic izquierdo. Monta la cámara sobre el cuerpo real. |
| **Z** | **DESPOSEER:** devuelve el control a tu personaje y la cámara a ti, pero **sigues cargando** al herido por la pierna. |
| **G** | **Soltar la carga** del juego. Si estás poseyendo, la posesión termina sola y vuelves arriba. |
| **WASD** | Mueve al herido. Su cuerpo sigue tirado; solo se desplaza. |
| **Shift** | Correr. Usa la animación `run` del herido. |
| **Espacio** | Saltar. Usa la animación `jump` del herido. |
| **Q** | **LOCK:** pon el mouse sobre una persona y pulsa Q. Contorno blanco en ella y en ti + línea blanca. |
| **J** | **ESP:** contorno blanco + nombre de usuario arriba de los jugadores, visible a través de las paredes. |
| **X + pared** | Trepar. Shift queda libre. |

## Cómo funciona la posesión (V13.4)

### 1. Requisitos para poseer

El tool `Control` **no posee a nadie** si no hay una carga real:

- `character.BodyEffects.Grabbed.Value` apunta al herido (`Player` o `Model`)
- existe `victima.GRABBING_CONSTRAINT` con `Part0` en el que carga y
  `Part1` en el `HumanoidRootPart` del herido
- si `victima.BodyEffects.Grabbed` existe, apunta al que carga; en el
  agarre clásico por la pierna puede estar en `nil`, y eso es válido
- el herido no está muerto (`BodyEffects.Dead = false`)
- `K.O. = true` es normal y no cancela la posesión; la vida puede ser `0.5`
- el que carga debe estar vivo y con el tool `Control` equipado

### 2. Al poseer

1. Se guarda el estado del cuerpo original y del herido.
2. Se **desactiva** el weld de carga sin destruirlo, conservando
   `Part0/Part1`, `C0` y `C1`.
3. Se desactivan sockets y `NoCollisionConstraint_HOLD` del herido.
4. El cuerpo original queda **13 studs debajo** del herido, anclado, tieso y
   mirando hacia arriba.
5. El herido **no se levanta**:
   - `PlatformStand = true`
   - `AutoRotate = false`
   - `WalkSpeed = 0`
   - `JumpPower = 0`
6. Se desactiva su `Animate` local para que no pelee con las animaciones
   nuestras.
7. Se cargan **sus propias animaciones** desde su `Animate`:
   `idle`, `walk`, `run`, `jump` y `fall`.
8. El cuerpo real se mueve por **CFrame**:
   - **sin servidor:** desde el cliente, con la propiedad de red que la
     carga del juego ya le dio;
   - **con servidor:** desde el servidor, autoritativo para todos.
9. La cámara se monta sobre el herido y el HUD avisa
   `CONTROLANDO: <nombre> | Z = desposeer`.

### 3. Animaciones: las del herido

- Parado → su `idle`
- Caminando → su `walk`
- Corriendo (Shift) → su `run`
- Saltando (Espacio) → su `jump`
- Si tiene animaciones de zombi, se usan las de zombi
- Las animaciones default solo se usan si el herido no trae las suyas

### 4. Tu cuerpo original

- Queda **13 studs debajo** del herido.
- Mira hacia arriba.
- Está totalmente tieso.
- Se mueve con el herido, como un imán.
- No hace ninguna animación propia.

### 5. Desposeer con Z

1. Se devuelve **primero** al jugador a la superficie, delante del herido.
2. Se restaura la cámara a tu `Humanoid` y se oculta el HUD.
3. Se restaura el herido:
   - `PlatformStand = true` (sigue siendo un herido)
   - `Massless = true`
   - sockets y weld de carga
   - su `Animate` se reactiva
4. **La carga sigue activa**: `Grabbed` sigue apuntando al herido y el weld
   `GRABBING_CONSTRAINT` se reengancha con sus `Part0/Part1` originales.

### 6. Soltar con G / salida automática

- Si el juego pone `Grabbed = nil` o destruye el weld, la posesión termina sola.
- El jugador vuelve arriba automáticamente.
- El weld queda desactivado.
- No se reproduce la animación de cargado.
- El herido queda donde lo dejaste.

### 7. Modo con servidor (V13.4)

- El servidor valida la carga y la posesión.
- Mantiene al herido tirado (`PlatformStand`, `AutoRotate`, `WalkSpeed 0`).
- Acumula el desplazamiento y aplica `CFrame` en cada `Heartbeat`.
- Carga y reproduce las animaciones propias del herido.
- Recibe `sprint` y `jump` del cliente para usar `run` y `jump`.
- Al desposeer restaura el estado guardado y reactiva el `Animate`.

## LOCK y ESP (sin tocar)

- El lock visual (2 `Highlight` + 1 `Beam`) se crea en tu cliente.
- Las armas nuevas siguen apuntando con el parche de `GunHandler.getAim`.
- Las armas viejas siguen usando el remoto de Da Hood.
- El ESP sigue siendo de cada cliente.
- La trepa con X y la telaraña tampoco se tocaron.

## Dos modos

### 1. Con servidor: posesión real y replicada (tu juego)

Instala **el mismo archivo** en estos dos lugares y publica:

1. `ServerScriptService` → Insert Object → **Script** (NO LocalScript),
   nombre `SpideyV11`, pega el archivo completo.
2. `StarterPlayer` → `StarterPlayerScripts` → **LocalScript**,
   nombre `SpideyClienteV11`, pega el mismo archivo.

Con eso:

- El servidor crea `ReplicatedStorage.SpideyRemotos` con `RE_Cuerpo` y
  `RE_Lock`.
- El servidor valida la carga, mueve el cuerpo real por CFrame, reproduce
  sus animaciones y sincroniza a todos.
- Al desposeer con Z, el herido vuelve a su estado de cargado.
- El lock del dueño dirige las balas por `RE_Lock`.

### 2. Sin servidor: Da Hood / executor

Si no existe `ReplicatedStorage.SpideyRemotos`, el script entra en **modo
local**. El cliente mueve el cuerpo real usando la propiedad de red que la
carga ya le dio. El herido sigue tirado, hace sus propias animaciones y tu
cuerpo queda debajo. Que los demás lo vean depende de que el juego mantenga
esa propiedad de red; un executor no puede crear scripts de servidor.

## Pruebas hechas en Studio (copia `Official Hood.rbxl`)

Se probaron **los dos modos** con un herido sintético (`CuerpoTest`), weld
real, `K.O. = true`, `Dead = false` y `Health = 0.5`.

### Modo local / executor

- Detección con `Grabbed = Model`, `victima.Grabbed = nil` y weld real.
- Reintento de 0.6 s cuando el weld tarda en replicar.
- Cámara sobre el herido.
- Cuerpo original **13.00 studs debajo**, mirando arriba.
- El herido **no se levanta**: `PlatformStand = true`, `AutoRotate = false`,
  `WalkSpeed = 0`, `JumpPower = 0`.
- Su `Animate` queda desactivado mientras lo controlas.
- Movimiento por CFrame: **15.99 studs en 1.0 s**.
- Animaciones:
  - `SpideyPose_idle` parado
  - `SpideyPose_walk` caminando
  - `SpideyPose_run` con Shift
  - `SpideyPose_jump` con Espacio
- Z:
  - cámara al jugador
  - jugador arriba
  - weld `Enabled = true`
  - `Part0/Part1` conservados
  - `Animate` reactivado
  - `Grabbed` sigue apuntando al herido
  - `PlatformStand` sigue `true` (sigue siendo un herido)
- `Grabbed = nil` (G / soltar carga):
  - la posesión terminó sola
  - jugador arriba
  - weld desactivado
  - `Animate` reactivado

### Modo servidor

- Pose con `Health = 0.5` y `K.O. = true`.
- Cámara sobre el herido.
- Cuerpo original **13.00 studs debajo**.
- El herido **no se levanta**:
  - `PlatformStand = true`
  - `AutoRotate = false`
  - `WalkSpeed = 0`
  - `JumpPower = 0`
  - estado `PlatformStanding`
  - `Animate` desactivado
- Movimiento por CFrame: **14.93 studs en 1.0 s**.
- Animaciones verificadas en el servidor:
  - `SpideyPose_idle` parado
  - `SpideyPose_walk` caminando
  - `SpideyPose_run` con Shift
  - `SpideyPose_jump` con Espacio
- Z:
  - cámara al jugador
  - weld `Enabled = true`
  - `Part0 = UpperTorso`, `Part1 = HumanoidRootPart`
  - `Animate` reactivado
  - `PlatformStand` sigue `true`
- `Grabbed = nil`:
  - la posesión terminó sola
  - cámara al jugador
  - weld desactivado
  - `Animate` reactivado
  - sin tracks nuestros reproduciéndose

## Cómo probarlo en Studio

1. Abre `Official Hood.rbxl`.
2. Para modo servidor, activa `ServerScriptService.SpideyV11`.
3. Pulsa **Play**.
4. Derriba a un NPC/jugador y cárgalo por la pierna con el sistema del juego.
5. Equipa el tool **Control** y haz clic izquierdo.
6. El herido debe seguir tirado, pero moverse con WASD y hacer sus animaciones.
7. Pulsa **Z**: vuelves a tu cuerpo y sigues cargando al herido.
8. Pulsa **G** o deja que el juego suelte la carga: la posesión termina sola.

### Comandos de prueba

```lua
local p = game.Players.LocalPlayer
p:SetAttribute("SpideyTest", "INFO")
p:SetAttribute("SpideyTest", "POSE")
p:SetAttribute("SpideyTest", "UNPOSE")
p:SetAttribute("SpideyTestMove", Vector3.new(0, 0, -1))
p:SetAttribute("SpideyTestMove", Vector3.zero)
```

Si repites el mismo valor exacto, primero pon otro (`INFO`) y luego el valor
deseado, porque el hook ignora valores idénticos al anterior.

## Límites conocidos

- **Da Hood/executor:** no hay servidor propio. El cliente ya mueve el cuerpo
  real y reproduce sus animaciones, pero no se garantiza que los demás lo
  vean si el juego cambia la propiedad de red.
- **Tu juego:** el servidor mueve y anima el cuerpo real; todos lo ven igual.
- El herido no se levanta: sigue siendo un cadáver controlado.
- No se tocó el lock, el ESP, la trepa ni la telaraña.

## Archivos

- `Resources/Scripts/Main.lua` — el archivo que sirve el loadstring (combinado).
- `Resources/Scripts/ServerScriptService/SpideyV11.lua` — copia para el Script
  de servidor.
- `Resources/Scripts/StarterPlayerScripts/SpideyClienteV11.lua` — copia para el
  LocalScript de StarterPlayerScripts.

Los tres son **idénticos** al `SPIDER V13.4.lua` entregado.

- Commit de V13.4: `01d848338048d9cc72919ac042b9302e0dc94860`.
- Tamaño: **156.053 bytes**.
- SHA256: `5986C6358D5A91C8F6172FB00E28A9A37CB30F108C34C1721E4683055DA8C311`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).

## Pruebas V13.5 (copia nueva `DESHOOOOODSESHOODS (1).rbxl` / place 10242026_3)

Dummy fiel al juego real: **clon del jugador** con el sistema de ragdoll de la
copia nueva (constraints de `CheckingKOED`, K.O, `FallingDown`, HRP anclado) y
luego el agarre real del `HelperModule` (`Grabbed` del que carga + weld
`GRABBING_CONSTRAINT` + `PlatformStand` + network owner al que carga).

### Deteccion (todas pasaron)

| Estado | Resultado |
| --- | --- |
| `Grabbed` + weld (Helper normal) | detecta `[Grabbed + weld]` |
| Solo `Grabbed` | detecta `[Grabbed]` |
| Solo `Grabbed` inverso (CarrySystem) | detecta `[Grabbed inverso]` |
| `Dead = true` y `Health = 0` (cadaver) | detecta y controla |
| Sin `Grabbed` ni weld | rechaza con motivo en HUD y consola |

### Modo servidor (Studio)

- Pose activa, atributos `SpideyPoseyendo` / `SpideyPoseidoPor` correctos.
- Weld del juego **desactivado** durante la posesion y reactivado con Z.
- Cuerpo original a **-13.00 studs** exactos, anclado, **NOCLIP 47/47 partes**.
- Movimiento por CFrame: **30.7 studs en 2 s** con el herido en `PlatformStand`.
- Soltar la carga (weld destruido + `Grabbed = nil`): la posesion **termina
  sola** (`ya no es valido`), jugador arriba y colision restaurada.
- Z: termina la posesion y **sigues cargando** (weld `Enabled = true`).

### Modo local / executor (simulado con copia LOCALTEST)

- Deteccion `[Grabbed + weld]`, camara sobre el herido, weld apagado.
- Cuerpo original a **-13.00 studs**, **NOCLIP 50/50 partes**.
- Movimiento **-32.0 studs en 2 s**.
- Soltar la carga: termina sola, jugador arriba.
- Z: weld reenganchado (`Enabled = true`) y `Grabbed` intacto.
- Sin senales: `[Spidey V13.5] no se detecto carga: sin Grabbed y sin un
  cuerpo agarrado cerca`.

Nota: el fallback por network owner solo funciona donde la API
`GetNetworkOwner` esta disponible (servidor); en el cliente las senales que
importan son `Grabbed`, `Grabbed` inverso y el weld, que si se replican.- Commit de V13.5: `6b05747a6bf7a7aa75fddf12c3751ba0af7793d2`.
- Tamano: **165.335 bytes**.
- SHA256: `4D1D47F93D3E35870FFAE14DC72A9974EC9BF11B1E8C192BEDB25948467073AA`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).
- Raw verificado en vivo tras el push (cabecera `SPIDER V13.5` presente).
## Pruebas V13.6 (copia nueva, dummy clon con el ragdoll real del juego)

| Escenario | Resultado |
| --- | --- |
| Solo `Massless` (sin Grabbed, sin weld, KO=false, vida 20) | detecta `[massless]`, pose activa |
| Juego suelta (`Massless=false` + `PlatformStand=false`) | la posesion termina sola |
| CERO senales (KO=true, vida 12, nada mas) | detecta `[cuerpo tirado cerca]`, pose activa |
| El herido recupera vida (KO=false, vida 60 >= 45) | la posesion termina sola, jugador arriba |
| Nada cerca | rechaza con motivo + diagnostico en consola |
| Resolver del servidor | ya no elige NPCs del mapa: puntua senales + distancia |

Verificado en **modo servidor** (pose activa, -13.00 studs, noclip) y en
**modo local/executor simulado** (camara en el herido, movimiento -32 studs
en 2 s, noclip 50/50, auto-fin al recuperar vida, diagnostico impreso).- Commit de V13.6: `22bc7476f7c818a5df816b64c0ca5bd0efd8c7ce`.
- Tamano: **175.470 bytes**.
- SHA256: `DE5729E65E3FB94FABD27D44663873D3E3520092BC78D1F07697E5D1AFC29A21`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).
- Raw verificado en vivo tras el push (cabecera `SPIDER V13.6` presente).
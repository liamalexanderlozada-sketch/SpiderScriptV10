# Spiderscript V13.3 🕷️

Sistema **Spider-Man completo** (telaraña, física de péndulo, trepa, cámara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESIÓN REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

> **Novedad V13.3: el cuerpo controlado sigue siendo un cadáver**
>
> - El herido **no se pone de pie**. Sigue tirado e inmovilizado.
> - Solo hace **sus propias animaciones** de caminar, correr y saltar.
> - Si tiene animaciones de **zombi**, se usan las de zombi.
> - Tu cuerpo original queda **debajo** de él, mirando hacia arriba y
>   moviéndose con él como un imán.
> - **Shift** = correr (animación `run` del herido).
> - **Espacio** = saltar (animación `jump` del herido).
> - **G** sigue soltando la carga del juego y te devuelve arriba.
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
`https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/cef7d0717d05b6a9e4a2ee64ff2637595482074d/Resources/Scripts/Main.lua`

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

## Cómo funciona la posesión (V13.3)

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
6. Se desactiva su `Animate` local para que no pele con las animaciones
   nuestras.
7. Se cargan **sus propias animaciones** desde su `Animate`:
   `idle`, `walk`, `run`, `jump` y `fall`.
8. El cliente mueve el cuerpo real por **CFrame**, usando la propiedad de red
   que la carga del juego ya le dio.
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
   - `PlatformStand = true`
   - `WalkSpeed = 0`
   - `Massless = true`
   - sockets y weld de carga
4. **La carga sigue activa**: `Grabbed` sigue apuntando al herido y el weld
   `GRABBING_CONSTRAINT` se reengancha.
5. Se reactiva el `Animate` del herido.

### 6. Soltar con G / salida automática

- Si el juego pone `Grabbed = nil` o destruye el weld, la posesión termina sola.
- El jugador vuelve arriba automáticamente.
- El weld queda desactivado.
- No se reproduce la animación de cargado.
- El herido queda donde lo dejaste.

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
- El servidor valida la carga, mueve el cuerpo real, reproduce sus
  animaciones y sincroniza a todos.
- Al desposeer con Z, el herido vuelve a su estado de cargado.
- El lock del dueño dirige las balas por `RE_Lock`.

### 2. Sin servidor: Da Hood / executor

Si no existe `ReplicatedStorage.SpideyRemotos`, el script entra en **modo
local**. El cliente mueve el cuerpo real usando la propiedad de red que la
carga ya le dio. En V13.3 este camino funciona para el jugador que controla:
el herido sigue tirado, hace sus propias animaciones y tu cuerpo queda
debajo. Que los demás lo vean depende de que el juego mantenga esa propiedad
de red; un executor no puede crear scripts de servidor.

## Pruebas hechas en Studio (copia `Official Hood.rbxl`)

Se probaron **los dos modos** con un herido sintético (`CuerpoTest`), weld
real, `K.O. = true`, `Dead = false` y `Health = 0.5` en modo local.

### Modo local / executor

- Detección con `Grabbed = Model`, `victima.Grabbed = nil` y weld real.
- Reintento de 0.6 s cuando el weld tarda en replicar.
- Cámara sobre el herido.
- Cuerpo original **13.00 studs debajo**, mirando arriba.
- El herido **no se levanta**: `PlatformStand = true`, `WalkSpeed = 0`.
- Movimiento por CFrame: **19.21 studs en 1.2 s**.
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
- `Grabbed = nil` (G / soltar carga):
  - la posesión terminó sola
  - jugador arriba
  - weld desactivado
  - `Animate` reactivado

### Modo servidor

- Pose con `Health = 0.5` y `K.O. = true`.
- Movimiento del herido replicado.
- Cuerpo original 13 studs debajo.
- Cámara sobre el herido.
- `SpideyPoseyendo = CuerpoTest`.

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

Los tres son **idénticos** al `SPIDER V13.3.lua` entregado.

- Commit de V13.3: `cef7d0717d05b6a9e4a2ee64ff2637595482074d`.
- Tamaño: **153.004 bytes**.
- SHA256: `6EBCA80F416727972ED810EE923316C0D4710D98D95B3B81CFDA69CD2B687500`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).

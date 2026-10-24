# Spiderscript V13.0 🕷️

Sistema **Spider-Man completo** (telaraña, física de péndulo, trepa, cámara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESIÓN REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

> **Novedad V13.0: poseer el cuerpo real que estás cargando por la pierna**
> - Derriban a alguien y el juego te deja cargarlo por la pierna.
> - Equipa el tool **Control** (lo entrega este script junto con `Spider`) y
>   haz **clic izquierdo**.
> - Si de verdad estás cargando a esa persona, tu cuerpo original se va
>   **13 studs debajo del mapa**, anclado, tieso y mirando hacia arriba.
> - La cámara pasa al **cuerpo real del herido** y lo controlas con **WASD**.
> - Sin moverte reproduce la **animación de estar parado del herido**; al
>   caminar, su **animación de caminar**. Si el herido tiene animaciones de
>   zombie, se usan las de zombie: no se reemplazan por las default.
> - Para desposeer se pulsa **Z**. Sigues cargando al herido por la pierna,
>   listo para caminar o soltarlo. **No se vuelve a hacer clic en Control** y
>   **no se usa G** (G soltaría al herido).
> - Ya no se crean muñecos ni clones decorativos: se controla el cuerpo real.
> - El clic de `Control` **no desposee**: si ya estás poseyendo, solo avisa.

## Loadstring (executor / potassium)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/main/Resources/Scripts/Main.lua"))()
```

Si tu ejecutor cachea la URL, usa la URL por commit:
`https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/<commit>/Resources/Scripts/Main.lua`

> Si ya tenías una versión anterior cargada en la misma sesión, **rejoin**:
> el candado `_G.__SPIDEY_V11_ACTIVO` impide cargar dos veces el script.

## Teclas

| Tecla | Qué hace |
|---|---|
| **Clic con `Control`** | **POSEER:** solo funciona si estás cargando de verdad a un herido por la pierna. Equipa el tool `Control` y haz clic izquierdo. Monta la cámara sobre el cuerpo real y responde a WASD. Si ya estás poseyendo, el clic no te saca; solo muestra un aviso. |
| **Z** | **DESPOSEER:** devuelve el control a tu personaje y la cámara a ti, pero **sigues cargando** al herido por la pierna. No lo tira al suelo y no usa G. |
| **Q** | **LOCK (sin cambios):** pon el mouse sobre una persona y pulsa Q. Contorno blanco en ella y en ti + línea blanca. Tu cámara no se mueve; tu personaje gira hacia el enemigo. Las balas van a la cabeza/torso. Q otra vez lo quita. |
| **J** | **ESP (sin cambios):** contorno blanco + nombre de usuario arriba de los jugadores, visible a través de las paredes. J otra vez lo apaga. |
| **X + pared** | Trepar (sin cambios). Shift queda libre. |
| **WASD** | Mueve el cuerpo real que estás poseyendo. |
| **G** | Lo usa el sistema de carga del juego para **soltar** al herido. No se usa para desposeer. |

## Cómo funciona la posesión (V13.0)

### 1. Requisitos para poseer

El tool `Control` **no posee a cualquiera**. El servidor comprueba que exista
una carga real:

- `character.BodyEffects.Grabbed.Value == victima`
- `victima.BodyEffects.Grabbed.Value == character`
- existe `victima.GRABBING_CONSTRAINT` (el weld de carga del juego)
- el herido no está muerto y ambos Humanoid tienen vida

Si falta cualquiera de esas cosas, el clic no hace nada y el HUD avisa. No
basta con estar cerca ni con tener el tool equipado.

### 2. Al poseer

1. Se guarda el estado del cuerpo original y del herido.
2. Se **desactiva** el weld de carga sin destruirlo, para que el juego no
   dispare su ragdoll mientras controlas.
3. Se desactivan sockets y `NoCollisionConstraint_HOLD` del herido.
4. El cuerpo original queda **13 studs debajo** del herido, anclado, tieso y
   mirando hacia arriba.
5. El cuerpo real del herido pasa a ser propiedad del servidor
   (`NetworkOwner = nil`) para que no atraviese el suelo.
6. El servidor mueve al herido con `Humanoid:Move`, lo gira según el vector
   de WASD y reproduce sus animaciones.
7. El cliente solo envía la orden de movimiento (~30 Hz) y monta cámara/HUD.

### 3. Animaciones: las del herido, no las default

El servidor lee primero el `Animate` del cuerpo original:

- `victima.Animate.idle` → animación de parado
- `victima.Animate.walk` → animación de caminar

Si el herido tiene animaciones personalizadas (por ejemplo, el idle de
zombie de Da Hood), se usan **esas**. Las animaciones default de Roblox solo
se usan como respaldo cuando el cuerpo no trae ninguna propia. Esto vale para
R15 y R6.

Al empezar a caminar se detiene el idle y se reproduce el walk; al parar se
detiene el walk y vuelve el idle. No quedan las dos a la vez.

### 4. Desposeer con Z

Al pulsar Z:

1. Se devuelve **primero** al jugador a la superficie, delante del herido.
2. Se restaura la cámara a tu `Humanoid` y se oculta el HUD.
3. Se restaura el herido: `PlatformStand = true`, `WalkSpeed = 0`,
   `Massless = true`, sockets y el weld de carga.
4. **La carga sigue activa**: `Grabbed` sigue apuntando al herido y el weld
   `GRABBING_CONSTRAINT` queda otra vez en `UpperTorso`.
5. No se destruye nada y no se suelta al herido.

> El orden importa: si se reactivara el weld antes de subir al jugador, el
> herido se engancharía al cuerpo original que aún está debajo del mapa y los
> dos caerían al vacío. Por eso primero se restaura al jugador y después al
> herido.

### 5. Salida automática

La posesión se corta sola si:

- dejas de cargar al herido (`Grabbed` cambia o desaparece),
- el herido muere (`Health <= 0` o `BodyEffects.Dead`),
- el herido desaparece o respawnea,
- tu personaje muere, respawnea o sale del juego.

En todos los casos se restaura la cámara, el HUD, el cuerpo original y el
estado del herido.

## LOCK y ESP (sin tocar)

**No se tocó el código del lock ni del ESP.** Siguen funcionando igual que en
V11.9:

- El lock visual (2 `Highlight` + 1 `Beam`) se crea en tu cliente.
- Las armas nuevas siguen apuntando con el parche de `GunHandler.getAim`.
- Las armas viejas siguen usando el remoto de Da Hood.
- El ESP sigue siendo de cada cliente: J lo activa y J lo apaga.
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
- Todos ven el mismo cuerpo caminando; la cámara y el HUD son del que posee.
- Al desposeer con Z, el herido vuelve a su estado de cargado y el que
  controlaba sigue cargándolo.
- El lock del dueño dirige las balas por `RE_Lock`.

### 2. Sin servidor: Da Hood / executor

Si no existe `ReplicatedStorage.SpideyRemotos`, el script entra en **modo
local**. El cliente intenta usar el cuerpo real y la propiedad de red que la
carga ya le dio. Esto puede funcionar a medias, pero **no se garantiza que los
demás jugadores lo vean** ni que el juego ajeno no lo sobrescriba: un executor
no puede crear scripts de servidor. La posesión fiable necesita el servidor de
tu juego.

El tool `Control` sigue exigiendo que el juego te esté cargando por la pierna.
El lock y el ESP siguen funcionando como siempre.

## Pruebas hechas en Studio (copia `Official Hood.rbxl`)

Pruebas reales ejecutando el juego, no solo leyendo el código. Se usó una
plataforma aislada de 140×140 studs en `(10000, 5000, 10000)` y un NPC R15
llamado `CuerpoTest`, con `BodyEffects.Grabbed` apuntando al jugador, el weld
`GRABBING_CONSTRAINT` en `UpperTorso`, `K.O = false` y `Dead = false`. Para
comprobar la prioridad de animaciones se le pusieron animaciones propias:

- `Animate.idle.Animation1 = rbxassetid://507767714`
- `Animate.walk.Animation1 = rbxassetid://507766666`

### Posesión con clic real en `Control`

- Antes de empezar, clic sin carga: **no posee** (`SpideyPoseyendo = nil`).
- Con carga válida, clic en `Control`:
  - `SpideyPoseyendo = CuerpoTest`
  - cámara con `CameraSubject` padre `CuerpoTest`
  - cuerpo original en `(10000, 4990.70, 10000.99)`, **anclado**, 13 studs
    debajo del herido y con `LookVector.Y = 1` (mirando hacia arriba)
  - herido en `(10000, 5003.70, 10000.99)`, sobre la plataforma
  - animación `SpideyPose_idle` con el ID propio `507767714`
- Clic en `Control` estando ya poseyendo: **no desposee**; el atributo sigue
  en `CuerpoTest`.

### Movimiento y animaciones con WASD real

- W mantenida: el herido pasó de `Z = 10000.99` a `Z = 9969.92`
  (**~31 studs** durante la pulsación) y reprodujo
  `SpideyPose_walk` con el ID propio `507766666`.
- Al soltar W: volvió a `SpideyPose_idle` con el ID propio `507767714`.
- En otra medición, W durante 1,2 s recorrió **19,8 studs** (16 studs/s).
- El cuerpo se mantuvo sobre la plataforma (`Y = 5003.70`, piso `Plastic`)
  durante 3,5 s seguidos sin caerse.

### Desposeer con Z real

- `SpideyPoseyendo = nil`
- cámara de vuelta en el `Humanoid` del jugador
- HUD oculto
- jugador en `(10000, 5003.70, 9972.86)`, desanclado y `WalkSpeed = 16`
- herido en `(10000, 5005.23, 9971.87)`, sobre la plataforma
- `PlatformStand = true`, `WalkSpeed = 0`, `Massless = true`
- weld `GRABBING_CONSTRAINT` activo otra vez en `UpperTorso`
- `Grabbed` sigue apuntando en los dos sentidos
- animación `SpideyPose_Cargado` del juego

### Salida automática al perder la carga

Se pusieron `Grabbed = nil` en el jugador y en el herido:

- la posesión terminó sola
- cámara y HUD normales
- jugador y herido sobre la plataforma
- el herido quedó en `PlatformStand`, `WalkSpeed = 0`, `Massless = true`
- el weld se restauró

**No se pudo probar con la herramienta de Studio:** dos jugadores reales a la
vez (una carga real entre dos cuentas) ni el executor/Da Hood real. La prueba
controlada usó un NPC con el estado de carga simulado y el clic real del tool.
La prueba final con dos jugadores la haces tú.

## Cómo probarlo en Studio

1. Abre `Official Hood.rbxl`.
2. Activa `ServerScriptService.SpideyV11` para probar el modo servidor.
3. Pulsa **Play**.
4. Derriba a un NPC/jugador y cárgalo por la pierna con el sistema del juego.
5. Equipa el tool **Control** y haz **clic izquierdo**.
6. Debe irse tu cuerpo debajo del mapa, la cámara al herido y el HUD debe
   decir: `CONTROLANDO: <nombre> | Z = desposeer (sigues cargando)`.
7. Camina con **WASD**; verás idle al parar y walk al moverte.
8. Pulsa **Z**: vuelves a tu cuerpo y sigues cargando al herido.
9. Para la salida automática, suelta al herido con el sistema del juego o
   haz que muera/desaparezca.

### Comandos de prueba

El hook `SpideyTest` sirve para pruebas automáticas. No es el flujo normal:

```lua
local p = game.Players.LocalPlayer
p:SetAttribute("SpideyTest", "INFO")   -- muestra información
p:SetAttribute("SpideyTest", "POSE")   -- inicia la posesión (requiere carga)
p:SetAttribute("SpideyTest", "UNPOSE") -- desposee conservando la carga
p:SetAttribute("SpideyTestMove", Vector3.new(0, 0, -1)) -- fuerza movimiento
p:SetAttribute("SpideyTestMove", Vector3.zero)          -- detiene
```

Si repites el mismo valor exacto, primero pon otro (`INFO`) y luego el valor
deseado, porque el hook ignora valores idénticos al anterior.

## Límites conocidos

- **Da Hood/executor:** no hay servidor propio. El cliente puede intentar
  mover el cuerpo real, pero no se garantiza la replicación ni que el juego
  ajeno no lo sobrescriba. La posesión fiable es en tu juego con el Script de
  servidor.
- **Tu juego:** el servidor mueve y anima el cuerpo real; todos lo ven igual.
- El cuerpo propio se coloca 13 studs debajo del herido, no en el vacío
  infinito.
- Las animaciones default solo se usan si el herido no trae animaciones
  propias en `Animate`.
- No se tocó el lock, el ESP, la trepa ni la telaraña.

## Archivos

- `Resources/Scripts/Main.lua` — el archivo que sirve el loadstring (combinado).
- `Resources/Scripts/ServerScriptService/SpideyV11.lua` — copia para el Script
  de servidor.
- `Resources/Scripts/StarterPlayerScripts/SpideyClienteV11.lua` — copia para el
  LocalScript de StarterPlayerScripts.

Los tres son **idénticos** al `SPIDER V13.0.lua` entregado.

- Tamaño: **144.415 bytes**.
- SHA256: `22EB363B86716F56EE672680DA4E2EE74D95DCEC5CC4A0DF37CEEE8711608F89`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).

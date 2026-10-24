# Spiderscript V13.2 🕷️

Sistema **Spider-Man completo** (telaraña, física de péndulo, trepa, cámara,
sonidos, GUI y animaciones A/B) **+ LOCK, ESP y POSESIÓN REAL DEL CUERPO
CARGADO** en **un solo archivo combinado**: sirve como script de servidor y
como LocalScript/executor. Se adapta solo con `RunService:IsServer()`.

> **Corrección V13.2: ya funciona la posesión en Da Hood / executor**
>
> La V13.1 detectaba la carga, pero en el modo sin servidor propio (el que usa
> un executor en Da Hood) la posesión se rompía justo después de empezar.
> Estas eran las causas reales:
>
> 1. `seguirBajoMapa()` se llamaba antes de que existiera su definición local:
>    el primer clic imprimía `controlando cuerpo real` y lanzaba
>    `attempt to call a nil value`.
> 2. Al iniciar la pose local se borraban `Part0` y `Part1` del weld
>    `GRABBING_CONSTRAINT`. En el siguiente frame, `detectarCarga()` ya no
>    encontraba la carga y cerraba la posesión.
> 3. Se rechazaba al herido si `Humanoid.Health <= 0`. Da Hood marca `K.O.`
>    cuando la vida baja a `0.5` o menos; el cuerpo puede seguir válido con
>    `BodyEffects.Dead = false`.
> 4. Si hacías clic justo al agarrar, el `Grabbed` ya había replicado pero el
>    weld todavía no. Ahora el clic espera hasta **0.6 s** a que aparezca.
>
> En V13.2:
>
> - La pose local ya no borra `Part0/Part1`; solo desactiva el weld.
> - El jugador vuelve arriba **antes** de reenganchar el weld, para que el
>   herido no caiga al vacío.
> - Con **Z** se fuerza el weld activo si `Grabbed` sigue apuntando al herido.
> - Si el juego quita la carga (`Grabbed = nil`), el weld queda **desactivado**
>   y no se reproduce la animación de cargado.
> - Se mantiene la detección de la V13.1: `Grabbed` puede ser `Player` o
>   `Model`, y la prueba fuerte es el weld real `GRABBING_CONSTRAINT`.
>
> **Novedad V13.1: detección corregida del agarre por la pierna**
> - El juego **no escribe** `BodyEffects.Grabbed` en la víctima cuando la
>   cargas por la pierna. Antes se exigía y por eso decía "No estás cargando".
> - Ahora se valida el weld real `GRABBING_CONSTRAINT`: `Part0` en el cuerpo
>   que carga y `Part1` en el `HumanoidRootPart` del herido.
> - Se aceptan las dos formas del juego: `Grabbed = Player` (CarrySystem) y
>   `Grabbed = Model` (agarre clásico por la pierna).
> - `K.O. = true` ya no corta la posesión: es normal en un herido derribado.
>
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
`https://raw.githubusercontent.com/liamalexanderlozada-sketch/SpiderScriptV10/COMMIT_AQUI/Resources/Scripts/Main.lua`

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

## Cómo funciona la posesión (V13.2)

### 1. Requisitos para poseer

El tool `Control` **no posee a cualquiera**. El cliente y el servidor
comprueban que exista una carga real:

- `character.BodyEffects.Grabbed.Value` apunta al herido (Player o Model)
- existe `victima.GRABBING_CONSTRAINT` con `Part0` en el que carga y
  `Part1` en el `HumanoidRootPart` del herido
- si `victima.BodyEffects.Grabbed` existe, apunta al que carga; en el
  agarre clásico por la pierna puede estar en `nil`, y eso es válido
- el herido no está muerto (`BodyEffects.Dead = false`). Si `Dead` no existe,
  se exige `Humanoid.Health > 0`
- `K.O. = true` es normal y no cancela la posesión; la vida puede ser `0.5`
- el que carga debe estar vivo y con el tool `Control` equipado

Si falta cualquiera de esas cosas, el clic no hace nada y el HUD avisa. No
basta con estar cerca ni con tener el tool equipado.

### 2. Al poseer

1. Se guarda el estado del cuerpo original y del herido.
2. Se **desactiva** el weld de carga sin destruirlo, conservando
   `Part0/Part1`, para que el juego no dispare su ragdoll mientras controlas.
3. Se desactivan sockets y `NoCollisionConstraint_HOLD` del herido.
4. El cuerpo original queda **13 studs debajo** del herido, anclado, tieso y
   mirando hacia arriba.
5. El cuerpo real del herido pasa a ser propiedad del servidor
   (`NetworkOwner = nil`) para que no atraviese el suelo.
6. El servidor mueve al herido con `Humanoid:Move`, lo gira según el vector
   de WASD y reproduce sus animaciones.
7. El cliente solo envía la orden de movimiento (~30 Hz) y monta cámara/HUD.

En **modo local** (Da Hood / executor) se usa el mismo procedimiento, pero
sin servidor: el cliente mueve el cuerpo real usando la propiedad de red que
la carga del juego ya le dio. El cliente conserva `Part0/Part1` y desactiva
el weld solo localmente.

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
   `GRABBING_CONSTRAINT` se reengancha en `UpperTorso`.
5. No se destruye nada y no se suelta al herido.

> El orden importa: si se reactivara el weld antes de subir al jugador, el
> herido se engancharía al cuerpo original que aún está debajo del mapa y los
> dos caerían al vacío. Por eso primero se restaura al jugador y después el
> weld del herido.

### 5. Salida automática

La posesión se corta sola si:

- dejas de cargar al herido (`Grabbed` cambia o desaparece),
- el herido muere (`BodyEffects.Dead = true`; si no existe `Dead`, `Health <= 0`),
- el herido desaparece o respawnea,
- tu personaje muere, respawnea o sale del juego.

En todos los casos se restaura la cámara, el HUD, el cuerpo original y el
estado del herido. Si la carga desapareció, el weld queda **desactivado** y
no se reproduce `SpideyPose_Cargado`.

## LOCK y ESP (sin tocar)

**No se tocó el código del lock ni el ESP.** Siguen funcionando igual que en
las versiones anteriores:

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
local**. El cliente mueve el cuerpo real usando la propiedad de red que la
carga ya le dio. En V13.2 este camino funciona para el jugador que controla:
se corrigieron el `nil` de `seguirBajoMapa`, el borrado de `Part0/Part1` y el
orden de restauración. Que los demás jugadores lo vean depende de que el
juego mantenga esa propiedad de red; un executor no puede crear scripts de
servidor. La posesión totalmente fiable y replicada sigue necesitando el
servidor de tu juego.

El tool `Control` sigue exigiendo que el juego te esté cargando por la pierna.
El lock y el ESP siguen funcionando como siempre.

## Pruebas hechas en Studio (copia `Official Hood.rbxl`)

Se probaron **los dos modos** en Studio con una plataforma aislada y un NPC
R15 llamado `CuerpoTest`:

- **Modo servidor:** `ServerScriptService.SpideyV11` activo, cliente en
  `StarterPlayerScripts.SpideyClienteV11`.
- **Modo local / executor:** servidor `SpideyV11` desactivado para que el
  cliente no encuentre `SpideyRemotos` y entre en `sinServidor = true`.
- Estado simulado: `BodyEffects.Grabbed = CuerpoTest` (Model), weld
  `GRABBING_CONSTRAINT` con `Part0 = UpperTorso` y
  `Part1 = HumanoidRootPart`, `K.O = true`, `Dead = false`.
- En la prueba de K.O. realista se usó `Humanoid.Health = 0.5`.

### Detección y clic inmediato

- Sin carga válida, `Control` no posee.
- Con la carga clásica (`Grabbed = Model`, `victima.Grabbed = nil`) sí posee.
- Con la variante moderna (`Grabbed = Player` en ambos lados) sí posee.
- Se creó el `Grabbed` **antes** que el weld y se hizo clic de inmediato: el
  reintento de 0.6 s esperó la replicación y la pose arrancó.

### Posesión

- `SpideyPoseyendo = CuerpoTest`.
- Cámara con `CameraSubject` en el Humanoid del herido.
- Cuerpo original **13.00 studs debajo** del herido, anclado, tieso y mirando
  hacia arriba.
- Weld desactivado pero con `Part0/Part1` conservados.
- `K.O. = true` y `Dead = false` se mantuvieron; el herido con
  `Health = 0.5` también fue controlable.
- WASD movió al herido (~15–20 studs en 1.2 s) y el cuerpo original siguió
  13 studs debajo.
- Animación propia de idle al parar y walk al moverse.

### Clic extra en `Control`

- Estando ya poseyendo, otro clic **no desposee**.
- Se mostró el aviso: `Para desposeer usa Z (sigues cargando al herido)`.
- La cámara siguió en el herido y el cuerpo siguió 13 studs debajo.

### Desposeer con Z

Probado con la tecla **Z** real y con el hook `UNPOSE`:

- cámara de vuelta en el jugador,
- HUD oculto,
- jugador de vuelta arriba,
- weld `GRABBING_CONSTRAINT` **activo** otra vez,
- `Part0/Part1` conservados,
- `Grabbed` sigue apuntando al herido,
- herido con `PlatformStand = true`,
- animación `SpideyPose_Cargado` solo si la carga sigue activa.

### Salida automática al perder la carga

Se puso `Grabbed = nil` con la pose activa:

- la posesión terminó sola,
- cámara y HUD normales,
- jugador arriba,
- weld **desactivado**,
- `Part0/Part1` conservados para una carga futura,
- `SpideyPose_Cargado` **no** quedó reproduciéndose.

**No se pudo probar desde Studio:** dos jugadores reales a la vez en Da Hood
(una carga real entre dos cuentas). Esa prueba final la hace el usuario; el
modo local y el modo servidor se validaron por separado con el estado real del
juego simulado y el clic/teclas reales.

## Cómo probarlo en Studio

1. Abre `Official Hood.rbxl`.
2. Para el modo servidor, activa `ServerScriptService.SpideyV11`.
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

- **Da Hood/executor:** no hay servidor propio. El cliente ya puede mover el
  cuerpo real con la propiedad de red, pero no se garantiza que los demás lo
  vean igual ni que el juego ajeno no lo sobrescriba. La posesión totalmente
  fiable es en tu juego con el Script de servidor.
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

Los tres son **idénticos** al `SPIDER V13.2.lua` entregado.

- Tamaño: **149.914 bytes**.
- SHA256: `12363F08979A257834A3DF89300BE509C8BD658415B45AC9DCFB219FC4723D97`.
- Sintaxis validada con `luau-compile --only-parse` (exit 0).
